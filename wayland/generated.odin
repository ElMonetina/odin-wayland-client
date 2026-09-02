package wayland

// Copyright © 2008-2011 Kristian Høgsberg
// Copyright © 2010-2011 Intel Corporation
// Copyright © 2012-2013 Collabora, Ltd.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation files
// (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice (including the
// next paragraph) shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import util "../util"
import "core:bytes"
import "core:mem"
import "core:strings"
import "core:sys/linux"

// The core global object, it is always defined to be equal to 1
@(rodata)
display := u32(1)

Request :: union #no_nil {
	Display_Sync_Request,
	Display_Get_Registry_Request,
	Registry_Bind_Request,
	Compositor_Create_Surface_Request,
	Compositor_Create_Region_Request,
	Compositor_Release_Request,
	Shm_Pool_Create_Buffer_Request,
	Shm_Pool_Destroy_Request,
	Shm_Pool_Resize_Request,
	Shm_Create_Pool_Request,
	Shm_Release_Request,
	Buffer_Destroy_Request,
	Data_Offer_Accept_Request,
	Data_Offer_Receive_Request,
	Data_Offer_Destroy_Request,
	Data_Offer_Finish_Request,
	Data_Offer_Set_Actions_Request,
	Data_Source_Offer_Request,
	Data_Source_Destroy_Request,
	Data_Source_Set_Actions_Request,
	Data_Device_Start_Drag_Request,
	Data_Device_Set_Selection_Request,
	Data_Device_Release_Request,
	Data_Device_Manager_Create_Data_Source_Request,
	Data_Device_Manager_Get_Data_Device_Request,
	Data_Device_Manager_Release_Request,
	Shell_Get_Shell_Surface_Request,
	Shell_Surface_Pong_Request,
	Shell_Surface_Move_Request,
	Shell_Surface_Resize_Request,
	Shell_Surface_Set_Toplevel_Request,
	Shell_Surface_Set_Transient_Request,
	Shell_Surface_Set_Fullscreen_Request,
	Shell_Surface_Set_Popup_Request,
	Shell_Surface_Set_Maximized_Request,
	Shell_Surface_Set_Title_Request,
	Shell_Surface_Set_Class_Request,
	Surface_Destroy_Request,
	Surface_Attach_Request,
	Surface_Damage_Request,
	Surface_Frame_Request,
	Surface_Set_Opaque_Region_Request,
	Surface_Set_Input_Region_Request,
	Surface_Commit_Request,
	Surface_Set_Buffer_Transform_Request,
	Surface_Set_Buffer_Scale_Request,
	Surface_Damage_Buffer_Request,
	Surface_Offset_Request,
	Surface_Get_Release_Request,
	Seat_Get_Pointer_Request,
	Seat_Get_Keyboard_Request,
	Seat_Get_Touch_Request,
	Seat_Release_Request,
	Pointer_Set_Cursor_Request,
	Pointer_Release_Request,
	Keyboard_Release_Request,
	Touch_Release_Request,
	Output_Release_Request,
	Region_Destroy_Request,
	Region_Add_Request,
	Region_Subtract_Request,
	Subcompositor_Destroy_Request,
	Subcompositor_Get_Subsurface_Request,
	Subsurface_Destroy_Request,
	Subsurface_Set_Position_Request,
	Subsurface_Place_Above_Request,
	Subsurface_Place_Below_Request,
	Subsurface_Set_Sync_Request,
	Subsurface_Set_Desync_Request,
	Fixes_Destroy_Request,
	Fixes_Destroy_Registry_Request,
	Fixes_Ack_Global_Remove_Request,
}

Event :: union #no_nil {
	Display_Error_Event,
	Display_Delete_Id_Event,
	Registry_Global_Event,
	Registry_Global_Remove_Event,
	Callback_Done_Event,
	Shm_Format_Event,
	Buffer_Release_Event,
	Data_Offer_Offer_Event,
	Data_Offer_Source_Actions_Event,
	Data_Offer_Action_Event,
	Data_Source_Target_Event,
	Data_Source_Send_Event,
	Data_Source_Cancelled_Event,
	Data_Source_Dnd_Drop_Performed_Event,
	Data_Source_Dnd_Finished_Event,
	Data_Source_Action_Event,
	Data_Device_Data_Offer_Event,
	Data_Device_Enter_Event,
	Data_Device_Leave_Event,
	Data_Device_Motion_Event,
	Data_Device_Drop_Event,
	Data_Device_Selection_Event,
	Shell_Surface_Ping_Event,
	Shell_Surface_Configure_Event,
	Shell_Surface_Popup_Done_Event,
	Surface_Enter_Event,
	Surface_Leave_Event,
	Surface_Preferred_Buffer_Scale_Event,
	Surface_Preferred_Buffer_Transform_Event,
	Seat_Capabilities_Event,
	Seat_Name_Event,
	Pointer_Enter_Event,
	Pointer_Leave_Event,
	Pointer_Motion_Event,
	Pointer_Button_Event,
	Pointer_Axis_Event,
	Pointer_Frame_Event,
	Pointer_Axis_Source_Event,
	Pointer_Axis_Stop_Event,
	Pointer_Axis_Discrete_Event,
	Pointer_Axis_Value120_Event,
	Pointer_Axis_Relative_Direction_Event,
	Pointer_Warp_Event,
	Keyboard_Keymap_Event,
	Keyboard_Enter_Event,
	Keyboard_Leave_Event,
	Keyboard_Key_Event,
	Keyboard_Modifiers_Event,
	Keyboard_Repeat_Info_Event,
	Touch_Down_Event,
	Touch_Up_Event,
	Touch_Motion_Event,
	Touch_Frame_Event,
	Touch_Cancel_Event,
	Touch_Shape_Event,
	Touch_Orientation_Event,
	Output_Geometry_Event,
	Output_Mode_Event,
	Output_Done_Event,
	Output_Scale_Event,
	Output_Name_Event,
	Output_Description_Event,
}

// core global object
// The core global object.  This is a special singleton object.  It
// is used for internal Wayland protocol features.
DISPLAY_INTERFACE :: "wl_display"
DISPLAY_VERSION :: 1

// asynchronous roundtrip
// The sync request asks the server to emit the 'done' event
// on the returned wl_callback object.  Since requests are
// handled in-order and events are delivered in-order, this can
// be used as a barrier to ensure all previous requests and the
// resulting events have been handled.
// The object returned by this request will be destroyed by the
// compositor after the callback is fired and as such the client must not
// attempt to use it after that point.
// The callback_data passed in the callback is undefined and should be ignored.
DISPLAY_SYNC_OPCODE :: 0
Display_Sync_Request :: struct {
	display : u32,
}
display_sync_encode :: proc(req: Display_Sync_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.display
	opcode := u16(DISPLAY_SYNC_OPCODE)
	size := u16(8 + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// get global registry object
// This request creates a registry object that allows the client
// to list and bind the global objects available from the
// compositor.
// It should be noted that the server side resources consumed in
// response to a get_registry request can only be released when the
// client disconnects, not when the client side proxy is destroyed.
// Therefore, clients should invoke get_registry as infrequently as
// possible to avoid wasting memory.
DISPLAY_GET_REGISTRY_OPCODE :: 1
Display_Get_Registry_Request :: struct {
	display : u32,
}
display_get_registry_encode :: proc(req: Display_Get_Registry_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.display
	opcode := u16(DISPLAY_GET_REGISTRY_OPCODE)
	size := u16(8 + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// fatal error event
// The error event is sent out when a fatal (non-recoverable)
// error has occurred.  The object_id argument is the object
// where the error occurred, most often in response to a request
// to that object.  The code identifies the error and is defined
// by the object interface.  As such, each interface defines its
// own set of error codes.  The message is a brief description
// of the error, for (debugging) convenience.
DISPLAY_ERROR_OPCODE :: 0
Display_Error_Event :: struct {
	object_id : u32,  // object where the error occurred
	code      : u32,  // error code
	message   : string,  // error description
}
display_error_decode :: proc(data: []byte, allocator: mem.Allocator) -> Display_Error_Event {
	e: Display_Error_Event
	r: int
	n := r
	e.object_id, r = util.read_u32(data[n:]); n += r
	e.code, r = util.read_u32(data[n:]); n += r
	e.message, r = util.read_string(data[n:]); n += r
	e.message = strings.clone(e.message, allocator)
	return e
}

// acknowledge object ID deletion
// This event is used internally by the object ID management logic.
// When the server stops using an object created by the client, the server
// sends this event. In particular, after sending this event, the server
// will no longer send any events that contain the object as the receiver
// or as an argument.
// When the client receives this event, it knows that it can reuse the
// object ID.
DISPLAY_DELETE_ID_OPCODE :: 1
Display_Delete_Id_Event :: struct {
	id : u32,  // deleted object ID
}
display_delete_id_decode :: proc(data: []byte) -> Display_Delete_Id_Event {
	e: Display_Delete_Id_Event
	r: int
	n := r
	e.id, r = util.read_u32(data[n:]); n += r
	return e
}

// global error values
// These errors are global and can be emitted in response to any
// server request.
Display_Error :: enum u32 {
	Invalid_Object = 0,  // server couldn't find object
	Invalid_Method = 1,  // method doesn't exist on the specified interface or malformed request
	No_Memory = 2,  // server is out of memory
	Implementation = 3,  // implementation error in compositor
}

// global registry object
// The singleton global registry object.  The server has a number of
// global objects that are available to all clients.  These objects
// typically represent an actual object in the server (for example,
// an input device) or they are singleton objects that provide
// extension functionality.
// When a client creates a registry object, the registry object
// will emit a global event for each global currently in the
// registry.  Globals come and go as a result of device or
// monitor hotplugs, reconfiguration or other events, and the
// registry will send out global and global_remove events to
// keep the client up to date with the changes.  To mark the end
// of the initial burst of events, the client can use the
// wl_display.sync request immediately after calling
// wl_display.get_registry.
// A client can bind to a global object by using the bind
// request.  This creates a client-side handle that lets the object
// emit events to the client and lets the client invoke requests on
// the object.
REGISTRY_INTERFACE :: "wl_registry"
REGISTRY_VERSION :: 1

// bind an object to the display
// Binds a new, client-created object to the server using the
// specified name as the identifier.
REGISTRY_BIND_OPCODE :: 0
Registry_Bind_Request :: struct {
	registry  : u32,
	name      : u32,
	interface : string,
	version   : u32,
}
registry_bind_encode :: proc(req: Registry_Bind_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.registry
	opcode := u16(REGISTRY_BIND_OPCODE)
	size := u16(8 + size_of(req.name) + util.compute_string_size(req.interface) + size_of(req.version) + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.name)
	util.write(&msg, req.interface)
	util.write(&msg, req.version)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// announce global object
// Notify the client of global objects.
// The event notifies the client that a global object with
// the given name is now available, and it implements the
// given version of the given interface.
REGISTRY_GLOBAL_OPCODE :: 0
Registry_Global_Event :: struct {
	name      : u32,  // numeric name of the global object
	interface : string,  // interface implemented by the object
	version   : u32,  // interface version
}
registry_global_decode :: proc(data: []byte, allocator: mem.Allocator) -> Registry_Global_Event {
	e: Registry_Global_Event
	r: int
	n := r
	e.name, r = util.read_u32(data[n:]); n += r
	e.interface, r = util.read_string(data[n:]); n += r
	e.interface = strings.clone(e.interface, allocator)
	e.version, r = util.read_u32(data[n:]); n += r
	return e
}

// announce removal of global object
// Notify the client of removed global objects.
// This event notifies the client that the global identified
// by name is no longer available.  If the client bound to
// the global using the bind request, the client should now
// destroy that object.
// The object remains valid and requests to the object will be
// ignored until the client destroys it, to avoid races between
// the global going away and a client sending a request to it.
REGISTRY_GLOBAL_REMOVE_OPCODE :: 1
Registry_Global_Remove_Event :: struct {
	name : u32,  // numeric name of the global object
}
registry_global_remove_decode :: proc(data: []byte) -> Registry_Global_Remove_Event {
	e: Registry_Global_Remove_Event
	r: int
	n := r
	e.name, r = util.read_u32(data[n:]); n += r
	return e
}

// callback object
// Clients can handle the 'done' event to get notified when
// the related request is done.
// Note, because wl_callback objects are created from multiple independent
// factory interfaces, the wl_callback interface is frozen at version 1.
CALLBACK_INTERFACE :: "wl_callback"
CALLBACK_VERSION :: 1

// done event
// Notify the client when the related request is done.
CALLBACK_DONE_OPCODE :: 0
Callback_Done_Event :: struct {
	callback_data : u32,  // request-specific data for the callback
}
callback_done_decode :: proc(data: []byte) -> Callback_Done_Event {
	e: Callback_Done_Event
	r: int
	n := r
	e.callback_data, r = util.read_u32(data[n:]); n += r
	return e
}

// the compositor singleton
// A compositor.  This object is a singleton global.  The
// compositor is in charge of combining the contents of multiple
// surfaces into one displayable output.
COMPOSITOR_INTERFACE :: "wl_compositor"
COMPOSITOR_VERSION :: 7

// create new surface
// Ask the compositor to create a new surface.
COMPOSITOR_CREATE_SURFACE_OPCODE :: 0
Compositor_Create_Surface_Request :: struct {
	compositor : u32,
}
compositor_create_surface_encode :: proc(req: Compositor_Create_Surface_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.compositor
	opcode := u16(COMPOSITOR_CREATE_SURFACE_OPCODE)
	size := u16(8 + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// create new region
// Ask the compositor to create a new region.
COMPOSITOR_CREATE_REGION_OPCODE :: 1
Compositor_Create_Region_Request :: struct {
	compositor : u32,
}
compositor_create_region_encode :: proc(req: Compositor_Create_Region_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.compositor
	opcode := u16(COMPOSITOR_CREATE_REGION_OPCODE)
	size := u16(8 + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// destroy wl_compositor
// This request destroys the wl_compositor. This has no effect on any other objects.
COMPOSITOR_RELEASE_OPCODE :: 2
Compositor_Release_Request :: struct {
	compositor : u32,
}
compositor_release_encode :: proc(req: Compositor_Release_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.compositor
	opcode := u16(COMPOSITOR_RELEASE_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// a shared memory pool
// The wl_shm_pool object encapsulates a piece of memory shared
// between the compositor and client.  Through the wl_shm_pool
// object, the client can allocate shared memory wl_buffer objects.
// All objects created through the same pool share the same
// underlying mapped memory. Reusing the mapped memory avoids the
// setup/teardown overhead and is useful when interactively resizing
// a surface or for many small buffers.
SHM_POOL_INTERFACE :: "wl_shm_pool"
SHM_POOL_VERSION :: 3

// create a buffer from the pool
// Create a wl_buffer object from the pool.
// The buffer is created offset bytes into the pool and has
// width and height as specified.  The stride argument specifies
// the number of bytes from the beginning of one row to the beginning
// of the next.  The format is the pixel format of the buffer and
// must be one of those advertised through the wl_shm.format event.
// A buffer will keep a reference to the pool it was created from
// so it is valid to destroy the pool immediately after creating
// a buffer from it.
SHM_POOL_CREATE_BUFFER_OPCODE :: 0
Shm_Pool_Create_Buffer_Request :: struct {
	shm_pool : u32,
	offset   : i32,  // buffer byte offset within the pool
	width    : i32,  // buffer width, in pixels
	height   : i32,  // buffer height, in pixels
	stride   : i32,  // number of bytes from the beginning of one row to the beginning of the next row
	format   : u32,  // buffer pixel format
}
shm_pool_create_buffer_encode :: proc(req: Shm_Pool_Create_Buffer_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shm_pool
	opcode := u16(SHM_POOL_CREATE_BUFFER_OPCODE)
	size := u16(8 + size_of(new_id) + size_of(req.offset) + size_of(req.width) + size_of(req.height) + size_of(req.stride) + size_of(req.format))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	util.write(&msg, req.offset)
	util.write(&msg, req.width)
	util.write(&msg, req.height)
	util.write(&msg, req.stride)
	util.write(&msg, req.format)
	encoded = msg[:]
	return
}

// destroy the pool
// Destroy the shared memory pool.
// The mmapped memory will be released when all
// buffers that have been created from this pool
// are gone.
SHM_POOL_DESTROY_OPCODE :: 1
Shm_Pool_Destroy_Request :: struct {
	shm_pool : u32,
}
shm_pool_destroy_encode :: proc(req: Shm_Pool_Destroy_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shm_pool
	opcode := u16(SHM_POOL_DESTROY_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// change the size of the pool mapping
// This request will cause the server to remap the backing memory
// for the pool from the file descriptor passed when the pool was
// created, but using the new size.  This request can only be
// used to make the pool bigger.
// This request only changes the amount of bytes that are mmapped
// by the server and does not touch the file corresponding to the
// file descriptor passed at creation time. It is the client's
// responsibility to ensure that the file is at least as big as
// the new pool size.
SHM_POOL_RESIZE_OPCODE :: 2
Shm_Pool_Resize_Request :: struct {
	shm_pool : u32,
	size     : i32,  // new size of the pool, in bytes
}
shm_pool_resize_encode :: proc(req: Shm_Pool_Resize_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shm_pool
	opcode := u16(SHM_POOL_RESIZE_OPCODE)
	size := u16(8 + size_of(req.size))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.size)
	encoded = msg[:]
	return
}

// wl_shm_pool error values
// These errors can be emitted in response to wl_shm_pool requests.
Shm_Pool_Error :: enum u32 {
	Invalid_Format = 0,  // buffer format is not known
	Invalid_Stride = 1,  // invalid size or stride during buffer creation
}

// shared memory support
// A singleton global object that provides support for shared
// memory.
// Clients can create wl_shm_pool objects using the create_pool
// request.
// On binding the wl_shm object one or more format events
// are emitted to inform clients about the valid pixel formats
// that can be used for buffers.
SHM_INTERFACE :: "wl_shm"
SHM_VERSION :: 3

// create a shm pool
// Create a new wl_shm_pool object.
// The pool can be used to create shared memory based buffer
// objects.  The server will mmap size bytes of the passed file
// descriptor, to use as backing memory for the pool.
SHM_CREATE_POOL_OPCODE :: 0
Shm_Create_Pool_Request :: struct {
	shm  : u32,
	fd   : linux.Fd,  // file descriptor for the pool
	size : i32,  // pool size, in bytes
}
shm_create_pool_encode :: proc(req: Shm_Create_Pool_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shm
	opcode := u16(SHM_CREATE_POOL_OPCODE)
	size := u16(8 + size_of(new_id) + size_of(req.size))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	// fd: fd — sent via SCM_RIGHTS, not in the body
	util.write(&msg, req.size)
	encoded = msg[:]
	return
}

// release the shm object
// Using this request a client can tell the server that it is not going to
// use the shm object anymore.
// Objects created via this interface remain unaffected.
SHM_RELEASE_OPCODE :: 1
Shm_Release_Request :: struct {
	shm : u32,
}
shm_release_encode :: proc(req: Shm_Release_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shm
	opcode := u16(SHM_RELEASE_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// pixel format description
// Informs the client about a valid pixel format that
// can be used for buffers. Known formats include
// argb8888 and xrgb8888.
// Extensions to drm_fourcc.h (or the format enum) do not require
// increasing the wl_shm version; as a result, clients may receive format
// codes which were not in the list at the time the client was made.
SHM_FORMAT_OPCODE :: 0
Shm_Format_Event :: struct {
	format : u32,  // buffer pixel format
}
shm_format_decode :: proc(data: []byte) -> Shm_Format_Event {
	e: Shm_Format_Event
	r: int
	n := r
	e.format, r = util.read_u32(data[n:]); n += r
	return e
}

// wl_shm error values
// These errors can be emitted in response to wl_shm requests.
Shm_Error :: enum u32 {
	Invalid_Format = 0,  // buffer format is not known
	Invalid_Stride = 1,  // invalid size or stride during pool creation
	Invalid_Fd = 2,  // mmapping the file descriptor failed
}

// pixel formats
// This describes the memory layout of an individual pixel.
// All renderers should support argb8888 and xrgb8888 but any other
// formats are optional and may not be supported by the particular
// renderer in use.
// The drm format codes match the macros defined in drm_fourcc.h, except
// argb8888 and xrgb8888. The formats actually supported by the compositor
// will be reported by the format event. See drm_fourcc.h for more detailed
// format descriptions.
// For all wl_shm formats and unless specified in another protocol
// extension, pre-multiplied alpha is used for pixel values.
Shm_Format :: enum u32 {
	Argb8888 = 0,  // 32-bit ARGB format, [31:0] A:R:G:B 8:8:8:8 little endian
	Xrgb8888 = 1,  // 32-bit RGB format, [31:0] x:R:G:B 8:8:8:8 little endian
	C8 = 0x20203843,  // 8-bit color index format, [7:0] C
	Rgb332 = 0x38424752,  // 8-bit RGB format, [7:0] R:G:B 3:3:2
	Bgr233 = 0x38524742,  // 8-bit BGR format, [7:0] B:G:R 2:3:3
	Xrgb4444 = 0x32315258,  // 16-bit xRGB format, [15:0] x:R:G:B 4:4:4:4 little endian
	Xbgr4444 = 0x32314258,  // 16-bit xBGR format, [15:0] x:B:G:R 4:4:4:4 little endian
	Rgbx4444 = 0x32315852,  // 16-bit RGBx format, [15:0] R:G:B:x 4:4:4:4 little endian
	Bgrx4444 = 0x32315842,  // 16-bit BGRx format, [15:0] B:G:R:x 4:4:4:4 little endian
	Argb4444 = 0x32315241,  // 16-bit ARGB format, [15:0] A:R:G:B 4:4:4:4 little endian
	Abgr4444 = 0x32314241,  // 16-bit ABGR format, [15:0] A:B:G:R 4:4:4:4 little endian
	Rgba4444 = 0x32314152,  // 16-bit RGBA format, [15:0] R:G:B:A 4:4:4:4 little endian
	Bgra4444 = 0x32314142,  // 16-bit BGRA format, [15:0] B:G:R:A 4:4:4:4 little endian
	Xrgb1555 = 0x35315258,  // 16-bit xRGB format, [15:0] x:R:G:B 1:5:5:5 little endian
	Xbgr1555 = 0x35314258,  // 16-bit xBGR 1555 format, [15:0] x:B:G:R 1:5:5:5 little endian
	Rgbx5551 = 0x35315852,  // 16-bit RGBx 5551 format, [15:0] R:G:B:x 5:5:5:1 little endian
	Bgrx5551 = 0x35315842,  // 16-bit BGRx 5551 format, [15:0] B:G:R:x 5:5:5:1 little endian
	Argb1555 = 0x35315241,  // 16-bit ARGB 1555 format, [15:0] A:R:G:B 1:5:5:5 little endian
	Abgr1555 = 0x35314241,  // 16-bit ABGR 1555 format, [15:0] A:B:G:R 1:5:5:5 little endian
	Rgba5551 = 0x35314152,  // 16-bit RGBA 5551 format, [15:0] R:G:B:A 5:5:5:1 little endian
	Bgra5551 = 0x35314142,  // 16-bit BGRA 5551 format, [15:0] B:G:R:A 5:5:5:1 little endian
	Rgb565 = 0x36314752,  // 16-bit RGB 565 format, [15:0] R:G:B 5:6:5 little endian
	Bgr565 = 0x36314742,  // 16-bit BGR 565 format, [15:0] B:G:R 5:6:5 little endian
	Rgb888 = 0x34324752,  // 24-bit RGB format, [23:0] R:G:B little endian
	Bgr888 = 0x34324742,  // 24-bit BGR format, [23:0] B:G:R little endian
	Xbgr8888 = 0x34324258,  // 32-bit xBGR format, [31:0] x:B:G:R 8:8:8:8 little endian
	Rgbx8888 = 0x34325852,  // 32-bit RGBx format, [31:0] R:G:B:x 8:8:8:8 little endian
	Bgrx8888 = 0x34325842,  // 32-bit BGRx format, [31:0] B:G:R:x 8:8:8:8 little endian
	Abgr8888 = 0x34324241,  // 32-bit ABGR format, [31:0] A:B:G:R 8:8:8:8 little endian
	Rgba8888 = 0x34324152,  // 32-bit RGBA format, [31:0] R:G:B:A 8:8:8:8 little endian
	Bgra8888 = 0x34324142,  // 32-bit BGRA format, [31:0] B:G:R:A 8:8:8:8 little endian
	Xrgb2101010 = 0x30335258,  // 32-bit xRGB format, [31:0] x:R:G:B 2:10:10:10 little endian
	Xbgr2101010 = 0x30334258,  // 32-bit xBGR format, [31:0] x:B:G:R 2:10:10:10 little endian
	Rgbx1010102 = 0x30335852,  // 32-bit RGBx format, [31:0] R:G:B:x 10:10:10:2 little endian
	Bgrx1010102 = 0x30335842,  // 32-bit BGRx format, [31:0] B:G:R:x 10:10:10:2 little endian
	Argb2101010 = 0x30335241,  // 32-bit ARGB format, [31:0] A:R:G:B 2:10:10:10 little endian
	Abgr2101010 = 0x30334241,  // 32-bit ABGR format, [31:0] A:B:G:R 2:10:10:10 little endian
	Rgba1010102 = 0x30334152,  // 32-bit RGBA format, [31:0] R:G:B:A 10:10:10:2 little endian
	Bgra1010102 = 0x30334142,  // 32-bit BGRA format, [31:0] B:G:R:A 10:10:10:2 little endian
	Yuyv = 0x56595559,  // packed YCbCr format, [31:0] Cr0:Y1:Cb0:Y0 8:8:8:8 little endian
	Yvyu = 0x55595659,  // packed YCbCr format, [31:0] Cb0:Y1:Cr0:Y0 8:8:8:8 little endian
	Uyvy = 0x59565955,  // packed YCbCr format, [31:0] Y1:Cr0:Y0:Cb0 8:8:8:8 little endian
	Vyuy = 0x59555956,  // packed YCbCr format, [31:0] Y1:Cb0:Y0:Cr0 8:8:8:8 little endian
	Ayuv = 0x56555941,  // packed AYCbCr format, [31:0] A:Y:Cb:Cr 8:8:8:8 little endian
	Nv12 = 0x3231564e,  // 2 plane YCbCr Cr:Cb format, 2x2 subsampled Cr:Cb plane
	Nv21 = 0x3132564e,  // 2 plane YCbCr Cb:Cr format, 2x2 subsampled Cb:Cr plane
	Nv16 = 0x3631564e,  // 2 plane YCbCr Cr:Cb format, 2x1 subsampled Cr:Cb plane
	Nv61 = 0x3136564e,  // 2 plane YCbCr Cb:Cr format, 2x1 subsampled Cb:Cr plane
	Yuv410 = 0x39565559,  // 3 plane YCbCr format, 4x4 subsampled Cb (1) and Cr (2) planes
	Yvu410 = 0x39555659,  // 3 plane YCbCr format, 4x4 subsampled Cr (1) and Cb (2) planes
	Yuv411 = 0x31315559,  // 3 plane YCbCr format, 4x1 subsampled Cb (1) and Cr (2) planes
	Yvu411 = 0x31315659,  // 3 plane YCbCr format, 4x1 subsampled Cr (1) and Cb (2) planes
	Yuv420 = 0x32315559,  // 3 plane YCbCr format, 2x2 subsampled Cb (1) and Cr (2) planes
	Yvu420 = 0x32315659,  // 3 plane YCbCr format, 2x2 subsampled Cr (1) and Cb (2) planes
	Yuv422 = 0x36315559,  // 3 plane YCbCr format, 2x1 subsampled Cb (1) and Cr (2) planes
	Yvu422 = 0x36315659,  // 3 plane YCbCr format, 2x1 subsampled Cr (1) and Cb (2) planes
	Yuv444 = 0x34325559,  // 3 plane YCbCr format, non-subsampled Cb (1) and Cr (2) planes
	Yvu444 = 0x34325659,  // 3 plane YCbCr format, non-subsampled Cr (1) and Cb (2) planes
	R8 = 0x20203852,  // [7:0] R
	R16 = 0x20363152,  // [15:0] R little endian
	Rg88 = 0x38384752,  // [15:0] R:G 8:8 little endian
	Gr88 = 0x38385247,  // [15:0] G:R 8:8 little endian
	Rg1616 = 0x32334752,  // [31:0] R:G 16:16 little endian
	Gr1616 = 0x32335247,  // [31:0] G:R 16:16 little endian
	Xrgb16161616f = 0x48345258,  // [63:0] x:R:G:B 16:16:16:16 little endian
	Xbgr16161616f = 0x48344258,  // [63:0] x:B:G:R 16:16:16:16 little endian
	Argb16161616f = 0x48345241,  // [63:0] A:R:G:B 16:16:16:16 little endian
	Abgr16161616f = 0x48344241,  // [63:0] A:B:G:R 16:16:16:16 little endian
	Xyuv8888 = 0x56555958,  // [31:0] X:Y:Cb:Cr 8:8:8:8 little endian
	Vuy888 = 0x34325556,  // [23:0] Cr:Cb:Y 8:8:8 little endian
	Vuy101010 = 0x30335556,  // Y followed by U then V, 10:10:10. Non-linear modifier only
	Y210 = 0x30313259,  // [63:0] Cr0:0:Y1:0:Cb0:0:Y0:0 10:6:10:6:10:6:10:6 little endian per 2 Y pixels
	Y212 = 0x32313259,  // [63:0] Cr0:0:Y1:0:Cb0:0:Y0:0 12:4:12:4:12:4:12:4 little endian per 2 Y pixels
	Y216 = 0x36313259,  // [63:0] Cr0:Y1:Cb0:Y0 16:16:16:16 little endian per 2 Y pixels
	Y410 = 0x30313459,  // [31:0] A:Cr:Y:Cb 2:10:10:10 little endian
	Y412 = 0x32313459,  // [63:0] A:0:Cr:0:Y:0:Cb:0 12:4:12:4:12:4:12:4 little endian
	Y416 = 0x36313459,  // [63:0] A:Cr:Y:Cb 16:16:16:16 little endian
	Xvyu2101010 = 0x30335658,  // [31:0] X:Cr:Y:Cb 2:10:10:10 little endian
	Xvyu12_16161616 = 0x36335658,  // [63:0] X:0:Cr:0:Y:0:Cb:0 12:4:12:4:12:4:12:4 little endian
	Xvyu16161616 = 0x38345658,  // [63:0] X:Cr:Y:Cb 16:16:16:16 little endian
	Y0l0 = 0x304c3059,  // [63:0]   A3:A2:Y3:0:Cr0:0:Y2:0:A1:A0:Y1:0:Cb0:0:Y0:0  1:1:8:2:8:2:8:2:1:1:8:2:8:2:8:2 little endian
	X0l0 = 0x304c3058,  // [63:0]   X3:X2:Y3:0:Cr0:0:Y2:0:X1:X0:Y1:0:Cb0:0:Y0:0  1:1:8:2:8:2:8:2:1:1:8:2:8:2:8:2 little endian
	Y0l2 = 0x324c3059,  // [63:0]   A3:A2:Y3:Cr0:Y2:A1:A0:Y1:Cb0:Y0  1:1:10:10:10:1:1:10:10:10 little endian
	X0l2 = 0x324c3058,  // [63:0]   X3:X2:Y3:Cr0:Y2:X1:X0:Y1:Cb0:Y0  1:1:10:10:10:1:1:10:10:10 little endian
	Yuv420_8bit = 0x38305559,
	Yuv420_10bit = 0x30315559,
	Xrgb8888_A8 = 0x38415258,
	Xbgr8888_A8 = 0x38414258,
	Rgbx8888_A8 = 0x38415852,
	Bgrx8888_A8 = 0x38415842,
	Rgb888_A8 = 0x38413852,
	Bgr888_A8 = 0x38413842,
	Rgb565_A8 = 0x38413552,
	Bgr565_A8 = 0x38413542,
	Nv24 = 0x3432564e,  // non-subsampled Cr:Cb plane
	Nv42 = 0x3234564e,  // non-subsampled Cb:Cr plane
	P210 = 0x30313250,  // 2x1 subsampled Cr:Cb plane, 10 bit per channel
	P010 = 0x30313050,  // 2x2 subsampled Cr:Cb plane 10 bits per channel
	P012 = 0x32313050,  // 2x2 subsampled Cr:Cb plane 12 bits per channel
	P016 = 0x36313050,  // 2x2 subsampled Cr:Cb plane 16 bits per channel
	Axbxgxrx106106106106 = 0x30314241,  // [63:0] A:x:B:x:G:x:R:x 10:6:10:6:10:6:10:6 little endian
	Nv15 = 0x3531564e,  // 2x2 subsampled Cr:Cb plane
	Q410 = 0x30313451,
	Q401 = 0x31303451,
	Xrgb16161616 = 0x38345258,  // [63:0] x:R:G:B 16:16:16:16 little endian
	Xbgr16161616 = 0x38344258,  // [63:0] x:B:G:R 16:16:16:16 little endian
	Argb16161616 = 0x38345241,  // [63:0] A:R:G:B 16:16:16:16 little endian
	Abgr16161616 = 0x38344241,  // [63:0] A:B:G:R 16:16:16:16 little endian
	C1 = 0x20203143,  // [7:0] C0:C1:C2:C3:C4:C5:C6:C7 1:1:1:1:1:1:1:1 eight pixels/byte
	C2 = 0x20203243,  // [7:0] C0:C1:C2:C3 2:2:2:2 four pixels/byte
	C4 = 0x20203443,  // [7:0] C0:C1 4:4 two pixels/byte
	D1 = 0x20203144,  // [7:0] D0:D1:D2:D3:D4:D5:D6:D7 1:1:1:1:1:1:1:1 eight pixels/byte
	D2 = 0x20203244,  // [7:0] D0:D1:D2:D3 2:2:2:2 four pixels/byte
	D4 = 0x20203444,  // [7:0] D0:D1 4:4 two pixels/byte
	D8 = 0x20203844,  // [7:0] D
	R1 = 0x20203152,  // [7:0] R0:R1:R2:R3:R4:R5:R6:R7 1:1:1:1:1:1:1:1 eight pixels/byte
	R2 = 0x20203252,  // [7:0] R0:R1:R2:R3 2:2:2:2 four pixels/byte
	R4 = 0x20203452,  // [7:0] R0:R1 4:4 two pixels/byte
	R10 = 0x20303152,  // [15:0] x:R 6:10 little endian
	R12 = 0x20323152,  // [15:0] x:R 4:12 little endian
	Avuy8888 = 0x59555641,  // [31:0] A:Cr:Cb:Y 8:8:8:8 little endian
	Xvuy8888 = 0x59555658,  // [31:0] X:Cr:Cb:Y 8:8:8:8 little endian
	P030 = 0x30333050,  // 2x2 subsampled Cr:Cb plane 10 bits per channel packed
	Rgb161616 = 0x38344752,  // [47:0] R:G:B 16:16:16 little endian
	Bgr161616 = 0x38344742,  // [47:0] B:G:R 16:16:16 little endian
	R16f = 0x48202052,  // [15:0] R 16 little endian
	Gr1616f = 0x48205247,  // [31:0] G:R 16:16 little endian
	Bgr161616f = 0x48524742,  // [47:0] B:G:R 16:16:16 little endian
	R32f = 0x46202052,  // [31:0] R 32 little endian
	Gr3232f = 0x46205247,  // [63:0] G:R 32:32 little endian
	Bgr323232f = 0x46524742,  // [95:0] B:G:R 32:32:32 little endian
	Abgr32323232f = 0x46384241,  // [127:0] A:B:G:R 32:32:32:32 little endian
	Nv20 = 0x3032564e,  // 2x1 subsampled Cr:Cb plane
	Nv30 = 0x3033564e,  // non-subsampled Cr:Cb plane
	S010 = 0x30313053,  // 2x2 subsampled Cb (1) and Cr (2) planes 10 bits per channel
	S210 = 0x30313253,  // 2x1 subsampled Cb (1) and Cr (2) planes 10 bits per channel
	S410 = 0x30313453,  // non-subsampled Cb (1) and Cr (2) planes 10 bits per channel
	S012 = 0x32313053,  // 2x2 subsampled Cb (1) and Cr (2) planes 12 bits per channel
	S212 = 0x32313253,  // 2x1 subsampled Cb (1) and Cr (2) planes 12 bits per channel
	S412 = 0x32313453,  // non-subsampled Cb (1) and Cr (2) planes 12 bits per channel
	S016 = 0x36313053,  // 2x2 subsampled Cb (1) and Cr (2) planes 16 bits per channel
	S216 = 0x36313253,  // 2x1 subsampled Cb (1) and Cr (2) planes 16 bits per channel
	S416 = 0x36313453,  // non-subsampled Cb (1) and Cr (2) planes 16 bits per channel
	Xvuy2101010 = 0x30335958,  // [31:0] x:Cr:Cb:Y 2:10:10:10 little endian
	P230 = 0x30333250,  // 2x1 subsampled Cr:Cb plane 10 bits per channel packed
	T430 = 0x30333454,
	Y8 = 0x59455247,  // 8-bit Y-only
	Xyyy2101010 = 0x34415059,  // [31:0] x:Y2:Y1:Y0 2:10:10:10 little endian
}

// content for a wl_surface
// A buffer provides the content for a wl_surface. Buffers are
// created through factory interfaces such as wl_shm, wp_linux_buffer_params
// (from the linux-dmabuf protocol extension) or similar. It has a width and
// a height and can be attached to a wl_surface, but the mechanism by which a
// client provides and updates the contents is defined by the buffer factory
// interface.
// Color channels are assumed to be electrical rather than optical (in other
// words, encoded with a transfer function) unless otherwise specified. If
// the buffer uses a format that has an alpha channel, the alpha channel is
// assumed to be premultiplied into the electrical color channel values
// (after transfer function encoding) unless otherwise specified.
// Note, because wl_buffer objects are created from multiple independent
// factory interfaces, the wl_buffer interface is frozen at version 1.
BUFFER_INTERFACE :: "wl_buffer"
BUFFER_VERSION :: 1

// destroy a buffer
// Destroy a buffer. If and how you need to release the backing
// storage is defined by the buffer factory interface.
// For possible side-effects to a surface, see wl_surface.attach.
BUFFER_DESTROY_OPCODE :: 0
Buffer_Destroy_Request :: struct {
	buffer : u32,
}
buffer_destroy_encode :: proc(req: Buffer_Destroy_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.buffer
	opcode := u16(BUFFER_DESTROY_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// compositor releases buffer
// Sent when this wl_buffer is no longer used by the compositor.
// For more information on when release events may or may not be sent,
// and what consequences it has, please see the description of
// wl_surface.attach.
// If a client receives a release event before the frame callback
// requested in the same wl_surface.commit that attaches this
// wl_buffer to a surface, then the client is immediately free to
// reuse the buffer and its backing storage, and does not need a
// second buffer for the next surface content update. Typically
// this is possible, when the compositor maintains a copy of the
// wl_surface contents, e.g. as a GL texture. This is an important
// optimization for GL(ES) compositors with wl_shm clients.
BUFFER_RELEASE_OPCODE :: 0
Buffer_Release_Event :: struct {}
buffer_release_decode :: proc(data: []byte) -> Buffer_Release_Event {
	e: Buffer_Release_Event
	r: int
	n := r
	return e
}

// offer to transfer data
// A wl_data_offer represents a piece of data offered for transfer
// by another client (the source client).  It is used by the
// copy-and-paste and drag-and-drop mechanisms.  The offer
// describes the different mime types that the data can be
// converted to and provides the mechanism for transferring the
// data directly from the source client.
DATA_OFFER_INTERFACE :: "wl_data_offer"
DATA_OFFER_VERSION :: 4

// accept one of the offered mime types
// Indicate that the client can accept the given mime type, or
// NULL for not accepted.
// For objects of version 2 or older, this request is used by the
// client to give feedback whether the client can receive the given
// mime type, or NULL if none is accepted; the feedback does not
// determine whether the drag-and-drop operation succeeds or not.
// For objects of version 3 or newer, this request determines the
// final result of the drag-and-drop operation. If the end result
// is that no mime types were accepted, the drag-and-drop operation
// will be cancelled and the corresponding drag source will receive
// wl_data_source.cancelled. Clients may still use this event in
// conjunction with wl_data_source.action for feedback.
DATA_OFFER_ACCEPT_OPCODE :: 0
Data_Offer_Accept_Request :: struct {
	data_offer : u32,
	serial     : u32,  // serial number of the accept request
	mime_type  : string,  // mime type accepted by the client
}
data_offer_accept_encode :: proc(req: Data_Offer_Accept_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_offer
	opcode := u16(DATA_OFFER_ACCEPT_OPCODE)
	size := u16(8 + size_of(req.serial) + util.compute_string_size(req.mime_type))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.serial)
	util.write(&msg, req.mime_type)
	encoded = msg[:]
	return
}

// request that the data is transferred
// To transfer the offered data, the client issues this request
// and indicates the mime type it wants to receive.  The transfer
// happens through the passed file descriptor (typically created
// with the pipe system call).  The source client writes the data
// in the mime type representation requested and then closes the
// file descriptor.
// The receiving client reads from the read end of the pipe until
// EOF and then closes its end, at which point the transfer is
// complete.
// This request may happen multiple times for different mime types,
// both before and after wl_data_device.drop. Drag-and-drop destination
// clients may preemptively fetch data or examine it more closely to
// determine acceptance.
DATA_OFFER_RECEIVE_OPCODE :: 1
Data_Offer_Receive_Request :: struct {
	data_offer : u32,
	mime_type  : string,  // mime type desired by receiver
	fd         : linux.Fd,  // file descriptor for data transfer
}
data_offer_receive_encode :: proc(req: Data_Offer_Receive_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_offer
	opcode := u16(DATA_OFFER_RECEIVE_OPCODE)
	size := u16(8 + util.compute_string_size(req.mime_type))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.mime_type)
	// fd: fd — sent via SCM_RIGHTS, not in the body
	encoded = msg[:]
	return
}

// destroy data offer
// Destroy the data offer.
DATA_OFFER_DESTROY_OPCODE :: 2
Data_Offer_Destroy_Request :: struct {
	data_offer : u32,
}
data_offer_destroy_encode :: proc(req: Data_Offer_Destroy_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_offer
	opcode := u16(DATA_OFFER_DESTROY_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// the offer will no longer be used
// Notifies the compositor that the drag destination successfully
// finished the drag-and-drop operation.
// Upon receiving this request, the compositor will emit
// wl_data_source.dnd_finished on the drag source client.
// It is a client error to perform other requests than
// wl_data_offer.destroy after this one. It is also an error to perform
// this request after a NULL mime type has been set in
// wl_data_offer.accept or no action was received through
// wl_data_offer.action.
// If wl_data_offer.finish request is received for a non drag and drop
// operation, the invalid_finish protocol error is raised.
DATA_OFFER_FINISH_OPCODE :: 3
Data_Offer_Finish_Request :: struct {
	data_offer : u32,
}
data_offer_finish_encode :: proc(req: Data_Offer_Finish_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_offer
	opcode := u16(DATA_OFFER_FINISH_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// set the available/preferred drag-and-drop actions
// Sets the actions that the destination side client supports for
// this operation. This request may trigger the emission of
// wl_data_source.action and wl_data_offer.action events if the compositor
// needs to change the selected action.
// This request can be called multiple times throughout the
// drag-and-drop operation, typically in response to wl_data_device.enter
// or wl_data_device.motion events.
// This request determines the final result of the drag-and-drop
// operation. If the end result is that no action is accepted,
// the drag source will receive wl_data_source.cancelled.
// The dnd_actions argument must contain only values expressed in the
// wl_data_device_manager.dnd_actions enum, and the preferred_action
// argument must only contain one of those values set, otherwise it
// will result in a protocol error.
// While managing an "ask" action, the destination drag-and-drop client
// may perform further wl_data_offer.receive requests, and is expected
// to perform one last wl_data_offer.set_actions request with a preferred
// action other than "ask" (and optionally wl_data_offer.accept) before
// requesting wl_data_offer.finish, in order to convey the action selected
// by the user. If the preferred action is not in the
// wl_data_offer.source_actions mask, an error will be raised.
// If the "ask" action is dismissed (e.g. user cancellation), the client
// is expected to perform wl_data_offer.destroy right away.
// This request can only be made on drag-and-drop offers, a protocol error
// will be raised otherwise.
DATA_OFFER_SET_ACTIONS_OPCODE :: 4
Data_Offer_Set_Actions_Request :: struct {
	data_offer       : u32,
	dnd_actions      : u32,  // actions supported by the destination client
	preferred_action : u32,  // action preferred by the destination client
}
data_offer_set_actions_encode :: proc(req: Data_Offer_Set_Actions_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_offer
	opcode := u16(DATA_OFFER_SET_ACTIONS_OPCODE)
	size := u16(8 + size_of(req.dnd_actions) + size_of(req.preferred_action))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.dnd_actions)
	util.write(&msg, req.preferred_action)
	encoded = msg[:]
	return
}

// advertise offered mime type
// Sent immediately after creating the wl_data_offer object.  One
// event per offered mime type.
DATA_OFFER_OFFER_OPCODE :: 0
Data_Offer_Offer_Event :: struct {
	mime_type : string,  // offered mime type
}
data_offer_offer_decode :: proc(data: []byte, allocator: mem.Allocator) -> Data_Offer_Offer_Event {
	e: Data_Offer_Offer_Event
	r: int
	n := r
	e.mime_type, r = util.read_string(data[n:]); n += r
	e.mime_type = strings.clone(e.mime_type, allocator)
	return e
}

// notify the source-side available actions
// This event indicates the actions offered by the data source. It
// will be sent immediately after creating the wl_data_offer object,
// or anytime the source side changes its offered actions through
// wl_data_source.set_actions.
DATA_OFFER_SOURCE_ACTIONS_OPCODE :: 1
Data_Offer_Source_Actions_Event :: struct {
	source_actions : u32,  // actions offered by the data source
}
data_offer_source_actions_decode :: proc(data: []byte) -> Data_Offer_Source_Actions_Event {
	e: Data_Offer_Source_Actions_Event
	r: int
	n := r
	e.source_actions, r = util.read_u32(data[n:]); n += r
	return e
}

// notify the selected action
// This event indicates the action selected by the compositor after
// matching the source/destination side actions. Only one action (or
// none) will be offered here.
// This event can be emitted multiple times during the drag-and-drop
// operation in response to destination side action changes through
// wl_data_offer.set_actions.
// This event will no longer be emitted after wl_data_device.drop
// happened on the drag-and-drop destination, the client must
// honor the last action received, or the last preferred one set
// through wl_data_offer.set_actions when handling an "ask" action.
// Compositors may also change the selected action on the fly, mainly
// in response to keyboard modifier changes during the drag-and-drop
// operation.
// The most recent action received is always the valid one. Prior to
// receiving wl_data_device.drop, the chosen action may change (e.g.
// due to keyboard modifiers being pressed). At the time of receiving
// wl_data_device.drop the drag-and-drop destination must honor the
// last action received.
// Action changes may still happen after wl_data_device.drop,
// especially on "ask" actions, where the drag-and-drop destination
// may choose another action afterwards. Action changes happening
// at this stage are always the result of inter-client negotiation, the
// compositor shall no longer be able to induce a different action.
// Upon "ask" actions, it is expected that the drag-and-drop destination
// may potentially choose a different action and/or mime type,
// based on wl_data_offer.source_actions and finally chosen by the
// user (e.g. popping up a menu with the available options). The
// final wl_data_offer.set_actions and wl_data_offer.accept requests
// must happen before the call to wl_data_offer.finish.
DATA_OFFER_ACTION_OPCODE :: 2
Data_Offer_Action_Event :: struct {
	dnd_action : u32,  // action selected by the compositor
}
data_offer_action_decode :: proc(data: []byte) -> Data_Offer_Action_Event {
	e: Data_Offer_Action_Event
	r: int
	n := r
	e.dnd_action, r = util.read_u32(data[n:]); n += r
	return e
}

Data_Offer_Error :: enum u32 {
	Invalid_Finish = 0,  // finish request was called untimely
	Invalid_Action_Mask = 1,  // action mask contains invalid values
	Invalid_Action = 2,  // action argument has an invalid value
	Invalid_Offer = 3,  // offer doesn't accept this request
}

// offer to transfer data
// The wl_data_source object is the source side of a wl_data_offer.
// It is created by the source client in a data transfer and
// provides a way to describe the offered data and a way to respond
// to requests to transfer the data.
DATA_SOURCE_INTERFACE :: "wl_data_source"
DATA_SOURCE_VERSION :: 4

// add an offered mime type
// This request adds a mime type to the set of mime types
// advertised to targets.  Can be called several times to offer
// multiple types.
DATA_SOURCE_OFFER_OPCODE :: 0
Data_Source_Offer_Request :: struct {
	data_source : u32,
	mime_type   : string,  // mime type offered by the data source
}
data_source_offer_encode :: proc(req: Data_Source_Offer_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_source
	opcode := u16(DATA_SOURCE_OFFER_OPCODE)
	size := u16(8 + util.compute_string_size(req.mime_type))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.mime_type)
	encoded = msg[:]
	return
}

// destroy the data source
// Destroy the data source.
DATA_SOURCE_DESTROY_OPCODE :: 1
Data_Source_Destroy_Request :: struct {
	data_source : u32,
}
data_source_destroy_encode :: proc(req: Data_Source_Destroy_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_source
	opcode := u16(DATA_SOURCE_DESTROY_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// set the available drag-and-drop actions
// Sets the actions that the source side client supports for this
// operation. This request may trigger wl_data_source.action and
// wl_data_offer.action events if the compositor needs to change the
// selected action.
// The dnd_actions argument must contain only values expressed in the
// wl_data_device_manager.dnd_actions enum, otherwise it will result
// in a protocol error.
// This request must be made once only, and can only be made on sources
// used in drag-and-drop, so it must be performed before
// wl_data_device.start_drag. Attempting to use the source other than
// for drag-and-drop will raise a protocol error.
DATA_SOURCE_SET_ACTIONS_OPCODE :: 2
Data_Source_Set_Actions_Request :: struct {
	data_source : u32,
	dnd_actions : u32,  // actions supported by the data source
}
data_source_set_actions_encode :: proc(req: Data_Source_Set_Actions_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_source
	opcode := u16(DATA_SOURCE_SET_ACTIONS_OPCODE)
	size := u16(8 + size_of(req.dnd_actions))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.dnd_actions)
	encoded = msg[:]
	return
}

// a target accepts an offered mime type
// Sent when a target accepts pointer_focus or motion events.  If
// a target does not accept any of the offered types, type is NULL.
// Used for feedback during drag-and-drop.
DATA_SOURCE_TARGET_OPCODE :: 0
Data_Source_Target_Event :: struct {
	mime_type : string,  // mime type accepted by the target
}
data_source_target_decode :: proc(data: []byte, allocator: mem.Allocator) -> Data_Source_Target_Event {
	e: Data_Source_Target_Event
	r: int
	n := r
	e.mime_type, r = util.read_string(data[n:]); n += r
	e.mime_type = strings.clone(e.mime_type, allocator)
	return e
}

// send the data
// Request for data from the client.  Send the data as the
// specified mime type over the passed file descriptor, then
// close it.
DATA_SOURCE_SEND_OPCODE :: 1
Data_Source_Send_Event :: struct {
	mime_type : string,  // mime type for the data
	fd        : linux.Fd,  // file descriptor for the data
}
data_source_send_decode :: proc(data: []byte, fds: ^[dynamic]linux.Fd, allocator: mem.Allocator) -> Data_Source_Send_Event {
	e: Data_Source_Send_Event
	r: int
	n := r
	e.mime_type, r = util.read_string(data[n:]); n += r
	e.mime_type = strings.clone(e.mime_type, allocator)
	e.fd = pop_front(fds)
	return e
}

// selection was cancelled
// This data source is no longer valid. There are several reasons why
// this could happen:
// - The data source has been replaced by another data source.
// - The drag-and-drop operation was performed, but the drop destination
// did not accept any of the mime types offered through
// wl_data_source.target.
// - The drag-and-drop operation was performed, but the drop destination
// did not select any of the actions present in the mask offered through
// wl_data_source.action.
// - The drag-and-drop operation was performed but didn't happen over a
// surface.
// - The compositor cancelled the drag-and-drop operation (e.g. compositor
// dependent timeouts to avoid stale drag-and-drop transfers).
// The client should clean up and destroy this data source.
// For objects of version 2 or older, wl_data_source.cancelled will
// only be emitted if the data source was replaced by another data
// source.
DATA_SOURCE_CANCELLED_OPCODE :: 2
Data_Source_Cancelled_Event :: struct {}
data_source_cancelled_decode :: proc(data: []byte) -> Data_Source_Cancelled_Event {
	e: Data_Source_Cancelled_Event
	r: int
	n := r
	return e
}

// the drag-and-drop operation physically finished
// The user performed the drop action. This event does not indicate
// acceptance, wl_data_source.cancelled may still be emitted afterwards
// if the drop destination does not accept any mime type.
// However, this event might not be received if the compositor cancelled
// the drag-and-drop operation before this event could happen.
// Note that the data_source may still be used in the future and should
// not be destroyed here.
DATA_SOURCE_DND_DROP_PERFORMED_OPCODE :: 3
Data_Source_Dnd_Drop_Performed_Event :: struct {}
data_source_dnd_drop_performed_decode :: proc(data: []byte) -> Data_Source_Dnd_Drop_Performed_Event {
	e: Data_Source_Dnd_Drop_Performed_Event
	r: int
	n := r
	return e
}

// the drag-and-drop operation concluded
// The drop destination finished interoperating with this data
// source, so the client is now free to destroy this data source and
// free all associated data.
// If the action used to perform the operation was "move", the
// source can now delete the transferred data.
DATA_SOURCE_DND_FINISHED_OPCODE :: 4
Data_Source_Dnd_Finished_Event :: struct {}
data_source_dnd_finished_decode :: proc(data: []byte) -> Data_Source_Dnd_Finished_Event {
	e: Data_Source_Dnd_Finished_Event
	r: int
	n := r
	return e
}

// notify the selected action
// This event indicates the action selected by the compositor after
// matching the source/destination side actions. Only one action (or
// none) will be offered here.
// This event can be emitted multiple times during the drag-and-drop
// operation, mainly in response to destination side changes through
// wl_data_offer.set_actions, and as the data device enters/leaves
// surfaces.
// It is only possible to receive this event after
// wl_data_source.dnd_drop_performed if the drag-and-drop operation
// ended in an "ask" action, in which case the final wl_data_source.action
// event will happen immediately before wl_data_source.dnd_finished.
// Compositors may also change the selected action on the fly, mainly
// in response to keyboard modifier changes during the drag-and-drop
// operation.
// The most recent action received is always the valid one. The chosen
// action may change alongside negotiation (e.g. an "ask" action can turn
// into a "move" operation), so the effects of the final action must
// always be applied in wl_data_source.dnd_finished.
// Clients can trigger cursor surface changes from this point, so
// they reflect the current action.
DATA_SOURCE_ACTION_OPCODE :: 5
Data_Source_Action_Event :: struct {
	dnd_action : u32,  // action selected by the compositor
}
data_source_action_decode :: proc(data: []byte) -> Data_Source_Action_Event {
	e: Data_Source_Action_Event
	r: int
	n := r
	e.dnd_action, r = util.read_u32(data[n:]); n += r
	return e
}

Data_Source_Error :: enum u32 {
	Invalid_Action_Mask = 0,  // action mask contains invalid values
	Invalid_Source = 1,  // source doesn't accept this request
}

// data transfer device
// There is one wl_data_device per seat which can be obtained
// from the global wl_data_device_manager singleton.
// A wl_data_device provides access to inter-client data transfer
// mechanisms such as copy-and-paste and drag-and-drop.
DATA_DEVICE_INTERFACE :: "wl_data_device"
DATA_DEVICE_VERSION :: 4

// start drag-and-drop operation
// This request asks the compositor to start a drag-and-drop
// operation on behalf of the client.
// The source argument is the data source that provides the data
// for the eventual data transfer. If source is NULL, enter, leave
// and motion events are sent only to the client that initiated the
// drag and the client is expected to handle the data passing
// internally. If source is destroyed, the drag-and-drop session will be
// cancelled.
// The origin surface is the surface where the drag originates and
// the client must have an active implicit grab that matches the
// serial.
// The icon surface is an optional (can be NULL) surface that
// provides an icon to be moved around with the cursor.  Initially,
// the top-left corner of the icon surface is placed at the cursor
// hotspot, but subsequent wl_surface.offset requests can move the
// relative position. Attach requests must be confirmed with
// wl_surface.commit as usual. The icon surface is given the role of
// a drag-and-drop icon. If the icon surface already has another role,
// it raises a protocol error.
// The input region is ignored for wl_surfaces with the role of a
// drag-and-drop icon.
// The given source may not be used in any further set_selection or
// start_drag requests. Attempting to reuse a previously-used source
// may send a used_source error.
DATA_DEVICE_START_DRAG_OPCODE :: 0
Data_Device_Start_Drag_Request :: struct {
	data_device : u32,
	source      : u32,  // data source for the eventual transfer
	origin      : u32,  // surface where the drag originates
	icon        : u32,  // drag-and-drop icon surface
	serial      : u32,  // serial number of the implicit grab on the origin
}
data_device_start_drag_encode :: proc(req: Data_Device_Start_Drag_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_device
	opcode := u16(DATA_DEVICE_START_DRAG_OPCODE)
	size := u16(8 + size_of(req.source) + size_of(req.origin) + size_of(req.icon) + size_of(req.serial))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.source)
	util.write(&msg, req.origin)
	util.write(&msg, req.icon)
	util.write(&msg, req.serial)
	encoded = msg[:]
	return
}

// copy data to the selection
// This request asks the compositor to set the selection
// to the data from the source on behalf of the client.
// To unset the selection, set the source to NULL.
// The given source may not be used in any further set_selection or
// start_drag requests. Attempting to reuse a previously-used source
// may send a used_source error.
DATA_DEVICE_SET_SELECTION_OPCODE :: 1
Data_Device_Set_Selection_Request :: struct {
	data_device : u32,
	source      : u32,  // data source for the selection
	serial      : u32,  // serial number of the event that triggered this request
}
data_device_set_selection_encode :: proc(req: Data_Device_Set_Selection_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_device
	opcode := u16(DATA_DEVICE_SET_SELECTION_OPCODE)
	size := u16(8 + size_of(req.source) + size_of(req.serial))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.source)
	util.write(&msg, req.serial)
	encoded = msg[:]
	return
}

// destroy data device
// This request destroys the data device.
DATA_DEVICE_RELEASE_OPCODE :: 2
Data_Device_Release_Request :: struct {
	data_device : u32,
}
data_device_release_encode :: proc(req: Data_Device_Release_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_device
	opcode := u16(DATA_DEVICE_RELEASE_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// introduce a new wl_data_offer
// The data_offer event introduces a new wl_data_offer object,
// which will subsequently be used in either the
// data_device.enter event (for drag-and-drop) or the
// data_device.selection event (for selections).  Immediately
// following the data_device.data_offer event, the new data_offer
// object will send out data_offer.offer events to describe the
// mime types it offers.
DATA_DEVICE_DATA_OFFER_OPCODE :: 0
Data_Device_Data_Offer_Event :: struct {
	id : u32,  // the new data_offer object
}
data_device_data_offer_decode :: proc(data: []byte) -> Data_Device_Data_Offer_Event {
	e: Data_Device_Data_Offer_Event
	r: int
	n := r
	e.id, r = util.read_u32(data[n:]); n += r
	return e
}

// initiate drag-and-drop session
// This event is sent when an active drag-and-drop pointer enters
// a surface owned by the client.  The position of the pointer at
// enter time is provided by the x and y arguments, in surface-local
// coordinates.
DATA_DEVICE_ENTER_OPCODE :: 1
Data_Device_Enter_Event :: struct {
	serial  : u32,  // serial number of the enter event
	surface : u32,  // client surface entered
	x       : util.Fixed,  // surface-local x coordinate
	y       : util.Fixed,  // surface-local y coordinate
	id      : u32,  // source data_offer object
}
data_device_enter_decode :: proc(data: []byte) -> Data_Device_Enter_Event {
	e: Data_Device_Enter_Event
	r: int
	n := r
	e.serial, r = util.read_u32(data[n:]); n += r
	e.surface, r = util.read_u32(data[n:]); n += r
	e.x, r = util.read_fixed(data[n:]); n += r
	e.y, r = util.read_fixed(data[n:]); n += r
	e.id, r = util.read_u32(data[n:]); n += r
	return e
}

// end drag-and-drop session
// This event is sent when the drag-and-drop pointer leaves the
// surface and the session ends.  The client must destroy the
// wl_data_offer introduced at enter time at this point.
DATA_DEVICE_LEAVE_OPCODE :: 2
Data_Device_Leave_Event :: struct {}
data_device_leave_decode :: proc(data: []byte) -> Data_Device_Leave_Event {
	e: Data_Device_Leave_Event
	r: int
	n := r
	return e
}

// drag-and-drop session motion
// This event is sent when the drag-and-drop pointer moves within
// the currently focused surface. The new position of the pointer
// is provided by the x and y arguments, in surface-local
// coordinates.
DATA_DEVICE_MOTION_OPCODE :: 3
Data_Device_Motion_Event :: struct {
	time : u32,  // timestamp with millisecond granularity
	x    : util.Fixed,  // surface-local x coordinate
	y    : util.Fixed,  // surface-local y coordinate
}
data_device_motion_decode :: proc(data: []byte) -> Data_Device_Motion_Event {
	e: Data_Device_Motion_Event
	r: int
	n := r
	e.time, r = util.read_u32(data[n:]); n += r
	e.x, r = util.read_fixed(data[n:]); n += r
	e.y, r = util.read_fixed(data[n:]); n += r
	return e
}

// end drag-and-drop session successfully
// The event is sent when a drag-and-drop operation is ended
// because the implicit grab is removed.
// The drag-and-drop destination is expected to honor the last action
// received through wl_data_offer.action, if the resulting action is
// "copy" or "move", the destination can still perform
// wl_data_offer.receive requests, and is expected to end all
// transfers with a wl_data_offer.finish request.
// If the resulting action is "ask", the action will not be considered
// final. The drag-and-drop destination is expected to perform one last
// wl_data_offer.set_actions request, or wl_data_offer.destroy in order
// to cancel the operation.
DATA_DEVICE_DROP_OPCODE :: 4
Data_Device_Drop_Event :: struct {}
data_device_drop_decode :: proc(data: []byte) -> Data_Device_Drop_Event {
	e: Data_Device_Drop_Event
	r: int
	n := r
	return e
}

// advertise new selection
// The selection event is sent out to notify the client of a new
// wl_data_offer for the selection for this device.  The
// data_device.data_offer and the data_offer.offer events are
// sent out immediately before this event to introduce the data
// offer object.  The selection event is sent to a client
// immediately before receiving keyboard focus and when a new
// selection is set while the client has keyboard focus.  The
// data_offer is valid until a new data_offer or NULL is received
// or until the client loses keyboard focus.  Switching surface with
// keyboard focus within the same client doesn't mean a new selection
// will be sent.  The client must destroy the previous selection
// data_offer, if any, upon receiving this event.
DATA_DEVICE_SELECTION_OPCODE :: 5
Data_Device_Selection_Event :: struct {
	id : u32,  // selection data_offer object
}
data_device_selection_decode :: proc(data: []byte) -> Data_Device_Selection_Event {
	e: Data_Device_Selection_Event
	r: int
	n := r
	e.id, r = util.read_u32(data[n:]); n += r
	return e
}

Data_Device_Error :: enum u32 {
	Role = 0,  // given wl_surface has another role
	Used_Source = 1,  // source has already been used
}

// data transfer interface
// The wl_data_device_manager is a singleton global object that
// provides access to inter-client data transfer mechanisms such as
// copy-and-paste and drag-and-drop.  These mechanisms are tied to
// a wl_seat and this interface lets a client get a wl_data_device
// corresponding to a wl_seat.
// Depending on the version bound, the objects created from the bound
// wl_data_device_manager object will have different requirements for
// functioning properly. See wl_data_source.set_actions,
// wl_data_offer.accept and wl_data_offer.finish for details.
DATA_DEVICE_MANAGER_INTERFACE :: "wl_data_device_manager"
DATA_DEVICE_MANAGER_VERSION :: 4

// create a new data source
// Create a new data source.
DATA_DEVICE_MANAGER_CREATE_DATA_SOURCE_OPCODE :: 0
Data_Device_Manager_Create_Data_Source_Request :: struct {
	data_device_manager : u32,
}
data_device_manager_create_data_source_encode :: proc(req: Data_Device_Manager_Create_Data_Source_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_device_manager
	opcode := u16(DATA_DEVICE_MANAGER_CREATE_DATA_SOURCE_OPCODE)
	size := u16(8 + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// create a new data device
// Create a new data device for a given seat.
DATA_DEVICE_MANAGER_GET_DATA_DEVICE_OPCODE :: 1
Data_Device_Manager_Get_Data_Device_Request :: struct {
	data_device_manager : u32,
	seat                : u32,  // seat associated with the data device
}
data_device_manager_get_data_device_encode :: proc(req: Data_Device_Manager_Get_Data_Device_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_device_manager
	opcode := u16(DATA_DEVICE_MANAGER_GET_DATA_DEVICE_OPCODE)
	size := u16(8 + size_of(new_id) + size_of(req.seat))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	util.write(&msg, req.seat)
	encoded = msg[:]
	return
}

// destroy wl_data_device_manager
// This request destroys the wl_data_device_manager. This has no effect on any other
// objects.
DATA_DEVICE_MANAGER_RELEASE_OPCODE :: 2
Data_Device_Manager_Release_Request :: struct {
	data_device_manager : u32,
}
data_device_manager_release_encode :: proc(req: Data_Device_Manager_Release_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.data_device_manager
	opcode := u16(DATA_DEVICE_MANAGER_RELEASE_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// drag and drop actions
// This is a bitmask of the available/preferred actions in a
// drag-and-drop operation.
// In the compositor, the selected action is a result of matching the
// actions offered by the source and destination sides.  "action" events
// with a "none" action will be sent to both source and destination if
// there is no match. All further checks will effectively happen on
// (source actions ∩ destination actions).
// In addition, compositors may also pick different actions in
// reaction to key modifiers being pressed. One common design that
// is used in major toolkits (and the behavior recommended for
// compositors) is:
// - If no modifiers are pressed, the first match (in bit order)
// will be used.
// - Pressing Shift selects "move", if enabled in the mask.
// - Pressing Control selects "copy", if enabled in the mask.
// Behavior beyond that is considered implementation-dependent.
// Compositors may for example bind other modifiers (like Alt/Meta)
// or drags initiated with other buttons than BTN_LEFT to specific
// actions (e.g. "ask").
Data_Device_Manager_Dnd_Action :: enum u32 {
	None = 0,  // no action
	Copy = 1,  // copy action
	Move = 2,  // move action
	Ask = 4,  // ask action
}

// create desktop-style surfaces
// This interface is implemented by servers that provide
// desktop-style user interfaces.
// It allows clients to associate a wl_shell_surface with
// a basic surface.
// Note! This protocol is deprecated and not intended for production use.
// For desktop-style user interfaces, use xdg_shell. Compositors and clients
// should not implement this interface.
SHELL_INTERFACE :: "wl_shell"
SHELL_VERSION :: 1

// create a shell surface from a surface
// Create a shell surface for an existing surface. This gives
// the wl_surface the role of a shell surface. If the wl_surface
// already has another role, it raises a protocol error.
// Only one shell surface can be associated with a given surface.
SHELL_GET_SHELL_SURFACE_OPCODE :: 0
Shell_Get_Shell_Surface_Request :: struct {
	shell   : u32,
	surface : u32,  // surface to be given the shell surface role
}
shell_get_shell_surface_encode :: proc(req: Shell_Get_Shell_Surface_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shell
	opcode := u16(SHELL_GET_SHELL_SURFACE_OPCODE)
	size := u16(8 + size_of(new_id) + size_of(req.surface))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	util.write(&msg, req.surface)
	encoded = msg[:]
	return
}

Shell_Error :: enum u32 {
	Role = 0,  // given wl_surface has another role
}

// desktop-style metadata interface
// An interface that may be implemented by a wl_surface, for
// implementations that provide a desktop-style user interface.
// It provides requests to treat surfaces like toplevel, fullscreen
// or popup windows, move, resize or maximize them, associate
// metadata like title and class, etc.
// On the server side the object is automatically destroyed when
// the related wl_surface is destroyed. On the client side,
// wl_shell_surface_destroy() must be called before destroying
// the wl_surface object.
SHELL_SURFACE_INTERFACE :: "wl_shell_surface"
SHELL_SURFACE_VERSION :: 1

// respond to a ping event
// A client must respond to a ping event with a pong request or
// the client may be deemed unresponsive.
SHELL_SURFACE_PONG_OPCODE :: 0
Shell_Surface_Pong_Request :: struct {
	shell_surface : u32,
	serial        : u32,  // serial number of the ping event
}
shell_surface_pong_encode :: proc(req: Shell_Surface_Pong_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shell_surface
	opcode := u16(SHELL_SURFACE_PONG_OPCODE)
	size := u16(8 + size_of(req.serial))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.serial)
	encoded = msg[:]
	return
}

// start an interactive move
// Start a pointer-driven move of the surface.
// This request must be used in response to a button press event.
// The server may ignore move requests depending on the state of
// the surface (e.g. fullscreen or maximized).
SHELL_SURFACE_MOVE_OPCODE :: 1
Shell_Surface_Move_Request :: struct {
	shell_surface : u32,
	seat          : u32,  // seat whose pointer is used
	serial        : u32,  // serial number of the implicit grab on the pointer
}
shell_surface_move_encode :: proc(req: Shell_Surface_Move_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shell_surface
	opcode := u16(SHELL_SURFACE_MOVE_OPCODE)
	size := u16(8 + size_of(req.seat) + size_of(req.serial))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.seat)
	util.write(&msg, req.serial)
	encoded = msg[:]
	return
}

// start an interactive resize
// Start a pointer-driven resizing of the surface.
// This request must be used in response to a button press event.
// The server may ignore resize requests depending on the state of
// the surface (e.g. fullscreen or maximized).
SHELL_SURFACE_RESIZE_OPCODE :: 2
Shell_Surface_Resize_Request :: struct {
	shell_surface : u32,
	seat          : u32,  // seat whose pointer is used
	serial        : u32,  // serial number of the implicit grab on the pointer
	edges         : u32,  // which edge or corner is being dragged
}
shell_surface_resize_encode :: proc(req: Shell_Surface_Resize_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shell_surface
	opcode := u16(SHELL_SURFACE_RESIZE_OPCODE)
	size := u16(8 + size_of(req.seat) + size_of(req.serial) + size_of(req.edges))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.seat)
	util.write(&msg, req.serial)
	util.write(&msg, req.edges)
	encoded = msg[:]
	return
}

// make the surface a toplevel surface
// Map the surface as a toplevel surface.
// A toplevel surface is not fullscreen, maximized or transient.
SHELL_SURFACE_SET_TOPLEVEL_OPCODE :: 3
Shell_Surface_Set_Toplevel_Request :: struct {
	shell_surface : u32,
}
shell_surface_set_toplevel_encode :: proc(req: Shell_Surface_Set_Toplevel_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shell_surface
	opcode := u16(SHELL_SURFACE_SET_TOPLEVEL_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// make the surface a transient surface
// Map the surface relative to an existing surface.
// The x and y arguments specify the location of the upper left
// corner of the surface relative to the upper left corner of the
// parent surface, in surface-local coordinates.
// The flags argument controls details of the transient behaviour.
SHELL_SURFACE_SET_TRANSIENT_OPCODE :: 4
Shell_Surface_Set_Transient_Request :: struct {
	shell_surface : u32,
	parent        : u32,  // parent surface
	x             : i32,  // surface-local x coordinate
	y             : i32,  // surface-local y coordinate
	flags         : u32,  // transient surface behavior
}
shell_surface_set_transient_encode :: proc(req: Shell_Surface_Set_Transient_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shell_surface
	opcode := u16(SHELL_SURFACE_SET_TRANSIENT_OPCODE)
	size := u16(8 + size_of(req.parent) + size_of(req.x) + size_of(req.y) + size_of(req.flags))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.parent)
	util.write(&msg, req.x)
	util.write(&msg, req.y)
	util.write(&msg, req.flags)
	encoded = msg[:]
	return
}

// make the surface a fullscreen surface
// Map the surface as a fullscreen surface.
// If an output parameter is given then the surface will be made
// fullscreen on that output. If the client does not specify the
// output then the compositor will apply its policy - usually
// choosing the output on which the surface has the biggest surface
// area.
// The client may specify a method to resolve a size conflict
// between the output size and the surface size - this is provided
// through the method parameter.
// The framerate parameter is used only when the method is set
// to "driver", to indicate the preferred framerate. A value of 0
// indicates that the client does not care about framerate.  The
// framerate is specified in mHz, that is framerate of 60000 is 60Hz.
// A method of "scale" or "driver" implies a scaling operation of
// the surface, either via a direct scaling operation or a change of
// the output mode. This will override any kind of output scaling, so
// that mapping a surface with a buffer size equal to the mode can
// fill the screen independent of buffer_scale.
// A method of "fill" means we don't scale up the buffer, however
// any output scale is applied. This means that you may run into
// an edge case where the application maps a buffer with the same
// size of the output mode but buffer_scale 1 (thus making a
// surface larger than the output). In this case it is allowed to
// downscale the results to fit the screen.
// The compositor must reply to this request with a configure event
// with the dimensions for the output on which the surface will
// be made fullscreen.
SHELL_SURFACE_SET_FULLSCREEN_OPCODE :: 5
Shell_Surface_Set_Fullscreen_Request :: struct {
	shell_surface : u32,
	method        : u32,  // method for resolving size conflict
	framerate     : u32,  // framerate in mHz
	output        : u32,  // output on which the surface is to be fullscreen
}
shell_surface_set_fullscreen_encode :: proc(req: Shell_Surface_Set_Fullscreen_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shell_surface
	opcode := u16(SHELL_SURFACE_SET_FULLSCREEN_OPCODE)
	size := u16(8 + size_of(req.method) + size_of(req.framerate) + size_of(req.output))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.method)
	util.write(&msg, req.framerate)
	util.write(&msg, req.output)
	encoded = msg[:]
	return
}

// make the surface a popup surface
// Map the surface as a popup.
// A popup surface is a transient surface with an added pointer
// grab.
// An existing implicit grab will be changed to owner-events mode,
// and the popup grab will continue after the implicit grab ends
// (i.e. releasing the mouse button does not cause the popup to
// be unmapped).
// The popup grab continues until the window is destroyed or a
// mouse button is pressed in any other client's window. A click
// in any of the client's surfaces is reported as normal, however,
// clicks in other clients' surfaces will be discarded and trigger
// the callback.
// The x and y arguments specify the location of the upper left
// corner of the surface relative to the upper left corner of the
// parent surface, in surface-local coordinates.
SHELL_SURFACE_SET_POPUP_OPCODE :: 6
Shell_Surface_Set_Popup_Request :: struct {
	shell_surface : u32,
	seat          : u32,  // seat whose pointer is used
	serial        : u32,  // serial number of the implicit grab on the pointer
	parent        : u32,  // parent surface
	x             : i32,  // surface-local x coordinate
	y             : i32,  // surface-local y coordinate
	flags         : u32,  // transient surface behavior
}
shell_surface_set_popup_encode :: proc(req: Shell_Surface_Set_Popup_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shell_surface
	opcode := u16(SHELL_SURFACE_SET_POPUP_OPCODE)
	size := u16(8 + size_of(req.seat) + size_of(req.serial) + size_of(req.parent) + size_of(req.x) + size_of(req.y) + size_of(req.flags))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.seat)
	util.write(&msg, req.serial)
	util.write(&msg, req.parent)
	util.write(&msg, req.x)
	util.write(&msg, req.y)
	util.write(&msg, req.flags)
	encoded = msg[:]
	return
}

// make the surface a maximized surface
// Map the surface as a maximized surface.
// If an output parameter is given then the surface will be
// maximized on that output. If the client does not specify the
// output then the compositor will apply its policy - usually
// choosing the output on which the surface has the biggest surface
// area.
// The compositor will reply with a configure event telling
// the expected new surface size. The operation is completed
// on the next buffer attach to this surface.
// A maximized surface typically fills the entire output it is
// bound to, except for desktop elements such as panels. This is
// the main difference between a maximized shell surface and a
// fullscreen shell surface.
// The details depend on the compositor implementation.
SHELL_SURFACE_SET_MAXIMIZED_OPCODE :: 7
Shell_Surface_Set_Maximized_Request :: struct {
	shell_surface : u32,
	output        : u32,  // output on which the surface is to be maximized
}
shell_surface_set_maximized_encode :: proc(req: Shell_Surface_Set_Maximized_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shell_surface
	opcode := u16(SHELL_SURFACE_SET_MAXIMIZED_OPCODE)
	size := u16(8 + size_of(req.output))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.output)
	encoded = msg[:]
	return
}

// set surface title
// Set a short title for the surface.
// This string may be used to identify the surface in a task bar,
// window list, or other user interface elements provided by the
// compositor.
// The string must be encoded in UTF-8.
SHELL_SURFACE_SET_TITLE_OPCODE :: 8
Shell_Surface_Set_Title_Request :: struct {
	shell_surface : u32,
	title         : string,  // surface title
}
shell_surface_set_title_encode :: proc(req: Shell_Surface_Set_Title_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shell_surface
	opcode := u16(SHELL_SURFACE_SET_TITLE_OPCODE)
	size := u16(8 + util.compute_string_size(req.title))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.title)
	encoded = msg[:]
	return
}

// set surface class
// Set a class for the surface.
// The surface class identifies the general class of applications
// to which the surface belongs. A common convention is to use the
// file name (or the full path if it is a non-standard location) of
// the application's .desktop file as the class.
SHELL_SURFACE_SET_CLASS_OPCODE :: 9
Shell_Surface_Set_Class_Request :: struct {
	shell_surface : u32,
	class_        : string,  // surface class
}
shell_surface_set_class_encode :: proc(req: Shell_Surface_Set_Class_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.shell_surface
	opcode := u16(SHELL_SURFACE_SET_CLASS_OPCODE)
	size := u16(8 + util.compute_string_size(req.class_))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.class_)
	encoded = msg[:]
	return
}

// ping client
// Ping a client to check if it is receiving events and sending
// requests. A client is expected to reply with a pong request.
SHELL_SURFACE_PING_OPCODE :: 0
Shell_Surface_Ping_Event :: struct {
	serial : u32,  // serial number of the ping
}
shell_surface_ping_decode :: proc(data: []byte) -> Shell_Surface_Ping_Event {
	e: Shell_Surface_Ping_Event
	r: int
	n := r
	e.serial, r = util.read_u32(data[n:]); n += r
	return e
}

// suggest resize
// The configure event asks the client to resize its surface.
// The size is a hint, in the sense that the client is free to
// ignore it if it doesn't resize, pick a smaller size (to
// satisfy aspect ratio or resize in steps of NxM pixels).
// The edges parameter provides a hint about how the surface
// was resized. The client may use this information to decide
// how to adjust its content to the new size (e.g. a scrolling
// area might adjust its content position to leave the viewable
// content unmoved).
// The client is free to dismiss all but the last configure
// event it received.
// The width and height arguments specify the size of the window
// in surface-local coordinates.
SHELL_SURFACE_CONFIGURE_OPCODE :: 1
Shell_Surface_Configure_Event :: struct {
	edges  : u32,  // how the surface was resized
	width  : i32,  // new width of the surface
	height : i32,  // new height of the surface
}
shell_surface_configure_decode :: proc(data: []byte) -> Shell_Surface_Configure_Event {
	e: Shell_Surface_Configure_Event
	r: int
	n := r
	e.edges, r = util.read_u32(data[n:]); n += r
	e.width, r = util.read_i32(data[n:]); n += r
	e.height, r = util.read_i32(data[n:]); n += r
	return e
}

// popup interaction is done
// The popup_done event is sent out when a popup grab is broken,
// that is, when the user clicks a surface that doesn't belong
// to the client owning the popup surface.
SHELL_SURFACE_POPUP_DONE_OPCODE :: 2
Shell_Surface_Popup_Done_Event :: struct {}
shell_surface_popup_done_decode :: proc(data: []byte) -> Shell_Surface_Popup_Done_Event {
	e: Shell_Surface_Popup_Done_Event
	r: int
	n := r
	return e
}

// edge values for resizing
// These values are used to indicate which edge of a surface
// is being dragged in a resize operation. The server may
// use this information to adapt its behavior, e.g. choose
// an appropriate cursor image.
Shell_Surface_Resize :: enum u32 {
	None = 0,  // no edge
	Top = 1,  // top edge
	Bottom = 2,  // bottom edge
	Left = 4,  // left edge
	Top_Left = 5,  // top and left edges
	Bottom_Left = 6,  // bottom and left edges
	Right = 8,  // right edge
	Top_Right = 9,  // top and right edges
	Bottom_Right = 10,  // bottom and right edges
}

// details of transient behaviour
// These flags specify details of the expected behaviour
// of transient surfaces. Used in the set_transient request.
Shell_Surface_Transient :: enum u32 {
	Inactive = 0x1,  // do not set keyboard focus
}

// different method to set the surface fullscreen
// Hints to indicate to the compositor how to deal with a conflict
// between the dimensions of the surface and the dimensions of the
// output. The compositor is free to ignore this parameter.
Shell_Surface_Fullscreen_Method :: enum u32 {
	Default = 0,  // no preference, apply default policy
	Scale = 1,  // scale, preserve the surface's aspect ratio and center on output
	Driver = 2,  // switch output mode to the smallest mode that can fit the surface, add black borders to compensate size mismatch
	Fill = 3,  // no upscaling, center on output and add black borders to compensate size mismatch
}

// an onscreen surface
// A surface is a rectangular area that may be displayed on zero
// or more outputs, and shown any number of times at the compositor's
// discretion. They can present wl_buffers, receive user input, and
// define a local coordinate system.
// The size of a surface (and relative positions on it) is described
// in surface-local coordinates, which may differ from the buffer
// coordinates of the pixel content, in case a buffer_transform
// or a buffer_scale is used.
// A surface without a "role" is fairly useless: a compositor does
// not know where, when or how to present it. The role is the
// purpose of a wl_surface. Examples of roles are a cursor for a
// pointer (as set by wl_pointer.set_cursor), a drag icon
// (wl_data_device.start_drag), a sub-surface
// (wl_subcompositor.get_subsurface), and a window as defined by a
// shell protocol (e.g. wl_shell.get_shell_surface).
// A surface can have only one role at a time. Initially a
// wl_surface does not have a role. Once a wl_surface is given a
// role, it is set permanently for the whole lifetime of the
// wl_surface object. Giving the current role again is allowed,
// unless explicitly forbidden by the relevant interface
// specification.
// Surface roles are given by requests in other interfaces such as
// wl_pointer.set_cursor. The request should explicitly mention
// that this request gives a role to a wl_surface. Often, this
// request also creates a new protocol object that represents the
// role and adds additional functionality to wl_surface. When a
// client wants to destroy a wl_surface, they must destroy this role
// object before the wl_surface, otherwise a defunct_role_object error is
// sent.
// Destroying the role object does not remove the role from the
// wl_surface, but it may stop the wl_surface from "playing the role".
// For instance, if a wl_subsurface object is destroyed, the wl_surface
// it was created for will be unmapped and forget its position and
// z-order. It is allowed to create a wl_subsurface for the same
// wl_surface again, but it is not allowed to use the wl_surface as
// a cursor (cursor is a different role than sub-surface, and role
// switching is not allowed).
SURFACE_INTERFACE :: "wl_surface"
SURFACE_VERSION :: 7

// delete surface
// Deletes the surface and invalidates its object ID.
SURFACE_DESTROY_OPCODE :: 0
Surface_Destroy_Request :: struct {
	surface : u32,
}
surface_destroy_encode :: proc(req: Surface_Destroy_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.surface
	opcode := u16(SURFACE_DESTROY_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// set the surface contents
// Set a buffer as the content of this surface.
// The new size of the surface is calculated based on the buffer
// size transformed by the inverse buffer_transform and the
// inverse buffer_scale. This means that at commit time the supplied
// buffer size must be an integer multiple of the buffer_scale. If
// that's not the case, an invalid_size error is sent.
// The x and y arguments specify the location of the new pending
// buffer's upper left corner, relative to the current buffer's upper
// left corner, in surface-local coordinates. In other words, the
// x and y, combined with the new surface size define in which
// directions the surface's size changes. Setting anything other than 0
// as x and y arguments is discouraged, and should instead be replaced
// with using the separate wl_surface.offset request.
// When the bound wl_surface version is 5 or higher, passing any
// non-zero x or y is a protocol violation, and will result in an
// 'invalid_offset' error being raised. The x and y arguments are ignored
// and do not change the pending state. To achieve equivalent semantics,
// use wl_surface.offset.
// Surface contents are double-buffered state, see wl_surface.commit.
// The initial surface contents are void; there is no content.
// wl_surface.attach assigns the given wl_buffer as the pending
// wl_buffer. wl_surface.commit makes the pending wl_buffer the new
// surface contents, and the size of the surface becomes the size
// calculated from the wl_buffer, as described above. After commit,
// there is no pending buffer until the next attach.
// Committing a pending wl_buffer allows the compositor to read the
// pixels in the wl_buffer. The compositor may access the pixels at
// any time after the wl_surface.commit request. When the compositor
// will not access the pixels anymore, it will send the
// wl_buffer.release event. Only after receiving wl_buffer.release,
// the client may reuse the wl_buffer. A wl_buffer that has been
// attached and then replaced by another attach instead of committed
// will not receive a release event, and is not used by the
// compositor.
// If a pending wl_buffer has been committed to more than one wl_surface,
// the delivery of wl_buffer.release events becomes undefined. A well
// behaved client should not rely on wl_buffer.release events in this
// case. Instead, clients hitting this case should use
// wl_surface.get_release or use a protocol extension providing per-commit
// release notifications (if none of these options are available, a
// fallback can be implemented by creating multiple wl_buffer objects from
// the same backing storage).
// Destroying the wl_buffer after wl_buffer.release does not change
// the surface contents. Destroying the wl_buffer before wl_buffer.release
// is allowed as long as the underlying buffer storage isn't re-used (this
// can happen e.g. on client process termination). However, if the client
// destroys the wl_buffer before receiving the wl_buffer.release event and
// mutates the underlying buffer storage, the surface contents become
// undefined immediately.
// If wl_surface.attach is sent with a NULL wl_buffer, the
// following wl_surface.commit will remove the surface content.
// If a pending wl_buffer has been destroyed, the result is not specified.
// Many compositors are known to remove the surface content on the following
// wl_surface.commit, but this behaviour is not universal. Clients seeking to
// maximise compatibility should not destroy pending buffers and should
// ensure that they explicitly remove content from surfaces, even after
// destroying buffers.
SURFACE_ATTACH_OPCODE :: 1
Surface_Attach_Request :: struct {
	surface : u32,
	buffer  : u32,  // buffer of surface contents
	x       : i32,  // surface-local x coordinate
	y       : i32,  // surface-local y coordinate
}
surface_attach_encode :: proc(req: Surface_Attach_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.surface
	opcode := u16(SURFACE_ATTACH_OPCODE)
	size := u16(8 + size_of(req.buffer) + size_of(req.x) + size_of(req.y))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.buffer)
	util.write(&msg, req.x)
	util.write(&msg, req.y)
	encoded = msg[:]
	return
}

// mark part of the surface damaged
// This request is used to describe the regions where the pending
// buffer is different from the current surface contents, and where
// the surface therefore needs to be repainted. The compositor
// ignores the parts of the damage that fall outside of the surface.
// Damage is double-buffered state, see wl_surface.commit.
// The damage rectangle is specified in surface-local coordinates,
// where x and y specify the upper left corner of the damage rectangle.
// The initial value for pending damage is empty: no damage.
// wl_surface.damage adds pending damage: the new pending damage
// is the union of old pending damage and the given rectangle.
// wl_surface.commit assigns pending damage as the current damage,
// and clears pending damage. The server will clear the current
// damage as it repaints the surface.
// Note! New clients should not use this request. Instead damage can be
// posted with wl_surface.damage_buffer which uses buffer coordinates
// instead of surface coordinates.
SURFACE_DAMAGE_OPCODE :: 2
Surface_Damage_Request :: struct {
	surface : u32,
	x       : i32,  // surface-local x coordinate
	y       : i32,  // surface-local y coordinate
	width   : i32,  // width of damage rectangle
	height  : i32,  // height of damage rectangle
}
surface_damage_encode :: proc(req: Surface_Damage_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.surface
	opcode := u16(SURFACE_DAMAGE_OPCODE)
	size := u16(8 + size_of(req.x) + size_of(req.y) + size_of(req.width) + size_of(req.height))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.x)
	util.write(&msg, req.y)
	util.write(&msg, req.width)
	util.write(&msg, req.height)
	encoded = msg[:]
	return
}

// request a frame throttling hint
// Request a notification when it is a good time to start drawing a new
// frame, by creating a frame callback. This is useful for throttling
// redrawing operations, and driving animations.
// When a client is animating on a wl_surface, it can use the 'frame'
// request to get notified when it is a good time to draw and commit the
// next frame of animation. If the client commits an update earlier than
// that, it is likely that some updates will not make it to the display,
// and the client is wasting resources by drawing too often.
// The frame request will take effect on the next wl_surface.commit.
// The notification will only be posted for one frame unless
// requested again. For a wl_surface, the notifications are posted in
// the order the frame requests were committed.
// The server must send the notifications so that a client
// will not send excessive updates, while still allowing
// the highest possible update rate for clients that wait for the reply
// before drawing again. The server should give some time for the client
// to draw and commit after sending the frame callback events to let it
// hit the next output refresh.
// A server should avoid signaling the frame callbacks if the
// surface is not visible in any way, e.g. the surface is off-screen,
// or completely obscured by other opaque surfaces.
// The object returned by this request will be destroyed by the
// compositor after the callback is fired and as such the client must not
// attempt to use it after that point.
// The callback_data passed in the callback is the current time, in
// milliseconds, with an undefined base.
SURFACE_FRAME_OPCODE :: 3
Surface_Frame_Request :: struct {
	surface : u32,
}
surface_frame_encode :: proc(req: Surface_Frame_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.surface
	opcode := u16(SURFACE_FRAME_OPCODE)
	size := u16(8 + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// set opaque region
// This request sets the region of the surface that contains
// opaque content.
// The opaque region is an optimization hint for the compositor
// that lets it optimize the redrawing of content behind opaque
// regions.  Setting an opaque region is not required for correct
// behaviour, but marking transparent content as opaque will result
// in repaint artifacts.
// The opaque region is specified in surface-local coordinates.
// The compositor ignores the parts of the opaque region that fall
// outside of the surface.
// Opaque region is double-buffered state, see wl_surface.commit.
// wl_surface.set_opaque_region changes the pending opaque region.
// wl_surface.commit copies the pending region to the current region.
// Otherwise, the pending and current regions are never changed.
// The initial value for an opaque region is empty. Setting the pending
// opaque region has copy semantics, and the wl_region object can be
// destroyed immediately. A NULL wl_region causes the pending opaque
// region to be set to empty.
SURFACE_SET_OPAQUE_REGION_OPCODE :: 4
Surface_Set_Opaque_Region_Request :: struct {
	surface : u32,
	region  : u32,  // opaque region of the surface
}
surface_set_opaque_region_encode :: proc(req: Surface_Set_Opaque_Region_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.surface
	opcode := u16(SURFACE_SET_OPAQUE_REGION_OPCODE)
	size := u16(8 + size_of(req.region))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.region)
	encoded = msg[:]
	return
}

// set input region
// This request sets the region of the surface that can receive
// pointer and touch events.
// Input events happening outside of this region will try the next
// surface in the server surface stack. The compositor ignores the
// parts of the input region that fall outside of the surface.
// The input region is specified in surface-local coordinates.
// Input region is double-buffered state, see wl_surface.commit.
// wl_surface.set_input_region changes the pending input region.
// wl_surface.commit copies the pending region to the current region.
// Otherwise the pending and current regions are never changed,
// except cursor and icon surfaces are special cases, see
// wl_pointer.set_cursor and wl_data_device.start_drag.
// The initial value for an input region is infinite. That means the
// whole surface will accept input. Setting the pending input region
// has copy semantics, and the wl_region object can be destroyed
// immediately. A NULL wl_region causes the input region to be set
// to infinite.
SURFACE_SET_INPUT_REGION_OPCODE :: 5
Surface_Set_Input_Region_Request :: struct {
	surface : u32,
	region  : u32,  // input region of the surface
}
surface_set_input_region_encode :: proc(req: Surface_Set_Input_Region_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.surface
	opcode := u16(SURFACE_SET_INPUT_REGION_OPCODE)
	size := u16(8 + size_of(req.region))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.region)
	encoded = msg[:]
	return
}

// commit pending surface state
// Surface state (input, opaque, and damage regions, attached buffers,
// etc.) is double-buffered. Protocol requests modify the pending state,
// as opposed to the active state in use by the compositor.
// All requests that need a commit to become effective are documented
// to affect double-buffered state.
// Other interfaces may add further double-buffered surface state.
// A commit request atomically creates a Content Update (CU) from the
// pending state, even if the pending state has not been touched. The
// content update is placed at the end of a per-surface queue until it
// becomes active. After commit, the new pending state is as documented for
// each related request.
// A CU is either a Desync Content Update (DCU) or a Sync Content Update
// (SCU). If the surface is effectively synchronized at the commit request,
// it is a SCU, otherwise a DCU.
// When a surface transitions from effectively synchronized to effectively
// desynchronized, all SCUs in its queue which are not reachable by any
// DCU become DCUs and dependency edges from outside the queue to these CUs
// are removed.
// See wl_subsurface for the definition of 'effectively synchronized' and
// 'effectively desynchronized'.
// When a CU is placed in the queue, the CU has a dependency on the CU in
// front of it and to the SCU at end of the queue of every direct child
// surface if that SCU exists and does not have another dependent. This can
// form a directed acyclic graph of CUs with dependencies as edges.
// In addition to surface state, the CU can have constraints that must be
// satisfied before it can be applied. Other interfaces may add CU
// constraints.
// All DCUs which do not have a SCU in front of themselves in their queue,
// are candidates. If the graph that's reachable by a candidate does not
// have any unsatisfied constraints, the entire graph must be applied
// atomically.
// When a CU is applied, the wl_buffer is applied before all other state.
// This means that all coordinates in double-buffered state are relative to
// the newly attached wl_buffers, except for wl_surface.attach itself. If
// there is no newly attached wl_buffer, the coordinates are relative to
// the previous content update.
SURFACE_COMMIT_OPCODE :: 6
Surface_Commit_Request :: struct {
	surface : u32,
}
surface_commit_encode :: proc(req: Surface_Commit_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.surface
	opcode := u16(SURFACE_COMMIT_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// sets the buffer transformation
// This request sets the transformation that the client has already applied
// to the content of the buffer. The accepted values for the transform
// parameter are the values for wl_output.transform.
// The compositor applies the inverse of this transformation whenever it
// uses the buffer contents.
// Buffer transform is double-buffered state, see wl_surface.commit.
// A newly created surface has its buffer transformation set to normal.
// wl_surface.set_buffer_transform changes the pending buffer
// transformation. wl_surface.commit copies the pending buffer
// transformation to the current one. Otherwise, the pending and current
// values are never changed.
// The purpose of this request is to allow clients to render content
// according to the output transform, thus permitting the compositor to
// use certain optimizations even if the display is rotated. Using
// hardware overlays and scanning out a client buffer for fullscreen
// surfaces are examples of such optimizations. Those optimizations are
// highly dependent on the compositor implementation, so the use of this
// request should be considered on a case-by-case basis.
// Note that if the transform value includes 90 or 270 degree rotation,
// the width of the buffer will become the surface height and the height
// of the buffer will become the surface width.
// If transform is not one of the values from the
// wl_output.transform enum the invalid_transform protocol error
// is raised.
SURFACE_SET_BUFFER_TRANSFORM_OPCODE :: 7
Surface_Set_Buffer_Transform_Request :: struct {
	surface   : u32,
	transform : i32,  // transform for interpreting buffer contents
}
surface_set_buffer_transform_encode :: proc(req: Surface_Set_Buffer_Transform_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.surface
	opcode := u16(SURFACE_SET_BUFFER_TRANSFORM_OPCODE)
	size := u16(8 + size_of(req.transform))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.transform)
	encoded = msg[:]
	return
}

// sets the buffer scaling factor
// This request sets an optional scaling factor on how the compositor
// interprets the contents of the buffer attached to the window.
// Buffer scale is double-buffered state, see wl_surface.commit.
// A newly created surface has its buffer scale set to 1.
// wl_surface.set_buffer_scale changes the pending buffer scale.
// wl_surface.commit copies the pending buffer scale to the current one.
// Otherwise, the pending and current values are never changed.
// The purpose of this request is to allow clients to supply higher
// resolution buffer data for use on high resolution outputs. It is
// intended that you pick the same buffer scale as the scale of the
// output that the surface is displayed on. This means the compositor
// can avoid scaling when rendering the surface on that output.
// Note that if the scale is larger than 1, then you have to attach
// a buffer that is larger (by a factor of scale in each dimension)
// than the desired surface size.
// If scale is not greater than 0 the invalid_scale protocol error is
// raised.
SURFACE_SET_BUFFER_SCALE_OPCODE :: 8
Surface_Set_Buffer_Scale_Request :: struct {
	surface : u32,
	scale   : i32,  // scale for interpreting buffer contents
}
surface_set_buffer_scale_encode :: proc(req: Surface_Set_Buffer_Scale_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.surface
	opcode := u16(SURFACE_SET_BUFFER_SCALE_OPCODE)
	size := u16(8 + size_of(req.scale))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.scale)
	encoded = msg[:]
	return
}

// mark part of the surface damaged using buffer coordinates
// This request is used to describe the regions where the pending
// buffer is different from the current surface contents, and where
// the surface therefore needs to be repainted. The compositor
// ignores the parts of the damage that fall outside of the surface.
// Damage is double-buffered state, see wl_surface.commit.
// The damage rectangle is specified in buffer coordinates,
// where x and y specify the upper left corner of the damage rectangle.
// The initial value for pending damage is empty: no damage.
// wl_surface.damage_buffer adds pending damage: the new pending
// damage is the union of old pending damage and the given rectangle.
// wl_surface.commit assigns pending damage as the current damage,
// and clears pending damage. The server will clear the current
// damage as it repaints the surface.
// This request differs from wl_surface.damage in only one way - it
// takes damage in buffer coordinates instead of surface-local
// coordinates. While this generally is more intuitive than surface
// coordinates, it is especially desirable when using wp_viewport
// or when a drawing library (like EGL) is unaware of buffer scale
// and buffer transform.
// Note: Because buffer transformation changes and damage requests may
// be interleaved in the protocol stream, it is impossible to determine
// the actual mapping between surface and buffer damage until
// wl_surface.commit time. Therefore, compositors wishing to take both
// kinds of damage into account will have to accumulate damage from the
// two requests separately and only transform from one to the other
// after receiving the wl_surface.commit.
SURFACE_DAMAGE_BUFFER_OPCODE :: 9
Surface_Damage_Buffer_Request :: struct {
	surface : u32,
	x       : i32,  // buffer-local x coordinate
	y       : i32,  // buffer-local y coordinate
	width   : i32,  // width of damage rectangle
	height  : i32,  // height of damage rectangle
}
surface_damage_buffer_encode :: proc(req: Surface_Damage_Buffer_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.surface
	opcode := u16(SURFACE_DAMAGE_BUFFER_OPCODE)
	size := u16(8 + size_of(req.x) + size_of(req.y) + size_of(req.width) + size_of(req.height))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.x)
	util.write(&msg, req.y)
	util.write(&msg, req.width)
	util.write(&msg, req.height)
	encoded = msg[:]
	return
}

// set the surface contents offset
// The x and y arguments specify the location of the new pending
// buffer's upper left corner, relative to the current buffer's upper
// left corner, in surface-local coordinates. In other words, the
// x and y, combined with the new surface size define in which
// directions the surface's size changes.
// The exact semantics of wl_surface.offset are role-specific. Refer to
// the documentation of specific roles for more information.
// Surface location offset is double-buffered state, see
// wl_surface.commit.
// This request is semantically equivalent to and the replaces the x and y
// arguments in the wl_surface.attach request in wl_surface versions prior
// to 5. See wl_surface.attach for details.
SURFACE_OFFSET_OPCODE :: 10
Surface_Offset_Request :: struct {
	surface : u32,
	x       : i32,  // surface-local x coordinate
	y       : i32,  // surface-local y coordinate
}
surface_offset_encode :: proc(req: Surface_Offset_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.surface
	opcode := u16(SURFACE_OFFSET_OPCODE)
	size := u16(8 + size_of(req.x) + size_of(req.y))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.x)
	util.write(&msg, req.y)
	encoded = msg[:]
	return
}

// get a release callback
// Create a callback for the release of the buffer attached by the client
// with wl_surface.attach.
// The compositor will release the buffer when it has finished its usage of
// the underlying storage for the relevant commit. Once the client receives
// this event, and assuming the associated buffer is not pending release
// from other wl_surface.commit requests, the client can safely re-use the
// buffer.
// Release callbacks are double-buffered state, and will be associated
// with the pending buffer at wl_surface.commit time.
// The callback_data passed in the wl_callback.done event is unused and
// is always zero.
// Sending this request without attaching a non-null buffer in the same
// content update is a protocol error. The compositor will send the
// no_buffer error in this case.
SURFACE_GET_RELEASE_OPCODE :: 11
Surface_Get_Release_Request :: struct {
	surface : u32,
}
surface_get_release_encode :: proc(req: Surface_Get_Release_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.surface
	opcode := u16(SURFACE_GET_RELEASE_OPCODE)
	size := u16(8 + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// surface enters an output
// This is emitted whenever a surface's creation, movement, or resizing
// results in some part of it being within the scanout region of an
// output.
// Note that a surface may be overlapping with zero or more outputs.
SURFACE_ENTER_OPCODE :: 0
Surface_Enter_Event :: struct {
	output : u32,  // output entered by the surface
}
surface_enter_decode :: proc(data: []byte) -> Surface_Enter_Event {
	e: Surface_Enter_Event
	r: int
	n := r
	e.output, r = util.read_u32(data[n:]); n += r
	return e
}

// surface leaves an output
// This is emitted whenever a surface's creation, movement, or resizing
// results in it no longer having any part of it within the scanout region
// of an output.
// Clients should not use the number of outputs the surface is on for frame
// throttling purposes. The surface might be hidden even if no leave event
// has been sent, and the compositor might expect new surface content
// updates even if no enter event has been sent. The frame event should be
// used instead.
SURFACE_LEAVE_OPCODE :: 1
Surface_Leave_Event :: struct {
	output : u32,  // output left by the surface
}
surface_leave_decode :: proc(data: []byte) -> Surface_Leave_Event {
	e: Surface_Leave_Event
	r: int
	n := r
	e.output, r = util.read_u32(data[n:]); n += r
	return e
}

// preferred buffer scale for the surface
// This event indicates the preferred buffer scale for this surface. It is
// sent whenever the compositor's preference changes.
// Before receiving this event the preferred buffer scale for this surface
// is 1.
// It is intended that scaling aware clients use this event to scale their
// content and use wl_surface.set_buffer_scale to indicate the scale they
// have rendered with. This allows clients to supply a higher detail
// buffer.
// The compositor shall emit a scale value greater than 0.
SURFACE_PREFERRED_BUFFER_SCALE_OPCODE :: 2
Surface_Preferred_Buffer_Scale_Event :: struct {
	factor : i32,  // preferred scaling factor
}
surface_preferred_buffer_scale_decode :: proc(data: []byte) -> Surface_Preferred_Buffer_Scale_Event {
	e: Surface_Preferred_Buffer_Scale_Event
	r: int
	n := r
	e.factor, r = util.read_i32(data[n:]); n += r
	return e
}

// preferred buffer transform for the surface
// This event indicates the preferred buffer transform for this surface.
// It is sent whenever the compositor's preference changes.
// Before receiving this event the preferred buffer transform for this
// surface is normal.
// Applying this transformation to the surface buffer contents and using
// wl_surface.set_buffer_transform might allow the compositor to use the
// surface buffer more efficiently.
SURFACE_PREFERRED_BUFFER_TRANSFORM_OPCODE :: 3
Surface_Preferred_Buffer_Transform_Event :: struct {
	transform : u32,  // preferred transform
}
surface_preferred_buffer_transform_decode :: proc(data: []byte) -> Surface_Preferred_Buffer_Transform_Event {
	e: Surface_Preferred_Buffer_Transform_Event
	r: int
	n := r
	e.transform, r = util.read_u32(data[n:]); n += r
	return e
}

// wl_surface error values
// These errors can be emitted in response to wl_surface requests.
Surface_Error :: enum u32 {
	Invalid_Scale = 0,  // buffer scale value is invalid
	Invalid_Transform = 1,  // buffer transform value is invalid
	Invalid_Size = 2,  // buffer size is invalid
	Invalid_Offset = 3,  // buffer offset is invalid
	Defunct_Role_Object = 4,  // surface was destroyed before its role object
	No_Buffer = 5,  // no buffer was attached
}

// group of input devices
// A seat is a group of keyboards, pointer and touch devices. This
// object is published as a global during start up, or when such a
// device is hot plugged.  A seat typically has a pointer and
// maintains a keyboard focus and a pointer focus.
SEAT_INTERFACE :: "wl_seat"
SEAT_VERSION :: 11

// return pointer object
// The ID provided will be initialized to the wl_pointer interface
// for this seat.
// This request only takes effect if the seat has the pointer
// capability, or has had the pointer capability in the past.
// It is a protocol violation to issue this request on a seat that has
// never had the pointer capability. The missing_capability error will
// be sent in this case.
SEAT_GET_POINTER_OPCODE :: 0
Seat_Get_Pointer_Request :: struct {
	seat : u32,
}
seat_get_pointer_encode :: proc(req: Seat_Get_Pointer_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.seat
	opcode := u16(SEAT_GET_POINTER_OPCODE)
	size := u16(8 + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// return keyboard object
// The ID provided will be initialized to the wl_keyboard interface
// for this seat.
// This request only takes effect if the seat has the keyboard
// capability, or has had the keyboard capability in the past.
// It is a protocol violation to issue this request on a seat that has
// never had the keyboard capability. The missing_capability error will
// be sent in this case.
SEAT_GET_KEYBOARD_OPCODE :: 1
Seat_Get_Keyboard_Request :: struct {
	seat : u32,
}
seat_get_keyboard_encode :: proc(req: Seat_Get_Keyboard_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.seat
	opcode := u16(SEAT_GET_KEYBOARD_OPCODE)
	size := u16(8 + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// return touch object
// The ID provided will be initialized to the wl_touch interface
// for this seat.
// This request only takes effect if the seat has the touch
// capability, or has had the touch capability in the past.
// It is a protocol violation to issue this request on a seat that has
// never had the touch capability. The missing_capability error will
// be sent in this case.
SEAT_GET_TOUCH_OPCODE :: 2
Seat_Get_Touch_Request :: struct {
	seat : u32,
}
seat_get_touch_encode :: proc(req: Seat_Get_Touch_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.seat
	opcode := u16(SEAT_GET_TOUCH_OPCODE)
	size := u16(8 + size_of(new_id))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	encoded = msg[:]
	return
}

// release the seat object
// Using this request a client can tell the server that it is not going to
// use the seat object anymore.
SEAT_RELEASE_OPCODE :: 3
Seat_Release_Request :: struct {
	seat : u32,
}
seat_release_encode :: proc(req: Seat_Release_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.seat
	opcode := u16(SEAT_RELEASE_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// seat capabilities changed
// This is sent on binding to the seat global or whenever a seat gains
// or loses the pointer, keyboard or touch capabilities.
// The argument is a capability enum containing the complete set of
// capabilities this seat has.
// When the pointer capability is added, a client may create a
// wl_pointer object using the wl_seat.get_pointer request. This object
// will receive pointer events until the capability is removed in the
// future.
// When the pointer capability is removed, a client should destroy the
// wl_pointer objects associated with the seat where the capability was
// removed, using the wl_pointer.release request. No further pointer
// events will be received on these objects.
// In some compositors, if a seat regains the pointer capability and a
// client has a previously obtained wl_pointer object of version 4 or
// less, that object may start sending pointer events again. This
// behavior is considered a misinterpretation of the intended behavior
// and must not be relied upon by the client. wl_pointer objects of
// version 5 or later must not send events if created before the most
// recent event notifying the client of an added pointer capability.
// The above behavior also applies to wl_keyboard and wl_touch with the
// keyboard and touch capabilities, respectively.
SEAT_CAPABILITIES_OPCODE :: 0
Seat_Capabilities_Event :: struct {
	capabilities : u32,  // capabilities of the seat
}
seat_capabilities_decode :: proc(data: []byte) -> Seat_Capabilities_Event {
	e: Seat_Capabilities_Event
	r: int
	n := r
	e.capabilities, r = util.read_u32(data[n:]); n += r
	return e
}

// unique identifier for this seat
// In a multi-seat configuration the seat name can be used by clients to
// help identify which physical devices the seat represents.
// The seat name is a UTF-8 string with no convention defined for its
// contents. Each name is unique among all wl_seat globals. The name is
// only guaranteed to be unique for the current compositor instance.
// The same seat names are used for all clients. Thus, the name can be
// shared across processes to refer to a specific wl_seat global.
// The name event is sent after binding to the seat global, and should be sent
// before announcing capabilities. This event is only sent once per seat object,
// and the name does not change over the lifetime of the wl_seat global.
// Compositors may re-use the same seat name if the wl_seat global is
// destroyed and re-created later.
SEAT_NAME_OPCODE :: 1
Seat_Name_Event :: struct {
	name : string,  // seat identifier
}
seat_name_decode :: proc(data: []byte, allocator: mem.Allocator) -> Seat_Name_Event {
	e: Seat_Name_Event
	r: int
	n := r
	e.name, r = util.read_string(data[n:]); n += r
	e.name = strings.clone(e.name, allocator)
	return e
}

// seat capability bitmask
// This is a bitmask of capabilities this seat has; if a member is
// set, then it is present on the seat.
Seat_Capability :: enum u32 {
	Pointer = 1,  // the seat has pointer devices
	Keyboard = 2,  // the seat has one or more keyboards
	Touch = 4,  // the seat has touch devices
}

// wl_seat error values
// These errors can be emitted in response to wl_seat requests.
Seat_Error :: enum u32 {
	Missing_Capability = 0,  // get_pointer, get_keyboard or get_touch called on seat without the matching capability
}

// pointer input device
// The wl_pointer interface represents one or more input devices,
// such as mice, which control the pointer location and pointer_focus
// of a seat.
// The wl_pointer interface generates motion, enter and leave
// events for the surfaces that the pointer is located over,
// and button and axis events for button presses, button releases
// and scrolling.
POINTER_INTERFACE :: "wl_pointer"
POINTER_VERSION :: 11

// set the pointer surface
// Set the pointer surface, i.e., the surface that contains the
// pointer image (cursor). This request gives the surface the role
// of a cursor. If the surface already has another role, it raises
// a protocol error.
// The cursor actually changes only if the pointer
// focus for this device is one of the requesting client's surfaces
// or the surface parameter is the current pointer surface. If
// there was a previous surface set with this request it is
// replaced. If surface is NULL, the pointer image is hidden.
// The parameters hotspot_x and hotspot_y define the position of
// the pointer surface relative to the pointer location. Its
// top-left corner is always at (x, y) - (hotspot_x, hotspot_y),
// where (x, y) are the coordinates of the pointer location, in
// surface-local coordinates.
// On wl_surface.offset requests to the pointer surface, hotspot_x
// and hotspot_y are decremented by the x and y parameters
// passed to the request. The offset must be applied by
// wl_surface.commit as usual.
// The hotspot can also be updated by passing the currently set
// pointer surface to this request with new values for hotspot_x
// and hotspot_y.
// The input region is ignored for wl_surfaces with the role of
// a cursor. When the use as a cursor ends, the wl_surface is
// unmapped.
// The serial parameter must match the latest wl_pointer.enter
// serial number sent to the client. Otherwise the request will be
// ignored.
POINTER_SET_CURSOR_OPCODE :: 0
Pointer_Set_Cursor_Request :: struct {
	pointer   : u32,
	serial    : u32,  // serial number of the enter event
	surface   : u32,  // pointer surface
	hotspot_x : i32,  // surface-local x coordinate
	hotspot_y : i32,  // surface-local y coordinate
}
pointer_set_cursor_encode :: proc(req: Pointer_Set_Cursor_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.pointer
	opcode := u16(POINTER_SET_CURSOR_OPCODE)
	size := u16(8 + size_of(req.serial) + size_of(req.surface) + size_of(req.hotspot_x) + size_of(req.hotspot_y))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.serial)
	util.write(&msg, req.surface)
	util.write(&msg, req.hotspot_x)
	util.write(&msg, req.hotspot_y)
	encoded = msg[:]
	return
}

// release the pointer object
// Using this request a client can tell the server that it is not going to
// use the pointer object anymore.
// This request destroys the pointer proxy object, so clients must not call
// wl_pointer_destroy() after using this request.
POINTER_RELEASE_OPCODE :: 1
Pointer_Release_Request :: struct {
	pointer : u32,
}
pointer_release_encode :: proc(req: Pointer_Release_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.pointer
	opcode := u16(POINTER_RELEASE_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// enter event
// Notification that this seat's pointer is focused on a certain
// surface.
// When a seat's focus enters a surface, the pointer image
// is undefined and a client should respond to this event by setting
// an appropriate pointer image with the set_cursor request.
POINTER_ENTER_OPCODE :: 0
Pointer_Enter_Event :: struct {
	serial    : u32,  // serial number of the enter event
	surface   : u32,  // surface entered by the pointer
	surface_x : util.Fixed,  // surface-local x coordinate
	surface_y : util.Fixed,  // surface-local y coordinate
}
pointer_enter_decode :: proc(data: []byte) -> Pointer_Enter_Event {
	e: Pointer_Enter_Event
	r: int
	n := r
	e.serial, r = util.read_u32(data[n:]); n += r
	e.surface, r = util.read_u32(data[n:]); n += r
	e.surface_x, r = util.read_fixed(data[n:]); n += r
	e.surface_y, r = util.read_fixed(data[n:]); n += r
	return e
}

// leave event
// Notification that this seat's pointer is no longer focused on
// a certain surface.
// The leave notification is sent before the enter notification
// for the new focus.
POINTER_LEAVE_OPCODE :: 1
Pointer_Leave_Event :: struct {
	serial  : u32,  // serial number of the leave event
	surface : u32,  // surface left by the pointer
}
pointer_leave_decode :: proc(data: []byte) -> Pointer_Leave_Event {
	e: Pointer_Leave_Event
	r: int
	n := r
	e.serial, r = util.read_u32(data[n:]); n += r
	e.surface, r = util.read_u32(data[n:]); n += r
	return e
}

// pointer motion event
// Notification of pointer location change. The arguments
// surface_x and surface_y are the location relative to the
// focused surface.
POINTER_MOTION_OPCODE :: 2
Pointer_Motion_Event :: struct {
	time      : u32,  // timestamp with millisecond granularity
	surface_x : util.Fixed,  // surface-local x coordinate
	surface_y : util.Fixed,  // surface-local y coordinate
}
pointer_motion_decode :: proc(data: []byte) -> Pointer_Motion_Event {
	e: Pointer_Motion_Event
	r: int
	n := r
	e.time, r = util.read_u32(data[n:]); n += r
	e.surface_x, r = util.read_fixed(data[n:]); n += r
	e.surface_y, r = util.read_fixed(data[n:]); n += r
	return e
}

// pointer button event
// Mouse button click and release notifications.
// The location of the click is given by the last motion, warp or
// enter event.
// The time argument is a timestamp with millisecond
// granularity, with an undefined base.
// The button is a button code as defined in the Linux kernel's
// linux/input-event-codes.h header file, e.g. BTN_LEFT.
// Any 16-bit button code value is reserved for future additions to the
// kernel's event code list. All other button codes above 0xFFFF are
// currently undefined but may be used in future versions of this
// protocol.
POINTER_BUTTON_OPCODE :: 3
Pointer_Button_Event :: struct {
	serial : u32,  // serial number of the button event
	time   : u32,  // timestamp with millisecond granularity
	button : u32,  // button that produced the event
	state  : u32,  // physical state of the button
}
pointer_button_decode :: proc(data: []byte) -> Pointer_Button_Event {
	e: Pointer_Button_Event
	r: int
	n := r
	e.serial, r = util.read_u32(data[n:]); n += r
	e.time, r = util.read_u32(data[n:]); n += r
	e.button, r = util.read_u32(data[n:]); n += r
	e.state, r = util.read_u32(data[n:]); n += r
	return e
}

// axis event
// Scroll and other axis notifications.
// For scroll events (vertical and horizontal scroll axes), the
// value parameter is the length of a vector along the specified
// axis in a coordinate space identical to those of motion events,
// representing a relative movement along the specified axis.
// For devices that support movements non-parallel to axes multiple
// axis events will be emitted.
// When applicable, for example for touch pads, the server can
// choose to emit scroll events where the motion vector is
// equivalent to a motion event vector.
// When applicable, a client can transform its content relative to the
// scroll distance.
POINTER_AXIS_OPCODE :: 4
Pointer_Axis_Event :: struct {
	time  : u32,  // timestamp with millisecond granularity
	axis  : u32,  // axis type
	value : util.Fixed,  // length of vector in surface-local coordinate space
}
pointer_axis_decode :: proc(data: []byte) -> Pointer_Axis_Event {
	e: Pointer_Axis_Event
	r: int
	n := r
	e.time, r = util.read_u32(data[n:]); n += r
	e.axis, r = util.read_u32(data[n:]); n += r
	e.value, r = util.read_fixed(data[n:]); n += r
	return e
}

// end of a pointer event sequence
// Indicates the end of a set of events that logically belong together.
// A client is expected to accumulate the data in all events within the
// frame before proceeding.
// All wl_pointer events before a wl_pointer.frame event belong
// logically together. For example, in a diagonal scroll motion the
// compositor will send an optional wl_pointer.axis_source event, two
// wl_pointer.axis events (horizontal and vertical) and finally a
// wl_pointer.frame event. The client may use this information to
// calculate a diagonal vector for scrolling.
// When multiple wl_pointer.axis events occur within the same frame,
// the motion vector is the combined motion of all events.
// When a wl_pointer.axis and a wl_pointer.axis_stop event occur within
// the same frame, this indicates that axis movement in one axis has
// stopped but continues in the other axis.
// When multiple wl_pointer.axis_stop events occur within the same
// frame, this indicates that these axes stopped in the same instance.
// A wl_pointer.frame event is sent for every logical event group,
// even if the group only contains a single wl_pointer event.
// Specifically, a client may get a sequence: motion, frame, button,
// frame, axis, frame, axis_stop, frame.
// The wl_pointer.enter and wl_pointer.leave events are logical events
// generated by the compositor and not the hardware. These events are
// also grouped by a wl_pointer.frame. When a pointer moves from one
// surface to another, a compositor should group the
// wl_pointer.leave event within the same wl_pointer.frame.
// However, a client must not rely on wl_pointer.leave and
// wl_pointer.enter being in the same wl_pointer.frame.
// Compositor-specific policies may require the wl_pointer.leave and
// wl_pointer.enter event being split across multiple wl_pointer.frame
// groups.
POINTER_FRAME_OPCODE :: 5
Pointer_Frame_Event :: struct {}
pointer_frame_decode :: proc(data: []byte) -> Pointer_Frame_Event {
	e: Pointer_Frame_Event
	r: int
	n := r
	return e
}

// axis source event
// Source information for scroll and other axes.
// This event does not occur on its own. It is sent before a
// wl_pointer.frame event and carries the source information for
// all events within that frame.
// The source specifies how this event was generated. If the source is
// wl_pointer.axis_source.finger, a wl_pointer.axis_stop event will be
// sent when the user lifts the finger off the device.
// If the source is wl_pointer.axis_source.wheel,
// wl_pointer.axis_source.wheel_tilt or
// wl_pointer.axis_source.continuous, a wl_pointer.axis_stop event may
// or may not be sent. Whether a compositor sends an axis_stop event
// for these sources is hardware-specific and implementation-dependent;
// clients must not rely on receiving an axis_stop event for these
// scroll sources and should treat scroll sequences from these scroll
// sources as unterminated by default.
// This event is optional. If the source is unknown for a particular
// axis event sequence, no event is sent.
// Only one wl_pointer.axis_source event is permitted per frame.
// The order of wl_pointer.axis_discrete and wl_pointer.axis_source is
// not guaranteed.
POINTER_AXIS_SOURCE_OPCODE :: 6
Pointer_Axis_Source_Event :: struct {
	axis_source : u32,  // source of the axis event
}
pointer_axis_source_decode :: proc(data: []byte) -> Pointer_Axis_Source_Event {
	e: Pointer_Axis_Source_Event
	r: int
	n := r
	e.axis_source, r = util.read_u32(data[n:]); n += r
	return e
}

// axis stop event
// Stop notification for scroll and other axes.
// For some wl_pointer.axis_source types, a wl_pointer.axis_stop event
// is sent to notify a client that the axis sequence has terminated.
// This enables the client to implement kinetic scrolling.
// See the wl_pointer.axis_source documentation for information on when
// this event may be generated.
// Any wl_pointer.axis events with the same axis_source after this
// event should be considered as the start of a new axis motion.
// The timestamp is to be interpreted identical to the timestamp in the
// wl_pointer.axis event. The timestamp value may be the same as a
// preceding wl_pointer.axis event.
POINTER_AXIS_STOP_OPCODE :: 7
Pointer_Axis_Stop_Event :: struct {
	time : u32,  // timestamp with millisecond granularity
	axis : u32,  // the axis stopped with this event
}
pointer_axis_stop_decode :: proc(data: []byte) -> Pointer_Axis_Stop_Event {
	e: Pointer_Axis_Stop_Event
	r: int
	n := r
	e.time, r = util.read_u32(data[n:]); n += r
	e.axis, r = util.read_u32(data[n:]); n += r
	return e
}

// axis click event
// Discrete step information for scroll and other axes.
// This event carries the axis value of the wl_pointer.axis event in
// discrete steps (e.g. mouse wheel clicks).
// This event is deprecated with wl_pointer version 8 - this event is not
// sent to clients supporting version 8 or later.
// This event does not occur on its own, it is coupled with a
// wl_pointer.axis event that represents this axis value on a
// continuous scale. The protocol guarantees that each axis_discrete
// event is always followed by exactly one axis event with the same
// axis number within the same wl_pointer.frame. Note that the protocol
// allows for other events to occur between the axis_discrete and
// its coupled axis event, including other axis_discrete or axis
// events. A wl_pointer.frame must not contain more than one axis_discrete
// event per axis type.
// This event is optional; continuous scrolling devices
// like two-finger scrolling on touchpads do not have discrete
// steps and do not generate this event.
// The discrete value carries the directional information. e.g. a value
// of -2 is two steps towards the negative direction of this axis.
// The axis number is identical to the axis number in the associated
// axis event.
// The order of wl_pointer.axis_discrete and wl_pointer.axis_source is
// not guaranteed.
POINTER_AXIS_DISCRETE_OPCODE :: 8
Pointer_Axis_Discrete_Event :: struct {
	axis     : u32,  // axis type
	discrete : i32,  // number of steps
}
pointer_axis_discrete_decode :: proc(data: []byte) -> Pointer_Axis_Discrete_Event {
	e: Pointer_Axis_Discrete_Event
	r: int
	n := r
	e.axis, r = util.read_u32(data[n:]); n += r
	e.discrete, r = util.read_i32(data[n:]); n += r
	return e
}

// axis high-resolution scroll event
// Discrete high-resolution scroll information.
// This event carries high-resolution wheel scroll information,
// with each multiple of 120 representing one logical scroll step
// (a wheel detent). For example, an axis_value120 of 30 is one quarter of
// a logical scroll step in the positive direction, a value120 of
// -240 are two logical scroll steps in the negative direction within the
// same hardware event.
// Clients that rely on discrete scrolling should accumulate the
// value120 to multiples of 120 before processing the event.
// The value120 must not be zero.
// This event replaces the wl_pointer.axis_discrete event in clients
// supporting wl_pointer version 8 or later.
// Where a wl_pointer.axis_source event occurs in the same
// wl_pointer.frame, the axis source applies to this event.
// The order of wl_pointer.axis_value120 and wl_pointer.axis_source is
// not guaranteed.
POINTER_AXIS_VALUE120_OPCODE :: 9
Pointer_Axis_Value120_Event :: struct {
	axis     : u32,  // axis type
	value120 : i32,  // scroll distance as fraction of 120
}
pointer_axis_value120_decode :: proc(data: []byte) -> Pointer_Axis_Value120_Event {
	e: Pointer_Axis_Value120_Event
	r: int
	n := r
	e.axis, r = util.read_u32(data[n:]); n += r
	e.value120, r = util.read_i32(data[n:]); n += r
	return e
}

// axis relative physical direction event
// Relative directional information of the entity causing the axis
// motion.
// For a wl_pointer.axis event, the wl_pointer.axis_relative_direction
// event specifies the movement direction of the entity causing the
// wl_pointer.axis event. For example:
// - if a user's fingers on a touchpad move down and this
// causes a wl_pointer.axis vertical_scroll down event, the physical
// direction is 'identical'
// - if a user's fingers on a touchpad move down and this causes a
// wl_pointer.axis vertical_scroll up scroll up event ('natural
// scrolling'), the physical direction is 'inverted'.
// A client may use this information to adjust scroll motion of
// components. Specifically, enabling natural scrolling causes the
// content to change direction compared to traditional scrolling.
// Some widgets like volume control sliders should usually match the
// physical direction regardless of whether natural scrolling is
// active. This event enables clients to match the scroll direction of
// a widget to the physical direction.
// This event does not occur on its own, it is coupled with a
// wl_pointer.axis event that represents this axis value.
// The protocol guarantees that each axis_relative_direction event is
// always followed by exactly one axis event with the same
// axis number within the same wl_pointer.frame. Note that the protocol
// allows for other events to occur between the axis_relative_direction
// and its coupled axis event.
// The axis number is identical to the axis number in the associated
// axis event.
// The order of wl_pointer.axis_relative_direction,
// wl_pointer.axis_discrete and wl_pointer.axis_source is not
// guaranteed.
POINTER_AXIS_RELATIVE_DIRECTION_OPCODE :: 10
Pointer_Axis_Relative_Direction_Event :: struct {
	axis      : u32,  // axis type
	direction : u32,  // physical direction relative to axis motion
}
pointer_axis_relative_direction_decode :: proc(data: []byte) -> Pointer_Axis_Relative_Direction_Event {
	e: Pointer_Axis_Relative_Direction_Event
	r: int
	n := r
	e.axis, r = util.read_u32(data[n:]); n += r
	e.direction, r = util.read_u32(data[n:]); n += r
	return e
}

// pointer warp event
// Notification of pointer location change within a surface.
// This location change is not due to events on the input device,
// but because either the surface under the pointer was moved and
// thus the relative position of the pointer changed, or because
// the compositor changed the pointer position in response to an
// event like pointer confinement being exited.
// The arguments surface_x and surface_y are the location relative to
// the focused surface.
// This event must not occur in the same wl_pointer.frame as a
// wl_pointer.enter or wl_pointer.motion event.
POINTER_WARP_OPCODE :: 11
Pointer_Warp_Event :: struct {
	surface_x : util.Fixed,  // surface-local x coordinate
	surface_y : util.Fixed,  // surface-local y coordinate
}
pointer_warp_decode :: proc(data: []byte) -> Pointer_Warp_Event {
	e: Pointer_Warp_Event
	r: int
	n := r
	e.surface_x, r = util.read_fixed(data[n:]); n += r
	e.surface_y, r = util.read_fixed(data[n:]); n += r
	return e
}

Pointer_Error :: enum u32 {
	Role = 0,  // given wl_surface has another role
}

// physical button state
// Describes the physical state of a button that produced the button
// event.
Pointer_Button_State :: enum u32 {
	Released = 0,  // the button is not pressed
	Pressed = 1,  // the button is pressed
}

// axis types
// Describes the axis types of scroll events.
Pointer_Axis :: enum u32 {
	Vertical_Scroll = 0,  // vertical axis
	Horizontal_Scroll = 1,  // horizontal axis
}

// axis source types
// Describes the source types for axis events. This indicates to the
// client how an axis event was physically generated; a client may
// adjust the user interface accordingly. For example, scroll events
// from a "finger" source may be in a smooth coordinate space with
// kinetic scrolling whereas a "wheel" source may be in discrete steps
// of a number of lines.
// The "continuous" axis source is a device generating events in a
// continuous coordinate space, but using something other than a
// finger. One example for this source is button-based scrolling where
// the vertical motion of a device is converted to scroll events while
// a button is held down.
// The "wheel tilt" axis source indicates that the actual device is a
// wheel but the scroll event is not caused by a rotation but a
// (usually sideways) tilt of the wheel.
Pointer_Axis_Source :: enum u32 {
	Wheel = 0,  // a physical wheel rotation
	Finger = 1,  // finger on a touch surface
	Continuous = 2,  // continuous coordinate space
	Wheel_Tilt = 3,  // a physical wheel tilt
}

// axis relative direction
// This specifies the direction of the physical motion that caused a
// wl_pointer.axis event, relative to the wl_pointer.axis direction.
Pointer_Axis_Relative_Direction :: enum u32 {
	Identical = 0,  // physical motion matches axis direction
	Inverted = 1,  // physical motion is the inverse of the axis direction
}

// keyboard input device
// The wl_keyboard interface represents one or more keyboards
// associated with a seat.
// Each wl_keyboard has the following logical state:
// - an active surface (possibly null),
// - the keys currently logically down,
// - the active modifiers,
// - the active group.
// By default, the active surface is null, the keys currently logically down
// are empty, the active modifiers and the active group are 0.
KEYBOARD_INTERFACE :: "wl_keyboard"
KEYBOARD_VERSION :: 11

// release the keyboard object
KEYBOARD_RELEASE_OPCODE :: 0
Keyboard_Release_Request :: struct {
	keyboard : u32,
}
keyboard_release_encode :: proc(req: Keyboard_Release_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.keyboard
	opcode := u16(KEYBOARD_RELEASE_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// keyboard mapping
// This event provides a file descriptor to the client which can be
// memory-mapped in read-only mode to provide a keyboard mapping
// description.
// From version 7 onwards, the fd must be mapped with MAP_PRIVATE by
// the recipient, as MAP_SHARED may fail.
KEYBOARD_KEYMAP_OPCODE :: 0
Keyboard_Keymap_Event :: struct {
	format : u32,  // keymap format
	fd     : linux.Fd,  // keymap file descriptor
	size   : u32,  // keymap size, in bytes
}
keyboard_keymap_decode :: proc(data: []byte, fds: ^[dynamic]linux.Fd) -> Keyboard_Keymap_Event {
	e: Keyboard_Keymap_Event
	r: int
	n := r
	e.format, r = util.read_u32(data[n:]); n += r
	e.fd = pop_front(fds)
	e.size, r = util.read_u32(data[n:]); n += r
	return e
}

// enter event
// Notification that this seat's keyboard focus is on a certain
// surface.
// The compositor must send the wl_keyboard.modifiers event after this
// event.
// In the wl_keyboard logical state, this event sets the active surface to
// the surface argument and the keys currently logically down to the keys
// in the keys argument. The compositor must not send this event if the
// wl_keyboard already had an active surface immediately before this event.
// Clients should not use the list of pressed keys to emulate key-press
// events. The order of keys in the list is unspecified.
KEYBOARD_ENTER_OPCODE :: 1
Keyboard_Enter_Event :: struct {
	serial  : u32,  // serial number of the enter event
	surface : u32,  // surface gaining keyboard focus
	keys    : []u8,  // the keys currently logically down
}
keyboard_enter_decode :: proc(data: []byte, allocator: mem.Allocator) -> Keyboard_Enter_Event {
	e: Keyboard_Enter_Event
	r: int
	n := r
	e.serial, r = util.read_u32(data[n:]); n += r
	e.surface, r = util.read_u32(data[n:]); n += r
	e.keys, r = util.read_array(data[n:]); n += r
	e.keys = bytes.clone(e.keys, allocator)
	return e
}

// leave event
// Notification that this seat's keyboard focus is no longer on
// a certain surface.
// The leave notification is sent before the enter notification
// for the new focus.
// In the wl_keyboard logical state, this event resets all values to their
// defaults. The compositor must not send this event if the active surface
// of the wl_keyboard was not equal to the surface argument immediately
// before this event.
KEYBOARD_LEAVE_OPCODE :: 2
Keyboard_Leave_Event :: struct {
	serial  : u32,  // serial number of the leave event
	surface : u32,  // surface that lost keyboard focus
}
keyboard_leave_decode :: proc(data: []byte) -> Keyboard_Leave_Event {
	e: Keyboard_Leave_Event
	r: int
	n := r
	e.serial, r = util.read_u32(data[n:]); n += r
	e.surface, r = util.read_u32(data[n:]); n += r
	return e
}

// key event
// A key was pressed or released.
// The time argument is a timestamp with millisecond
// granularity, with an undefined base.
// The key is a platform-specific key code that can be interpreted
// by feeding it to the keyboard mapping (see the keymap event).
// If this event produces a change in modifiers, then the resulting
// wl_keyboard.modifiers event must be sent after this event.
// In the wl_keyboard logical state, this event adds the key to the keys
// currently logically down (if the state argument is pressed) or removes
// the key from the keys currently logically down (if the state argument is
// released). The compositor must not send this event if the wl_keyboard
// did not have an active surface immediately before this event. The
// compositor must not send this event if state is pressed (resp. released)
// and the key was already logically down (resp. was not logically down)
// immediately before this event.
// Since version 10, compositors may send key events with the "repeated"
// key state when a wl_keyboard.repeat_info event with a rate argument of
// 0 has been received. This allows the compositor to take over the
// responsibility of key repetition.
KEYBOARD_KEY_OPCODE :: 3
Keyboard_Key_Event :: struct {
	serial : u32,  // serial number of the key event
	time   : u32,  // timestamp with millisecond granularity
	key    : u32,  // key that produced the event
	state  : u32,  // physical state of the key
}
keyboard_key_decode :: proc(data: []byte) -> Keyboard_Key_Event {
	e: Keyboard_Key_Event
	r: int
	n := r
	e.serial, r = util.read_u32(data[n:]); n += r
	e.time, r = util.read_u32(data[n:]); n += r
	e.key, r = util.read_u32(data[n:]); n += r
	e.state, r = util.read_u32(data[n:]); n += r
	return e
}

// modifier and group state
// Notifies clients that the modifier and/or group state has
// changed, and it should update its local state.
// The compositor may send this event without a surface of the client
// having keyboard focus, for example to tie modifier information to
// pointer focus instead. If a modifier event with pressed modifiers is sent
// without a prior enter event, the client can assume the modifier state is
// valid until it receives the next wl_keyboard.modifiers event. In order to
// reset the modifier state again, the compositor can send a
// wl_keyboard.modifiers event with no pressed modifiers.
// In the wl_keyboard logical state, this event updates the modifiers and
// group.
KEYBOARD_MODIFIERS_OPCODE :: 4
Keyboard_Modifiers_Event :: struct {
	serial         : u32,  // serial number of the modifiers event
	mods_depressed : u32,  // depressed modifiers
	mods_latched   : u32,  // latched modifiers
	mods_locked    : u32,  // locked modifiers
	group          : u32,  // keyboard layout
}
keyboard_modifiers_decode :: proc(data: []byte) -> Keyboard_Modifiers_Event {
	e: Keyboard_Modifiers_Event
	r: int
	n := r
	e.serial, r = util.read_u32(data[n:]); n += r
	e.mods_depressed, r = util.read_u32(data[n:]); n += r
	e.mods_latched, r = util.read_u32(data[n:]); n += r
	e.mods_locked, r = util.read_u32(data[n:]); n += r
	e.group, r = util.read_u32(data[n:]); n += r
	return e
}

// repeat rate and delay
// Informs the client about the keyboard's repeat rate and delay.
// This event is sent as soon as the wl_keyboard object has been created,
// and is guaranteed to be received by the client before any key press
// event.
// Negative values for either rate or delay are illegal. A rate of zero
// will disable any repeating (regardless of the value of delay).
// This event can be sent later on as well with a new value if necessary,
// so clients should continue listening for the event past the creation
// of wl_keyboard.
KEYBOARD_REPEAT_INFO_OPCODE :: 5
Keyboard_Repeat_Info_Event :: struct {
	rate  : i32,  // the rate of repeating keys in characters per second
	delay : i32,  // delay in milliseconds since key down until repeating starts
}
keyboard_repeat_info_decode :: proc(data: []byte) -> Keyboard_Repeat_Info_Event {
	e: Keyboard_Repeat_Info_Event
	r: int
	n := r
	e.rate, r = util.read_i32(data[n:]); n += r
	e.delay, r = util.read_i32(data[n:]); n += r
	return e
}

// keyboard mapping format
// This specifies the format of the keymap provided to the
// client with the wl_keyboard.keymap event.
Keyboard_Keymap_Format :: enum u32 {
	No_Keymap = 0,  // no keymap; client must understand how to interpret the raw keycode
	Xkb_V1 = 1,  // libxkbcommon compatible, null-terminated string; to determine the xkb keycode, clients must add 8 to the key event keycode
}

// physical key state
// Describes the physical state of a key that produced the key event.
// Since version 10, the key can be in a "repeated" pseudo-state which
// means the same as "pressed", but is used to signal repetition in the
// key event.
// The key may only enter the repeated state after entering the pressed
// state and before entering the released state. This event may be
// generated multiple times while the key is down.
Keyboard_Key_State :: enum u32 {
	Released = 0,  // key is not pressed
	Pressed = 1,  // key is pressed
	Repeated = 2,  // key was repeated
}

// touchscreen input device
// The wl_touch interface represents a touchscreen
// associated with a seat.
// Touch interactions can consist of one or more contacts.
// For each contact, a series of events is generated, starting
// with a down event, followed by zero or more motion events,
// and ending with an up event. Events relating to the same
// contact point can be identified by the ID of the sequence.
TOUCH_INTERFACE :: "wl_touch"
TOUCH_VERSION :: 11

// release the touch object
TOUCH_RELEASE_OPCODE :: 0
Touch_Release_Request :: struct {
	touch : u32,
}
touch_release_encode :: proc(req: Touch_Release_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.touch
	opcode := u16(TOUCH_RELEASE_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// touch down event and beginning of a touch sequence
// A new touch point has appeared on the surface. This touch point is
// assigned a unique ID. Future events from this touch point reference
// this ID. The ID ceases to be valid after a touch up event and may be
// reused in the future.
TOUCH_DOWN_OPCODE :: 0
Touch_Down_Event :: struct {
	serial  : u32,  // serial number of the touch down event
	time    : u32,  // timestamp with millisecond granularity
	surface : u32,  // surface touched
	id      : i32,  // the unique ID of this touch point
	x       : util.Fixed,  // surface-local x coordinate
	y       : util.Fixed,  // surface-local y coordinate
}
touch_down_decode :: proc(data: []byte) -> Touch_Down_Event {
	e: Touch_Down_Event
	r: int
	n := r
	e.serial, r = util.read_u32(data[n:]); n += r
	e.time, r = util.read_u32(data[n:]); n += r
	e.surface, r = util.read_u32(data[n:]); n += r
	e.id, r = util.read_i32(data[n:]); n += r
	e.x, r = util.read_fixed(data[n:]); n += r
	e.y, r = util.read_fixed(data[n:]); n += r
	return e
}

// end of a touch event sequence
// The touch point has disappeared. No further events will be sent for
// this touch point and the touch point's ID is released and may be
// reused in a future touch down event.
TOUCH_UP_OPCODE :: 1
Touch_Up_Event :: struct {
	serial : u32,  // serial number of the touch up event
	time   : u32,  // timestamp with millisecond granularity
	id     : i32,  // the unique ID of this touch point
}
touch_up_decode :: proc(data: []byte) -> Touch_Up_Event {
	e: Touch_Up_Event
	r: int
	n := r
	e.serial, r = util.read_u32(data[n:]); n += r
	e.time, r = util.read_u32(data[n:]); n += r
	e.id, r = util.read_i32(data[n:]); n += r
	return e
}

// update of touch point coordinates
// A touch point has changed coordinates.
TOUCH_MOTION_OPCODE :: 2
Touch_Motion_Event :: struct {
	time : u32,  // timestamp with millisecond granularity
	id   : i32,  // the unique ID of this touch point
	x    : util.Fixed,  // surface-local x coordinate
	y    : util.Fixed,  // surface-local y coordinate
}
touch_motion_decode :: proc(data: []byte) -> Touch_Motion_Event {
	e: Touch_Motion_Event
	r: int
	n := r
	e.time, r = util.read_u32(data[n:]); n += r
	e.id, r = util.read_i32(data[n:]); n += r
	e.x, r = util.read_fixed(data[n:]); n += r
	e.y, r = util.read_fixed(data[n:]); n += r
	return e
}

// end of touch frame event
// Indicates the end of a set of events that logically belong together.
// A client is expected to accumulate the data in all events within the
// frame before proceeding.
// A wl_touch.frame terminates at least one event but otherwise no
// guarantee is provided about the set of events within a frame. A client
// must assume that any state not updated in a frame is unchanged from the
// previously known state.
TOUCH_FRAME_OPCODE :: 3
Touch_Frame_Event :: struct {}
touch_frame_decode :: proc(data: []byte) -> Touch_Frame_Event {
	e: Touch_Frame_Event
	r: int
	n := r
	return e
}

// touch session cancelled
// Sent if the compositor decides the touch stream is a global
// gesture. No further events are sent to the clients from that
// particular gesture. Touch cancellation applies to all touch points
// currently active on this client's surface. The client is
// responsible for finalizing the touch points, future touch points on
// this surface may reuse the touch point ID.
// No frame event is required after the cancel event.
TOUCH_CANCEL_OPCODE :: 4
Touch_Cancel_Event :: struct {}
touch_cancel_decode :: proc(data: []byte) -> Touch_Cancel_Event {
	e: Touch_Cancel_Event
	r: int
	n := r
	return e
}

// update shape of touch point
// Sent when a touchpoint has changed its shape.
// This event does not occur on its own. It is sent before a
// wl_touch.frame event and carries the new shape information for
// any previously reported, or new touch points of that frame.
// Other events describing the touch point such as wl_touch.down,
// wl_touch.motion or wl_touch.orientation may be sent within the
// same wl_touch.frame. A client should treat these events as a single
// logical touch point update. The order of wl_touch.shape,
// wl_touch.orientation and wl_touch.motion is not guaranteed.
// A wl_touch.down event is guaranteed to occur before the first
// wl_touch.shape event for this touch ID but both events may occur within
// the same wl_touch.frame.
// A touchpoint shape is approximated by an ellipse through the major and
// minor axis length. The major axis length describes the longer diameter
// of the ellipse, while the minor axis length describes the shorter
// diameter. Major and minor are orthogonal and both are specified in
// surface-local coordinates. The center of the ellipse is always at the
// touchpoint location as reported by wl_touch.down or wl_touch.motion.
// This event is only sent by the compositor if the touch device supports
// shape reports. The client has to make reasonable assumptions about the
// shape if it did not receive this event.
TOUCH_SHAPE_OPCODE :: 5
Touch_Shape_Event :: struct {
	id    : i32,  // the unique ID of this touch point
	major : util.Fixed,  // length of the major axis in surface-local coordinates
	minor : util.Fixed,  // length of the minor axis in surface-local coordinates
}
touch_shape_decode :: proc(data: []byte) -> Touch_Shape_Event {
	e: Touch_Shape_Event
	r: int
	n := r
	e.id, r = util.read_i32(data[n:]); n += r
	e.major, r = util.read_fixed(data[n:]); n += r
	e.minor, r = util.read_fixed(data[n:]); n += r
	return e
}

// update orientation of touch point
// Sent when a touchpoint has changed its orientation.
// This event does not occur on its own. It is sent before a
// wl_touch.frame event and carries the new shape information for
// any previously reported, or new touch points of that frame.
// Other events describing the touch point such as wl_touch.down,
// wl_touch.motion or wl_touch.shape may be sent within the
// same wl_touch.frame. A client should treat these events as a single
// logical touch point update. The order of wl_touch.shape,
// wl_touch.orientation and wl_touch.motion is not guaranteed.
// A wl_touch.down event is guaranteed to occur before the first
// wl_touch.orientation event for this touch ID but both events may occur
// within the same wl_touch.frame.
// The orientation describes the clockwise angle of a touchpoint's major
// axis to the positive surface y-axis and is normalized to the -180 to
// +180 degree range. The granularity of orientation depends on the touch
// device, some devices only support binary rotation values between 0 and
// 90 degrees.
// This event is only sent by the compositor if the touch device supports
// orientation reports.
TOUCH_ORIENTATION_OPCODE :: 6
Touch_Orientation_Event :: struct {
	id          : i32,  // the unique ID of this touch point
	orientation : util.Fixed,  // angle between major axis and positive surface y-axis in degrees
}
touch_orientation_decode :: proc(data: []byte) -> Touch_Orientation_Event {
	e: Touch_Orientation_Event
	r: int
	n := r
	e.id, r = util.read_i32(data[n:]); n += r
	e.orientation, r = util.read_fixed(data[n:]); n += r
	return e
}

// compositor output region
// An output describes part of the compositor geometry.  The
// compositor works in the 'compositor coordinate system' and an
// output corresponds to a rectangular area in that space that is
// actually visible.  This typically corresponds to a monitor that
// displays part of the compositor space.  This object is published
// as global during start up, or when a monitor is hotplugged.
OUTPUT_INTERFACE :: "wl_output"
OUTPUT_VERSION :: 4

// release the output object
// Using this request a client can tell the server that it is not going to
// use the output object anymore.
OUTPUT_RELEASE_OPCODE :: 0
Output_Release_Request :: struct {
	output : u32,
}
output_release_encode :: proc(req: Output_Release_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.output
	opcode := u16(OUTPUT_RELEASE_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// properties of the output
// The geometry event describes geometric properties of the output.
// The event is sent when binding to the output object and whenever
// any of the properties change.
// The physical size can be set to zero if it doesn't make sense for this
// output (e.g. for projectors or virtual outputs).
// The geometry event will be followed by a done event (starting from
// version 2).
// Clients should use wl_surface.preferred_buffer_transform instead of the
// transform advertised by this event to find the preferred buffer
// transform to use for a surface.
// Note: wl_output only advertises partial information about the output
// position and identification. Some compositors, for instance those not
// implementing a desktop-style output layout or those exposing virtual
// outputs, might fake this information. Instead of using x and y, clients
// should use xdg_output.logical_position. Instead of using make and model,
// clients should use name and description.
OUTPUT_GEOMETRY_OPCODE :: 0
Output_Geometry_Event :: struct {
	x               : i32,  // x position within the global compositor space
	y               : i32,  // y position within the global compositor space
	physical_width  : i32,  // width in millimeters of the output
	physical_height : i32,  // height in millimeters of the output
	subpixel        : i32,  // subpixel orientation of the output
	make            : string,  // textual description of the manufacturer
	model           : string,  // textual description of the model
	transform       : i32,  // additional transformation applied to buffer contents during presentation
}
output_geometry_decode :: proc(data: []byte, allocator: mem.Allocator) -> Output_Geometry_Event {
	e: Output_Geometry_Event
	r: int
	n := r
	e.x, r = util.read_i32(data[n:]); n += r
	e.y, r = util.read_i32(data[n:]); n += r
	e.physical_width, r = util.read_i32(data[n:]); n += r
	e.physical_height, r = util.read_i32(data[n:]); n += r
	e.subpixel, r = util.read_i32(data[n:]); n += r
	e.make, r = util.read_string(data[n:]); n += r
	e.make = strings.clone(e.make, allocator)
	e.model, r = util.read_string(data[n:]); n += r
	e.model = strings.clone(e.model, allocator)
	e.transform, r = util.read_i32(data[n:]); n += r
	return e
}

// advertise available modes for the output
// The mode event describes an available mode for the output.
// The event is sent when binding to the output object and there
// will always be one mode, the current mode.  The event is sent
// again if an output changes mode, for the mode that is now
// current.  In other words, the current mode is always the last
// mode that was received with the current flag set.
// Non-current modes are deprecated. A compositor can decide to only
// advertise the current mode and never send other modes. Clients
// should not rely on non-current modes.
// The size of a mode is given in physical hardware units of
// the output device. This is not necessarily the same as
// the output size in the global compositor space. For instance,
// the output may be scaled, as described in wl_output.scale,
// or transformed, as described in wl_output.transform. Clients
// willing to retrieve the output size in the global compositor
// space should use xdg_output.logical_size instead.
// The vertical refresh rate can be set to zero if it doesn't make
// sense for this output (e.g. for virtual outputs).
// The mode event will be followed by a done event (starting from
// version 2).
// Clients should not use the refresh rate to schedule frames. Instead,
// they should use the wl_surface.frame event or the presentation-time
// protocol.
// Note: this information is not always meaningful for all outputs. Some
// compositors, such as those exposing virtual outputs, might fake the
// refresh rate or the size.
OUTPUT_MODE_OPCODE :: 1
Output_Mode_Event :: struct {
	flags   : u32,  // bitfield of mode flags
	width   : i32,  // width of the mode in hardware units
	height  : i32,  // height of the mode in hardware units
	refresh : i32,  // vertical refresh rate in mHz
}
output_mode_decode :: proc(data: []byte) -> Output_Mode_Event {
	e: Output_Mode_Event
	r: int
	n := r
	e.flags, r = util.read_u32(data[n:]); n += r
	e.width, r = util.read_i32(data[n:]); n += r
	e.height, r = util.read_i32(data[n:]); n += r
	e.refresh, r = util.read_i32(data[n:]); n += r
	return e
}

// sent all information about output
// This event is sent after all other properties have been
// sent after binding to the output object and after any
// other property changes done after that. This allows
// changes to the output properties to be seen as
// atomic, even if they happen via multiple events.
OUTPUT_DONE_OPCODE :: 2
Output_Done_Event :: struct {}
output_done_decode :: proc(data: []byte) -> Output_Done_Event {
	e: Output_Done_Event
	r: int
	n := r
	return e
}

// output scaling properties
// This event contains scaling geometry information
// that is not in the geometry event. It may be sent after
// binding the output object or if the output scale changes
// later. The compositor will emit a non-zero, positive
// value for scale. If it is not sent, the client should
// assume a scale of 1.
// A scale larger than 1 means that the compositor will
// automatically scale surface buffers by this amount
// when rendering. This is used for very high resolution
// displays where applications rendering at the native
// resolution would be too small to be legible.
// Clients should use wl_surface.preferred_buffer_scale
// instead of this event to find the preferred buffer
// scale to use for a surface.
// The scale event will be followed by a done event.
OUTPUT_SCALE_OPCODE :: 3
Output_Scale_Event :: struct {
	factor : i32,  // scaling factor of output
}
output_scale_decode :: proc(data: []byte) -> Output_Scale_Event {
	e: Output_Scale_Event
	r: int
	n := r
	e.factor, r = util.read_i32(data[n:]); n += r
	return e
}

// name of this output
// Many compositors will assign user-friendly names to their outputs, show
// them to the user, allow the user to refer to an output, etc. The client
// may wish to know this name as well to offer the user similar behaviors.
// The name is a UTF-8 string with no convention defined for its contents.
// Each name is unique among all wl_output globals. The name is only
// guaranteed to be unique for the compositor instance.
// The same output name is used for all clients for a given wl_output
// global. Thus, the name can be shared across processes to refer to a
// specific wl_output global.
// The name is not guaranteed to be persistent across sessions, thus cannot
// be used to reliably identify an output in e.g. configuration files.
// Examples of names include 'HDMI-A-1', 'WL-1', 'X11-1', etc. However, do
// not assume that the name is a reflection of an underlying DRM connector,
// X11 connection, etc.
// The name event is sent after binding the output object. This event is
// only sent once per output object, and the name does not change over the
// lifetime of the wl_output global.
// Compositors may re-use the same output name if the wl_output global is
// destroyed and re-created later. Compositors should avoid re-using the
// same name if possible.
// The name event will be followed by a done event.
OUTPUT_NAME_OPCODE :: 4
Output_Name_Event :: struct {
	name : string,  // output name
}
output_name_decode :: proc(data: []byte, allocator: mem.Allocator) -> Output_Name_Event {
	e: Output_Name_Event
	r: int
	n := r
	e.name, r = util.read_string(data[n:]); n += r
	e.name = strings.clone(e.name, allocator)
	return e
}

// human-readable description of this output
// Many compositors can produce human-readable descriptions of their
// outputs. The client may wish to know this description as well, e.g. for
// output selection purposes.
// The description is a UTF-8 string with no convention defined for its
// contents. The description is not guaranteed to be unique among all
// wl_output globals. Examples might include 'Foocorp 11" Display' or
// 'Virtual X11 output via :1'.
// The description event is sent after binding the output object and
// whenever the description changes. The description is optional, and may
// not be sent at all.
// The description event will be followed by a done event.
OUTPUT_DESCRIPTION_OPCODE :: 5
Output_Description_Event :: struct {
	description : string,  // output description
}
output_description_decode :: proc(data: []byte, allocator: mem.Allocator) -> Output_Description_Event {
	e: Output_Description_Event
	r: int
	n := r
	e.description, r = util.read_string(data[n:]); n += r
	e.description = strings.clone(e.description, allocator)
	return e
}

// subpixel geometry information
// This enumeration describes how the physical
// pixels on an output are laid out.
Output_Subpixel :: enum u32 {
	Unknown = 0,  // unknown geometry
	None = 1,  // no geometry
	Horizontal_Rgb = 2,  // horizontal RGB
	Horizontal_Bgr = 3,  // horizontal BGR
	Vertical_Rgb = 4,  // vertical RGB
	Vertical_Bgr = 5,  // vertical BGR
}

// transformation applied to buffer contents
// This describes transformations that clients and compositors apply to
// buffer contents.
// The flipped values correspond to an initial flip around a
// vertical axis followed by rotation.
// The purpose is mainly to allow clients to render accordingly and
// tell the compositor, so that for fullscreen surfaces, the
// compositor will still be able to scan out directly from client
// surfaces.
Output_Transform :: enum u32 {
	Normal = 0,  // no transform
	_90 = 1,  // 90 degrees counter-clockwise
	_180 = 2,  // 180 degrees counter-clockwise
	_270 = 3,  // 270 degrees counter-clockwise
	Flipped = 4,  // 180 degree flip around a vertical axis
	Flipped_90 = 5,  // flip and rotate 90 degrees counter-clockwise
	Flipped_180 = 6,  // flip and rotate 180 degrees counter-clockwise
	Flipped_270 = 7,  // flip and rotate 270 degrees counter-clockwise
}

// mode information
// These flags describe properties of an output mode.
// They are used in the flags bitfield of the mode event.
Output_Mode :: enum u32 {
	Current = 0x1,  // indicates this is the current mode
	Preferred = 0x2,  // indicates this is the preferred mode
}

// region interface
// A region object describes an area.
// Region objects are used to describe the opaque and input
// regions of a surface.
REGION_INTERFACE :: "wl_region"
REGION_VERSION :: 7

// destroy region
// Destroy the region.  This will invalidate the object ID.
REGION_DESTROY_OPCODE :: 0
Region_Destroy_Request :: struct {
	region : u32,
}
region_destroy_encode :: proc(req: Region_Destroy_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.region
	opcode := u16(REGION_DESTROY_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// add rectangle to region
// Add the specified rectangle to the region.
REGION_ADD_OPCODE :: 1
Region_Add_Request :: struct {
	region : u32,
	x      : i32,  // region-local x coordinate
	y      : i32,  // region-local y coordinate
	width  : i32,  // rectangle width
	height : i32,  // rectangle height
}
region_add_encode :: proc(req: Region_Add_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.region
	opcode := u16(REGION_ADD_OPCODE)
	size := u16(8 + size_of(req.x) + size_of(req.y) + size_of(req.width) + size_of(req.height))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.x)
	util.write(&msg, req.y)
	util.write(&msg, req.width)
	util.write(&msg, req.height)
	encoded = msg[:]
	return
}

// subtract rectangle from region
// Subtract the specified rectangle from the region.
REGION_SUBTRACT_OPCODE :: 2
Region_Subtract_Request :: struct {
	region : u32,
	x      : i32,  // region-local x coordinate
	y      : i32,  // region-local y coordinate
	width  : i32,  // rectangle width
	height : i32,  // rectangle height
}
region_subtract_encode :: proc(req: Region_Subtract_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.region
	opcode := u16(REGION_SUBTRACT_OPCODE)
	size := u16(8 + size_of(req.x) + size_of(req.y) + size_of(req.width) + size_of(req.height))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.x)
	util.write(&msg, req.y)
	util.write(&msg, req.width)
	util.write(&msg, req.height)
	encoded = msg[:]
	return
}

// sub-surface compositing
// The global interface exposing sub-surface compositing capabilities.
// A wl_surface, that has sub-surfaces associated, is called the
// parent surface. Sub-surfaces can be arbitrarily nested and create
// a tree of sub-surfaces.
// The root surface in a tree of sub-surfaces is the main
// surface. The main surface cannot be a sub-surface, because
// sub-surfaces must always have a parent.
// A main surface with its sub-surfaces forms a (compound) window.
// For window management purposes, this set of wl_surface objects is
// to be considered as a single window, and it should also behave as
// such.
// The aim of sub-surfaces is to offload some of the compositing work
// within a window from clients to the compositor. A prime example is
// a video player with decorations and video in separate wl_surface
// objects. This should allow the compositor to pass YUV video buffer
// processing to dedicated overlay hardware when possible.
SUBCOMPOSITOR_INTERFACE :: "wl_subcompositor"
SUBCOMPOSITOR_VERSION :: 1

// unbind from the subcompositor interface
// Informs the server that the client will not be using this
// protocol object anymore. This does not affect any other
// objects, wl_subsurface objects included.
SUBCOMPOSITOR_DESTROY_OPCODE :: 0
Subcompositor_Destroy_Request :: struct {
	subcompositor : u32,
}
subcompositor_destroy_encode :: proc(req: Subcompositor_Destroy_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.subcompositor
	opcode := u16(SUBCOMPOSITOR_DESTROY_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// give a surface the role sub-surface
// Create a sub-surface interface for the given surface, and
// associate it with the given parent surface. This turns a
// plain wl_surface into a sub-surface.
// The to-be sub-surface must not already have another role, and it
// must not have an existing wl_subsurface object. Otherwise the
// bad_surface protocol error is raised.
// Adding sub-surfaces to a parent is a double-buffered operation on the
// parent (see wl_surface.commit). The effect of adding a sub-surface
// becomes visible on the next time the state of the parent surface is
// applied.
// The parent surface must not be one of the child surface's descendants,
// and the parent must be different from the child surface, otherwise the
// bad_parent protocol error is raised.
// This request modifies the behaviour of wl_surface.commit request on
// the sub-surface, see the documentation on wl_subsurface interface.
SUBCOMPOSITOR_GET_SUBSURFACE_OPCODE :: 1
Subcompositor_Get_Subsurface_Request :: struct {
	subcompositor : u32,
	surface       : u32,  // the surface to be turned into a sub-surface
	parent        : u32,  // the parent surface
}
subcompositor_get_subsurface_encode :: proc(req: Subcompositor_Get_Subsurface_Request, new_id: u32, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.subcompositor
	opcode := u16(SUBCOMPOSITOR_GET_SUBSURFACE_OPCODE)
	size := u16(8 + size_of(new_id) + size_of(req.surface) + size_of(req.parent))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, new_id)
	util.write(&msg, req.surface)
	util.write(&msg, req.parent)
	encoded = msg[:]
	return
}

Subcompositor_Error :: enum u32 {
	Bad_Surface = 0,  // the to-be sub-surface is invalid
	Bad_Parent = 1,  // the to-be sub-surface parent is invalid
}

// sub-surface interface to a wl_surface
// An additional interface to a wl_surface object, which has been
// made a sub-surface. A sub-surface has one parent surface. A
// sub-surface's size and position are not limited to that of the parent.
// Particularly, a sub-surface is not automatically clipped to its
// parent's area.
// A sub-surface becomes mapped, when a non-NULL wl_buffer is applied
// and the parent surface is mapped. The order of which one happens
// first is irrelevant. A sub-surface is hidden if the parent becomes
// hidden, or if a NULL wl_buffer is applied. These rules apply
// recursively through the tree of surfaces.
// A sub-surface can be in one of two modes. The possible modes are
// synchronized and desynchronized, see methods wl_subsurface.set_sync and
// wl_subsurface.set_desync.
// The main surface can be thought to be always in desynchronized mode,
// since it does not have a parent in the sub-surfaces sense.
// Even if a sub-surface is in desynchronized mode, it will behave as
// in synchronized mode, if its parent surface behaves as in
// synchronized mode. This rule is applied recursively throughout the
// tree of surfaces. This means, that one can set a sub-surface into
// synchronized mode, and then assume that all its child and grand-child
// sub-surfaces are synchronized, too, without explicitly setting them.
// If a surface behaves as in synchronized mode, it is effectively
// synchronized, otherwise it is effectively desynchronized.
// A sub-surface is initially in the synchronized mode.
// The wl_subsurface interface has requests which modify double-buffered
// state of the parent surface (wl_subsurface.set_position, .place_above and
// .place_below).
// Destroying a sub-surface takes effect immediately. If you need to
// synchronize the removal of a sub-surface to the parent surface update,
// unmap the sub-surface first by attaching a NULL wl_buffer, update parent,
// and then destroy the sub-surface.
// If the parent wl_surface object is destroyed, the sub-surface is
// unmapped.
// A sub-surface never has the keyboard focus of any seat.
// The wl_surface.offset request is ignored: clients must use set_position
// instead to move the sub-surface.
SUBSURFACE_INTERFACE :: "wl_subsurface"
SUBSURFACE_VERSION :: 1

// remove sub-surface interface
// The sub-surface interface is removed from the wl_surface object
// that was turned into a sub-surface with a
// wl_subcompositor.get_subsurface request. The wl_surface's association
// to the parent is deleted. The wl_surface is unmapped immediately.
SUBSURFACE_DESTROY_OPCODE :: 0
Subsurface_Destroy_Request :: struct {
	subsurface : u32,
}
subsurface_destroy_encode :: proc(req: Subsurface_Destroy_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.subsurface
	opcode := u16(SUBSURFACE_DESTROY_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// reposition the sub-surface
// This sets the position of the sub-surface, relative to the parent
// surface.
// The sub-surface will be moved so that its origin (top left
// corner pixel) will be at the location x, y of the parent surface
// coordinate system. The coordinates are not restricted to the parent
// surface area. Negative values are allowed.
// The initial position is 0, 0.
// Position is double-buffered state on the parent surface, see
// wl_subsurface and wl_surface.commit for more information.
SUBSURFACE_SET_POSITION_OPCODE :: 1
Subsurface_Set_Position_Request :: struct {
	subsurface : u32,
	x          : i32,  // x coordinate in the parent surface
	y          : i32,  // y coordinate in the parent surface
}
subsurface_set_position_encode :: proc(req: Subsurface_Set_Position_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.subsurface
	opcode := u16(SUBSURFACE_SET_POSITION_OPCODE)
	size := u16(8 + size_of(req.x) + size_of(req.y))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.x)
	util.write(&msg, req.y)
	encoded = msg[:]
	return
}

// restack the sub-surface
// This sub-surface is taken from the stack, and put back just
// above the reference surface, changing the z-order of the sub-surfaces.
// The reference surface must be one of the sibling surfaces, or the
// parent surface. Using any other surface, including this sub-surface,
// will cause a protocol error.
// A new sub-surface is initially added as the top-most in the stack
// of its siblings and parent.
// Z-order is double-buffered state on the parent surface, see
// wl_subsurface and wl_surface.commit for more information.
SUBSURFACE_PLACE_ABOVE_OPCODE :: 2
Subsurface_Place_Above_Request :: struct {
	subsurface : u32,
	sibling    : u32,  // the reference surface
}
subsurface_place_above_encode :: proc(req: Subsurface_Place_Above_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.subsurface
	opcode := u16(SUBSURFACE_PLACE_ABOVE_OPCODE)
	size := u16(8 + size_of(req.sibling))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.sibling)
	encoded = msg[:]
	return
}

// restack the sub-surface
// The sub-surface is placed just below the reference surface.
// See wl_subsurface.place_above.
SUBSURFACE_PLACE_BELOW_OPCODE :: 3
Subsurface_Place_Below_Request :: struct {
	subsurface : u32,
	sibling    : u32,  // the reference surface
}
subsurface_place_below_encode :: proc(req: Subsurface_Place_Below_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.subsurface
	opcode := u16(SUBSURFACE_PLACE_BELOW_OPCODE)
	size := u16(8 + size_of(req.sibling))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.sibling)
	encoded = msg[:]
	return
}

// set sub-surface to synchronized mode
// Change the commit behaviour of the sub-surface to synchronized
// mode.
// See wl_subsurface and wl_surface.commit for more information.
SUBSURFACE_SET_SYNC_OPCODE :: 4
Subsurface_Set_Sync_Request :: struct {
	subsurface : u32,
}
subsurface_set_sync_encode :: proc(req: Subsurface_Set_Sync_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.subsurface
	opcode := u16(SUBSURFACE_SET_SYNC_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// set sub-surface to desynchronized mode
// Change the commit behaviour of the sub-surface to desynchronized
// mode.
// See wl_subsurface and wl_surface.commit for more information.
SUBSURFACE_SET_DESYNC_OPCODE :: 5
Subsurface_Set_Desync_Request :: struct {
	subsurface : u32,
}
subsurface_set_desync_encode :: proc(req: Subsurface_Set_Desync_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.subsurface
	opcode := u16(SUBSURFACE_SET_DESYNC_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

Subsurface_Error :: enum u32 {
	Bad_Surface = 0,  // wl_surface is not a sibling or the parent
}

// wayland protocol fixes
// This global fixes problems with other core-protocol interfaces that
// cannot be fixed in these interfaces themselves.
FIXES_INTERFACE :: "wl_fixes"
FIXES_VERSION :: 2

// destroys this object
FIXES_DESTROY_OPCODE :: 0
Fixes_Destroy_Request :: struct {
	fixes : u32,
}
fixes_destroy_encode :: proc(req: Fixes_Destroy_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.fixes
	opcode := u16(FIXES_DESTROY_OPCODE)
	size := u16(8)
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	encoded = msg[:]
	return
}

// destroy a wl_registry
// This request destroys a wl_registry object.
// The client should no longer use the wl_registry after making this
// request.
// The compositor will emit a wl_display.delete_id event with the object ID
// of the registry and will no longer emit any events on the registry. The
// client should re-use the object ID once it receives the
// wl_display.delete_id event.
FIXES_DESTROY_REGISTRY_OPCODE :: 1
Fixes_Destroy_Registry_Request :: struct {
	fixes    : u32,
	registry : u32,  // the registry to destroy
}
fixes_destroy_registry_encode :: proc(req: Fixes_Destroy_Registry_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.fixes
	opcode := u16(FIXES_DESTROY_REGISTRY_OPCODE)
	size := u16(8 + size_of(req.registry))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.registry)
	encoded = msg[:]
	return
}

// acknowledge global removal
// Acknowledge the removal of the specified global.
// If no global with the specified name exists or the global is not removed,
// the wl_fixes.invalid_ack_remove protocol error will be posted.
// Due to the Wayland protocol being asynchronous, the wl_global objects
// cannot be destroyed immediately. For example, if a wl_global is removed
// and a client attempts to bind that global around same time, it can
// result in a protocol error due to an unknown global name in the bind
// request.
// In order to avoid crashing clients, the compositor should remove the
// wl_global once it is guaranteed that no more bind requests will come.
// The wl_fixes.ack_global_remove() request is used to signal to the
// compositor that the client will not bind the given global anymore. After
// all clients acknowledge the removal of the global, the compositor can
// safely destroy it.
// The client must call the wl_fixes.ack_global_remove() request in
// response to a wl_registry.global_remove() event even if it did not bind
// the corresponding global.
FIXES_ACK_GLOBAL_REMOVE_OPCODE :: 2
Fixes_Ack_Global_Remove_Request :: struct {
	fixes    : u32,
	registry : u32,  // the registry object
	name     : u32,  // unique name of the global
}
fixes_ack_global_remove_encode :: proc(req: Fixes_Ack_Global_Remove_Request, allocator: mem.Allocator) -> (encoded: []byte, err: mem.Allocator_Error) {
	object := req.fixes
	opcode := u16(FIXES_ACK_GLOBAL_REMOVE_OPCODE)
	size := u16(8 + size_of(req.registry) + size_of(req.name))
	msg := make([dynamic]byte, 0, size, allocator) or_return
	util.write(&msg, object, opcode, size)
	util.write(&msg, req.registry)
	util.write(&msg, req.name)
	encoded = msg[:]
	return
}

// wl_fixes error values
// These errors can be emitted in response to wl_fixes requests.
Fixes_Error :: enum u32 {
	Invalid_Ack_Remove = 0,  // unknown global or the global is not removed
}
