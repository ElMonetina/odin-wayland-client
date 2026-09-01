package client

import "core:mem"
import "core:os"
import "core:strings"
import "core:sys/linux"
import wl "wayland"
import "/util"

@(private)
internal_state: struct {
	global_current_id:    u32,
	wayland_socket:       linux.Fd,
	requests_byte_buffer: [dynamic]byte,
	outgoing_fds:         [dynamic]linux.Fd,
	incoming_fds:         [dynamic]linux.Fd,
	events_byte_buffer:   [dynamic]byte,
	events:               [dynamic]Event,
	event_index:          int,
	interface_map:        map[u32]string,
	allocator:            mem.Allocator,
	temp_allocator:       mem.Allocator,
}

WAYLAND_HEADER_SIZE :: 8
WAYLAND_BUFFER_LEN :: 4096

Error :: union {
	linux.Errno,
	mem.Allocator_Error
}

// Connects the client to the wayland server, note that the temp allocator must be backed by an allocator that supports free_all(temp_allocator)
connect :: proc(allocator := context.allocator, temp_allocator := context.temp_allocator) -> Error {
	internal_state.allocator = allocator
	internal_state.temp_allocator = temp_allocator

	internal_state.requests_byte_buffer = make([dynamic]byte, 0, WAYLAND_BUFFER_LEN, internal_state.allocator) or_return
	internal_state.events_byte_buffer   = make([dynamic]byte, 0, WAYLAND_BUFFER_LEN, internal_state.allocator) or_return
	internal_state.incoming_fds         = make([dynamic]linux.Fd, 0, 28, internal_state.allocator) or_return
	internal_state.outgoing_fds         = make([dynamic]linux.Fd, 0, 28, internal_state.allocator) or_return
	internal_state.interface_map        = make(map[u32]string, internal_state.allocator)

	internal_state.wayland_socket = linux.socket(.UNIX, .STREAM, {}, .HOPOPT) or_return
	addr: linux.Sock_Addr_Un
	addr.sun_family = .UNIX
	// TODO(gabri): do proper checking for availability
	xdg_runtime_dir := os.get_env("XDG_RUNTIME_DIR", internal_state.temp_allocator)
	wayland_display := os.get_env("WAYLAND_DISPLAY", internal_state.temp_allocator)

	socket_path       := strings.concatenate({xdg_runtime_dir, "/", wayland_display}, internal_state.temp_allocator)
	socket_path_bytes := transmute([]u8)socket_path
	copy(addr.sun_path[:], socket_path_bytes)
	linux.connect(internal_state.wayland_socket, &addr) or_return
	
	internal_state.event_index = -1
	internal_state.global_current_id = 1
	internal_state.interface_map[wl.display] = wl.DISPLAY_INTERFACE

	free_all(temp_allocator)
	return nil
}

disconnect :: proc() {
	delete(internal_state.requests_byte_buffer)
	delete(internal_state.outgoing_fds)
	delete(internal_state.incoming_fds)
	delete(internal_state.interface_map)
	linux.close(internal_state.wayland_socket)
}

new_id :: proc() -> u32 {
	internal_state.global_current_id += 1
	return internal_state.global_current_id
}

roundtrip :: proc() -> Error {
	free_all(internal_state.temp_allocator)
	socket := internal_state.wayland_socket	
	internal_state.events = make([dynamic]Event, internal_state.temp_allocator) or_return
	send(socket, internal_state.requests_byte_buffer[:], internal_state.outgoing_fds[:]) or_return
	clear(&internal_state.requests_byte_buffer)
	recv(socket, internal_state.events_byte_buffer[:], &internal_state.incoming_fds) or_return
	parse_events(internal_state.events_byte_buffer[:], &internal_state.events)
	return nil
}

send :: proc(socket: linux.Fd, data: []byte, fds: []linux.Fd) ->  (n: int, err: Error) {	
	if len(fds) > 0 {
		control: [128]byte
		payload := uint(len(fds) * size_of(linux.Fd))
		cmsg := (^util.Cmsghdr)(&control[0])
		cmsg.len = util.CMSG_LEN(payload)
		cmsg.level = i32(linux.SOL_SOCKET)
		cmsg.type = util.SCM_RIGHTS
		copy(([^]linux.Fd)(&control[size_of(util.Cmsghdr)])[:len(fds)], fds)

		hdr := linux.Msg_Hdr {
			iov     = {{base = raw_data(data), len = len(data)}},
			control = control[:util.CMSG_SPACE(payload)],
		}
		n = linux.sendmsg(socket, &hdr, {.NOSIGNAL}) or_return
		clear(&internal_state.outgoing_fds)
	} else {
		n = linux.send(socket, data, {.NOSIGNAL}) or_return
	}

	for n < len(data) {
		n += linux.send(socket, data[n:], {.NOSIGNAL}) or_return
	}
	return
}

recv :: proc(socket: linux.Fd, data: []byte, fds: ^[dynamic]linux.Fd) -> (n: int, err: Error) {
	control: [128]byte
	staging: [WAYLAND_BUFFER_LEN]byte
	hdr := linux.Msg_Hdr {
		iov = {{base = &staging[0], len = len(staging)}},
		control = control[:]
	}
	n = linux.recvmsg(socket, &hdr, {.CMSG_CLOEXEC}) or_return
	if n ==  0 {
		return n, .EPIPE
	}
	if .CTRUNC in hdr.flags {
		return n, .ENOBUFS
	}
	append(&internal_state.events_byte_buffer, ..staging[:n])
	ptr := uintptr(raw_data(hdr.control))
	end := ptr + uintptr(len(hdr.control))
	for ptr + size_of(util.Cmsghdr) <= end {
		cmsg := (^util.Cmsghdr)(ptr)
		if cmsg.level == i32(linux.SOL_SOCKET) && cmsg.type == util.SCM_RIGHTS {
			n_fds := (cmsg.len - util.CMSG_ALIGN(size_of(util.Cmsghdr))) / size_of(linux.Fd)
			src := ([^]linux.Fd)(ptr + size_of(util.Cmsghdr))
			append(fds, ..src[:n_fds])
		}
		ptr += uintptr(util.CMSG_ALIGN(cmsg.len))
	}
	return
}

parse_events :: proc(data: []byte, events: ^[dynamic]Event) {
	pos: int
	for pos + WAYLAND_HEADER_SIZE <= len(data) {
		object_id, opcode, size, n := util.read_header(data[pos:])
		if pos + int(size) > len(data) {
			break
		}
		dispatch_event(object_id, opcode, data[pos + WAYLAND_HEADER_SIZE: pos + int(size)])
		pos += int(size)
	}
	remove_range(&internal_state.events_byte_buffer, 0, pos)
}

poll_event :: proc() -> (Event, bool) {
	internal_state.event_index += 1
	if internal_state.event_index >= len(internal_state.events) {
		internal_state.event_index = 0
		return {}, false
	}
	ev := internal_state.events[internal_state.event_index]
	return ev, true
}

create_shm_file :: proc(size: i32) -> (shm: linux.Fd, data: []byte, err: Error) {
	shm = linux.memfd_create("wayland-shm", {.CLOEXEC, .ALLOW_SEALING}) or_return
	linux.ftruncate(shm, i64(size)) or_return
	ptr := linux.mmap(0, uint(size), {.READ, .WRITE}, {.SHARED}, shm) or_return
	data = ([^]byte)(ptr)[:size]
	return
}