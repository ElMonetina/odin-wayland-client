package wayland

import "../util"
import "core:sys/linux"
import "base:runtime"

DISPLAY_INTERFACE :: "wl_display"
DISPLAY_VERSION   :: 1

Display :: distinct u32

DISPLAY_SYNC_OPCODE :: 0
Display_Sync :: struct {
	display: Display,
	callback: Callback,
}
display_sync_write :: proc(buf: ^[dynamic]byte, req: Display_Sync, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.display)
	opcode := u16(DISPLAY_SYNC_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

DISPLAY_GET_REGISTRY_OPCODE :: 1
Display_Get_Registry :: struct {
	display: Display,
	registry: Registry,
}
display_get_registry_write :: proc(buf: ^[dynamic]byte, req: Display_Get_Registry, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.display)
	opcode := u16(DISPLAY_GET_REGISTRY_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

Display_Error :: struct {
	display: Display,
	object_id: u32,
	code: u32,
	message: string,
}
display_error_read :: proc(buf: []byte) -> (Display_Error, int) {
	e: Display_Error
	r: int
	n := r
	object_id: u32
	object_id, r = util.read_u32(buf[n:]); n += r
	e.object_id = (object_id)
	e.code, r = util.read_u32(buf[n:]); n += r
	e.message, r = util.read_string(buf[n:]); n += r
	return e, n
}

Display_Delete_Id :: struct {
	display: Display,
	id: u32,
}
display_delete_id_read :: proc(buf: []byte) -> (Display_Delete_Id, int) {
	e: Display_Delete_Id
	r: int
	n := r
	e.id, r = util.read_u32(buf[n:]); n += r
	return e, n
}

REGISTRY_INTERFACE :: "wl_registry"
REGISTRY_VERSION   :: 1

Registry :: distinct u32

REGISTRY_BIND_OPCODE :: 0
Registry_Bind :: struct {
	registry: Registry,
	name: u32,
	id: u32,
}
registry_bind_write :: proc(buf: ^[dynamic]byte, req: Registry_Bind, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.registry)
	opcode := u16(REGISTRY_BIND_OPCODE)
	size   := u16(8 + size_of(req.name) + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.name) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

Registry_Global :: struct {
	registry: Registry,
	name: u32,
	interface: string,
	version: u32,
}
registry_global_read :: proc(buf: []byte) -> (Registry_Global, int) {
	e: Registry_Global
	r: int
	n := r
	e.name, r = util.read_u32(buf[n:]); n += r
	e.interface, r = util.read_string(buf[n:]); n += r
	e.version, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Registry_Global_Remove :: struct {
	registry: Registry,
	name: u32,
}
registry_global_remove_read :: proc(buf: []byte) -> (Registry_Global_Remove, int) {
	e: Registry_Global_Remove
	r: int
	n := r
	e.name, r = util.read_u32(buf[n:]); n += r
	return e, n
}

CALLBACK_INTERFACE :: "wl_callback"
CALLBACK_VERSION   :: 1

Callback :: distinct u32

Callback_Done :: struct {
	callback: Callback,
	callback_data: u32,
}
callback_done_read :: proc(buf: []byte) -> (Callback_Done, int) {
	e: Callback_Done
	r: int
	n := r
	e.callback_data, r = util.read_u32(buf[n:]); n += r
	return e, n
}

COMPOSITOR_INTERFACE :: "wl_compositor"
COMPOSITOR_VERSION   :: 7

Compositor :: distinct u32

COMPOSITOR_CREATE_SURFACE_OPCODE :: 0
Compositor_Create_Surface :: struct {
	compositor: Compositor,
	id: Surface,
}
compositor_create_surface_write :: proc(buf: ^[dynamic]byte, req: Compositor_Create_Surface, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.compositor)
	opcode := u16(COMPOSITOR_CREATE_SURFACE_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

COMPOSITOR_CREATE_REGION_OPCODE :: 1
Compositor_Create_Region :: struct {
	compositor: Compositor,
	id: Region,
}
compositor_create_region_write :: proc(buf: ^[dynamic]byte, req: Compositor_Create_Region, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.compositor)
	opcode := u16(COMPOSITOR_CREATE_REGION_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

COMPOSITOR_RELEASE_OPCODE :: 2
Compositor_Release :: struct {
	compositor: Compositor,
}
compositor_release_write :: proc(buf: ^[dynamic]byte, req: Compositor_Release) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.compositor)
	opcode := u16(COMPOSITOR_RELEASE_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

SHM_POOL_INTERFACE :: "wl_shm_pool"
SHM_POOL_VERSION   :: 3

Shm_Pool :: distinct u32

SHM_POOL_CREATE_BUFFER_OPCODE :: 0
Shm_Pool_Create_Buffer :: struct {
	shm_pool: Shm_Pool,
	id: Buffer,
	offset: i32,
	width: i32,
	height: i32,
	stride: i32,
	format: u32,
}
shm_pool_create_buffer_write :: proc(buf: ^[dynamic]byte, req: Shm_Pool_Create_Buffer, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shm_pool)
	opcode := u16(SHM_POOL_CREATE_BUFFER_OPCODE)
	size   := u16(8 + size_of(req.offset) + size_of(req.width) + size_of(req.height) + size_of(req.stride) + size_of(req.format) + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.offset) or_return
	num_appended += util.write(buf, req.width) or_return
	num_appended += util.write(buf, req.height) or_return
	num_appended += util.write(buf, req.stride) or_return
	num_appended += util.write(buf, req.format) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

SHM_POOL_DESTROY_OPCODE :: 1
Shm_Pool_Destroy :: struct {
	shm_pool: Shm_Pool,
}
shm_pool_destroy_write :: proc(buf: ^[dynamic]byte, req: Shm_Pool_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shm_pool)
	opcode := u16(SHM_POOL_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

SHM_POOL_RESIZE_OPCODE :: 2
Shm_Pool_Resize :: struct {
	shm_pool: Shm_Pool,
	size: i32,
}
shm_pool_resize_write :: proc(buf: ^[dynamic]byte, req: Shm_Pool_Resize) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shm_pool)
	opcode := u16(SHM_POOL_RESIZE_OPCODE)
	size   := u16(8 + size_of(req.size))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.size) or_return
	return
}

SHM_INTERFACE :: "wl_shm"
SHM_VERSION   :: 3

Shm :: distinct u32

SHM_CREATE_POOL_OPCODE :: 0
Shm_Create_Pool :: struct {
	shm: Shm,
	id: Shm_Pool,
	fd: linux.Fd,
	size: i32,
}
shm_create_pool_write :: proc(buf: ^[dynamic]byte, req: Shm_Create_Pool, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shm)
	opcode := u16(SHM_CREATE_POOL_OPCODE)
	size   := u16(8 + size_of(req.fd) + size_of(req.size) + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

SHM_RELEASE_OPCODE :: 1
Shm_Release :: struct {
	shm: Shm,
}
shm_release_write :: proc(buf: ^[dynamic]byte, req: Shm_Release) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shm)
	opcode := u16(SHM_RELEASE_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

Shm_Format :: struct {
	shm: Shm,
	format: u32,
}
shm_format_read :: proc(buf: []byte) -> (Shm_Format, int) {
	e: Shm_Format
	r: int
	n := r
	e.format, r = util.read_u32(buf[n:]); n += r
	return e, n
}

BUFFER_INTERFACE :: "wl_buffer"
BUFFER_VERSION   :: 1

Buffer :: distinct u32

BUFFER_DESTROY_OPCODE :: 0
Buffer_Destroy :: struct {
	buffer: Buffer,
}
buffer_destroy_write :: proc(buf: ^[dynamic]byte, req: Buffer_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.buffer)
	opcode := u16(BUFFER_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

Buffer_Release :: struct {
	buffer: Buffer,
}
buffer_release_read :: proc(buf: []byte) -> (Buffer_Release, int) {
	e: Buffer_Release
	r: int
	n := r
	return e, n
}

DATA_OFFER_INTERFACE :: "wl_data_offer"
DATA_OFFER_VERSION   :: 4

Data_Offer :: distinct u32

DATA_OFFER_ACCEPT_OPCODE :: 0
Data_Offer_Accept :: struct {
	data_offer: Data_Offer,
	serial: u32,
	mime_type: string,
}
data_offer_accept_write :: proc(buf: ^[dynamic]byte, req: Data_Offer_Accept) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_offer)
	opcode := u16(DATA_OFFER_ACCEPT_OPCODE)
	size   := u16(8 + size_of(req.serial) + util.compute_string_size(req.mime_type))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	num_appended += util.write(buf, req.mime_type) or_return
	return
}

DATA_OFFER_RECEIVE_OPCODE :: 1
Data_Offer_Receive :: struct {
	data_offer: Data_Offer,
	mime_type: string,
	fd: linux.Fd,
}
data_offer_receive_write :: proc(buf: ^[dynamic]byte, req: Data_Offer_Receive) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_offer)
	opcode := u16(DATA_OFFER_RECEIVE_OPCODE)
	size   := u16(8 + util.compute_string_size(req.mime_type) + size_of(req.fd))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.mime_type) or_return
	return
}

DATA_OFFER_DESTROY_OPCODE :: 2
Data_Offer_Destroy :: struct {
	data_offer: Data_Offer,
}
data_offer_destroy_write :: proc(buf: ^[dynamic]byte, req: Data_Offer_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_offer)
	opcode := u16(DATA_OFFER_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

DATA_OFFER_FINISH_OPCODE :: 3
Data_Offer_Finish :: struct {
	data_offer: Data_Offer,
}
data_offer_finish_write :: proc(buf: ^[dynamic]byte, req: Data_Offer_Finish) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_offer)
	opcode := u16(DATA_OFFER_FINISH_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

DATA_OFFER_SET_ACTIONS_OPCODE :: 4
Data_Offer_Set_Actions :: struct {
	data_offer: Data_Offer,
	dnd_actions: u32,
	preferred_action: u32,
}
data_offer_set_actions_write :: proc(buf: ^[dynamic]byte, req: Data_Offer_Set_Actions) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_offer)
	opcode := u16(DATA_OFFER_SET_ACTIONS_OPCODE)
	size   := u16(8 + size_of(req.dnd_actions) + size_of(req.preferred_action))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.dnd_actions) or_return
	num_appended += util.write(buf, req.preferred_action) or_return
	return
}

Data_Offer_Offer :: struct {
	data_offer: Data_Offer,
	mime_type: string,
}
data_offer_offer_read :: proc(buf: []byte) -> (Data_Offer_Offer, int) {
	e: Data_Offer_Offer
	r: int
	n := r
	e.mime_type, r = util.read_string(buf[n:]); n += r
	return e, n
}

Data_Offer_Source_Actions :: struct {
	data_offer: Data_Offer,
	source_actions: u32,
}
data_offer_source_actions_read :: proc(buf: []byte) -> (Data_Offer_Source_Actions, int) {
	e: Data_Offer_Source_Actions
	r: int
	n := r
	e.source_actions, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Data_Offer_Action :: struct {
	data_offer: Data_Offer,
	dnd_action: u32,
}
data_offer_action_read :: proc(buf: []byte) -> (Data_Offer_Action, int) {
	e: Data_Offer_Action
	r: int
	n := r
	e.dnd_action, r = util.read_u32(buf[n:]); n += r
	return e, n
}

DATA_SOURCE_INTERFACE :: "wl_data_source"
DATA_SOURCE_VERSION   :: 4

Data_Source :: distinct u32

DATA_SOURCE_OFFER_OPCODE :: 0
Data_Source_Offer :: struct {
	data_source: Data_Source,
	mime_type: string,
}
data_source_offer_write :: proc(buf: ^[dynamic]byte, req: Data_Source_Offer) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_source)
	opcode := u16(DATA_SOURCE_OFFER_OPCODE)
	size   := u16(8 + util.compute_string_size(req.mime_type))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.mime_type) or_return
	return
}

DATA_SOURCE_DESTROY_OPCODE :: 1
Data_Source_Destroy :: struct {
	data_source: Data_Source,
}
data_source_destroy_write :: proc(buf: ^[dynamic]byte, req: Data_Source_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_source)
	opcode := u16(DATA_SOURCE_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

DATA_SOURCE_SET_ACTIONS_OPCODE :: 2
Data_Source_Set_Actions :: struct {
	data_source: Data_Source,
	dnd_actions: u32,
}
data_source_set_actions_write :: proc(buf: ^[dynamic]byte, req: Data_Source_Set_Actions) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_source)
	opcode := u16(DATA_SOURCE_SET_ACTIONS_OPCODE)
	size   := u16(8 + size_of(req.dnd_actions))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.dnd_actions) or_return
	return
}

Data_Source_Target :: struct {
	data_source: Data_Source,
	mime_type: string,
}
data_source_target_read :: proc(buf: []byte) -> (Data_Source_Target, int) {
	e: Data_Source_Target
	r: int
	n := r
	e.mime_type, r = util.read_string(buf[n:]); n += r
	return e, n
}

Data_Source_Send :: struct {
	data_source: Data_Source,
	mime_type: string,
	fd: linux.Fd,
}
data_source_send_read :: proc(buf: []byte) -> (Data_Source_Send, int) {
	e: Data_Source_Send
	r: int
	n := r
	e.mime_type, r = util.read_string(buf[n:]); n += r
	return e, n
}

Data_Source_Cancelled :: struct {
	data_source: Data_Source,
}
data_source_cancelled_read :: proc(buf: []byte) -> (Data_Source_Cancelled, int) {
	e: Data_Source_Cancelled
	r: int
	n := r
	return e, n
}

Data_Source_Dnd_Drop_Performed :: struct {
	data_source: Data_Source,
}
data_source_dnd_drop_performed_read :: proc(buf: []byte) -> (Data_Source_Dnd_Drop_Performed, int) {
	e: Data_Source_Dnd_Drop_Performed
	r: int
	n := r
	return e, n
}

Data_Source_Dnd_Finished :: struct {
	data_source: Data_Source,
}
data_source_dnd_finished_read :: proc(buf: []byte) -> (Data_Source_Dnd_Finished, int) {
	e: Data_Source_Dnd_Finished
	r: int
	n := r
	return e, n
}

Data_Source_Action :: struct {
	data_source: Data_Source,
	dnd_action: u32,
}
data_source_action_read :: proc(buf: []byte) -> (Data_Source_Action, int) {
	e: Data_Source_Action
	r: int
	n := r
	e.dnd_action, r = util.read_u32(buf[n:]); n += r
	return e, n
}

DATA_DEVICE_INTERFACE :: "wl_data_device"
DATA_DEVICE_VERSION   :: 4

Data_Device :: distinct u32

DATA_DEVICE_START_DRAG_OPCODE :: 0
Data_Device_Start_Drag :: struct {
	data_device: Data_Device,
	source: Data_Source,
	origin: Surface,
	icon: Surface,
	serial: u32,
}
data_device_start_drag_write :: proc(buf: ^[dynamic]byte, req: Data_Device_Start_Drag) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_device)
	opcode := u16(DATA_DEVICE_START_DRAG_OPCODE)
	size   := u16(8 + size_of(req.source) + size_of(req.origin) + size_of(req.icon) + size_of(req.serial))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, u32(req.source)) or_return
	num_appended += util.write(buf, u32(req.origin)) or_return
	num_appended += util.write(buf, u32(req.icon)) or_return
	num_appended += util.write(buf, req.serial) or_return
	return
}

DATA_DEVICE_SET_SELECTION_OPCODE :: 1
Data_Device_Set_Selection :: struct {
	data_device: Data_Device,
	source: Data_Source,
	serial: u32,
}
data_device_set_selection_write :: proc(buf: ^[dynamic]byte, req: Data_Device_Set_Selection) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_device)
	opcode := u16(DATA_DEVICE_SET_SELECTION_OPCODE)
	size   := u16(8 + size_of(req.source) + size_of(req.serial))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, u32(req.source)) or_return
	num_appended += util.write(buf, req.serial) or_return
	return
}

DATA_DEVICE_RELEASE_OPCODE :: 2
Data_Device_Release :: struct {
	data_device: Data_Device,
}
data_device_release_write :: proc(buf: ^[dynamic]byte, req: Data_Device_Release) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_device)
	opcode := u16(DATA_DEVICE_RELEASE_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

Data_Device_Data_Offer :: struct {
	data_device: Data_Device,
	id: Data_Offer,
}
data_device_data_offer_read :: proc(buf: []byte) -> (Data_Device_Data_Offer, int) {
	e: Data_Device_Data_Offer
	r: int
	n := r
	return e, n
}

Data_Device_Enter :: struct {
	data_device: Data_Device,
	serial: u32,
	surface: Surface,
	x: util.Fixed,
	y: util.Fixed,
	id: Data_Offer,
}
data_device_enter_read :: proc(buf: []byte) -> (Data_Device_Enter, int) {
	e: Data_Device_Enter
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	surface: u32
	surface, r = util.read_u32(buf[n:]); n += r
	e.surface = Surface(surface)
	e.x, r = util.read_fixed(buf[n:]); n += r
	e.y, r = util.read_fixed(buf[n:]); n += r
	id: u32
	id, r = util.read_u32(buf[n:]); n += r
	e.id = Data_Offer(id)
	return e, n
}

Data_Device_Leave :: struct {
	data_device: Data_Device,
}
data_device_leave_read :: proc(buf: []byte) -> (Data_Device_Leave, int) {
	e: Data_Device_Leave
	r: int
	n := r
	return e, n
}

Data_Device_Motion :: struct {
	data_device: Data_Device,
	time: u32,
	x: util.Fixed,
	y: util.Fixed,
}
data_device_motion_read :: proc(buf: []byte) -> (Data_Device_Motion, int) {
	e: Data_Device_Motion
	r: int
	n := r
	e.time, r = util.read_u32(buf[n:]); n += r
	e.x, r = util.read_fixed(buf[n:]); n += r
	e.y, r = util.read_fixed(buf[n:]); n += r
	return e, n
}

Data_Device_Drop :: struct {
	data_device: Data_Device,
}
data_device_drop_read :: proc(buf: []byte) -> (Data_Device_Drop, int) {
	e: Data_Device_Drop
	r: int
	n := r
	return e, n
}

Data_Device_Selection :: struct {
	data_device: Data_Device,
	id: Data_Offer,
}
data_device_selection_read :: proc(buf: []byte) -> (Data_Device_Selection, int) {
	e: Data_Device_Selection
	r: int
	n := r
	id: u32
	id, r = util.read_u32(buf[n:]); n += r
	e.id = Data_Offer(id)
	return e, n
}

DATA_DEVICE_MANAGER_INTERFACE :: "wl_data_device_manager"
DATA_DEVICE_MANAGER_VERSION   :: 4

Data_Device_Manager :: distinct u32

DATA_DEVICE_MANAGER_CREATE_DATA_SOURCE_OPCODE :: 0
Data_Device_Manager_Create_Data_Source :: struct {
	data_device_manager: Data_Device_Manager,
	id: Data_Source,
}
data_device_manager_create_data_source_write :: proc(buf: ^[dynamic]byte, req: Data_Device_Manager_Create_Data_Source, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_device_manager)
	opcode := u16(DATA_DEVICE_MANAGER_CREATE_DATA_SOURCE_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

DATA_DEVICE_MANAGER_GET_DATA_DEVICE_OPCODE :: 1
Data_Device_Manager_Get_Data_Device :: struct {
	data_device_manager: Data_Device_Manager,
	id: Data_Device,
	seat: Seat,
}
data_device_manager_get_data_device_write :: proc(buf: ^[dynamic]byte, req: Data_Device_Manager_Get_Data_Device, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_device_manager)
	opcode := u16(DATA_DEVICE_MANAGER_GET_DATA_DEVICE_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

DATA_DEVICE_MANAGER_RELEASE_OPCODE :: 2
Data_Device_Manager_Release :: struct {
	data_device_manager: Data_Device_Manager,
}
data_device_manager_release_write :: proc(buf: ^[dynamic]byte, req: Data_Device_Manager_Release) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.data_device_manager)
	opcode := u16(DATA_DEVICE_MANAGER_RELEASE_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

SHELL_INTERFACE :: "wl_shell"
SHELL_VERSION   :: 1

Shell :: distinct u32

SHELL_GET_SHELL_SURFACE_OPCODE :: 0
Shell_Get_Shell_Surface :: struct {
	shell: Shell,
	id: Shell_Surface,
	surface: Surface,
}
shell_get_shell_surface_write :: proc(buf: ^[dynamic]byte, req: Shell_Get_Shell_Surface, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shell)
	opcode := u16(SHELL_GET_SHELL_SURFACE_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

SHELL_SURFACE_INTERFACE :: "wl_shell_surface"
SHELL_SURFACE_VERSION   :: 1

Shell_Surface :: distinct u32

SHELL_SURFACE_PONG_OPCODE :: 0
Shell_Surface_Pong :: struct {
	shell_surface: Shell_Surface,
	serial: u32,
}
shell_surface_pong_write :: proc(buf: ^[dynamic]byte, req: Shell_Surface_Pong) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shell_surface)
	opcode := u16(SHELL_SURFACE_PONG_OPCODE)
	size   := u16(8 + size_of(req.serial))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	return
}

SHELL_SURFACE_MOVE_OPCODE :: 1
Shell_Surface_Move :: struct {
	shell_surface: Shell_Surface,
	seat: Seat,
	serial: u32,
}
shell_surface_move_write :: proc(buf: ^[dynamic]byte, req: Shell_Surface_Move) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shell_surface)
	opcode := u16(SHELL_SURFACE_MOVE_OPCODE)
	size   := u16(8 + size_of(req.serial))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	return
}

SHELL_SURFACE_RESIZE_OPCODE :: 2
Shell_Surface_Resize :: struct {
	shell_surface: Shell_Surface,
	seat: Seat,
	serial: u32,
	edges: u32,
}
shell_surface_resize_write :: proc(buf: ^[dynamic]byte, req: Shell_Surface_Resize) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shell_surface)
	opcode := u16(SHELL_SURFACE_RESIZE_OPCODE)
	size   := u16(8 + size_of(req.serial) + size_of(req.edges))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	num_appended += util.write(buf, req.edges) or_return
	return
}

SHELL_SURFACE_SET_TOPLEVEL_OPCODE :: 3
Shell_Surface_Set_Toplevel :: struct {
	shell_surface: Shell_Surface,
}
shell_surface_set_toplevel_write :: proc(buf: ^[dynamic]byte, req: Shell_Surface_Set_Toplevel) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shell_surface)
	opcode := u16(SHELL_SURFACE_SET_TOPLEVEL_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

SHELL_SURFACE_SET_TRANSIENT_OPCODE :: 4
Shell_Surface_Set_Transient :: struct {
	shell_surface: Shell_Surface,
	parent: Surface,
	x: i32,
	y: i32,
	flags: u32,
}
shell_surface_set_transient_write :: proc(buf: ^[dynamic]byte, req: Shell_Surface_Set_Transient) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shell_surface)
	opcode := u16(SHELL_SURFACE_SET_TRANSIENT_OPCODE)
	size   := u16(8 + size_of(req.parent) + size_of(req.x) + size_of(req.y) + size_of(req.flags))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, u32(req.parent)) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	num_appended += util.write(buf, req.flags) or_return
	return
}

SHELL_SURFACE_SET_FULLSCREEN_OPCODE :: 5
Shell_Surface_Set_Fullscreen :: struct {
	shell_surface: Shell_Surface,
	method: u32,
	framerate: u32,
	output: Output,
}
shell_surface_set_fullscreen_write :: proc(buf: ^[dynamic]byte, req: Shell_Surface_Set_Fullscreen) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shell_surface)
	opcode := u16(SHELL_SURFACE_SET_FULLSCREEN_OPCODE)
	size   := u16(8 + size_of(req.method) + size_of(req.framerate))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.method) or_return
	num_appended += util.write(buf, req.framerate) or_return
	return
}

SHELL_SURFACE_SET_POPUP_OPCODE :: 6
Shell_Surface_Set_Popup :: struct {
	shell_surface: Shell_Surface,
	seat: Seat,
	serial: u32,
	parent: Surface,
	x: i32,
	y: i32,
	flags: u32,
}
shell_surface_set_popup_write :: proc(buf: ^[dynamic]byte, req: Shell_Surface_Set_Popup) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shell_surface)
	opcode := u16(SHELL_SURFACE_SET_POPUP_OPCODE)
	size   := u16(8 + size_of(req.serial) + size_of(req.parent) + size_of(req.x) + size_of(req.y) + size_of(req.flags))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	num_appended += util.write(buf, u32(req.parent)) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	num_appended += util.write(buf, req.flags) or_return
	return
}

SHELL_SURFACE_SET_MAXIMIZED_OPCODE :: 7
Shell_Surface_Set_Maximized :: struct {
	shell_surface: Shell_Surface,
	output: Output,
}
shell_surface_set_maximized_write :: proc(buf: ^[dynamic]byte, req: Shell_Surface_Set_Maximized) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shell_surface)
	opcode := u16(SHELL_SURFACE_SET_MAXIMIZED_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

SHELL_SURFACE_SET_TITLE_OPCODE :: 8
Shell_Surface_Set_Title :: struct {
	shell_surface: Shell_Surface,
	title: string,
}
shell_surface_set_title_write :: proc(buf: ^[dynamic]byte, req: Shell_Surface_Set_Title) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shell_surface)
	opcode := u16(SHELL_SURFACE_SET_TITLE_OPCODE)
	size   := u16(8 + util.compute_string_size(req.title))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.title) or_return
	return
}

SHELL_SURFACE_SET_CLASS_OPCODE :: 9
Shell_Surface_Set_Class :: struct {
	shell_surface: Shell_Surface,
	class_: string,
}
shell_surface_set_class_write :: proc(buf: ^[dynamic]byte, req: Shell_Surface_Set_Class) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.shell_surface)
	opcode := u16(SHELL_SURFACE_SET_CLASS_OPCODE)
	size   := u16(8 + util.compute_string_size(req.class_))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.class_) or_return
	return
}

Shell_Surface_Ping :: struct {
	shell_surface: Shell_Surface,
	serial: u32,
}
shell_surface_ping_read :: proc(buf: []byte) -> (Shell_Surface_Ping, int) {
	e: Shell_Surface_Ping
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Shell_Surface_Configure :: struct {
	shell_surface: Shell_Surface,
	edges: u32,
	width: i32,
	height: i32,
}
shell_surface_configure_read :: proc(buf: []byte) -> (Shell_Surface_Configure, int) {
	e: Shell_Surface_Configure
	r: int
	n := r
	e.edges, r = util.read_u32(buf[n:]); n += r
	e.width, r = util.read_i32(buf[n:]); n += r
	e.height, r = util.read_i32(buf[n:]); n += r
	return e, n
}

Shell_Surface_Popup_Done :: struct {
	shell_surface: Shell_Surface,
}
shell_surface_popup_done_read :: proc(buf: []byte) -> (Shell_Surface_Popup_Done, int) {
	e: Shell_Surface_Popup_Done
	r: int
	n := r
	return e, n
}

SURFACE_INTERFACE :: "wl_surface"
SURFACE_VERSION   :: 7

Surface :: distinct u32

SURFACE_DESTROY_OPCODE :: 0
Surface_Destroy :: struct {
	surface: Surface,
}
surface_destroy_write :: proc(buf: ^[dynamic]byte, req: Surface_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

SURFACE_ATTACH_OPCODE :: 1
Surface_Attach :: struct {
	surface: Surface,
	buffer: Buffer,
	x: i32,
	y: i32,
}
surface_attach_write :: proc(buf: ^[dynamic]byte, req: Surface_Attach) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_ATTACH_OPCODE)
	size   := u16(8 + size_of(req.x) + size_of(req.y))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	return
}

SURFACE_DAMAGE_OPCODE :: 2
Surface_Damage :: struct {
	surface: Surface,
	x: i32,
	y: i32,
	width: i32,
	height: i32,
}
surface_damage_write :: proc(buf: ^[dynamic]byte, req: Surface_Damage) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_DAMAGE_OPCODE)
	size   := u16(8 + size_of(req.x) + size_of(req.y) + size_of(req.width) + size_of(req.height))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	num_appended += util.write(buf, req.width) or_return
	num_appended += util.write(buf, req.height) or_return
	return
}

SURFACE_FRAME_OPCODE :: 3
Surface_Frame :: struct {
	surface: Surface,
	callback: Callback,
}
surface_frame_write :: proc(buf: ^[dynamic]byte, req: Surface_Frame, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_FRAME_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

SURFACE_SET_OPAQUE_REGION_OPCODE :: 4
Surface_Set_Opaque_Region :: struct {
	surface: Surface,
	region: Region,
}
surface_set_opaque_region_write :: proc(buf: ^[dynamic]byte, req: Surface_Set_Opaque_Region) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_SET_OPAQUE_REGION_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

SURFACE_SET_INPUT_REGION_OPCODE :: 5
Surface_Set_Input_Region :: struct {
	surface: Surface,
	region: Region,
}
surface_set_input_region_write :: proc(buf: ^[dynamic]byte, req: Surface_Set_Input_Region) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_SET_INPUT_REGION_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

SURFACE_COMMIT_OPCODE :: 6
Surface_Commit :: struct {
	surface: Surface,
}
surface_commit_write :: proc(buf: ^[dynamic]byte, req: Surface_Commit) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_COMMIT_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

SURFACE_SET_BUFFER_TRANSFORM_OPCODE :: 7
Surface_Set_Buffer_Transform :: struct {
	surface: Surface,
	transform: i32,
}
surface_set_buffer_transform_write :: proc(buf: ^[dynamic]byte, req: Surface_Set_Buffer_Transform) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_SET_BUFFER_TRANSFORM_OPCODE)
	size   := u16(8 + size_of(req.transform))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.transform) or_return
	return
}

SURFACE_SET_BUFFER_SCALE_OPCODE :: 8
Surface_Set_Buffer_Scale :: struct {
	surface: Surface,
	scale: i32,
}
surface_set_buffer_scale_write :: proc(buf: ^[dynamic]byte, req: Surface_Set_Buffer_Scale) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_SET_BUFFER_SCALE_OPCODE)
	size   := u16(8 + size_of(req.scale))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.scale) or_return
	return
}

SURFACE_DAMAGE_BUFFER_OPCODE :: 9
Surface_Damage_Buffer :: struct {
	surface: Surface,
	x: i32,
	y: i32,
	width: i32,
	height: i32,
}
surface_damage_buffer_write :: proc(buf: ^[dynamic]byte, req: Surface_Damage_Buffer) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_DAMAGE_BUFFER_OPCODE)
	size   := u16(8 + size_of(req.x) + size_of(req.y) + size_of(req.width) + size_of(req.height))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	num_appended += util.write(buf, req.width) or_return
	num_appended += util.write(buf, req.height) or_return
	return
}

SURFACE_OFFSET_OPCODE :: 10
Surface_Offset :: struct {
	surface: Surface,
	x: i32,
	y: i32,
}
surface_offset_write :: proc(buf: ^[dynamic]byte, req: Surface_Offset) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_OFFSET_OPCODE)
	size   := u16(8 + size_of(req.x) + size_of(req.y))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	return
}

SURFACE_GET_RELEASE_OPCODE :: 11
Surface_Get_Release :: struct {
	surface: Surface,
	callback: Callback,
}
surface_get_release_write :: proc(buf: ^[dynamic]byte, req: Surface_Get_Release, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_GET_RELEASE_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

Surface_Enter :: struct {
	surface: Surface,
	output: Output,
}
surface_enter_read :: proc(buf: []byte) -> (Surface_Enter, int) {
	e: Surface_Enter
	r: int
	n := r
	output: u32
	output, r = util.read_u32(buf[n:]); n += r
	e.output = Output(output)
	return e, n
}

Surface_Leave :: struct {
	surface: Surface,
	output: Output,
}
surface_leave_read :: proc(buf: []byte) -> (Surface_Leave, int) {
	e: Surface_Leave
	r: int
	n := r
	output: u32
	output, r = util.read_u32(buf[n:]); n += r
	e.output = Output(output)
	return e, n
}

Surface_Preferred_Buffer_Scale :: struct {
	surface: Surface,
	factor: i32,
}
surface_preferred_buffer_scale_read :: proc(buf: []byte) -> (Surface_Preferred_Buffer_Scale, int) {
	e: Surface_Preferred_Buffer_Scale
	r: int
	n := r
	e.factor, r = util.read_i32(buf[n:]); n += r
	return e, n
}

Surface_Preferred_Buffer_Transform :: struct {
	surface: Surface,
	transform: u32,
}
surface_preferred_buffer_transform_read :: proc(buf: []byte) -> (Surface_Preferred_Buffer_Transform, int) {
	e: Surface_Preferred_Buffer_Transform
	r: int
	n := r
	e.transform, r = util.read_u32(buf[n:]); n += r
	return e, n
}

SEAT_INTERFACE :: "wl_seat"
SEAT_VERSION   :: 11

Seat :: distinct u32

SEAT_GET_POINTER_OPCODE :: 0
Seat_Get_Pointer :: struct {
	seat: Seat,
	id: Pointer,
}
seat_get_pointer_write :: proc(buf: ^[dynamic]byte, req: Seat_Get_Pointer, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.seat)
	opcode := u16(SEAT_GET_POINTER_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

SEAT_GET_KEYBOARD_OPCODE :: 1
Seat_Get_Keyboard :: struct {
	seat: Seat,
	id: Keyboard,
}
seat_get_keyboard_write :: proc(buf: ^[dynamic]byte, req: Seat_Get_Keyboard, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.seat)
	opcode := u16(SEAT_GET_KEYBOARD_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

SEAT_GET_TOUCH_OPCODE :: 2
Seat_Get_Touch :: struct {
	seat: Seat,
	id: Touch,
}
seat_get_touch_write :: proc(buf: ^[dynamic]byte, req: Seat_Get_Touch, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.seat)
	opcode := u16(SEAT_GET_TOUCH_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

SEAT_RELEASE_OPCODE :: 3
Seat_Release :: struct {
	seat: Seat,
}
seat_release_write :: proc(buf: ^[dynamic]byte, req: Seat_Release) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.seat)
	opcode := u16(SEAT_RELEASE_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

Seat_Capabilities :: struct {
	seat: Seat,
	capabilities: u32,
}
seat_capabilities_read :: proc(buf: []byte) -> (Seat_Capabilities, int) {
	e: Seat_Capabilities
	r: int
	n := r
	e.capabilities, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Seat_Name :: struct {
	seat: Seat,
	name: string,
}
seat_name_read :: proc(buf: []byte) -> (Seat_Name, int) {
	e: Seat_Name
	r: int
	n := r
	e.name, r = util.read_string(buf[n:]); n += r
	return e, n
}

POINTER_INTERFACE :: "wl_pointer"
POINTER_VERSION   :: 11

Pointer :: distinct u32

POINTER_SET_CURSOR_OPCODE :: 0
Pointer_Set_Cursor :: struct {
	pointer: Pointer,
	serial: u32,
	surface: Surface,
	hotspot_x: i32,
	hotspot_y: i32,
}
pointer_set_cursor_write :: proc(buf: ^[dynamic]byte, req: Pointer_Set_Cursor) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.pointer)
	opcode := u16(POINTER_SET_CURSOR_OPCODE)
	size   := u16(8 + size_of(req.serial) + size_of(req.hotspot_x) + size_of(req.hotspot_y))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	num_appended += util.write(buf, req.hotspot_x) or_return
	num_appended += util.write(buf, req.hotspot_y) or_return
	return
}

POINTER_RELEASE_OPCODE :: 1
Pointer_Release :: struct {
	pointer: Pointer,
}
pointer_release_write :: proc(buf: ^[dynamic]byte, req: Pointer_Release) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.pointer)
	opcode := u16(POINTER_RELEASE_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

Pointer_Enter :: struct {
	pointer: Pointer,
	serial: u32,
	surface: Surface,
	surface_x: util.Fixed,
	surface_y: util.Fixed,
}
pointer_enter_read :: proc(buf: []byte) -> (Pointer_Enter, int) {
	e: Pointer_Enter
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	surface: u32
	surface, r = util.read_u32(buf[n:]); n += r
	e.surface = Surface(surface)
	e.surface_x, r = util.read_fixed(buf[n:]); n += r
	e.surface_y, r = util.read_fixed(buf[n:]); n += r
	return e, n
}

Pointer_Leave :: struct {
	pointer: Pointer,
	serial: u32,
	surface: Surface,
}
pointer_leave_read :: proc(buf: []byte) -> (Pointer_Leave, int) {
	e: Pointer_Leave
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	surface: u32
	surface, r = util.read_u32(buf[n:]); n += r
	e.surface = Surface(surface)
	return e, n
}

Pointer_Motion :: struct {
	pointer: Pointer,
	time: u32,
	surface_x: util.Fixed,
	surface_y: util.Fixed,
}
pointer_motion_read :: proc(buf: []byte) -> (Pointer_Motion, int) {
	e: Pointer_Motion
	r: int
	n := r
	e.time, r = util.read_u32(buf[n:]); n += r
	e.surface_x, r = util.read_fixed(buf[n:]); n += r
	e.surface_y, r = util.read_fixed(buf[n:]); n += r
	return e, n
}

Pointer_Button :: struct {
	pointer: Pointer,
	serial: u32,
	time: u32,
	button: u32,
	state: u32,
}
pointer_button_read :: proc(buf: []byte) -> (Pointer_Button, int) {
	e: Pointer_Button
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	e.time, r = util.read_u32(buf[n:]); n += r
	e.button, r = util.read_u32(buf[n:]); n += r
	e.state, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Pointer_Axis :: struct {
	pointer: Pointer,
	time: u32,
	axis: u32,
	value: util.Fixed,
}
pointer_axis_read :: proc(buf: []byte) -> (Pointer_Axis, int) {
	e: Pointer_Axis
	r: int
	n := r
	e.time, r = util.read_u32(buf[n:]); n += r
	e.axis, r = util.read_u32(buf[n:]); n += r
	e.value, r = util.read_fixed(buf[n:]); n += r
	return e, n
}

Pointer_Frame :: struct {
	pointer: Pointer,
}
pointer_frame_read :: proc(buf: []byte) -> (Pointer_Frame, int) {
	e: Pointer_Frame
	r: int
	n := r
	return e, n
}

Pointer_Axis_Source :: struct {
	pointer: Pointer,
	axis_source: u32,
}
pointer_axis_source_read :: proc(buf: []byte) -> (Pointer_Axis_Source, int) {
	e: Pointer_Axis_Source
	r: int
	n := r
	e.axis_source, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Pointer_Axis_Stop :: struct {
	pointer: Pointer,
	time: u32,
	axis: u32,
}
pointer_axis_stop_read :: proc(buf: []byte) -> (Pointer_Axis_Stop, int) {
	e: Pointer_Axis_Stop
	r: int
	n := r
	e.time, r = util.read_u32(buf[n:]); n += r
	e.axis, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Pointer_Axis_Discrete :: struct {
	pointer: Pointer,
	axis: u32,
	discrete: i32,
}
pointer_axis_discrete_read :: proc(buf: []byte) -> (Pointer_Axis_Discrete, int) {
	e: Pointer_Axis_Discrete
	r: int
	n := r
	e.axis, r = util.read_u32(buf[n:]); n += r
	e.discrete, r = util.read_i32(buf[n:]); n += r
	return e, n
}

Pointer_Axis_Value120 :: struct {
	pointer: Pointer,
	axis: u32,
	value120: i32,
}
pointer_axis_value120_read :: proc(buf: []byte) -> (Pointer_Axis_Value120, int) {
	e: Pointer_Axis_Value120
	r: int
	n := r
	e.axis, r = util.read_u32(buf[n:]); n += r
	e.value120, r = util.read_i32(buf[n:]); n += r
	return e, n
}

Pointer_Axis_Relative_Direction :: struct {
	pointer: Pointer,
	axis: u32,
	direction: u32,
}
pointer_axis_relative_direction_read :: proc(buf: []byte) -> (Pointer_Axis_Relative_Direction, int) {
	e: Pointer_Axis_Relative_Direction
	r: int
	n := r
	e.axis, r = util.read_u32(buf[n:]); n += r
	e.direction, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Pointer_Warp :: struct {
	pointer: Pointer,
	surface_x: util.Fixed,
	surface_y: util.Fixed,
}
pointer_warp_read :: proc(buf: []byte) -> (Pointer_Warp, int) {
	e: Pointer_Warp
	r: int
	n := r
	e.surface_x, r = util.read_fixed(buf[n:]); n += r
	e.surface_y, r = util.read_fixed(buf[n:]); n += r
	return e, n
}

KEYBOARD_INTERFACE :: "wl_keyboard"
KEYBOARD_VERSION   :: 11

Keyboard :: distinct u32

KEYBOARD_RELEASE_OPCODE :: 0
Keyboard_Release :: struct {
	keyboard: Keyboard,
}
keyboard_release_write :: proc(buf: ^[dynamic]byte, req: Keyboard_Release) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.keyboard)
	opcode := u16(KEYBOARD_RELEASE_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

Keyboard_Keymap :: struct {
	keyboard: Keyboard,
	format: u32,
	fd: linux.Fd,
	size: u32,
}
keyboard_keymap_read :: proc(buf: []byte) -> (Keyboard_Keymap, int) {
	e: Keyboard_Keymap
	r: int
	n := r
	e.format, r = util.read_u32(buf[n:]); n += r
	e.size, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Keyboard_Enter :: struct {
	keyboard: Keyboard,
	serial: u32,
	surface: Surface,
	keys: []u8,
}
keyboard_enter_read :: proc(buf: []byte) -> (Keyboard_Enter, int) {
	e: Keyboard_Enter
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	surface: u32
	surface, r = util.read_u32(buf[n:]); n += r
	e.surface = Surface(surface)
	e.keys, r = util.read_array(buf[n:]); n += r
	return e, n
}

Keyboard_Leave :: struct {
	keyboard: Keyboard,
	serial: u32,
	surface: Surface,
}
keyboard_leave_read :: proc(buf: []byte) -> (Keyboard_Leave, int) {
	e: Keyboard_Leave
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	surface: u32
	surface, r = util.read_u32(buf[n:]); n += r
	e.surface = Surface(surface)
	return e, n
}

Keyboard_Key :: struct {
	keyboard: Keyboard,
	serial: u32,
	time: u32,
	key: u32,
	state: u32,
}
keyboard_key_read :: proc(buf: []byte) -> (Keyboard_Key, int) {
	e: Keyboard_Key
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	e.time, r = util.read_u32(buf[n:]); n += r
	e.key, r = util.read_u32(buf[n:]); n += r
	e.state, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Keyboard_Modifiers :: struct {
	keyboard: Keyboard,
	serial: u32,
	mods_depressed: u32,
	mods_latched: u32,
	mods_locked: u32,
	group: u32,
}
keyboard_modifiers_read :: proc(buf: []byte) -> (Keyboard_Modifiers, int) {
	e: Keyboard_Modifiers
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	e.mods_depressed, r = util.read_u32(buf[n:]); n += r
	e.mods_latched, r = util.read_u32(buf[n:]); n += r
	e.mods_locked, r = util.read_u32(buf[n:]); n += r
	e.group, r = util.read_u32(buf[n:]); n += r
	return e, n
}

Keyboard_Repeat_Info :: struct {
	keyboard: Keyboard,
	rate: i32,
	delay: i32,
}
keyboard_repeat_info_read :: proc(buf: []byte) -> (Keyboard_Repeat_Info, int) {
	e: Keyboard_Repeat_Info
	r: int
	n := r
	e.rate, r = util.read_i32(buf[n:]); n += r
	e.delay, r = util.read_i32(buf[n:]); n += r
	return e, n
}

TOUCH_INTERFACE :: "wl_touch"
TOUCH_VERSION   :: 11

Touch :: distinct u32

TOUCH_RELEASE_OPCODE :: 0
Touch_Release :: struct {
	touch: Touch,
}
touch_release_write :: proc(buf: ^[dynamic]byte, req: Touch_Release) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.touch)
	opcode := u16(TOUCH_RELEASE_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

Touch_Down :: struct {
	touch: Touch,
	serial: u32,
	time: u32,
	surface: Surface,
	id: i32,
	x: util.Fixed,
	y: util.Fixed,
}
touch_down_read :: proc(buf: []byte) -> (Touch_Down, int) {
	e: Touch_Down
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	e.time, r = util.read_u32(buf[n:]); n += r
	surface: u32
	surface, r = util.read_u32(buf[n:]); n += r
	e.surface = Surface(surface)
	e.id, r = util.read_i32(buf[n:]); n += r
	e.x, r = util.read_fixed(buf[n:]); n += r
	e.y, r = util.read_fixed(buf[n:]); n += r
	return e, n
}

Touch_Up :: struct {
	touch: Touch,
	serial: u32,
	time: u32,
	id: i32,
}
touch_up_read :: proc(buf: []byte) -> (Touch_Up, int) {
	e: Touch_Up
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	e.time, r = util.read_u32(buf[n:]); n += r
	e.id, r = util.read_i32(buf[n:]); n += r
	return e, n
}

Touch_Motion :: struct {
	touch: Touch,
	time: u32,
	id: i32,
	x: util.Fixed,
	y: util.Fixed,
}
touch_motion_read :: proc(buf: []byte) -> (Touch_Motion, int) {
	e: Touch_Motion
	r: int
	n := r
	e.time, r = util.read_u32(buf[n:]); n += r
	e.id, r = util.read_i32(buf[n:]); n += r
	e.x, r = util.read_fixed(buf[n:]); n += r
	e.y, r = util.read_fixed(buf[n:]); n += r
	return e, n
}

Touch_Frame :: struct {
	touch: Touch,
}
touch_frame_read :: proc(buf: []byte) -> (Touch_Frame, int) {
	e: Touch_Frame
	r: int
	n := r
	return e, n
}

Touch_Cancel :: struct {
	touch: Touch,
}
touch_cancel_read :: proc(buf: []byte) -> (Touch_Cancel, int) {
	e: Touch_Cancel
	r: int
	n := r
	return e, n
}

Touch_Shape :: struct {
	touch: Touch,
	id: i32,
	major: util.Fixed,
	minor: util.Fixed,
}
touch_shape_read :: proc(buf: []byte) -> (Touch_Shape, int) {
	e: Touch_Shape
	r: int
	n := r
	e.id, r = util.read_i32(buf[n:]); n += r
	e.major, r = util.read_fixed(buf[n:]); n += r
	e.minor, r = util.read_fixed(buf[n:]); n += r
	return e, n
}

Touch_Orientation :: struct {
	touch: Touch,
	id: i32,
	orientation: util.Fixed,
}
touch_orientation_read :: proc(buf: []byte) -> (Touch_Orientation, int) {
	e: Touch_Orientation
	r: int
	n := r
	e.id, r = util.read_i32(buf[n:]); n += r
	e.orientation, r = util.read_fixed(buf[n:]); n += r
	return e, n
}

OUTPUT_INTERFACE :: "wl_output"
OUTPUT_VERSION   :: 4

Output :: distinct u32

OUTPUT_RELEASE_OPCODE :: 0
Output_Release :: struct {
	output: Output,
}
output_release_write :: proc(buf: ^[dynamic]byte, req: Output_Release) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.output)
	opcode := u16(OUTPUT_RELEASE_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

Output_Geometry :: struct {
	output: Output,
	x: i32,
	y: i32,
	physical_width: i32,
	physical_height: i32,
	subpixel: i32,
	make: string,
	model: string,
	transform: i32,
}
output_geometry_read :: proc(buf: []byte) -> (Output_Geometry, int) {
	e: Output_Geometry
	r: int
	n := r
	e.x, r = util.read_i32(buf[n:]); n += r
	e.y, r = util.read_i32(buf[n:]); n += r
	e.physical_width, r = util.read_i32(buf[n:]); n += r
	e.physical_height, r = util.read_i32(buf[n:]); n += r
	e.subpixel, r = util.read_i32(buf[n:]); n += r
	e.make, r = util.read_string(buf[n:]); n += r
	e.model, r = util.read_string(buf[n:]); n += r
	e.transform, r = util.read_i32(buf[n:]); n += r
	return e, n
}

Output_Mode :: struct {
	output: Output,
	flags: u32,
	width: i32,
	height: i32,
	refresh: i32,
}
output_mode_read :: proc(buf: []byte) -> (Output_Mode, int) {
	e: Output_Mode
	r: int
	n := r
	e.flags, r = util.read_u32(buf[n:]); n += r
	e.width, r = util.read_i32(buf[n:]); n += r
	e.height, r = util.read_i32(buf[n:]); n += r
	e.refresh, r = util.read_i32(buf[n:]); n += r
	return e, n
}

Output_Done :: struct {
	output: Output,
}
output_done_read :: proc(buf: []byte) -> (Output_Done, int) {
	e: Output_Done
	r: int
	n := r
	return e, n
}

Output_Scale :: struct {
	output: Output,
	factor: i32,
}
output_scale_read :: proc(buf: []byte) -> (Output_Scale, int) {
	e: Output_Scale
	r: int
	n := r
	e.factor, r = util.read_i32(buf[n:]); n += r
	return e, n
}

Output_Name :: struct {
	output: Output,
	name: string,
}
output_name_read :: proc(buf: []byte) -> (Output_Name, int) {
	e: Output_Name
	r: int
	n := r
	e.name, r = util.read_string(buf[n:]); n += r
	return e, n
}

Output_Description :: struct {
	output: Output,
	description: string,
}
output_description_read :: proc(buf: []byte) -> (Output_Description, int) {
	e: Output_Description
	r: int
	n := r
	e.description, r = util.read_string(buf[n:]); n += r
	return e, n
}

REGION_INTERFACE :: "wl_region"
REGION_VERSION   :: 7

Region :: distinct u32

REGION_DESTROY_OPCODE :: 0
Region_Destroy :: struct {
	region: Region,
}
region_destroy_write :: proc(buf: ^[dynamic]byte, req: Region_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.region)
	opcode := u16(REGION_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

REGION_ADD_OPCODE :: 1
Region_Add :: struct {
	region: Region,
	x: i32,
	y: i32,
	width: i32,
	height: i32,
}
region_add_write :: proc(buf: ^[dynamic]byte, req: Region_Add) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.region)
	opcode := u16(REGION_ADD_OPCODE)
	size   := u16(8 + size_of(req.x) + size_of(req.y) + size_of(req.width) + size_of(req.height))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	num_appended += util.write(buf, req.width) or_return
	num_appended += util.write(buf, req.height) or_return
	return
}

REGION_SUBTRACT_OPCODE :: 2
Region_Subtract :: struct {
	region: Region,
	x: i32,
	y: i32,
	width: i32,
	height: i32,
}
region_subtract_write :: proc(buf: ^[dynamic]byte, req: Region_Subtract) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.region)
	opcode := u16(REGION_SUBTRACT_OPCODE)
	size   := u16(8 + size_of(req.x) + size_of(req.y) + size_of(req.width) + size_of(req.height))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	num_appended += util.write(buf, req.width) or_return
	num_appended += util.write(buf, req.height) or_return
	return
}

SUBCOMPOSITOR_INTERFACE :: "wl_subcompositor"
SUBCOMPOSITOR_VERSION   :: 1

Subcompositor :: distinct u32

SUBCOMPOSITOR_DESTROY_OPCODE :: 0
Subcompositor_Destroy :: struct {
	subcompositor: Subcompositor,
}
subcompositor_destroy_write :: proc(buf: ^[dynamic]byte, req: Subcompositor_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.subcompositor)
	opcode := u16(SUBCOMPOSITOR_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

SUBCOMPOSITOR_GET_SUBSURFACE_OPCODE :: 1
Subcompositor_Get_Subsurface :: struct {
	subcompositor: Subcompositor,
	id: Subsurface,
	surface: Surface,
	parent: Surface,
}
subcompositor_get_subsurface_write :: proc(buf: ^[dynamic]byte, req: Subcompositor_Get_Subsurface, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.subcompositor)
	opcode := u16(SUBCOMPOSITOR_GET_SUBSURFACE_OPCODE)
	size   := u16(8 + size_of(req.parent) + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, u32(req.parent)) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

SUBSURFACE_INTERFACE :: "wl_subsurface"
SUBSURFACE_VERSION   :: 1

Subsurface :: distinct u32

SUBSURFACE_DESTROY_OPCODE :: 0
Subsurface_Destroy :: struct {
	subsurface: Subsurface,
}
subsurface_destroy_write :: proc(buf: ^[dynamic]byte, req: Subsurface_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.subsurface)
	opcode := u16(SUBSURFACE_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

SUBSURFACE_SET_POSITION_OPCODE :: 1
Subsurface_Set_Position :: struct {
	subsurface: Subsurface,
	x: i32,
	y: i32,
}
subsurface_set_position_write :: proc(buf: ^[dynamic]byte, req: Subsurface_Set_Position) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.subsurface)
	opcode := u16(SUBSURFACE_SET_POSITION_OPCODE)
	size   := u16(8 + size_of(req.x) + size_of(req.y))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	return
}

SUBSURFACE_PLACE_ABOVE_OPCODE :: 2
Subsurface_Place_Above :: struct {
	subsurface: Subsurface,
	sibling: Surface,
}
subsurface_place_above_write :: proc(buf: ^[dynamic]byte, req: Subsurface_Place_Above) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.subsurface)
	opcode := u16(SUBSURFACE_PLACE_ABOVE_OPCODE)
	size   := u16(8 + size_of(req.sibling))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, u32(req.sibling)) or_return
	return
}

SUBSURFACE_PLACE_BELOW_OPCODE :: 3
Subsurface_Place_Below :: struct {
	subsurface: Subsurface,
	sibling: Surface,
}
subsurface_place_below_write :: proc(buf: ^[dynamic]byte, req: Subsurface_Place_Below) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.subsurface)
	opcode := u16(SUBSURFACE_PLACE_BELOW_OPCODE)
	size   := u16(8 + size_of(req.sibling))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, u32(req.sibling)) or_return
	return
}

SUBSURFACE_SET_SYNC_OPCODE :: 4
Subsurface_Set_Sync :: struct {
	subsurface: Subsurface,
}
subsurface_set_sync_write :: proc(buf: ^[dynamic]byte, req: Subsurface_Set_Sync) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.subsurface)
	opcode := u16(SUBSURFACE_SET_SYNC_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

SUBSURFACE_SET_DESYNC_OPCODE :: 5
Subsurface_Set_Desync :: struct {
	subsurface: Subsurface,
}
subsurface_set_desync_write :: proc(buf: ^[dynamic]byte, req: Subsurface_Set_Desync) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.subsurface)
	opcode := u16(SUBSURFACE_SET_DESYNC_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

FIXES_INTERFACE :: "wl_fixes"
FIXES_VERSION   :: 2

Fixes :: distinct u32

FIXES_DESTROY_OPCODE :: 0
Fixes_Destroy :: struct {
	fixes: Fixes,
}
fixes_destroy_write :: proc(buf: ^[dynamic]byte, req: Fixes_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.fixes)
	opcode := u16(FIXES_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

FIXES_DESTROY_REGISTRY_OPCODE :: 1
Fixes_Destroy_Registry :: struct {
	fixes: Fixes,
	registry: Registry,
}
fixes_destroy_registry_write :: proc(buf: ^[dynamic]byte, req: Fixes_Destroy_Registry) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.fixes)
	opcode := u16(FIXES_DESTROY_REGISTRY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

FIXES_ACK_GLOBAL_REMOVE_OPCODE :: 2
Fixes_Ack_Global_Remove :: struct {
	fixes: Fixes,
	registry: Registry,
	name: u32,
}
fixes_ack_global_remove_write :: proc(buf: ^[dynamic]byte, req: Fixes_Ack_Global_Remove) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.fixes)
	opcode := u16(FIXES_ACK_GLOBAL_REMOVE_OPCODE)
	size   := u16(8 + size_of(req.name))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.name) or_return
	return
}

