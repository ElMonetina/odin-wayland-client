package client

import "core:mem"
import "core:os"
import "core:strings"
import "core:sys/linux"
import "util"
import wl "wayland"

Client :: struct {
	wayland_socket:       linux.Fd,
	requests_byte_buffer: [dynamic]byte,
	outgoing_fds:         [dynamic; 28]linux.Fd,
	events_byte_buffer:   [dynamic]byte,
	events_read_pos:      int,
	incoming_fds:         [dynamic; 28]linux.Fd,
	id_to_interface:      map[u32]string,
	next_id:              u32,
}

WAYLAND_HEADER_SIZE :: 8
WAYLAND_BUFFER_LEN :: 4096

Error :: union #shared_nil {
	linux.Errno,
	mem.Allocator_Error,
}

create :: proc(allocator := context.allocator, temp_allocator := context.temp_allocator) -> (client: Client, err: Error) {
	client.requests_byte_buffer = make([dynamic]byte, 0, WAYLAND_BUFFER_LEN, allocator) or_return
	client.events_byte_buffer = make([dynamic]byte, 0, WAYLAND_BUFFER_LEN, allocator) or_return
	client.id_to_interface = make(map[u32]string, allocator)
	client.wayland_socket = connect(temp_allocator) or_return
	client.id_to_interface[u32(wl.display)] = wl.DISPLAY_INTERFACE
	client.next_id = 1
	return
}

connect :: proc(allocator := context.temp_allocator) -> (wayland_socket: linux.Fd, err: Error) {
	wayland_socket = linux.socket(.UNIX, .STREAM, {}, .HOPOPT) or_return
	addr: linux.Sock_Addr_Un
	addr.sun_family = .UNIX
	// TODO(gabri): do proper checking for availability
	xdg_runtime_dir := os.get_env("XDG_RUNTIME_DIR", allocator)
	wayland_display := os.get_env("WAYLAND_DISPLAY", allocator)

	socket_path := strings.concatenate({xdg_runtime_dir, "/", wayland_display}, allocator) or_return
	socket_path_bytes := transmute([]u8)socket_path
	copy(addr.sun_path[:], socket_path_bytes)
	linux.connect(wayland_socket, &addr) or_return
	return
}

destroy :: proc(client: ^Client) -> Error {
	for fd in client.incoming_fds {
		linux.close(fd) or_return
	}
	delete(client.requests_byte_buffer) or_return
	delete(client.events_byte_buffer) or_return
	delete(client.id_to_interface) or_return
	disconnect(client.wayland_socket) or_return
	return nil
}

disconnect :: proc(socket: linux.Fd) -> Error {
	linux.close(socket) or_return
	return nil
}

roundtrip :: proc(client: ^Client) -> Error {
	send(client) or_return
	wait(client) or_return
	return nil
}

send :: proc(client: ^Client) -> Error {
	hdr: linux.Msg_Hdr
	control: [128]byte
	hdr.iov = {{base = raw_data(client.requests_byte_buffer), len = len(client.requests_byte_buffer)}}
	if len(client.outgoing_fds) > 0 {
		hdr.control = control[:util.CMSG_SPACE(uint(len(client.outgoing_fds) * size_of(linux.Fd)))]
		cmsg := (^util.Cmsghdr)(&control[0])
		cmsg.len = util.CMSG_LEN(uint(len(client.outgoing_fds) * size_of(linux.Fd)))
		cmsg.level = i32(linux.SOL_SOCKET)
		cmsg.type = util.SCM_RIGHTS
		copy(([^]linux.Fd)(&control[size_of(util.Cmsghdr)])[:len(client.outgoing_fds)], client.outgoing_fds[:])
		clear(&client.outgoing_fds)
	}
	linux.sendmsg(client.wayland_socket, &hdr, {.NOSIGNAL}) or_return
	clear(&client.requests_byte_buffer)
	return nil
}

wait :: proc(client: ^Client) -> Error {
	control: [128]byte
	staging: [WAYLAND_BUFFER_LEN]byte
	hdr := linux.Msg_Hdr {
		iov     = {{base = &staging[0], len = len(staging)}},
		control = control[:],
	}
	n := linux.recvmsg(client.wayland_socket, &hdr, {.CMSG_CLOEXEC}) or_return
	if n == 0 {
		return .EPIPE
	}
	if .CTRUNC in hdr.flags {
		return .ENOBUFS
	}
	append(&client.events_byte_buffer, ..staging[:n]) or_return
	control_start := uintptr(raw_data(hdr.control))
	control_end := control_start + uintptr(len(hdr.control))
	recv_control_fds(control_start, control_end, &client.incoming_fds)
	return nil
}

recv_control_fds :: proc(control_start, control_end: uintptr, fds: ^[dynamic; 28]linux.Fd) {
	ptr := control_start
	for ptr + size_of(util.Cmsghdr) <= control_end {
		cmsg := (^util.Cmsghdr)(ptr)
		if cmsg.level == i32(linux.SOL_SOCKET) && cmsg.type == util.SCM_RIGHTS {
			n_fds := (cmsg.len - util.CMSG_ALIGN(size_of(util.Cmsghdr))) / size_of(linux.Fd)
			src := ([^]linux.Fd)(ptr + size_of(util.Cmsghdr))
			append(fds, ..src[:n_fds])
		}
		ptr += uintptr(util.CMSG_ALIGN(cmsg.len))
	}
}

poll_event :: proc(client: ^Client, allocator := context.temp_allocator) -> (ev: Event, ok: bool) {
	for {
		read_pos := client.events_read_pos
		buf := client.events_byte_buffer
		if read_pos + WAYLAND_HEADER_SIZE > len(buf) {
			return {}, false
		}
		object_id, opcode, size, _ := util.read_header(buf[read_pos:])
		if read_pos + int(size) > len(buf) {
			return {}, false
		}
		interface, has := client.id_to_interface[object_id]
		if !has {
			read_pos += int(size)
			continue
		}
		ev, ok = parse_event(client, interface, object_id, opcode, buf[read_pos + WAYLAND_HEADER_SIZE:read_pos + int(size)], &client.incoming_fds, allocator)
		read_pos += int(size)
		if read_pos > WAYLAND_BUFFER_LEN {
			remove_range(&client.events_byte_buffer, 0, read_pos)
			read_pos = 0
		}
		client.events_read_pos = read_pos
		if ok {
			return ev, true
		}
	}
	return {}, false
}

create_shm_file :: proc(size: i32) -> (shm: linux.Fd, data: []byte, err: Error) {
	shm = linux.memfd_create("wayland-shm", {.CLOEXEC, .ALLOW_SEALING}) or_return
	linux.ftruncate(shm, i64(size)) or_return
	ptr := linux.mmap(0, uint(size), {.READ, .WRITE}, {.SHARED}, shm) or_return
	data = ([^]byte)(ptr)[:size]
	return
}

register_object :: proc(client: ^Client, id: u32, interface: string) {
	client.id_to_interface[id] = interface
}

submit :: proc(client: ^Client, data: []byte, fds: []linux.Fd) {
	append(&client.outgoing_fds, ..fds)
	append(&client.requests_byte_buffer, ..data)
}
