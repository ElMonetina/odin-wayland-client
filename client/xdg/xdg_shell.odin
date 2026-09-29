package xdg

import "../../util"
import wayland "../"
import "core:sys/linux"
import "base:runtime"

WM_BASE_INTERFACE :: "xdg_wm_base"
WM_BASE_VERSION   :: 7

Wm_Base :: distinct u32

WM_BASE_DESTROY_OPCODE :: 0
Wm_Base_Destroy :: struct {
	wm_base: Wm_Base,
}
wm_base_destroy_write :: proc(buf: ^[dynamic]byte, req: Wm_Base_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.wm_base)
	opcode := u16(WM_BASE_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

WM_BASE_CREATE_POSITIONER_OPCODE :: 1
Wm_Base_Create_Positioner :: struct {
	wm_base: Wm_Base,
	id: Positioner,
}
wm_base_create_positioner_write :: proc(buf: ^[dynamic]byte, req: Wm_Base_Create_Positioner, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.wm_base)
	opcode := u16(WM_BASE_CREATE_POSITIONER_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

WM_BASE_GET_XDG_SURFACE_OPCODE :: 2
Wm_Base_Get_Xdg_Surface :: struct {
	wm_base: Wm_Base,
	id: Surface,
	surface: wayland.Surface,
}
wm_base_get_xdg_surface_write :: proc(buf: ^[dynamic]byte, req: Wm_Base_Get_Xdg_Surface, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.wm_base)
	opcode := u16(WM_BASE_GET_XDG_SURFACE_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

WM_BASE_PONG_OPCODE :: 3
Wm_Base_Pong :: struct {
	wm_base: Wm_Base,
	serial: u32,
}
wm_base_pong_write :: proc(buf: ^[dynamic]byte, req: Wm_Base_Pong) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.wm_base)
	opcode := u16(WM_BASE_PONG_OPCODE)
	size   := u16(8 + size_of(req.serial))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	return
}

Wm_Base_Ping :: struct {
	wm_base: Wm_Base,
	serial: u32,
}
wm_base_ping_read :: proc(buf: []byte) -> (Wm_Base_Ping, int) {
	e: Wm_Base_Ping
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	return e, n
}

POSITIONER_INTERFACE :: "xdg_positioner"
POSITIONER_VERSION   :: 7

Positioner :: distinct u32

POSITIONER_DESTROY_OPCODE :: 0
Positioner_Destroy :: struct {
	positioner: Positioner,
}
positioner_destroy_write :: proc(buf: ^[dynamic]byte, req: Positioner_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.positioner)
	opcode := u16(POSITIONER_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

POSITIONER_SET_SIZE_OPCODE :: 1
Positioner_Set_Size :: struct {
	positioner: Positioner,
	width: i32,
	height: i32,
}
positioner_set_size_write :: proc(buf: ^[dynamic]byte, req: Positioner_Set_Size) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.positioner)
	opcode := u16(POSITIONER_SET_SIZE_OPCODE)
	size   := u16(8 + size_of(req.width) + size_of(req.height))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.width) or_return
	num_appended += util.write(buf, req.height) or_return
	return
}

POSITIONER_SET_ANCHOR_RECT_OPCODE :: 2
Positioner_Set_Anchor_Rect :: struct {
	positioner: Positioner,
	x: i32,
	y: i32,
	width: i32,
	height: i32,
}
positioner_set_anchor_rect_write :: proc(buf: ^[dynamic]byte, req: Positioner_Set_Anchor_Rect) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.positioner)
	opcode := u16(POSITIONER_SET_ANCHOR_RECT_OPCODE)
	size   := u16(8 + size_of(req.x) + size_of(req.y) + size_of(req.width) + size_of(req.height))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	num_appended += util.write(buf, req.width) or_return
	num_appended += util.write(buf, req.height) or_return
	return
}

POSITIONER_SET_ANCHOR_OPCODE :: 3
Positioner_Set_Anchor :: struct {
	positioner: Positioner,
	anchor: u32,
}
positioner_set_anchor_write :: proc(buf: ^[dynamic]byte, req: Positioner_Set_Anchor) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.positioner)
	opcode := u16(POSITIONER_SET_ANCHOR_OPCODE)
	size   := u16(8 + size_of(req.anchor))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.anchor) or_return
	return
}

POSITIONER_SET_GRAVITY_OPCODE :: 4
Positioner_Set_Gravity :: struct {
	positioner: Positioner,
	gravity: u32,
}
positioner_set_gravity_write :: proc(buf: ^[dynamic]byte, req: Positioner_Set_Gravity) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.positioner)
	opcode := u16(POSITIONER_SET_GRAVITY_OPCODE)
	size   := u16(8 + size_of(req.gravity))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.gravity) or_return
	return
}

POSITIONER_SET_CONSTRAINT_ADJUSTMENT_OPCODE :: 5
Positioner_Set_Constraint_Adjustment :: struct {
	positioner: Positioner,
	constraint_adjustment: u32,
}
positioner_set_constraint_adjustment_write :: proc(buf: ^[dynamic]byte, req: Positioner_Set_Constraint_Adjustment) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.positioner)
	opcode := u16(POSITIONER_SET_CONSTRAINT_ADJUSTMENT_OPCODE)
	size   := u16(8 + size_of(req.constraint_adjustment))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.constraint_adjustment) or_return
	return
}

POSITIONER_SET_OFFSET_OPCODE :: 6
Positioner_Set_Offset :: struct {
	positioner: Positioner,
	x: i32,
	y: i32,
}
positioner_set_offset_write :: proc(buf: ^[dynamic]byte, req: Positioner_Set_Offset) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.positioner)
	opcode := u16(POSITIONER_SET_OFFSET_OPCODE)
	size   := u16(8 + size_of(req.x) + size_of(req.y))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	return
}

POSITIONER_SET_REACTIVE_OPCODE :: 7
Positioner_Set_Reactive :: struct {
	positioner: Positioner,
}
positioner_set_reactive_write :: proc(buf: ^[dynamic]byte, req: Positioner_Set_Reactive) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.positioner)
	opcode := u16(POSITIONER_SET_REACTIVE_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

POSITIONER_SET_PARENT_SIZE_OPCODE :: 8
Positioner_Set_Parent_Size :: struct {
	positioner: Positioner,
	parent_width: i32,
	parent_height: i32,
}
positioner_set_parent_size_write :: proc(buf: ^[dynamic]byte, req: Positioner_Set_Parent_Size) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.positioner)
	opcode := u16(POSITIONER_SET_PARENT_SIZE_OPCODE)
	size   := u16(8 + size_of(req.parent_width) + size_of(req.parent_height))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.parent_width) or_return
	num_appended += util.write(buf, req.parent_height) or_return
	return
}

POSITIONER_SET_PARENT_CONFIGURE_OPCODE :: 9
Positioner_Set_Parent_Configure :: struct {
	positioner: Positioner,
	serial: u32,
}
positioner_set_parent_configure_write :: proc(buf: ^[dynamic]byte, req: Positioner_Set_Parent_Configure) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.positioner)
	opcode := u16(POSITIONER_SET_PARENT_CONFIGURE_OPCODE)
	size   := u16(8 + size_of(req.serial))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	return
}

SURFACE_INTERFACE :: "xdg_surface"
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

SURFACE_GET_TOPLEVEL_OPCODE :: 1
Surface_Get_Toplevel :: struct {
	surface: Surface,
	id: Toplevel,
}
surface_get_toplevel_write :: proc(buf: ^[dynamic]byte, req: Surface_Get_Toplevel, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_GET_TOPLEVEL_OPCODE)
	size   := u16(8 + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

SURFACE_GET_POPUP_OPCODE :: 2
Surface_Get_Popup :: struct {
	surface: Surface,
	id: Popup,
	parent: Surface,
	positioner: Positioner,
}
surface_get_popup_write :: proc(buf: ^[dynamic]byte, req: Surface_Get_Popup, new_id: u32) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_GET_POPUP_OPCODE)
	size   := u16(8 + size_of(req.parent) + size_of(new_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, u32(req.parent)) or_return
	num_appended += util.write(buf, new_id) or_return
	return
}

SURFACE_SET_WINDOW_GEOMETRY_OPCODE :: 3
Surface_Set_Window_Geometry :: struct {
	surface: Surface,
	x: i32,
	y: i32,
	width: i32,
	height: i32,
}
surface_set_window_geometry_write :: proc(buf: ^[dynamic]byte, req: Surface_Set_Window_Geometry) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_SET_WINDOW_GEOMETRY_OPCODE)
	size   := u16(8 + size_of(req.x) + size_of(req.y) + size_of(req.width) + size_of(req.height))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	num_appended += util.write(buf, req.width) or_return
	num_appended += util.write(buf, req.height) or_return
	return
}

SURFACE_ACK_CONFIGURE_OPCODE :: 4
Surface_Ack_Configure :: struct {
	surface: Surface,
	serial: u32,
}
surface_ack_configure_write :: proc(buf: ^[dynamic]byte, req: Surface_Ack_Configure) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.surface)
	opcode := u16(SURFACE_ACK_CONFIGURE_OPCODE)
	size   := u16(8 + size_of(req.serial))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	return
}

Surface_Configure :: struct {
	surface: Surface,
	serial: u32,
}
surface_configure_read :: proc(buf: []byte) -> (Surface_Configure, int) {
	e: Surface_Configure
	r: int
	n := r
	e.serial, r = util.read_u32(buf[n:]); n += r
	return e, n
}

TOPLEVEL_INTERFACE :: "xdg_toplevel"
TOPLEVEL_VERSION   :: 7

Toplevel :: distinct u32

TOPLEVEL_DESTROY_OPCODE :: 0
Toplevel_Destroy :: struct {
	toplevel: Toplevel,
}
toplevel_destroy_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

TOPLEVEL_SET_PARENT_OPCODE :: 1
Toplevel_Set_Parent :: struct {
	toplevel: Toplevel,
	parent: Toplevel,
}
toplevel_set_parent_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Set_Parent) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_SET_PARENT_OPCODE)
	size   := u16(8 + size_of(req.parent))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, u32(req.parent)) or_return
	return
}

TOPLEVEL_SET_TITLE_OPCODE :: 2
Toplevel_Set_Title :: struct {
	toplevel: Toplevel,
	title: string,
}
toplevel_set_title_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Set_Title) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_SET_TITLE_OPCODE)
	size   := u16(8 + util.compute_string_size(req.title))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.title) or_return
	return
}

TOPLEVEL_SET_APP_ID_OPCODE :: 3
Toplevel_Set_App_Id :: struct {
	toplevel: Toplevel,
	app_id: string,
}
toplevel_set_app_id_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Set_App_Id) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_SET_APP_ID_OPCODE)
	size   := u16(8 + util.compute_string_size(req.app_id))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.app_id) or_return
	return
}

TOPLEVEL_SHOW_WINDOW_MENU_OPCODE :: 4
Toplevel_Show_Window_Menu :: struct {
	toplevel: Toplevel,
	seat: wayland.Seat,
	serial: u32,
	x: i32,
	y: i32,
}
toplevel_show_window_menu_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Show_Window_Menu) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_SHOW_WINDOW_MENU_OPCODE)
	size   := u16(8 + size_of(req.serial) + size_of(req.x) + size_of(req.y))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	num_appended += util.write(buf, req.x) or_return
	num_appended += util.write(buf, req.y) or_return
	return
}

TOPLEVEL_MOVE_OPCODE :: 5
Toplevel_Move :: struct {
	toplevel: Toplevel,
	seat: wayland.Seat,
	serial: u32,
}
toplevel_move_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Move) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_MOVE_OPCODE)
	size   := u16(8 + size_of(req.serial))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	return
}

TOPLEVEL_RESIZE_OPCODE :: 6
Toplevel_Resize :: struct {
	toplevel: Toplevel,
	seat: wayland.Seat,
	serial: u32,
	edges: u32,
}
toplevel_resize_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Resize) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_RESIZE_OPCODE)
	size   := u16(8 + size_of(req.serial) + size_of(req.edges))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	num_appended += util.write(buf, req.edges) or_return
	return
}

TOPLEVEL_SET_MAX_SIZE_OPCODE :: 7
Toplevel_Set_Max_Size :: struct {
	toplevel: Toplevel,
	width: i32,
	height: i32,
}
toplevel_set_max_size_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Set_Max_Size) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_SET_MAX_SIZE_OPCODE)
	size   := u16(8 + size_of(req.width) + size_of(req.height))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.width) or_return
	num_appended += util.write(buf, req.height) or_return
	return
}

TOPLEVEL_SET_MIN_SIZE_OPCODE :: 8
Toplevel_Set_Min_Size :: struct {
	toplevel: Toplevel,
	width: i32,
	height: i32,
}
toplevel_set_min_size_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Set_Min_Size) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_SET_MIN_SIZE_OPCODE)
	size   := u16(8 + size_of(req.width) + size_of(req.height))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.width) or_return
	num_appended += util.write(buf, req.height) or_return
	return
}

TOPLEVEL_SET_MAXIMIZED_OPCODE :: 9
Toplevel_Set_Maximized :: struct {
	toplevel: Toplevel,
}
toplevel_set_maximized_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Set_Maximized) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_SET_MAXIMIZED_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

TOPLEVEL_UNSET_MAXIMIZED_OPCODE :: 10
Toplevel_Unset_Maximized :: struct {
	toplevel: Toplevel,
}
toplevel_unset_maximized_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Unset_Maximized) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_UNSET_MAXIMIZED_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

TOPLEVEL_SET_FULLSCREEN_OPCODE :: 11
Toplevel_Set_Fullscreen :: struct {
	toplevel: Toplevel,
	output: wayland.Output,
}
toplevel_set_fullscreen_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Set_Fullscreen) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_SET_FULLSCREEN_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

TOPLEVEL_UNSET_FULLSCREEN_OPCODE :: 12
Toplevel_Unset_Fullscreen :: struct {
	toplevel: Toplevel,
}
toplevel_unset_fullscreen_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Unset_Fullscreen) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_UNSET_FULLSCREEN_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

TOPLEVEL_SET_MINIMIZED_OPCODE :: 13
Toplevel_Set_Minimized :: struct {
	toplevel: Toplevel,
}
toplevel_set_minimized_write :: proc(buf: ^[dynamic]byte, req: Toplevel_Set_Minimized) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.toplevel)
	opcode := u16(TOPLEVEL_SET_MINIMIZED_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

Toplevel_Configure :: struct {
	toplevel: Toplevel,
	width: i32,
	height: i32,
	states: []u8,
}
toplevel_configure_read :: proc(buf: []byte) -> (Toplevel_Configure, int) {
	e: Toplevel_Configure
	r: int
	n := r
	e.width, r = util.read_i32(buf[n:]); n += r
	e.height, r = util.read_i32(buf[n:]); n += r
	e.states, r = util.read_array(buf[n:]); n += r
	return e, n
}

Toplevel_Close :: struct {
	toplevel: Toplevel,
}
toplevel_close_read :: proc(buf: []byte) -> (Toplevel_Close, int) {
	e: Toplevel_Close
	r: int
	n := r
	return e, n
}

Toplevel_Configure_Bounds :: struct {
	toplevel: Toplevel,
	width: i32,
	height: i32,
}
toplevel_configure_bounds_read :: proc(buf: []byte) -> (Toplevel_Configure_Bounds, int) {
	e: Toplevel_Configure_Bounds
	r: int
	n := r
	e.width, r = util.read_i32(buf[n:]); n += r
	e.height, r = util.read_i32(buf[n:]); n += r
	return e, n
}

Toplevel_Wm_Capabilities :: struct {
	toplevel: Toplevel,
	capabilities: []u8,
}
toplevel_wm_capabilities_read :: proc(buf: []byte) -> (Toplevel_Wm_Capabilities, int) {
	e: Toplevel_Wm_Capabilities
	r: int
	n := r
	e.capabilities, r = util.read_array(buf[n:]); n += r
	return e, n
}

POPUP_INTERFACE :: "xdg_popup"
POPUP_VERSION   :: 7

Popup :: distinct u32

POPUP_DESTROY_OPCODE :: 0
Popup_Destroy :: struct {
	popup: Popup,
}
popup_destroy_write :: proc(buf: ^[dynamic]byte, req: Popup_Destroy) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.popup)
	opcode := u16(POPUP_DESTROY_OPCODE)
	size   := u16(8)
	num_appended += util.write(buf, object, opcode, size) or_return
	return
}

POPUP_GRAB_OPCODE :: 1
Popup_Grab :: struct {
	popup: Popup,
	seat: wayland.Seat,
	serial: u32,
}
popup_grab_write :: proc(buf: ^[dynamic]byte, req: Popup_Grab) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.popup)
	opcode := u16(POPUP_GRAB_OPCODE)
	size   := u16(8 + size_of(req.serial))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.serial) or_return
	return
}

POPUP_REPOSITION_OPCODE :: 2
Popup_Reposition :: struct {
	popup: Popup,
	positioner: Positioner,
	token: u32,
}
popup_reposition_write :: proc(buf: ^[dynamic]byte, req: Popup_Reposition) -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {
	object := u32(req.popup)
	opcode := u16(POPUP_REPOSITION_OPCODE)
	size   := u16(8 + size_of(req.token))
	num_appended += util.write(buf, object, opcode, size) or_return
	num_appended += util.write(buf, req.token) or_return
	return
}

Popup_Configure :: struct {
	popup: Popup,
	x: i32,
	y: i32,
	width: i32,
	height: i32,
}
popup_configure_read :: proc(buf: []byte) -> (Popup_Configure, int) {
	e: Popup_Configure
	r: int
	n := r
	e.x, r = util.read_i32(buf[n:]); n += r
	e.y, r = util.read_i32(buf[n:]); n += r
	e.width, r = util.read_i32(buf[n:]); n += r
	e.height, r = util.read_i32(buf[n:]); n += r
	return e, n
}

Popup_Popup_Done :: struct {
	popup: Popup,
}
popup_popup_done_read :: proc(buf: []byte) -> (Popup_Popup_Done, int) {
	e: Popup_Popup_Done
	r: int
	n := r
	return e, n
}

Popup_Repositioned :: struct {
	popup: Popup,
	token: u32,
}
popup_repositioned_read :: proc(buf: []byte) -> (Popup_Repositioned, int) {
	e: Popup_Repositioned
	r: int
	n := r
	e.token, r = util.read_u32(buf[n:]); n += r
	return e, n
}
