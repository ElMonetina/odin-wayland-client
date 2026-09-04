package linux_dmabuf_v1

// Copyright © 2014, 2015 Collabora, Ltd.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice (including the next
// paragraph) shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

import util "../util"
import "core:bytes"
import "core:mem"
import "core:strings"
import "core:sys/linux"

Request :: union #no_nil {
	Dmabuf_Destroy_Request,
	Dmabuf_Create_Params_Request,
	Dmabuf_Get_Default_Feedback_Request,
	Dmabuf_Get_Surface_Feedback_Request,
	Buffer_Params_Destroy_Request,
	Buffer_Params_Add_Request,
	Buffer_Params_Create_Request,
	Buffer_Params_Create_Immed_Request,
	Buffer_Params_Set_Sampling_Device_Request,
	Dmabuf_Feedback_Destroy_Request,
}

Event :: union #no_nil {
	Dmabuf_Format_Event,
	Dmabuf_Modifier_Event,
	Buffer_Params_Created_Event,
	Buffer_Params_Failed_Event,
	Dmabuf_Feedback_Done_Event,
	Dmabuf_Feedback_Format_Table_Event,
	Dmabuf_Feedback_Main_Device_Event,
	Dmabuf_Feedback_Tranche_Done_Event,
	Dmabuf_Feedback_Tranche_Target_Device_Event,
	Dmabuf_Feedback_Tranche_Formats_Event,
	Dmabuf_Feedback_Tranche_Flags_Event,
}

// factory for creating dmabuf-based wl_buffers
// This interface offers ways to create generic dmabuf-based wl_buffers.
// For more information about dmabuf, see:
// https://www.kernel.org/doc/html/next/userspace-api/dma-buf-alloc-exchange.html
// Clients can use the get_surface_feedback request to get dmabuf feedback
// for a particular surface. If the client wants to retrieve feedback not
// tied to a surface, they can use the get_default_feedback request.
// The following are required from clients:
// - Clients must ensure that either all data in the dma-buf is
// coherent for all subsequent read access or that coherency is
// correctly handled by the underlying kernel-side dma-buf
// implementation.
// - Don't make any more attachments after sending the buffer to the
// compositor. Making more attachments later increases the risk of
// the compositor not being able to use (re-import) an existing
// dmabuf-based wl_buffer.
// The underlying graphics stack must ensure the following:
// - The dmabuf file descriptors relayed to the server will stay valid
// for the whole lifetime of the wl_buffer. This means the server may
// at any time use those fds to import the dmabuf into any kernel
// sub-system that might accept it.
// However, when the underlying graphics stack fails to deliver the
// promise, because of e.g. a device hot-unplug which raises internal
// errors, after the wl_buffer has been successfully created the
// compositor must not raise protocol errors to the client when dmabuf
// import later fails.
// To create a wl_buffer from one or more dmabufs, a client creates a
// zwp_linux_buffer_params_v1 object with a zwp_linux_dmabuf_v1.create_params
// request. All planes required by the intended format are added with
// the 'add' request. Finally, a 'create' or 'create_immed' request is
// issued, which has the following outcome depending on the import success.
// The 'create' request,
// - on success, triggers a 'created' event which provides the final
// wl_buffer to the client.
// - on failure, triggers a 'failed' event to convey that the server
// cannot use the dmabufs received from the client.
// For the 'create_immed' request,
// - on success, the server immediately imports the added dmabufs to
// create a wl_buffer. No event is sent from the server in this case.
// - on failure, the server can choose to either:
// - terminate the client by raising a fatal error.
// - mark the wl_buffer as failed, and send a 'failed' event to the
// client. If the client uses a failed wl_buffer as an argument to any
// request, the behaviour is compositor implementation-defined.
// For all DRM formats and unless specified in another protocol extension,
// pre-multiplied alpha is used for pixel values.
// Unless specified otherwise in another protocol extension, implicit
// synchronization is used. In other words, compositors and clients must
// wait and signal fences implicitly passed via the DMA-BUF's reservation
// mechanism.
DMABUF_INTERFACE :: "zwp_linux_dmabuf_v1"
DMABUF_VERSION :: 6

// unbind the factory
// Objects created through this interface, especially wl_buffers, will
// remain valid.
DMABUF_DESTROY_OPCODE :: 0
Dmabuf_Destroy_Request :: struct {
	dmabuf : u32,
}
dmabuf_destroy_encode :: proc(req: Dmabuf_Destroy_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.dmabuf
	opcode := u16(DMABUF_DESTROY_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// create a temporary object for buffer parameters
// This temporary object is used to collect multiple dmabuf handles into
// a single batch to create a wl_buffer. It can only be used once and
// should be destroyed after a 'created' or 'failed' event has been
// received.
DMABUF_CREATE_PARAMS_OPCODE :: 1
Dmabuf_Create_Params_Request :: struct {
	dmabuf : u32,
}
dmabuf_create_params_encode :: proc(req: Dmabuf_Create_Params_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.dmabuf
	opcode := u16(DMABUF_CREATE_PARAMS_OPCODE)
	size := u16(8 + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// get default feedback
// This request creates a new zwp_linux_dmabuf_feedback_v1 object not bound
// to a particular surface. This object will deliver feedback about dmabuf
// parameters to use if the client doesn't support per-surface feedback
// (see get_surface_feedback).
DMABUF_GET_DEFAULT_FEEDBACK_OPCODE :: 2
Dmabuf_Get_Default_Feedback_Request :: struct {
	dmabuf : u32,
}
dmabuf_get_default_feedback_encode :: proc(req: Dmabuf_Get_Default_Feedback_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.dmabuf
	opcode := u16(DMABUF_GET_DEFAULT_FEEDBACK_OPCODE)
	size := u16(8 + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// get feedback for a surface
// This request creates a new zwp_linux_dmabuf_feedback_v1 object for the
// specified wl_surface. This object will deliver feedback about dmabuf
// parameters to use for buffers attached to this surface.
// If the surface is destroyed before the zwp_linux_dmabuf_feedback_v1 object,
// the feedback object becomes inert.
DMABUF_GET_SURFACE_FEEDBACK_OPCODE :: 3
Dmabuf_Get_Surface_Feedback_Request :: struct {
	dmabuf  : u32,
	surface : u32,
}
dmabuf_get_surface_feedback_encode :: proc(req: Dmabuf_Get_Surface_Feedback_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.dmabuf
	opcode := u16(DMABUF_GET_SURFACE_FEEDBACK_OPCODE)
	size := u16(8 + size_of(new_id) + size_of(req.surface))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	util.write(&msg, req.surface)
	encoded = msg[:]
	return
}

// supported buffer format
// This event advertises one buffer format that the server supports.
// All the supported formats are advertised once when the client
// binds to this interface. A roundtrip after binding guarantees
// that the client has received all supported formats.
// For the definition of the format codes, see the
// zwp_linux_buffer_params_v1::create request.
// Starting version 4, the format event is deprecated and must not be
// sent by compositors. Instead, use get_default_feedback or
// get_surface_feedback.
DMABUF_FORMAT_OPCODE :: 0
Dmabuf_Format_Event :: struct {
	format : u32,  // DRM_FORMAT code
}
dmabuf_format_decode :: proc(data: []byte) -> Dmabuf_Format_Event {
	e: Dmabuf_Format_Event
	r: int
	n := r
	e.format, r = util.read_u32(data[n:]); n += r
	return e
}

// supported buffer format modifier
// This event advertises the formats that the server supports, along with
// the modifiers supported for each format. All the supported modifiers
// for all the supported formats are advertised once when the client
// binds to this interface. A roundtrip after binding guarantees that
// the client has received all supported format-modifier pairs.
// For legacy support, DRM_FORMAT_MOD_INVALID (that is, modifier_hi ==
// 0x00ffffff and modifier_lo == 0xffffffff) is allowed in this event.
// It indicates that the server can support the format with an implicit
// modifier. When a plane has DRM_FORMAT_MOD_INVALID as its modifier, it
// is as if no explicit modifier is specified. The effective modifier
// will be derived from the dmabuf.
// A compositor that sends valid modifiers and DRM_FORMAT_MOD_INVALID for
// a given format supports both explicit modifiers and implicit modifiers.
// For the definition of the format and modifier codes, see the
// zwp_linux_buffer_params_v1::create and zwp_linux_buffer_params_v1::add
// requests.
// Starting version 4, the modifier event is deprecated and must not be
// sent by compositors. Instead, use get_default_feedback or
// get_surface_feedback.
DMABUF_MODIFIER_OPCODE :: 1
Dmabuf_Modifier_Event :: struct {
	format      : u32,  // DRM_FORMAT code
	modifier_hi : u32,  // high 32 bits of layout modifier
	modifier_lo : u32,  // low 32 bits of layout modifier
}
dmabuf_modifier_decode :: proc(data: []byte) -> Dmabuf_Modifier_Event {
	e: Dmabuf_Modifier_Event
	r: int
	n := r
	e.format, r = util.read_u32(data[n:]); n += r
	e.modifier_hi, r = util.read_u32(data[n:]); n += r
	e.modifier_lo, r = util.read_u32(data[n:]); n += r
	return e
}

// parameters for creating a dmabuf-based wl_buffer
// This temporary object is a collection of dmabufs and other
// parameters that together form a single logical buffer. The temporary
// object may eventually create one wl_buffer unless cancelled by
// destroying it before requesting 'create'.
// Single-planar formats only require one dmabuf, however
// multi-planar formats may require more than one dmabuf. For all
// formats, an 'add' request must be called once per plane (even if the
// underlying dmabuf fd is identical).
// You must use consecutive plane indices ('plane_idx' argument for 'add')
// from zero to the number of planes used by the drm_fourcc format code.
// All planes required by the format must be given exactly once, but can
// be given in any order. Each plane index can only be set once; subsequent
// calls with a plane index which has already been set will result in a
// plane_set error being generated.
BUFFER_PARAMS_INTERFACE :: "zwp_linux_buffer_params_v1"
BUFFER_PARAMS_VERSION :: 6

// delete this object, used or not
// Cleans up the temporary data sent to the server for dmabuf-based
// wl_buffer creation.
BUFFER_PARAMS_DESTROY_OPCODE :: 0
Buffer_Params_Destroy_Request :: struct {
	buffer_params : u32,
}
buffer_params_destroy_encode :: proc(req: Buffer_Params_Destroy_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.buffer_params
	opcode := u16(BUFFER_PARAMS_DESTROY_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// add a dmabuf to the temporary set
// This request adds one dmabuf to the set in this
// zwp_linux_buffer_params_v1.
// The 64-bit unsigned value combined from modifier_hi and modifier_lo
// is the dmabuf layout modifier. DRM AddFB2 ioctl calls this the
// fb modifier, which is defined in drm_mode.h of Linux UAPI.
// This is an opaque token. Drivers use this token to express tiling,
// compression, etc. driver-specific modifications to the base format
// defined by the DRM fourcc code.
// Starting from version 4, the invalid_format protocol error is sent if
// the format + modifier pair was not advertised as supported.
// Starting from version 5, the invalid_format protocol error is sent if
// all planes don't use the same modifier.
// This request raises the PLANE_IDX error if plane_idx is too large.
// The error PLANE_SET is raised if attempting to set a plane that
// was already set.
BUFFER_PARAMS_ADD_OPCODE :: 1
Buffer_Params_Add_Request :: struct {
	buffer_params : u32,
	fd            : linux.Fd,  // dmabuf fd
	plane_idx     : u32,  // plane index
	offset        : u32,  // offset in bytes
	stride        : u32,  // stride in bytes
	modifier_hi   : u32,  // high 32 bits of layout modifier
	modifier_lo   : u32,  // low 32 bits of layout modifier
}
buffer_params_add_encode :: proc(req: Buffer_Params_Add_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.buffer_params
	opcode := u16(BUFFER_PARAMS_ADD_OPCODE)
	size := u16(8 + size_of(req.plane_idx) + size_of(req.offset) + size_of(req.stride) + size_of(req.modifier_hi) + size_of(req.modifier_lo))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	// fd: fd — sent via SCM_RIGHTS, not in the body
	util.write(&msg, req.plane_idx)
	util.write(&msg, req.offset)
	util.write(&msg, req.stride)
	util.write(&msg, req.modifier_hi)
	util.write(&msg, req.modifier_lo)
	encoded = msg[:]
	return
}

// create a wl_buffer from the given dmabufs
// This asks for creation of a wl_buffer from the added dmabuf
// buffers. The wl_buffer is not created immediately but returned via
// the 'created' event if the dmabuf sharing succeeds. The sharing
// may fail at runtime for reasons a client cannot predict, in
// which case the 'failed' event is triggered.
// The 'format' argument is a DRM_FORMAT code, as defined by the
// libdrm's drm_fourcc.h. The Linux kernel's DRM sub-system is the
// authoritative source on how the format codes should work.
// The 'flags' is a bitfield of the flags defined in enum "flags".
// 'y_invert' means that the image needs to be y-flipped.
// Flag 'interlaced' means that the frame in the buffer is not
// progressive as usual, but interlaced. An interlaced buffer as
// supported here must always contain both top and bottom fields.
// The top field always begins on the first pixel row. The temporal
// ordering between the two fields is top field first, unless
// 'bottom_first' is specified. It is undefined whether 'bottom_first'
// is ignored if 'interlaced' is not set.
// This protocol does not convey any information about field rate,
// duration, or timing, other than the relative ordering between the
// two fields in one buffer. A compositor may have to estimate the
// intended field rate from the incoming buffer rate. It is undefined
// whether the time of receiving wl_surface.commit with a new buffer
// attached, applying the wl_surface state, wl_surface.frame callback
// trigger, presentation, or any other point in the compositor cycle
// is used to measure the frame or field times. There is no support
// for detecting missed or late frames/fields/buffers either, and
// there is no support whatsoever for cooperating with interlaced
// compositor output.
// The composited image quality resulting from the use of interlaced
// buffers is explicitly undefined. A compositor may use elaborate
// hardware features or software to deinterlace and create progressive
// output frames from a sequence of interlaced input buffers, or it
// may produce substandard image quality. However, compositors that
// cannot guarantee reasonable image quality in all cases are recommended
// to just reject all interlaced buffers.
// Any argument errors, including non-positive width or height,
// mismatch between the number of planes and the format, bad
// format, bad offset or stride, may be indicated by fatal protocol
// errors: INCOMPLETE, INVALID_FORMAT, INVALID_DIMENSIONS,
// OUT_OF_BOUNDS.
// Dmabuf import errors in the server that are not obvious client
// bugs are returned via the 'failed' event as non-fatal. This
// allows attempting dmabuf sharing and falling back in the client
// if it fails.
// This request can be sent only once in the object's lifetime, after
// which the only legal request is destroy. This object should be
// destroyed after issuing a 'create' request. Attempting to use this
// object after issuing 'create' raises the ALREADY_USED protocol error.
// It is not mandatory to issue 'create'. If a client wants to
// cancel the buffer creation, it can just destroy this object.
BUFFER_PARAMS_CREATE_OPCODE :: 2
Buffer_Params_Create_Request :: struct {
	buffer_params : u32,
	width         : i32,  // base plane width in pixels
	height        : i32,  // base plane height in pixels
	format        : u32,  // DRM_FORMAT code
	flags         : Buffer_Params_Flags_Set,  // see enum flags
}
buffer_params_create_encode :: proc(req: Buffer_Params_Create_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.buffer_params
	opcode := u16(BUFFER_PARAMS_CREATE_OPCODE)
	size := u16(8 + size_of(req.width) + size_of(req.height) + size_of(req.format) + size_of(req.flags))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.width)
	util.write(&msg, req.height)
	util.write(&msg, req.format)
	util.write_u32(&msg, transmute(u32)req.flags)
	encoded = msg[:]
	return
}

// immediately create a wl_buffer from the given                      dmabufs
// This asks for immediate creation of a wl_buffer by importing the
// added dmabufs.
// In case of import success, no event is sent from the server, and the
// wl_buffer is ready to be used by the client.
// Upon import failure, either of the following may happen, as seen fit
// by the implementation:
// - the client is terminated with one of the following fatal protocol
// errors:
// - INCOMPLETE, INVALID_FORMAT, INVALID_DIMENSIONS, OUT_OF_BOUNDS,
// in case of argument errors such as mismatch between the number
// of planes and the format, bad format, non-positive width or
// height, or bad offset or stride.
// - INVALID_WL_BUFFER, in case the cause for failure is unknown or
// platform specific.
// - the server creates an invalid wl_buffer, marks it as failed and
// sends a 'failed' event to the client. The result of using this
// invalid wl_buffer as an argument in any request by the client is
// defined by the compositor implementation.
// This takes the same arguments as a 'create' request, and obeys the
// same restrictions.
BUFFER_PARAMS_CREATE_IMMED_OPCODE :: 3
Buffer_Params_Create_Immed_Request :: struct {
	buffer_params : u32,
	width         : i32,  // base plane width in pixels
	height        : i32,  // base plane height in pixels
	format        : u32,  // DRM_FORMAT code
	flags         : Buffer_Params_Flags_Set,  // see enum flags
}
buffer_params_create_immed_encode :: proc(req: Buffer_Params_Create_Immed_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.buffer_params
	opcode := u16(BUFFER_PARAMS_CREATE_IMMED_OPCODE)
	size := u16(8 + size_of(new_id) + size_of(req.width) + size_of(req.height) + size_of(req.format) + size_of(req.flags))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	util.write(&msg, req.width)
	util.write(&msg, req.height)
	util.write(&msg, req.format)
	util.write_u32(&msg, transmute(u32)req.flags)
	encoded = msg[:]
	return
}

// set the target device of the wl_buffer
// Set the device the compositor should import the dmabufs to for sampling
// in the next create or create_immed request.
// To avoid race conditions when the compositor removes a device from the
// tranches, it is not a protocol error if the device hasn't been advertised
// by the compositor in a tranche with the sampling flag, but the import is
// likely to fail in that case.
// If the client doesn't know a suitable target device, it shouldn't set one,
// and the compositor should attempt import on all devices it supports.
// If the array is too small to contain a dev_t or larger than required, the
// invalid_dev_t_size error will be emitted.
BUFFER_PARAMS_SET_SAMPLING_DEVICE_OPCODE :: 4
Buffer_Params_Set_Sampling_Device_Request :: struct {
	buffer_params : u32,
	device        : []u8,  // device dev_t value
}
buffer_params_set_sampling_device_encode :: proc(req: Buffer_Params_Set_Sampling_Device_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.buffer_params
	opcode := u16(BUFFER_PARAMS_SET_SAMPLING_DEVICE_OPCODE)
	size := u16(8 + util.compute_array_size(req.device))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.device)
	encoded = msg[:]
	return
}

// buffer creation succeeded
// This event indicates that the attempted buffer creation was
// successful. It provides the new wl_buffer referencing the dmabuf(s).
// Upon receiving this event, the client should destroy the
// zwp_linux_buffer_params_v1 object.
BUFFER_PARAMS_CREATED_OPCODE :: 0
Buffer_Params_Created_Event :: struct {
	buffer : u32,  // id for the the newly created wl_buffer
}
buffer_params_created_decode :: proc(data: []byte) -> Buffer_Params_Created_Event {
	e: Buffer_Params_Created_Event
	r: int
	n := r
	e.buffer, r = util.read_u32(data[n:]); n += r
	return e
}

// buffer creation failed
// This event indicates that the attempted buffer creation has
// failed. It usually means that one of the dmabuf constraints
// has not been fulfilled.
// Upon receiving this event, the client should destroy the
// zwp_linux_buffer_params_v1 object.
BUFFER_PARAMS_FAILED_OPCODE :: 1
Buffer_Params_Failed_Event :: struct {}
buffer_params_failed_decode :: proc(data: []byte) -> Buffer_Params_Failed_Event {
	e: Buffer_Params_Failed_Event
	r: int
	n := r
	return e
}

Buffer_Params_Error :: enum u32 {
	Already_Used = 0,  // the zwp_linux_buffer_params_v1 object has already been used to create a wl_buffer
	Plane_Idx = 1,  // plane index out of bounds
	Plane_Set = 2,  // the plane index was already set
	Incomplete = 3,  // missing or too many planes to create a buffer
	Invalid_Format = 4,  // format not supported
	Invalid_Dimensions = 5,  // invalid width or height
	Out_Of_Bounds = 6,  // offset + stride * height goes out of dmabuf bounds
	Invalid_Wl_Buffer = 7,  // invalid wl_buffer resulted from importing dmabufs via                the create_immed request on given buffer_params
	Invalid_Dev_T_Size = 8,  // an array with mismatching size for a dev_t was used
}

Buffer_Params_Flags :: enum u32 {
	Y_Invert = 0,  // contents are y-inverted
	Interlaced = 1,  // content is interlaced
	Bottom_First = 2,  // bottom field first
}
Buffer_Params_Flags_Set :: bit_set[Buffer_Params_Flags; u32]

// dmabuf feedback
// This object advertises dmabuf parameters feedback. This includes the
// preferred devices and the supported formats/modifiers.
// The parameters are sent once when this object is created and whenever they
// change. The done event is always sent once after all parameters have been
// sent. When a single parameter changes, all parameters are re-sent by the
// compositor.
// Compositors can re-send the parameters when the current client buffer
// allocations are sub-optimal. Compositors should not re-send the
// parameters if re-allocating the buffers would not result in a more optimal
// configuration. In particular, compositors should avoid sending the exact
// same parameters multiple times in a row.
// The tranche_target_device and tranche_formats events are grouped by
// tranches of preference. For each tranche, a tranche_target_device, one
// tranche_flags and one or more tranche_formats events are sent, followed
// by a tranche_done event finishing the list. The tranches are sent in
// descending order of preference. All formats and modifiers in the same
// tranche have the same preference.
// To send parameters, the compositor sends one main_device event (unless
// the client bound version 6 or above), tranches (each consisting of one
// tranche_target_device event, one tranche_flags event, tranche_formats
// events and then a tranche_done event), then one done event.
// With version 6 and above, the compositor must always advertise at least
// one tranche with the sampling flag set.
// The compositor sends a format_table event at least once for each dmabuf
// parameters feedback object, before any tranche events. Unless the format
// table contents change later, the compositor is free not to send another
// format_table event for the same dmabuf parameters feedback object.
DMABUF_FEEDBACK_INTERFACE :: "zwp_linux_dmabuf_feedback_v1"
DMABUF_FEEDBACK_VERSION :: 6

// destroy the feedback object
// Using this request a client can tell the server that it is not going to
// use the zwp_linux_dmabuf_feedback_v1 object anymore.
DMABUF_FEEDBACK_DESTROY_OPCODE :: 0
Dmabuf_Feedback_Destroy_Request :: struct {
	dmabuf_feedback : u32,
}
dmabuf_feedback_destroy_encode :: proc(req: Dmabuf_Feedback_Destroy_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.dmabuf_feedback
	opcode := u16(DMABUF_FEEDBACK_DESTROY_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// all feedback has been sent
// This event is sent after all parameters of a zwp_linux_dmabuf_feedback_v1
// object have been sent.
// This allows changes to the zwp_linux_dmabuf_feedback_v1 parameters to be
// seen as atomic, even if they happen via multiple events.
DMABUF_FEEDBACK_DONE_OPCODE :: 0
Dmabuf_Feedback_Done_Event :: struct {}
dmabuf_feedback_done_decode :: proc(data: []byte) -> Dmabuf_Feedback_Done_Event {
	e: Dmabuf_Feedback_Done_Event
	r: int
	n := r
	return e
}

// format and modifier table
// This event provides a file descriptor which can be memory-mapped to
// access the format and modifier table.
// The table contains a tightly packed array of consecutive format +
// modifier pairs. Each pair is 16 bytes wide. It contains a format as a
// 32-bit unsigned integer, followed by 4 bytes of unused padding, and a
// modifier as a 64-bit unsigned integer. The native endianness is used.
// The client must map the file descriptor in read-only private mode.
// Compositors are not allowed to mutate the table file contents once this
// event has been sent. Instead, compositors must create a new, separate
// table file and re-send feedback parameters. Compositors are allowed to
// store duplicate format + modifier pairs in the table.
DMABUF_FEEDBACK_FORMAT_TABLE_OPCODE :: 1
Dmabuf_Feedback_Format_Table_Event :: struct {
	fd   : linux.Fd,  // table file descriptor
	size : u32,  // table size, in bytes
}
dmabuf_feedback_format_table_decode :: proc(data: []byte, fds: ^[dynamic]linux.Fd) -> Dmabuf_Feedback_Format_Table_Event {
	e: Dmabuf_Feedback_Format_Table_Event
	r: int
	n := r
	e.fd = pop_front(fds)
	e.size, r = util.read_u32(data[n:]); n += r
	return e
}

// preferred main device
// This event advertises the main device that the server prefers to use
// when direct scan-out to the target device isn't possible. The
// advertised main device may be different for each
// zwp_linux_dmabuf_feedback_v1 object, and may change over time.
// There is exactly one main device. The compositor must send at least
// one preference tranche with tranche_target_device equal to main_device.
// Clients need to create buffers that the main device can import and
// read from, otherwise creating the dmabuf wl_buffer will fail (see the
// zwp_linux_buffer_params_v1.create and create_immed requests for details).
// The main device will also likely be kept active by the compositor,
// so clients can use it instead of waking up another device for power
// savings.
// In general the device is a DRM node. The DRM node type (primary vs.
// render) is unspecified. Clients must not rely on the compositor sending
// a particular node type. Clients cannot check two devices for equality
// by comparing the dev_t value.
// If explicit modifiers are not supported and the client performs buffer
// allocations on a different device than the main device, then the client
// must force the buffer to have a linear layout.
// With version 6 and above, this event is no longer sent. Clients should
// use a device with the sampling flag in the tranches instead.
DMABUF_FEEDBACK_MAIN_DEVICE_OPCODE :: 2
Dmabuf_Feedback_Main_Device_Event :: struct {
	device : []u8,  // device dev_t value
}
dmabuf_feedback_main_device_decode :: proc(data: []byte, allocator: mem.Allocator) -> Dmabuf_Feedback_Main_Device_Event {
	e: Dmabuf_Feedback_Main_Device_Event
	r: int
	n := r
	e.device, r = util.read_array(data[n:]); n += r
	e.device = bytes.clone(e.device, allocator)
	return e
}

// a preference tranche has been sent
// This event splits tranche_target_device and tranche_formats events into
// preference tranches. It is sent after a set of tranche_target_device
// and tranche_formats events; it represents the end of a tranche. The
// next tranche will have a lower preference.
DMABUF_FEEDBACK_TRANCHE_DONE_OPCODE :: 3
Dmabuf_Feedback_Tranche_Done_Event :: struct {}
dmabuf_feedback_tranche_done_decode :: proc(data: []byte) -> Dmabuf_Feedback_Tranche_Done_Event {
	e: Dmabuf_Feedback_Tranche_Done_Event
	r: int
	n := r
	return e
}

// target device
// This event advertises the target device that the server prefers to use
// for a buffer created given this tranche. The advertised target device
// may be different for each preference tranche, and may change over time.
// There is exactly one target device per tranche.
// The target device may be a scan-out device, for example if the
// compositor prefers to directly scan-out a buffer created given this
// tranche. The target device may be a rendering device, for example if
// the compositor prefers to texture from said buffer.
// The client can use this hint to allocate the buffer in a way that makes
// it accessible from the target device, ideally directly. The buffer must
// still be accessible from a device with the sampling flag, either through
// direct import or a potentially more expensive fallback path. If the
// buffer can't be directly imported for sampling, then clients must be
// prepared for the compositor changing the tranche priority or making
// wl_buffer creation fail (see the zwp_linux_buffer_params_v1.create and
// create_immed requests for details).
// If the device is a DRM node, the DRM node type (primary vs. render) is
// unspecified. Clients must not rely on the compositor sending a
// particular node type. Clients cannot check two devices for equality by
// comparing the dev_t value.
// This event is tied to a preference tranche, see the tranche_done event.
DMABUF_FEEDBACK_TRANCHE_TARGET_DEVICE_OPCODE :: 4
Dmabuf_Feedback_Tranche_Target_Device_Event :: struct {
	device : []u8,  // device dev_t value
}
dmabuf_feedback_tranche_target_device_decode :: proc(data: []byte, allocator: mem.Allocator) -> Dmabuf_Feedback_Tranche_Target_Device_Event {
	e: Dmabuf_Feedback_Tranche_Target_Device_Event
	r: int
	n := r
	e.device, r = util.read_array(data[n:]); n += r
	e.device = bytes.clone(e.device, allocator)
	return e
}

// supported buffer format modifiers
// This event advertises the format + modifier combinations that the
// compositor supports.
// It carries an array of indices, each referring to a format + modifier
// pair in the last received format table (see the format_table event).
// Each index is a 16-bit unsigned integer in native endianness.
// For legacy support, DRM_FORMAT_MOD_INVALID is an allowed modifier.
// It indicates that the server can support the format with an implicit
// modifier. When a buffer has DRM_FORMAT_MOD_INVALID as its modifier, it
// is as if no explicit modifier is specified. The effective modifier
// will be derived from the dmabuf.
// A compositor that sends valid modifiers and DRM_FORMAT_MOD_INVALID for
// a given format supports both explicit modifiers and implicit modifiers.
// Compositors must not send duplicate format + modifier pairs within the
// same tranche or across two different tranches with the same target
// device and flags.
// This event is tied to a preference tranche, see the tranche_done event.
// For the definition of the format and modifier codes, see the
// zwp_linux_buffer_params_v1.create request.
DMABUF_FEEDBACK_TRANCHE_FORMATS_OPCODE :: 5
Dmabuf_Feedback_Tranche_Formats_Event :: struct {
	indices : []u8,  // array of 16-bit indexes
}
dmabuf_feedback_tranche_formats_decode :: proc(data: []byte, allocator: mem.Allocator) -> Dmabuf_Feedback_Tranche_Formats_Event {
	e: Dmabuf_Feedback_Tranche_Formats_Event
	r: int
	n := r
	e.indices, r = util.read_array(data[n:]); n += r
	e.indices = bytes.clone(e.indices, allocator)
	return e
}

// tranche flags
// This event sets tranche-specific flags. This event is tied to a
// preference tranche, see the tranche_done event.
// With version 6 and above, the compositor must set at least one flag
// in each tranche.
DMABUF_FEEDBACK_TRANCHE_FLAGS_OPCODE :: 6
Dmabuf_Feedback_Tranche_Flags_Event :: struct {
	flags : Dmabuf_Feedback_Tranche_Flags_Set,  // tranche flags
}
dmabuf_feedback_tranche_flags_decode :: proc(data: []byte) -> Dmabuf_Feedback_Tranche_Flags_Event {
	e: Dmabuf_Feedback_Tranche_Flags_Event
	r: int
	n := r
	val_flags, _ := util.read_u32(data[n:]); n += 4
	e.flags = transmute(Dmabuf_Feedback_Tranche_Flags_Set)val_flags
	return e
}

Dmabuf_Feedback_Tranche_Flags :: enum u32 {
	Scanout = 0,
	Sampling = 1,
}
Dmabuf_Feedback_Tranche_Flags_Set :: bit_set[Dmabuf_Feedback_Tranche_Flags; u32]
