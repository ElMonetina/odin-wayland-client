package wp

import "../../util"
import wayland "../"
import "core:sys/linux"
import "base:runtime"

LINUX_DMABUF_V1_INTERFACE :: "zwp_linux_dmabuf_v1"
LINUX_DMABUF_V1_VERSION   :: 6

Linux_Dmabuf_V1 :: distinct u32

LINUX_DMABUF_V1_DESTROY_OPCODE :: 0
Linux_Dmabuf_V1_Destroy :: struct {
	linux_dmabuf_v1: Linux_Dmabuf_V1,
}
linux_dmabuf_v1_destroy_write :: proc(buf: ^[dynamic]byte, req: Linux_Dmabuf_V1_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.linux_dmabuf_v1)
	opcode := u16(LINUX_DMABUF_V1_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

LINUX_DMABUF_V1_CREATE_PARAMS_OPCODE :: 1
Linux_Dmabuf_V1_Create_Params :: struct {
	linux_dmabuf_v1: Linux_Dmabuf_V1,
	params_id: Linux_Buffer_Params_V1,
}
linux_dmabuf_v1_create_params_write :: proc(buf: ^[dynamic]byte, req: Linux_Dmabuf_V1_Create_Params, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.linux_dmabuf_v1)
	opcode := u16(LINUX_DMABUF_V1_CREATE_PARAMS_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

LINUX_DMABUF_V1_GET_DEFAULT_FEEDBACK_OPCODE :: 2
Linux_Dmabuf_V1_Get_Default_Feedback :: struct {
	linux_dmabuf_v1: Linux_Dmabuf_V1,
	id: Linux_Dmabuf_Feedback_V1,
}
linux_dmabuf_v1_get_default_feedback_write :: proc(buf: ^[dynamic]byte, req: Linux_Dmabuf_V1_Get_Default_Feedback, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.linux_dmabuf_v1)
	opcode := u16(LINUX_DMABUF_V1_GET_DEFAULT_FEEDBACK_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

LINUX_DMABUF_V1_GET_SURFACE_FEEDBACK_OPCODE :: 3
Linux_Dmabuf_V1_Get_Surface_Feedback :: struct {
	linux_dmabuf_v1: Linux_Dmabuf_V1,
	id: Linux_Dmabuf_Feedback_V1,
	surface: wayland.Surface,
}
linux_dmabuf_v1_get_surface_feedback_write :: proc(buf: ^[dynamic]byte, req: Linux_Dmabuf_V1_Get_Surface_Feedback, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.linux_dmabuf_v1)
	opcode := u16(LINUX_DMABUF_V1_GET_SURFACE_FEEDBACK_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

Linux_Dmabuf_V1_Format :: struct {
	linux_dmabuf_v1: Linux_Dmabuf_V1,
	format: u32,
}
linux_dmabuf_v1_format_read :: proc(buf: []byte) -> (Linux_Dmabuf_V1_Format, int) {
	e: Linux_Dmabuf_V1_Format
	r: int
	n := r
	e.format, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Linux_Dmabuf_V1_Modifier :: struct {
	linux_dmabuf_v1: Linux_Dmabuf_V1,
	format: u32,
	modifier_hi: u32,
	modifier_lo: u32,
}
linux_dmabuf_v1_modifier_read :: proc(buf: []byte) -> (Linux_Dmabuf_V1_Modifier, int) {
	e: Linux_Dmabuf_V1_Modifier
	r: int
	n := r
	e.format, r = util.read_u32(buf[n:]); n += r
	e.modifier_hi, r = util.read_u32(buf[n:]); n += r
	e.modifier_lo, r = util.read_u32(buf[n:]); n += r
	return e, n
}

LINUX_BUFFER_PARAMS_V1_INTERFACE :: "zwp_linux_buffer_params_v1"
LINUX_BUFFER_PARAMS_V1_VERSION   :: 6

Linux_Buffer_Params_V1 :: distinct u32

LINUX_BUFFER_PARAMS_V1_DESTROY_OPCODE :: 0
Linux_Buffer_Params_V1_Destroy :: struct {
	linux_buffer_params_v1: Linux_Buffer_Params_V1,
}
linux_buffer_params_v1_destroy_write :: proc(buf: ^[dynamic]byte, req: Linux_Buffer_Params_V1_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.linux_buffer_params_v1)
	opcode := u16(LINUX_BUFFER_PARAMS_V1_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

LINUX_BUFFER_PARAMS_V1_ADD_OPCODE :: 1
Linux_Buffer_Params_V1_Add :: struct {
	linux_buffer_params_v1: Linux_Buffer_Params_V1,
	fd: linux.Fd,
	plane_idx: u32,
	offset: u32,
	stride: u32,
	modifier_hi: u32,
	modifier_lo: u32,
}
linux_buffer_params_v1_add_write :: proc(buf: ^[dynamic]byte, req: Linux_Buffer_Params_V1_Add) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.linux_buffer_params_v1)
	opcode := u16(LINUX_BUFFER_PARAMS_V1_ADD_OPCODE)
	size   := u16(8 + size_of(req.fd) + size_of(req.plane_idx) + size_of(req.offset) + size_of(req.stride) + size_of(req.modifier_hi) + size_of(req.modifier_lo))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.plane_idx) or_return
	num_appended += util.write(buf, req.offset) or_return
	num_appended += util.write(buf, req.stride) or_return
	num_appended += util.write(buf, req.modifier_hi) or_return
	num_appended += util.write(buf, req.modifier_lo) or_return
	return
}

LINUX_BUFFER_PARAMS_V1_CREATE_OPCODE :: 2
Linux_Buffer_Params_V1_Create :: struct {
	linux_buffer_params_v1: Linux_Buffer_Params_V1,
	width: i32,
	height: i32,
	format: u32,
	flags: u32,
}
linux_buffer_params_v1_create_write :: proc(buf: ^[dynamic]byte, req: Linux_Buffer_Params_V1_Create) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.linux_buffer_params_v1)
	opcode := u16(LINUX_BUFFER_PARAMS_V1_CREATE_OPCODE)
	size   := u16(8 + size_of(req.width) + size_of(req.height) + size_of(req.format) + size_of(req.flags))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.width) or_return
	num_appended += util.write(buf, req.height) or_return
	num_appended += util.write(buf, req.format) or_return
	num_appended += util.write(buf, req.flags) or_return
	return
}

LINUX_BUFFER_PARAMS_V1_CREATE_IMMED_OPCODE :: 3
Linux_Buffer_Params_V1_Create_Immed :: struct {
	linux_buffer_params_v1: Linux_Buffer_Params_V1,
	buffer_id: wayland.Buffer_Id,
	width: i32,
	height: i32,
	format: u32,
	flags: u32,
}
linux_buffer_params_v1_create_immed_write :: proc(buf: ^[dynamic]byte, req: Linux_Buffer_Params_V1_Create_Immed, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.linux_buffer_params_v1)
	opcode := u16(LINUX_BUFFER_PARAMS_V1_CREATE_IMMED_OPCODE)
	size   := u16(8 + size_of(req.width) + size_of(req.height) + size_of(req.format) + size_of(req.flags) + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.width) or_return
	num_appended += util.write(buf, req.height) or_return
	num_appended += util.write(buf, req.format) or_return
	num_appended += util.write(buf, req.flags) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

LINUX_BUFFER_PARAMS_V1_SET_SAMPLING_DEVICE_OPCODE :: 4
Linux_Buffer_Params_V1_Set_Sampling_Device :: struct {
	linux_buffer_params_v1: Linux_Buffer_Params_V1,
	device: []u8,
}
linux_buffer_params_v1_set_sampling_device_write :: proc(buf: ^[dynamic]byte, req: Linux_Buffer_Params_V1_Set_Sampling_Device) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.linux_buffer_params_v1)
	opcode := u16(LINUX_BUFFER_PARAMS_V1_SET_SAMPLING_DEVICE_OPCODE)
	size   := u16(8 + size_of(req.device))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.device) or_return
	return
}

Linux_Buffer_Params_V1_Created :: struct {
	linux_buffer_params_v1: Linux_Buffer_Params_V1,
	buffer: wayland.Buffer,
}
linux_buffer_params_v1_created_read :: proc(buf: []byte) -> (Linux_Buffer_Params_V1_Created, int) {
	e: Linux_Buffer_Params_V1_Created
	r: int
	n := r
	return e, n
}

Linux_Buffer_Params_V1_Failed :: struct {
	linux_buffer_params_v1: Linux_Buffer_Params_V1,
}
linux_buffer_params_v1_failed_read :: proc(buf: []byte) -> (Linux_Buffer_Params_V1_Failed, int) {
	e: Linux_Buffer_Params_V1_Failed
	r: int
	n := r
	return e, n
}

LINUX_DMABUF_FEEDBACK_V1_INTERFACE :: "zwp_linux_dmabuf_feedback_v1"
LINUX_DMABUF_FEEDBACK_V1_VERSION   :: 6

Linux_Dmabuf_Feedback_V1 :: distinct u32

LINUX_DMABUF_FEEDBACK_V1_DESTROY_OPCODE :: 0
Linux_Dmabuf_Feedback_V1_Destroy :: struct {
	linux_dmabuf_feedback_v1: Linux_Dmabuf_Feedback_V1,
}
linux_dmabuf_feedback_v1_destroy_write :: proc(buf: ^[dynamic]byte, req: Linux_Dmabuf_Feedback_V1_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.linux_dmabuf_feedback_v1)
	opcode := u16(LINUX_DMABUF_FEEDBACK_V1_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

Linux_Dmabuf_Feedback_V1_Done :: struct {
	linux_dmabuf_feedback_v1: Linux_Dmabuf_Feedback_V1,
}
linux_dmabuf_feedback_v1_done_read :: proc(buf: []byte) -> (Linux_Dmabuf_Feedback_V1_Done, int) {
	e: Linux_Dmabuf_Feedback_V1_Done
	r: int
	n := r
	return e, n
}

Linux_Dmabuf_Feedback_V1_Format_Table :: struct {
	linux_dmabuf_feedback_v1: Linux_Dmabuf_Feedback_V1,
	fd: linux.Fd,
	size: u32,
}
linux_dmabuf_feedback_v1_format_table_read :: proc(buf: []byte) -> (Linux_Dmabuf_Feedback_V1_Format_Table, int) {
	e: Linux_Dmabuf_Feedback_V1_Format_Table
	r: int
	n := r
	e.size, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Linux_Dmabuf_Feedback_V1_Main_Device :: struct {
	linux_dmabuf_feedback_v1: Linux_Dmabuf_Feedback_V1,
	device: []u8,
}
linux_dmabuf_feedback_v1_main_device_read :: proc(buf: []byte) -> (Linux_Dmabuf_Feedback_V1_Main_Device, int) {
	e: Linux_Dmabuf_Feedback_V1_Main_Device
	r: int
	n := r
	e.device, r = util.read_array(buf[n:]); n += r
	return e, n
}

Linux_Dmabuf_Feedback_V1_Tranche_Done :: struct {
	linux_dmabuf_feedback_v1: Linux_Dmabuf_Feedback_V1,
}
linux_dmabuf_feedback_v1_tranche_done_read :: proc(buf: []byte) -> (Linux_Dmabuf_Feedback_V1_Tranche_Done, int) {
	e: Linux_Dmabuf_Feedback_V1_Tranche_Done
	r: int
	n := r
	return e, n
}

Linux_Dmabuf_Feedback_V1_Tranche_Target_Device :: struct {
	linux_dmabuf_feedback_v1: Linux_Dmabuf_Feedback_V1,
	device: []u8,
}
linux_dmabuf_feedback_v1_tranche_target_device_read :: proc(buf: []byte) -> (Linux_Dmabuf_Feedback_V1_Tranche_Target_Device, int) {
	e: Linux_Dmabuf_Feedback_V1_Tranche_Target_Device
	r: int
	n := r
	e.device, r = util.read_array(buf[n:]); n += r
	return e, n
}

Linux_Dmabuf_Feedback_V1_Tranche_Formats :: struct {
	linux_dmabuf_feedback_v1: Linux_Dmabuf_Feedback_V1,
	indices: []u8,
}
linux_dmabuf_feedback_v1_tranche_formats_read :: proc(buf: []byte) -> (Linux_Dmabuf_Feedback_V1_Tranche_Formats, int) {
	e: Linux_Dmabuf_Feedback_V1_Tranche_Formats
	r: int
	n := r
	e.indices, r = util.read_array(buf[n:]); n += r
	return e, n
}

Linux_Dmabuf_Feedback_V1_Tranche_Flags :: struct {
	linux_dmabuf_feedback_v1: Linux_Dmabuf_Feedback_V1,
	flags: u32,
}
linux_dmabuf_feedback_v1_tranche_flags_read :: proc(buf: []byte) -> (Linux_Dmabuf_Feedback_V1_Tranche_Flags, int) {
	e: Linux_Dmabuf_Feedback_V1_Tranche_Flags
	r: int
	n := r
	e.flags, r = util.read_u32(buf[n:]); n += r
	return e, n
}

