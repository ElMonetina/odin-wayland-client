package util

import "core:mem"
import "core:math/fixed"
import "base:runtime"

Fixed :: distinct fixed.Fixed(i32, 8)

write :: proc {
	write_header,
	write_u16,
	write_u32,
	write_i32,
	write_string,
	write_array,
	write_fixed,
}

write_header :: proc(msg: ^[dynamic]byte, object: u32, opcode, size: u16) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	num_appended  = write_u32(msg, object) or_return
	num_appended += write_u16(msg, opcode) or_return
	num_appended += write_u16(msg, size) or_return
	return
}

write_u16 :: proc(msg: ^[dynamic]byte, n: u16) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	n := n
	return append(msg, ..mem.ptr_to_bytes(&n))
}

write_u32 :: proc(msg: ^[dynamic]byte, n: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	n := n
	return append(msg, ..mem.ptr_to_bytes(&n))
}

write_i32 :: proc(msg: ^[dynamic]byte, n: i32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	n := n
	return append(msg, ..mem.ptr_to_bytes(&n))
}

write_array :: proc(msg: ^[dynamic]byte, arr: []byte) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	num_appended  = write_u32(msg, u32(len(arr)))
	num_appended += append(msg, ..arr[:])
	num_appended += write_padding(msg, round_up_word(len(arr)))
	return
}

write_string :: proc(msg: ^[dynamic]byte, str: string) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	str := transmute(runtime.Raw_String)str
	num_appended  = write_u32(msg, u32(str.len + 1))or_return
	num_appended += append(msg, ..str.data[:str.len])or_return
	num_appended += append(msg, 0)or_return
	n_pad := round_up_word(str.len + 1)
	num_appended += write_padding(msg, n_pad)or_return
	return 
}

write_fixed :: proc(msg: ^[dynamic]byte, f: Fixed) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	return write(msg, f.i)
}

write_padding :: proc(msg: ^[dynamic]byte, n: int) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	for i in 0 ..< n {
		padding: byte
		append(msg, padding) or_return
	}
	num_appended = n
	return
}

read_header :: proc(msg: []byte) -> (u32, u16, u16, int) {
	object_id: u32
	opcode, size: u16
	r: int
	n := r
	object_id, r = read_u32(msg[n:]); n += r
	opcode, r = read_u16(msg[n:]); n += r
	size, r = read_u16(msg[n:]); n += r
	return object_id, opcode, size, n
}

read_u16 :: proc(msg: []byte) -> (u16, int) {
	return mem.reinterpret_copy(u16, raw_data(msg[:size_of(u16)])), size_of(u16)
}

read_u32 :: proc(msg: []byte) -> (u32, int) {
	return mem.reinterpret_copy(u32, raw_data(msg[:size_of(u32)])), size_of(u32)
}

read_i32 :: proc(msg: []byte) -> (i32, int) {
	return mem.reinterpret_copy(i32, raw_data(msg[:size_of(i32)])), size_of(i32)
}

read_string :: proc(msg: []byte) -> (string, int) {
	strlen, read := read_u32(msg)
	if strlen == 0 {
		return "", read
	}
	n := int(strlen)
	str := string(msg[read:read + n - 1])
	return str, read + n + round_up_word(n)
}

read_array :: proc(msg: []byte) -> (arr: []byte, consumed: int) {
	length, read := read_u32(msg)
	n := int(length)
	arr = msg[read:read + n]
	return arr, read + n + round_up_word(n)
}

read_fixed :: proc(msg: []byte) -> (Fixed, int) {
	f: Fixed
	i, read := read_i32(msg)
	f.i = i
	return f, read
}

round_up_word :: proc(#any_int n: int) -> int {
	return (4 - n & 3) & 3
}

Cmsghdr :: struct {
	len:   uint,
	level: i32,
	type:  i32,
}

SCM_RIGHTS :: 1

CMSG_ALIGN :: #force_inline proc(n: uint) -> uint {return (n + 7) &~ 7}
CMSG_LEN :: #force_inline proc(n: uint) -> uint {return CMSG_ALIGN(size_of(Cmsghdr) + n)}
CMSG_SPACE :: #force_inline proc(n: uint) -> uint {return CMSG_ALIGN(size_of(Cmsghdr) + CMSG_ALIGN(n))}

compute_string_size :: proc(str: string) -> int {
	n := len(str) + 1
	return 4 + n + round_up_word(n)
}

compute_array_size :: proc(arr: []byte) -> int {
	return 4 + len(arr) + round_up_word(len(arr))
}
