package client

import "core:mem"
import "core:os"
import "core:strings"
import "core:sys/linux"
import "util"
import wl "wayland"

@(private)
current_global_id := u32(1)
@(private)
next_id :: proc(current: ^u32) -> u32 {
	current^ += 1
	return current^
}

Client :: struct {
	wayland_socket:        linux.Fd,
	requests_byte_buffer:  [dynamic]byte,
	outgoing_fds:          [dynamic; 28]linux.Fd,
	events_byte_buffer:    [dynamic]byte,
	incoming_fds:          [dynamic; 28]linux.Fd,
	id_to_interface:       map[u32]string,
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
	client.id_to_interface[wl.display] = wl.DISPLAY_INTERFACE
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

roundtrip :: proc(client: ^Client, allocator := context.temp_allocator) -> (evs: []Event, err: Error) {
	events := make([dynamic]Event, allocator) or_return
	if len(client.requests_byte_buffer) > 0 {
		res: os.Error = os.write_entire_file_from_bytes("/tmp/opencode/req.bin", client.requests_byte_buffer[:])
	_ = res
	}
	send_requests_data(client.wayland_socket, client.requests_byte_buffer[:], client.outgoing_fds[:]) or_return
	clear(&client.requests_byte_buffer)
	if len(client.outgoing_fds) > 0 {
		clear(&client.outgoing_fds)
	}
	recv_events_data(client.wayland_socket, &client.events_byte_buffer, &client.incoming_fds) or_return
	parse_events_data(client, client.events_byte_buffer[:], &events)
	return events[:], nil
}

send_requests_data :: proc(socket: linux.Fd, reqs_buf: []byte, outgoing_fds: []linux.Fd) -> (n: int, err: Error) {
	if len(outgoing_fds) > 0 {
		control: [128]byte
		payload := uint(len(outgoing_fds) * size_of(linux.Fd))
		cmsg := (^util.Cmsghdr)(&control[0])
		cmsg.len = util.CMSG_LEN(payload)
		cmsg.level = i32(linux.SOL_SOCKET)
		cmsg.type = util.SCM_RIGHTS
		copy(([^]linux.Fd)(&control[size_of(util.Cmsghdr)])[:len(outgoing_fds)], outgoing_fds)

		hdr := linux.Msg_Hdr {
			iov     = {{base = raw_data(reqs_buf), len = len(reqs_buf)}},
			control = control[:util.CMSG_SPACE(payload)],
		}
		n = linux.sendmsg(socket, &hdr, {.NOSIGNAL}) or_return
	} else {
		n = linux.send(socket, reqs_buf, {.NOSIGNAL}) or_return
	}

	for n < len(reqs_buf) {
		n += linux.send(socket, reqs_buf[n:], {.NOSIGNAL}) or_return
	}
	return
}

recv_events_data :: proc(socket: linux.Fd, evs_buf: ^[dynamic]byte, incoming_fds: ^[dynamic; 28]linux.Fd) -> Error {
	control: [128]byte
	staging: [WAYLAND_BUFFER_LEN]byte
	hdr := linux.Msg_Hdr {
		iov     = {{base = &staging[0], len = len(staging)}},
		control = control[:],
	}
	n := linux.recvmsg(socket, &hdr, {.CMSG_CLOEXEC}) or_return
	if n == 0 {
		return .EPIPE
	}
	if .CTRUNC in hdr.flags {
		return .ENOBUFS
	}
	append(evs_buf, ..staging[:n]) or_return
	start := uintptr(raw_data(hdr.control))
	end := start + uintptr(len(hdr.control))
	recv_control_fds(start, end, incoming_fds) or_return
	return nil
}

recv_control_fds :: proc(control_start, control_end: uintptr, fds: ^[dynamic; 28]linux.Fd) -> Error {
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
	return nil
}

parse_events_data :: proc(client: ^Client, data: []byte, events: ^[dynamic]Event, allocator := context.temp_allocator) {
	pos: int
	for pos + WAYLAND_HEADER_SIZE <= len(data) {
		object_id, opcode, size, n := util.read_header(data[pos:])
		if pos + int(size) > len(data) {
			break
		}
		interface := client.id_to_interface[object_id]
		if ev, delete_object, ok := parse_event(interface, object_id, opcode, data[pos + WAYLAND_HEADER_SIZE:pos + int(size)], &client.incoming_fds, allocator); ok {
			append(events, ev)
		} else if delete_object != 0 {
			delete_key(&client.id_to_interface, delete_object)
		}
		pos += int(size)
	}
	remove_range(&client.events_byte_buffer, 0, pos)
}

create_shm_file :: proc(size: i32) -> (shm: linux.Fd, data: []byte, err: Error) {
	shm = linux.memfd_create("wayland-shm", {.CLOEXEC, .ALLOW_SEALING}) or_return
	linux.ftruncate(shm, i64(size)) or_return
	ptr := linux.mmap(0, uint(size), {.READ, .WRITE}, {.SHARED}, shm) or_return
	data = ([^]byte)(ptr)[:size]
	return
}
