package client

import "core:sys/linux"

import "linux_dmabuf_v1"
import "wayland"
import "xdg_shell"

encode_request :: proc {
	encode_request_linux_dmabuf_v1_dmabuf_destroy,
	encode_request_linux_dmabuf_v1_dmabuf_create_params,
	encode_request_linux_dmabuf_v1_dmabuf_get_default_feedback,
	encode_request_linux_dmabuf_v1_dmabuf_get_surface_feedback,
	encode_request_linux_dmabuf_v1_buffer_params_destroy,
	encode_request_linux_dmabuf_v1_buffer_params_add,
	encode_request_linux_dmabuf_v1_buffer_params_create,
	encode_request_linux_dmabuf_v1_buffer_params_create_immed,
	encode_request_linux_dmabuf_v1_buffer_params_set_sampling_device,
	encode_request_linux_dmabuf_v1_dmabuf_feedback_destroy,
	encode_request_wayland_display_sync,
	encode_request_wayland_display_get_registry,
	encode_request_wayland_registry_bind,
	encode_request_wayland_compositor_create_surface,
	encode_request_wayland_compositor_create_region,
	encode_request_wayland_compositor_release,
	encode_request_wayland_shm_pool_create_buffer,
	encode_request_wayland_shm_pool_destroy,
	encode_request_wayland_shm_pool_resize,
	encode_request_wayland_shm_create_pool,
	encode_request_wayland_shm_release,
	encode_request_wayland_buffer_destroy,
	encode_request_wayland_data_offer_accept,
	encode_request_wayland_data_offer_receive,
	encode_request_wayland_data_offer_destroy,
	encode_request_wayland_data_offer_finish,
	encode_request_wayland_data_offer_set_actions,
	encode_request_wayland_data_source_offer,
	encode_request_wayland_data_source_destroy,
	encode_request_wayland_data_source_set_actions,
	encode_request_wayland_data_device_start_drag,
	encode_request_wayland_data_device_set_selection,
	encode_request_wayland_data_device_release,
	encode_request_wayland_data_device_manager_create_data_source,
	encode_request_wayland_data_device_manager_get_data_device,
	encode_request_wayland_data_device_manager_release,
	encode_request_wayland_shell_get_shell_surface,
	encode_request_wayland_shell_surface_pong,
	encode_request_wayland_shell_surface_move,
	encode_request_wayland_shell_surface_resize,
	encode_request_wayland_shell_surface_set_toplevel,
	encode_request_wayland_shell_surface_set_transient,
	encode_request_wayland_shell_surface_set_fullscreen,
	encode_request_wayland_shell_surface_set_popup,
	encode_request_wayland_shell_surface_set_maximized,
	encode_request_wayland_shell_surface_set_title,
	encode_request_wayland_shell_surface_set_class,
	encode_request_wayland_surface_destroy,
	encode_request_wayland_surface_attach,
	encode_request_wayland_surface_damage,
	encode_request_wayland_surface_frame,
	encode_request_wayland_surface_set_opaque_region,
	encode_request_wayland_surface_set_input_region,
	encode_request_wayland_surface_commit,
	encode_request_wayland_surface_set_buffer_transform,
	encode_request_wayland_surface_set_buffer_scale,
	encode_request_wayland_surface_damage_buffer,
	encode_request_wayland_surface_offset,
	encode_request_wayland_surface_get_release,
	encode_request_wayland_seat_get_pointer,
	encode_request_wayland_seat_get_keyboard,
	encode_request_wayland_seat_get_touch,
	encode_request_wayland_seat_release,
	encode_request_wayland_pointer_set_cursor,
	encode_request_wayland_pointer_release,
	encode_request_wayland_keyboard_release,
	encode_request_wayland_touch_release,
	encode_request_wayland_output_release,
	encode_request_wayland_region_destroy,
	encode_request_wayland_region_add,
	encode_request_wayland_region_subtract,
	encode_request_wayland_subcompositor_destroy,
	encode_request_wayland_subcompositor_get_subsurface,
	encode_request_wayland_subsurface_destroy,
	encode_request_wayland_subsurface_set_position,
	encode_request_wayland_subsurface_place_above,
	encode_request_wayland_subsurface_place_below,
	encode_request_wayland_subsurface_set_sync,
	encode_request_wayland_subsurface_set_desync,
	encode_request_wayland_fixes_destroy,
	encode_request_wayland_fixes_destroy_registry,
	encode_request_wayland_fixes_ack_global_remove,
	encode_request_xdg_shell_wm_base_destroy,
	encode_request_xdg_shell_wm_base_create_positioner,
	encode_request_xdg_shell_wm_base_get_xdg_surface,
	encode_request_xdg_shell_wm_base_pong,
	encode_request_xdg_shell_positioner_destroy,
	encode_request_xdg_shell_positioner_set_size,
	encode_request_xdg_shell_positioner_set_anchor_rect,
	encode_request_xdg_shell_positioner_set_anchor,
	encode_request_xdg_shell_positioner_set_gravity,
	encode_request_xdg_shell_positioner_set_constraint_adjustment,
	encode_request_xdg_shell_positioner_set_offset,
	encode_request_xdg_shell_positioner_set_reactive,
	encode_request_xdg_shell_positioner_set_parent_size,
	encode_request_xdg_shell_positioner_set_parent_configure,
	encode_request_xdg_shell_surface_destroy,
	encode_request_xdg_shell_surface_get_toplevel,
	encode_request_xdg_shell_surface_get_popup,
	encode_request_xdg_shell_surface_set_window_geometry,
	encode_request_xdg_shell_surface_ack_configure,
	encode_request_xdg_shell_toplevel_destroy,
	encode_request_xdg_shell_toplevel_set_parent,
	encode_request_xdg_shell_toplevel_set_title,
	encode_request_xdg_shell_toplevel_set_app_id,
	encode_request_xdg_shell_toplevel_show_window_menu,
	encode_request_xdg_shell_toplevel_move,
	encode_request_xdg_shell_toplevel_resize,
	encode_request_xdg_shell_toplevel_set_max_size,
	encode_request_xdg_shell_toplevel_set_min_size,
	encode_request_xdg_shell_toplevel_set_maximized,
	encode_request_xdg_shell_toplevel_unset_maximized,
	encode_request_xdg_shell_toplevel_set_fullscreen,
	encode_request_xdg_shell_toplevel_unset_fullscreen,
	encode_request_xdg_shell_toplevel_set_minimized,
	encode_request_xdg_shell_popup_destroy,
	encode_request_xdg_shell_popup_grab,
	encode_request_xdg_shell_popup_reposition,
}


encode_request_linux_dmabuf_v1_dmabuf_destroy :: proc(req: linux_dmabuf_v1.Dmabuf_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = linux_dmabuf_v1.dmabuf_destroy_encode(req, allocator) or_return
	return
}

encode_request_linux_dmabuf_v1_dmabuf_create_params :: proc(req: linux_dmabuf_v1.Dmabuf_Create_Params_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = linux_dmabuf_v1.dmabuf_create_params_encode(req, id, allocator) or_return
	return
}

encode_request_linux_dmabuf_v1_dmabuf_get_default_feedback :: proc(req: linux_dmabuf_v1.Dmabuf_Get_Default_Feedback_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = linux_dmabuf_v1.dmabuf_get_default_feedback_encode(req, id, allocator) or_return
	return
}

encode_request_linux_dmabuf_v1_dmabuf_get_surface_feedback :: proc(req: linux_dmabuf_v1.Dmabuf_Get_Surface_Feedback_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = linux_dmabuf_v1.dmabuf_get_surface_feedback_encode(req, id, allocator) or_return
	return
}

encode_request_linux_dmabuf_v1_buffer_params_destroy :: proc(req: linux_dmabuf_v1.Buffer_Params_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = linux_dmabuf_v1.buffer_params_destroy_encode(req, allocator) or_return
	return
}

encode_request_linux_dmabuf_v1_buffer_params_add :: proc(req: linux_dmabuf_v1.Buffer_Params_Add_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = linux_dmabuf_v1.buffer_params_add_encode(req, allocator) or_return
	fds = make([]linux.Fd, 1, allocator) or_return
	fds[0] = req.fd
	return
}

encode_request_linux_dmabuf_v1_buffer_params_create :: proc(req: linux_dmabuf_v1.Buffer_Params_Create_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = linux_dmabuf_v1.buffer_params_create_encode(req, allocator) or_return
	return
}

encode_request_linux_dmabuf_v1_buffer_params_create_immed :: proc(req: linux_dmabuf_v1.Buffer_Params_Create_Immed_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = linux_dmabuf_v1.buffer_params_create_immed_encode(req, id, allocator) or_return
	return
}

encode_request_linux_dmabuf_v1_buffer_params_set_sampling_device :: proc(req: linux_dmabuf_v1.Buffer_Params_Set_Sampling_Device_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = linux_dmabuf_v1.buffer_params_set_sampling_device_encode(req, allocator) or_return
	return
}

encode_request_linux_dmabuf_v1_dmabuf_feedback_destroy :: proc(req: linux_dmabuf_v1.Dmabuf_Feedback_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = linux_dmabuf_v1.dmabuf_feedback_destroy_encode(req, allocator) or_return
	return
}

encode_request_wayland_display_sync :: proc(req: wayland.Display_Sync_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.display_sync_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_display_get_registry :: proc(req: wayland.Display_Get_Registry_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.display_get_registry_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_registry_bind :: proc(req: wayland.Registry_Bind_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.registry_bind_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_compositor_create_surface :: proc(req: wayland.Compositor_Create_Surface_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.compositor_create_surface_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_compositor_create_region :: proc(req: wayland.Compositor_Create_Region_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.compositor_create_region_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_compositor_release :: proc(req: wayland.Compositor_Release_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.compositor_release_encode(req, allocator) or_return
	return
}

encode_request_wayland_shm_pool_create_buffer :: proc(req: wayland.Shm_Pool_Create_Buffer_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shm_pool_create_buffer_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_shm_pool_destroy :: proc(req: wayland.Shm_Pool_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shm_pool_destroy_encode(req, allocator) or_return
	return
}

encode_request_wayland_shm_pool_resize :: proc(req: wayland.Shm_Pool_Resize_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shm_pool_resize_encode(req, allocator) or_return
	return
}

encode_request_wayland_shm_create_pool :: proc(req: wayland.Shm_Create_Pool_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shm_create_pool_encode(req, id, allocator) or_return
	fds = make([]linux.Fd, 1, allocator) or_return
	fds[0] = req.fd
	return
}

encode_request_wayland_shm_release :: proc(req: wayland.Shm_Release_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shm_release_encode(req, allocator) or_return
	return
}

encode_request_wayland_buffer_destroy :: proc(req: wayland.Buffer_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.buffer_destroy_encode(req, allocator) or_return
	return
}

encode_request_wayland_data_offer_accept :: proc(req: wayland.Data_Offer_Accept_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_offer_accept_encode(req, allocator) or_return
	return
}

encode_request_wayland_data_offer_receive :: proc(req: wayland.Data_Offer_Receive_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_offer_receive_encode(req, allocator) or_return
	fds = make([]linux.Fd, 1, allocator) or_return
	fds[0] = req.fd
	return
}

encode_request_wayland_data_offer_destroy :: proc(req: wayland.Data_Offer_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_offer_destroy_encode(req, allocator) or_return
	return
}

encode_request_wayland_data_offer_finish :: proc(req: wayland.Data_Offer_Finish_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_offer_finish_encode(req, allocator) or_return
	return
}

encode_request_wayland_data_offer_set_actions :: proc(req: wayland.Data_Offer_Set_Actions_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_offer_set_actions_encode(req, allocator) or_return
	return
}

encode_request_wayland_data_source_offer :: proc(req: wayland.Data_Source_Offer_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_source_offer_encode(req, allocator) or_return
	return
}

encode_request_wayland_data_source_destroy :: proc(req: wayland.Data_Source_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_source_destroy_encode(req, allocator) or_return
	return
}

encode_request_wayland_data_source_set_actions :: proc(req: wayland.Data_Source_Set_Actions_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_source_set_actions_encode(req, allocator) or_return
	return
}

encode_request_wayland_data_device_start_drag :: proc(req: wayland.Data_Device_Start_Drag_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_device_start_drag_encode(req, allocator) or_return
	return
}

encode_request_wayland_data_device_set_selection :: proc(req: wayland.Data_Device_Set_Selection_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_device_set_selection_encode(req, allocator) or_return
	return
}

encode_request_wayland_data_device_release :: proc(req: wayland.Data_Device_Release_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_device_release_encode(req, allocator) or_return
	return
}

encode_request_wayland_data_device_manager_create_data_source :: proc(req: wayland.Data_Device_Manager_Create_Data_Source_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_device_manager_create_data_source_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_data_device_manager_get_data_device :: proc(req: wayland.Data_Device_Manager_Get_Data_Device_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_device_manager_get_data_device_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_data_device_manager_release :: proc(req: wayland.Data_Device_Manager_Release_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.data_device_manager_release_encode(req, allocator) or_return
	return
}

encode_request_wayland_shell_get_shell_surface :: proc(req: wayland.Shell_Get_Shell_Surface_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shell_get_shell_surface_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_shell_surface_pong :: proc(req: wayland.Shell_Surface_Pong_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shell_surface_pong_encode(req, allocator) or_return
	return
}

encode_request_wayland_shell_surface_move :: proc(req: wayland.Shell_Surface_Move_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shell_surface_move_encode(req, allocator) or_return
	return
}

encode_request_wayland_shell_surface_resize :: proc(req: wayland.Shell_Surface_Resize_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shell_surface_resize_encode(req, allocator) or_return
	return
}

encode_request_wayland_shell_surface_set_toplevel :: proc(req: wayland.Shell_Surface_Set_Toplevel_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shell_surface_set_toplevel_encode(req, allocator) or_return
	return
}

encode_request_wayland_shell_surface_set_transient :: proc(req: wayland.Shell_Surface_Set_Transient_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shell_surface_set_transient_encode(req, allocator) or_return
	return
}

encode_request_wayland_shell_surface_set_fullscreen :: proc(req: wayland.Shell_Surface_Set_Fullscreen_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shell_surface_set_fullscreen_encode(req, allocator) or_return
	return
}

encode_request_wayland_shell_surface_set_popup :: proc(req: wayland.Shell_Surface_Set_Popup_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shell_surface_set_popup_encode(req, allocator) or_return
	return
}

encode_request_wayland_shell_surface_set_maximized :: proc(req: wayland.Shell_Surface_Set_Maximized_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shell_surface_set_maximized_encode(req, allocator) or_return
	return
}

encode_request_wayland_shell_surface_set_title :: proc(req: wayland.Shell_Surface_Set_Title_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shell_surface_set_title_encode(req, allocator) or_return
	return
}

encode_request_wayland_shell_surface_set_class :: proc(req: wayland.Shell_Surface_Set_Class_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.shell_surface_set_class_encode(req, allocator) or_return
	return
}

encode_request_wayland_surface_destroy :: proc(req: wayland.Surface_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.surface_destroy_encode(req, allocator) or_return
	return
}

encode_request_wayland_surface_attach :: proc(req: wayland.Surface_Attach_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.surface_attach_encode(req, allocator) or_return
	return
}

encode_request_wayland_surface_damage :: proc(req: wayland.Surface_Damage_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.surface_damage_encode(req, allocator) or_return
	return
}

encode_request_wayland_surface_frame :: proc(req: wayland.Surface_Frame_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.surface_frame_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_surface_set_opaque_region :: proc(req: wayland.Surface_Set_Opaque_Region_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.surface_set_opaque_region_encode(req, allocator) or_return
	return
}

encode_request_wayland_surface_set_input_region :: proc(req: wayland.Surface_Set_Input_Region_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.surface_set_input_region_encode(req, allocator) or_return
	return
}

encode_request_wayland_surface_commit :: proc(req: wayland.Surface_Commit_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.surface_commit_encode(req, allocator) or_return
	return
}

encode_request_wayland_surface_set_buffer_transform :: proc(req: wayland.Surface_Set_Buffer_Transform_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.surface_set_buffer_transform_encode(req, allocator) or_return
	return
}

encode_request_wayland_surface_set_buffer_scale :: proc(req: wayland.Surface_Set_Buffer_Scale_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.surface_set_buffer_scale_encode(req, allocator) or_return
	return
}

encode_request_wayland_surface_damage_buffer :: proc(req: wayland.Surface_Damage_Buffer_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.surface_damage_buffer_encode(req, allocator) or_return
	return
}

encode_request_wayland_surface_offset :: proc(req: wayland.Surface_Offset_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.surface_offset_encode(req, allocator) or_return
	return
}

encode_request_wayland_surface_get_release :: proc(req: wayland.Surface_Get_Release_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.surface_get_release_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_seat_get_pointer :: proc(req: wayland.Seat_Get_Pointer_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.seat_get_pointer_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_seat_get_keyboard :: proc(req: wayland.Seat_Get_Keyboard_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.seat_get_keyboard_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_seat_get_touch :: proc(req: wayland.Seat_Get_Touch_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.seat_get_touch_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_seat_release :: proc(req: wayland.Seat_Release_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.seat_release_encode(req, allocator) or_return
	return
}

encode_request_wayland_pointer_set_cursor :: proc(req: wayland.Pointer_Set_Cursor_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.pointer_set_cursor_encode(req, allocator) or_return
	return
}

encode_request_wayland_pointer_release :: proc(req: wayland.Pointer_Release_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.pointer_release_encode(req, allocator) or_return
	return
}

encode_request_wayland_keyboard_release :: proc(req: wayland.Keyboard_Release_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.keyboard_release_encode(req, allocator) or_return
	return
}

encode_request_wayland_touch_release :: proc(req: wayland.Touch_Release_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.touch_release_encode(req, allocator) or_return
	return
}

encode_request_wayland_output_release :: proc(req: wayland.Output_Release_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.output_release_encode(req, allocator) or_return
	return
}

encode_request_wayland_region_destroy :: proc(req: wayland.Region_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.region_destroy_encode(req, allocator) or_return
	return
}

encode_request_wayland_region_add :: proc(req: wayland.Region_Add_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.region_add_encode(req, allocator) or_return
	return
}

encode_request_wayland_region_subtract :: proc(req: wayland.Region_Subtract_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.region_subtract_encode(req, allocator) or_return
	return
}

encode_request_wayland_subcompositor_destroy :: proc(req: wayland.Subcompositor_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.subcompositor_destroy_encode(req, allocator) or_return
	return
}

encode_request_wayland_subcompositor_get_subsurface :: proc(req: wayland.Subcompositor_Get_Subsurface_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.subcompositor_get_subsurface_encode(req, id, allocator) or_return
	return
}

encode_request_wayland_subsurface_destroy :: proc(req: wayland.Subsurface_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.subsurface_destroy_encode(req, allocator) or_return
	return
}

encode_request_wayland_subsurface_set_position :: proc(req: wayland.Subsurface_Set_Position_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.subsurface_set_position_encode(req, allocator) or_return
	return
}

encode_request_wayland_subsurface_place_above :: proc(req: wayland.Subsurface_Place_Above_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.subsurface_place_above_encode(req, allocator) or_return
	return
}

encode_request_wayland_subsurface_place_below :: proc(req: wayland.Subsurface_Place_Below_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.subsurface_place_below_encode(req, allocator) or_return
	return
}

encode_request_wayland_subsurface_set_sync :: proc(req: wayland.Subsurface_Set_Sync_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.subsurface_set_sync_encode(req, allocator) or_return
	return
}

encode_request_wayland_subsurface_set_desync :: proc(req: wayland.Subsurface_Set_Desync_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.subsurface_set_desync_encode(req, allocator) or_return
	return
}

encode_request_wayland_fixes_destroy :: proc(req: wayland.Fixes_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.fixes_destroy_encode(req, allocator) or_return
	return
}

encode_request_wayland_fixes_destroy_registry :: proc(req: wayland.Fixes_Destroy_Registry_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.fixes_destroy_registry_encode(req, allocator) or_return
	return
}

encode_request_wayland_fixes_ack_global_remove :: proc(req: wayland.Fixes_Ack_Global_Remove_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = wayland.fixes_ack_global_remove_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_wm_base_destroy :: proc(req: xdg_shell.Wm_Base_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.wm_base_destroy_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_wm_base_create_positioner :: proc(req: xdg_shell.Wm_Base_Create_Positioner_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.wm_base_create_positioner_encode(req, id, allocator) or_return
	return
}

encode_request_xdg_shell_wm_base_get_xdg_surface :: proc(req: xdg_shell.Wm_Base_Get_Xdg_Surface_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.wm_base_get_xdg_surface_encode(req, id, allocator) or_return
	return
}

encode_request_xdg_shell_wm_base_pong :: proc(req: xdg_shell.Wm_Base_Pong_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.wm_base_pong_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_positioner_destroy :: proc(req: xdg_shell.Positioner_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.positioner_destroy_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_positioner_set_size :: proc(req: xdg_shell.Positioner_Set_Size_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.positioner_set_size_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_positioner_set_anchor_rect :: proc(req: xdg_shell.Positioner_Set_Anchor_Rect_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.positioner_set_anchor_rect_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_positioner_set_anchor :: proc(req: xdg_shell.Positioner_Set_Anchor_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.positioner_set_anchor_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_positioner_set_gravity :: proc(req: xdg_shell.Positioner_Set_Gravity_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.positioner_set_gravity_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_positioner_set_constraint_adjustment :: proc(req: xdg_shell.Positioner_Set_Constraint_Adjustment_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.positioner_set_constraint_adjustment_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_positioner_set_offset :: proc(req: xdg_shell.Positioner_Set_Offset_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.positioner_set_offset_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_positioner_set_reactive :: proc(req: xdg_shell.Positioner_Set_Reactive_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.positioner_set_reactive_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_positioner_set_parent_size :: proc(req: xdg_shell.Positioner_Set_Parent_Size_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.positioner_set_parent_size_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_positioner_set_parent_configure :: proc(req: xdg_shell.Positioner_Set_Parent_Configure_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.positioner_set_parent_configure_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_surface_destroy :: proc(req: xdg_shell.Surface_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.surface_destroy_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_surface_get_toplevel :: proc(req: xdg_shell.Surface_Get_Toplevel_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.surface_get_toplevel_encode(req, id, allocator) or_return
	return
}

encode_request_xdg_shell_surface_get_popup :: proc(req: xdg_shell.Surface_Get_Popup_Request, id: u32, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.surface_get_popup_encode(req, id, allocator) or_return
	return
}

encode_request_xdg_shell_surface_set_window_geometry :: proc(req: xdg_shell.Surface_Set_Window_Geometry_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.surface_set_window_geometry_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_surface_ack_configure :: proc(req: xdg_shell.Surface_Ack_Configure_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.surface_ack_configure_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_destroy :: proc(req: xdg_shell.Toplevel_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_destroy_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_set_parent :: proc(req: xdg_shell.Toplevel_Set_Parent_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_set_parent_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_set_title :: proc(req: xdg_shell.Toplevel_Set_Title_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_set_title_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_set_app_id :: proc(req: xdg_shell.Toplevel_Set_App_Id_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_set_app_id_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_show_window_menu :: proc(req: xdg_shell.Toplevel_Show_Window_Menu_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_show_window_menu_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_move :: proc(req: xdg_shell.Toplevel_Move_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_move_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_resize :: proc(req: xdg_shell.Toplevel_Resize_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_resize_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_set_max_size :: proc(req: xdg_shell.Toplevel_Set_Max_Size_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_set_max_size_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_set_min_size :: proc(req: xdg_shell.Toplevel_Set_Min_Size_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_set_min_size_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_set_maximized :: proc(req: xdg_shell.Toplevel_Set_Maximized_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_set_maximized_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_unset_maximized :: proc(req: xdg_shell.Toplevel_Unset_Maximized_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_unset_maximized_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_set_fullscreen :: proc(req: xdg_shell.Toplevel_Set_Fullscreen_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_set_fullscreen_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_unset_fullscreen :: proc(req: xdg_shell.Toplevel_Unset_Fullscreen_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_unset_fullscreen_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_toplevel_set_minimized :: proc(req: xdg_shell.Toplevel_Set_Minimized_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.toplevel_set_minimized_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_popup_destroy :: proc(req: xdg_shell.Popup_Destroy_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.popup_destroy_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_popup_grab :: proc(req: xdg_shell.Popup_Grab_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.popup_grab_encode(req, allocator) or_return
	return
}

encode_request_xdg_shell_popup_reposition :: proc(req: xdg_shell.Popup_Reposition_Request, allocator := context.temp_allocator) -> (data: []byte, fds: []linux.Fd, err: Error) {
	data = xdg_shell.popup_reposition_encode(req, allocator) or_return
	return
}

queue_request :: proc {
	queue_request_linux_dmabuf_v1_dmabuf_destroy,
	queue_request_linux_dmabuf_v1_dmabuf_create_params,
	queue_request_linux_dmabuf_v1_dmabuf_get_default_feedback,
	queue_request_linux_dmabuf_v1_dmabuf_get_surface_feedback,
	queue_request_linux_dmabuf_v1_buffer_params_destroy,
	queue_request_linux_dmabuf_v1_buffer_params_add,
	queue_request_linux_dmabuf_v1_buffer_params_create,
	queue_request_linux_dmabuf_v1_buffer_params_create_immed,
	queue_request_linux_dmabuf_v1_buffer_params_set_sampling_device,
	queue_request_linux_dmabuf_v1_dmabuf_feedback_destroy,
	queue_request_wayland_display_sync,
	queue_request_wayland_display_get_registry,
	queue_request_wayland_registry_bind,
	queue_request_wayland_compositor_create_surface,
	queue_request_wayland_compositor_create_region,
	queue_request_wayland_compositor_release,
	queue_request_wayland_shm_pool_create_buffer,
	queue_request_wayland_shm_pool_destroy,
	queue_request_wayland_shm_pool_resize,
	queue_request_wayland_shm_create_pool,
	queue_request_wayland_shm_release,
	queue_request_wayland_buffer_destroy,
	queue_request_wayland_data_offer_accept,
	queue_request_wayland_data_offer_receive,
	queue_request_wayland_data_offer_destroy,
	queue_request_wayland_data_offer_finish,
	queue_request_wayland_data_offer_set_actions,
	queue_request_wayland_data_source_offer,
	queue_request_wayland_data_source_destroy,
	queue_request_wayland_data_source_set_actions,
	queue_request_wayland_data_device_start_drag,
	queue_request_wayland_data_device_set_selection,
	queue_request_wayland_data_device_release,
	queue_request_wayland_data_device_manager_create_data_source,
	queue_request_wayland_data_device_manager_get_data_device,
	queue_request_wayland_data_device_manager_release,
	queue_request_wayland_shell_get_shell_surface,
	queue_request_wayland_shell_surface_pong,
	queue_request_wayland_shell_surface_move,
	queue_request_wayland_shell_surface_resize,
	queue_request_wayland_shell_surface_set_toplevel,
	queue_request_wayland_shell_surface_set_transient,
	queue_request_wayland_shell_surface_set_fullscreen,
	queue_request_wayland_shell_surface_set_popup,
	queue_request_wayland_shell_surface_set_maximized,
	queue_request_wayland_shell_surface_set_title,
	queue_request_wayland_shell_surface_set_class,
	queue_request_wayland_surface_destroy,
	queue_request_wayland_surface_attach,
	queue_request_wayland_surface_damage,
	queue_request_wayland_surface_frame,
	queue_request_wayland_surface_set_opaque_region,
	queue_request_wayland_surface_set_input_region,
	queue_request_wayland_surface_commit,
	queue_request_wayland_surface_set_buffer_transform,
	queue_request_wayland_surface_set_buffer_scale,
	queue_request_wayland_surface_damage_buffer,
	queue_request_wayland_surface_offset,
	queue_request_wayland_surface_get_release,
	queue_request_wayland_seat_get_pointer,
	queue_request_wayland_seat_get_keyboard,
	queue_request_wayland_seat_get_touch,
	queue_request_wayland_seat_release,
	queue_request_wayland_pointer_set_cursor,
	queue_request_wayland_pointer_release,
	queue_request_wayland_keyboard_release,
	queue_request_wayland_touch_release,
	queue_request_wayland_output_release,
	queue_request_wayland_region_destroy,
	queue_request_wayland_region_add,
	queue_request_wayland_region_subtract,
	queue_request_wayland_subcompositor_destroy,
	queue_request_wayland_subcompositor_get_subsurface,
	queue_request_wayland_subsurface_destroy,
	queue_request_wayland_subsurface_set_position,
	queue_request_wayland_subsurface_place_above,
	queue_request_wayland_subsurface_place_below,
	queue_request_wayland_subsurface_set_sync,
	queue_request_wayland_subsurface_set_desync,
	queue_request_wayland_fixes_destroy,
	queue_request_wayland_fixes_destroy_registry,
	queue_request_wayland_fixes_ack_global_remove,
	queue_request_xdg_shell_wm_base_destroy,
	queue_request_xdg_shell_wm_base_create_positioner,
	queue_request_xdg_shell_wm_base_get_xdg_surface,
	queue_request_xdg_shell_wm_base_pong,
	queue_request_xdg_shell_positioner_destroy,
	queue_request_xdg_shell_positioner_set_size,
	queue_request_xdg_shell_positioner_set_anchor_rect,
	queue_request_xdg_shell_positioner_set_anchor,
	queue_request_xdg_shell_positioner_set_gravity,
	queue_request_xdg_shell_positioner_set_constraint_adjustment,
	queue_request_xdg_shell_positioner_set_offset,
	queue_request_xdg_shell_positioner_set_reactive,
	queue_request_xdg_shell_positioner_set_parent_size,
	queue_request_xdg_shell_positioner_set_parent_configure,
	queue_request_xdg_shell_surface_destroy,
	queue_request_xdg_shell_surface_get_toplevel,
	queue_request_xdg_shell_surface_get_popup,
	queue_request_xdg_shell_surface_set_window_geometry,
	queue_request_xdg_shell_surface_ack_configure,
	queue_request_xdg_shell_toplevel_destroy,
	queue_request_xdg_shell_toplevel_set_parent,
	queue_request_xdg_shell_toplevel_set_title,
	queue_request_xdg_shell_toplevel_set_app_id,
	queue_request_xdg_shell_toplevel_show_window_menu,
	queue_request_xdg_shell_toplevel_move,
	queue_request_xdg_shell_toplevel_resize,
	queue_request_xdg_shell_toplevel_set_max_size,
	queue_request_xdg_shell_toplevel_set_min_size,
	queue_request_xdg_shell_toplevel_set_maximized,
	queue_request_xdg_shell_toplevel_unset_maximized,
	queue_request_xdg_shell_toplevel_set_fullscreen,
	queue_request_xdg_shell_toplevel_unset_fullscreen,
	queue_request_xdg_shell_toplevel_set_minimized,
	queue_request_xdg_shell_popup_destroy,
	queue_request_xdg_shell_popup_grab,
	queue_request_xdg_shell_popup_reposition,
}


queue_request_linux_dmabuf_v1_dmabuf_destroy :: proc(client: ^Client, req: linux_dmabuf_v1.Dmabuf_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_linux_dmabuf_v1_dmabuf_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.dmabuf))
	return nil
}

queue_request_linux_dmabuf_v1_dmabuf_create_params :: proc(client: ^Client, req: linux_dmabuf_v1.Dmabuf_Create_Params_Request, allocator := context.temp_allocator) -> (ret: linux_dmabuf_v1.Buffer_Params, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_linux_dmabuf_v1_dmabuf_create_params(req, id, allocator) or_return
	register_object(client, id, linux_dmabuf_v1.BUFFER_PARAMS_INTERFACE)
	submit(client, data, fds) or_return
	return linux_dmabuf_v1.Buffer_Params(id), nil
}

queue_request_linux_dmabuf_v1_dmabuf_get_default_feedback :: proc(client: ^Client, req: linux_dmabuf_v1.Dmabuf_Get_Default_Feedback_Request, allocator := context.temp_allocator) -> (ret: linux_dmabuf_v1.Dmabuf_Feedback, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_linux_dmabuf_v1_dmabuf_get_default_feedback(req, id, allocator) or_return
	register_object(client, id, linux_dmabuf_v1.DMABUF_FEEDBACK_INTERFACE)
	submit(client, data, fds) or_return
	return linux_dmabuf_v1.Dmabuf_Feedback(id), nil
}

queue_request_linux_dmabuf_v1_dmabuf_get_surface_feedback :: proc(client: ^Client, req: linux_dmabuf_v1.Dmabuf_Get_Surface_Feedback_Request, allocator := context.temp_allocator) -> (ret: linux_dmabuf_v1.Dmabuf_Feedback, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_linux_dmabuf_v1_dmabuf_get_surface_feedback(req, id, allocator) or_return
	register_object(client, id, linux_dmabuf_v1.DMABUF_FEEDBACK_INTERFACE)
	submit(client, data, fds) or_return
	return linux_dmabuf_v1.Dmabuf_Feedback(id), nil
}

queue_request_linux_dmabuf_v1_buffer_params_destroy :: proc(client: ^Client, req: linux_dmabuf_v1.Buffer_Params_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_linux_dmabuf_v1_buffer_params_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.buffer_params))
	return nil
}

queue_request_linux_dmabuf_v1_buffer_params_add :: proc(client: ^Client, req: linux_dmabuf_v1.Buffer_Params_Add_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_linux_dmabuf_v1_buffer_params_add(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_linux_dmabuf_v1_buffer_params_create :: proc(client: ^Client, req: linux_dmabuf_v1.Buffer_Params_Create_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_linux_dmabuf_v1_buffer_params_create(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_linux_dmabuf_v1_buffer_params_create_immed :: proc(client: ^Client, req: linux_dmabuf_v1.Buffer_Params_Create_Immed_Request, allocator := context.temp_allocator) -> (ret: wayland.Buffer, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_linux_dmabuf_v1_buffer_params_create_immed(req, id, allocator) or_return
	register_object(client, id, wayland.BUFFER_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Buffer(id), nil
}

queue_request_linux_dmabuf_v1_buffer_params_set_sampling_device :: proc(client: ^Client, req: linux_dmabuf_v1.Buffer_Params_Set_Sampling_Device_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_linux_dmabuf_v1_buffer_params_set_sampling_device(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_linux_dmabuf_v1_dmabuf_feedback_destroy :: proc(client: ^Client, req: linux_dmabuf_v1.Dmabuf_Feedback_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_linux_dmabuf_v1_dmabuf_feedback_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.dmabuf_feedback))
	return nil
}

queue_request_wayland_display_sync :: proc(client: ^Client, req: wayland.Display_Sync_Request, allocator := context.temp_allocator) -> (ret: wayland.Callback, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_display_sync(req, id, allocator) or_return
	register_object(client, id, wayland.CALLBACK_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Callback(id), nil
}

queue_request_wayland_display_get_registry :: proc(client: ^Client, req: wayland.Display_Get_Registry_Request, allocator := context.temp_allocator) -> (ret: wayland.Registry, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_display_get_registry(req, id, allocator) or_return
	register_object(client, id, wayland.REGISTRY_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Registry(id), nil
}

queue_request_wayland_registry_bind :: proc(client: ^Client, req: wayland.Registry_Bind_Request, allocator := context.temp_allocator) -> (ret: u32, err: Error) {
	client.next_id += 1
	id := client.next_id
	rb := req
	switch rb.interface {
	case linux_dmabuf_v1.DMABUF_INTERFACE:
		rb.version = min(rb.version, linux_dmabuf_v1.DMABUF_VERSION)
		register_object(client, id, linux_dmabuf_v1.DMABUF_INTERFACE)
	case wayland.COMPOSITOR_INTERFACE:
		rb.version = min(rb.version, wayland.COMPOSITOR_VERSION)
		register_object(client, id, wayland.COMPOSITOR_INTERFACE)
	case wayland.SHM_INTERFACE:
		rb.version = min(rb.version, wayland.SHM_VERSION)
		register_object(client, id, wayland.SHM_INTERFACE)
	case wayland.DATA_DEVICE_MANAGER_INTERFACE:
		rb.version = min(rb.version, wayland.DATA_DEVICE_MANAGER_VERSION)
		register_object(client, id, wayland.DATA_DEVICE_MANAGER_INTERFACE)
	case wayland.SHELL_INTERFACE:
		rb.version = min(rb.version, wayland.SHELL_VERSION)
		register_object(client, id, wayland.SHELL_INTERFACE)
	case wayland.SEAT_INTERFACE:
		rb.version = min(rb.version, wayland.SEAT_VERSION)
		register_object(client, id, wayland.SEAT_INTERFACE)
	case wayland.OUTPUT_INTERFACE:
		rb.version = min(rb.version, wayland.OUTPUT_VERSION)
		register_object(client, id, wayland.OUTPUT_INTERFACE)
	case wayland.SUBCOMPOSITOR_INTERFACE:
		rb.version = min(rb.version, wayland.SUBCOMPOSITOR_VERSION)
		register_object(client, id, wayland.SUBCOMPOSITOR_INTERFACE)
	case wayland.FIXES_INTERFACE:
		rb.version = min(rb.version, wayland.FIXES_VERSION)
		register_object(client, id, wayland.FIXES_INTERFACE)
	case xdg_shell.WM_BASE_INTERFACE:
		rb.version = min(rb.version, xdg_shell.WM_BASE_VERSION)
		register_object(client, id, xdg_shell.WM_BASE_INTERFACE)
	}
	data, fds := encode_request_wayland_registry_bind(rb, id, allocator) or_return
	submit(client, data, fds) or_return
	return id, nil
}

queue_request_wayland_compositor_create_surface :: proc(client: ^Client, req: wayland.Compositor_Create_Surface_Request, allocator := context.temp_allocator) -> (ret: wayland.Surface, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_compositor_create_surface(req, id, allocator) or_return
	register_object(client, id, wayland.SURFACE_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Surface(id), nil
}

queue_request_wayland_compositor_create_region :: proc(client: ^Client, req: wayland.Compositor_Create_Region_Request, allocator := context.temp_allocator) -> (ret: wayland.Region, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_compositor_create_region(req, id, allocator) or_return
	register_object(client, id, wayland.REGION_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Region(id), nil
}

queue_request_wayland_compositor_release :: proc(client: ^Client, req: wayland.Compositor_Release_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_compositor_release(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.compositor))
	return nil
}

queue_request_wayland_shm_pool_create_buffer :: proc(client: ^Client, req: wayland.Shm_Pool_Create_Buffer_Request, allocator := context.temp_allocator) -> (ret: wayland.Buffer, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_shm_pool_create_buffer(req, id, allocator) or_return
	register_object(client, id, wayland.BUFFER_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Buffer(id), nil
}

queue_request_wayland_shm_pool_destroy :: proc(client: ^Client, req: wayland.Shm_Pool_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shm_pool_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.shm_pool))
	return nil
}

queue_request_wayland_shm_pool_resize :: proc(client: ^Client, req: wayland.Shm_Pool_Resize_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shm_pool_resize(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_shm_create_pool :: proc(client: ^Client, req: wayland.Shm_Create_Pool_Request, allocator := context.temp_allocator) -> (ret: wayland.Shm_Pool, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_shm_create_pool(req, id, allocator) or_return
	register_object(client, id, wayland.SHM_POOL_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Shm_Pool(id), nil
}

queue_request_wayland_shm_release :: proc(client: ^Client, req: wayland.Shm_Release_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shm_release(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.shm))
	return nil
}

queue_request_wayland_buffer_destroy :: proc(client: ^Client, req: wayland.Buffer_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_buffer_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.buffer))
	return nil
}

queue_request_wayland_data_offer_accept :: proc(client: ^Client, req: wayland.Data_Offer_Accept_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_data_offer_accept(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_data_offer_receive :: proc(client: ^Client, req: wayland.Data_Offer_Receive_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_data_offer_receive(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_data_offer_destroy :: proc(client: ^Client, req: wayland.Data_Offer_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_data_offer_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.data_offer))
	return nil
}

queue_request_wayland_data_offer_finish :: proc(client: ^Client, req: wayland.Data_Offer_Finish_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_data_offer_finish(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_data_offer_set_actions :: proc(client: ^Client, req: wayland.Data_Offer_Set_Actions_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_data_offer_set_actions(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_data_source_offer :: proc(client: ^Client, req: wayland.Data_Source_Offer_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_data_source_offer(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_data_source_destroy :: proc(client: ^Client, req: wayland.Data_Source_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_data_source_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.data_source))
	return nil
}

queue_request_wayland_data_source_set_actions :: proc(client: ^Client, req: wayland.Data_Source_Set_Actions_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_data_source_set_actions(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_data_device_start_drag :: proc(client: ^Client, req: wayland.Data_Device_Start_Drag_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_data_device_start_drag(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_data_device_set_selection :: proc(client: ^Client, req: wayland.Data_Device_Set_Selection_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_data_device_set_selection(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_data_device_release :: proc(client: ^Client, req: wayland.Data_Device_Release_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_data_device_release(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.data_device))
	return nil
}

queue_request_wayland_data_device_manager_create_data_source :: proc(client: ^Client, req: wayland.Data_Device_Manager_Create_Data_Source_Request, allocator := context.temp_allocator) -> (ret: wayland.Data_Source, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_data_device_manager_create_data_source(req, id, allocator) or_return
	register_object(client, id, wayland.DATA_SOURCE_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Data_Source(id), nil
}

queue_request_wayland_data_device_manager_get_data_device :: proc(client: ^Client, req: wayland.Data_Device_Manager_Get_Data_Device_Request, allocator := context.temp_allocator) -> (ret: wayland.Data_Device, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_data_device_manager_get_data_device(req, id, allocator) or_return
	register_object(client, id, wayland.DATA_DEVICE_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Data_Device(id), nil
}

queue_request_wayland_data_device_manager_release :: proc(client: ^Client, req: wayland.Data_Device_Manager_Release_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_data_device_manager_release(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.data_device_manager))
	return nil
}

queue_request_wayland_shell_get_shell_surface :: proc(client: ^Client, req: wayland.Shell_Get_Shell_Surface_Request, allocator := context.temp_allocator) -> (ret: wayland.Shell_Surface, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_shell_get_shell_surface(req, id, allocator) or_return
	register_object(client, id, wayland.SHELL_SURFACE_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Shell_Surface(id), nil
}

queue_request_wayland_shell_surface_pong :: proc(client: ^Client, req: wayland.Shell_Surface_Pong_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shell_surface_pong(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_shell_surface_move :: proc(client: ^Client, req: wayland.Shell_Surface_Move_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shell_surface_move(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_shell_surface_resize :: proc(client: ^Client, req: wayland.Shell_Surface_Resize_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shell_surface_resize(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_shell_surface_set_toplevel :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Toplevel_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shell_surface_set_toplevel(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_shell_surface_set_transient :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Transient_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shell_surface_set_transient(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_shell_surface_set_fullscreen :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Fullscreen_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shell_surface_set_fullscreen(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_shell_surface_set_popup :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Popup_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shell_surface_set_popup(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_shell_surface_set_maximized :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Maximized_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shell_surface_set_maximized(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_shell_surface_set_title :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Title_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shell_surface_set_title(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_shell_surface_set_class :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Class_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_shell_surface_set_class(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_surface_destroy :: proc(client: ^Client, req: wayland.Surface_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_surface_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.surface))
	return nil
}

queue_request_wayland_surface_attach :: proc(client: ^Client, req: wayland.Surface_Attach_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_surface_attach(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_surface_damage :: proc(client: ^Client, req: wayland.Surface_Damage_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_surface_damage(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_surface_frame :: proc(client: ^Client, req: wayland.Surface_Frame_Request, allocator := context.temp_allocator) -> (ret: wayland.Callback, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_surface_frame(req, id, allocator) or_return
	register_object(client, id, wayland.CALLBACK_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Callback(id), nil
}

queue_request_wayland_surface_set_opaque_region :: proc(client: ^Client, req: wayland.Surface_Set_Opaque_Region_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_surface_set_opaque_region(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_surface_set_input_region :: proc(client: ^Client, req: wayland.Surface_Set_Input_Region_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_surface_set_input_region(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_surface_commit :: proc(client: ^Client, req: wayland.Surface_Commit_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_surface_commit(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_surface_set_buffer_transform :: proc(client: ^Client, req: wayland.Surface_Set_Buffer_Transform_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_surface_set_buffer_transform(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_surface_set_buffer_scale :: proc(client: ^Client, req: wayland.Surface_Set_Buffer_Scale_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_surface_set_buffer_scale(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_surface_damage_buffer :: proc(client: ^Client, req: wayland.Surface_Damage_Buffer_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_surface_damage_buffer(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_surface_offset :: proc(client: ^Client, req: wayland.Surface_Offset_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_surface_offset(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_surface_get_release :: proc(client: ^Client, req: wayland.Surface_Get_Release_Request, allocator := context.temp_allocator) -> (ret: wayland.Callback, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_surface_get_release(req, id, allocator) or_return
	register_object(client, id, wayland.CALLBACK_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Callback(id), nil
}

queue_request_wayland_seat_get_pointer :: proc(client: ^Client, req: wayland.Seat_Get_Pointer_Request, allocator := context.temp_allocator) -> (ret: wayland.Pointer, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_seat_get_pointer(req, id, allocator) or_return
	register_object(client, id, wayland.POINTER_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Pointer(id), nil
}

queue_request_wayland_seat_get_keyboard :: proc(client: ^Client, req: wayland.Seat_Get_Keyboard_Request, allocator := context.temp_allocator) -> (ret: wayland.Keyboard, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_seat_get_keyboard(req, id, allocator) or_return
	register_object(client, id, wayland.KEYBOARD_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Keyboard(id), nil
}

queue_request_wayland_seat_get_touch :: proc(client: ^Client, req: wayland.Seat_Get_Touch_Request, allocator := context.temp_allocator) -> (ret: wayland.Touch, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_seat_get_touch(req, id, allocator) or_return
	register_object(client, id, wayland.TOUCH_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Touch(id), nil
}

queue_request_wayland_seat_release :: proc(client: ^Client, req: wayland.Seat_Release_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_seat_release(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.seat))
	return nil
}

queue_request_wayland_pointer_set_cursor :: proc(client: ^Client, req: wayland.Pointer_Set_Cursor_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_pointer_set_cursor(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_pointer_release :: proc(client: ^Client, req: wayland.Pointer_Release_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_pointer_release(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.pointer))
	return nil
}

queue_request_wayland_keyboard_release :: proc(client: ^Client, req: wayland.Keyboard_Release_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_keyboard_release(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.keyboard))
	return nil
}

queue_request_wayland_touch_release :: proc(client: ^Client, req: wayland.Touch_Release_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_touch_release(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.touch))
	return nil
}

queue_request_wayland_output_release :: proc(client: ^Client, req: wayland.Output_Release_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_output_release(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.output))
	return nil
}

queue_request_wayland_region_destroy :: proc(client: ^Client, req: wayland.Region_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_region_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.region))
	return nil
}

queue_request_wayland_region_add :: proc(client: ^Client, req: wayland.Region_Add_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_region_add(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_region_subtract :: proc(client: ^Client, req: wayland.Region_Subtract_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_region_subtract(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_subcompositor_destroy :: proc(client: ^Client, req: wayland.Subcompositor_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_subcompositor_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.subcompositor))
	return nil
}

queue_request_wayland_subcompositor_get_subsurface :: proc(client: ^Client, req: wayland.Subcompositor_Get_Subsurface_Request, allocator := context.temp_allocator) -> (ret: wayland.Subsurface, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_wayland_subcompositor_get_subsurface(req, id, allocator) or_return
	register_object(client, id, wayland.SUBSURFACE_INTERFACE)
	submit(client, data, fds) or_return
	return wayland.Subsurface(id), nil
}

queue_request_wayland_subsurface_destroy :: proc(client: ^Client, req: wayland.Subsurface_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_subsurface_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.subsurface))
	return nil
}

queue_request_wayland_subsurface_set_position :: proc(client: ^Client, req: wayland.Subsurface_Set_Position_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_subsurface_set_position(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_subsurface_place_above :: proc(client: ^Client, req: wayland.Subsurface_Place_Above_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_subsurface_place_above(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_subsurface_place_below :: proc(client: ^Client, req: wayland.Subsurface_Place_Below_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_subsurface_place_below(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_subsurface_set_sync :: proc(client: ^Client, req: wayland.Subsurface_Set_Sync_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_subsurface_set_sync(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_subsurface_set_desync :: proc(client: ^Client, req: wayland.Subsurface_Set_Desync_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_subsurface_set_desync(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_fixes_destroy :: proc(client: ^Client, req: wayland.Fixes_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_fixes_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.fixes))
	return nil
}

queue_request_wayland_fixes_destroy_registry :: proc(client: ^Client, req: wayland.Fixes_Destroy_Registry_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_fixes_destroy_registry(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_wayland_fixes_ack_global_remove :: proc(client: ^Client, req: wayland.Fixes_Ack_Global_Remove_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_wayland_fixes_ack_global_remove(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_wm_base_destroy :: proc(client: ^Client, req: xdg_shell.Wm_Base_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_wm_base_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.wm_base))
	return nil
}

queue_request_xdg_shell_wm_base_create_positioner :: proc(client: ^Client, req: xdg_shell.Wm_Base_Create_Positioner_Request, allocator := context.temp_allocator) -> (ret: xdg_shell.Positioner, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_xdg_shell_wm_base_create_positioner(req, id, allocator) or_return
	register_object(client, id, xdg_shell.POSITIONER_INTERFACE)
	submit(client, data, fds) or_return
	return xdg_shell.Positioner(id), nil
}

queue_request_xdg_shell_wm_base_get_xdg_surface :: proc(client: ^Client, req: xdg_shell.Wm_Base_Get_Xdg_Surface_Request, allocator := context.temp_allocator) -> (ret: xdg_shell.Surface, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_xdg_shell_wm_base_get_xdg_surface(req, id, allocator) or_return
	register_object(client, id, xdg_shell.SURFACE_INTERFACE)
	submit(client, data, fds) or_return
	return xdg_shell.Surface(id), nil
}

queue_request_xdg_shell_wm_base_pong :: proc(client: ^Client, req: xdg_shell.Wm_Base_Pong_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_wm_base_pong(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_positioner_destroy :: proc(client: ^Client, req: xdg_shell.Positioner_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_positioner_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.positioner))
	return nil
}

queue_request_xdg_shell_positioner_set_size :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Size_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_positioner_set_size(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_positioner_set_anchor_rect :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Anchor_Rect_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_positioner_set_anchor_rect(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_positioner_set_anchor :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Anchor_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_positioner_set_anchor(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_positioner_set_gravity :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Gravity_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_positioner_set_gravity(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_positioner_set_constraint_adjustment :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Constraint_Adjustment_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_positioner_set_constraint_adjustment(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_positioner_set_offset :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Offset_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_positioner_set_offset(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_positioner_set_reactive :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Reactive_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_positioner_set_reactive(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_positioner_set_parent_size :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Parent_Size_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_positioner_set_parent_size(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_positioner_set_parent_configure :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Parent_Configure_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_positioner_set_parent_configure(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_surface_destroy :: proc(client: ^Client, req: xdg_shell.Surface_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_surface_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.surface))
	return nil
}

queue_request_xdg_shell_surface_get_toplevel :: proc(client: ^Client, req: xdg_shell.Surface_Get_Toplevel_Request, allocator := context.temp_allocator) -> (ret: xdg_shell.Toplevel, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_xdg_shell_surface_get_toplevel(req, id, allocator) or_return
	register_object(client, id, xdg_shell.TOPLEVEL_INTERFACE)
	submit(client, data, fds) or_return
	return xdg_shell.Toplevel(id), nil
}

queue_request_xdg_shell_surface_get_popup :: proc(client: ^Client, req: xdg_shell.Surface_Get_Popup_Request, allocator := context.temp_allocator) -> (ret: xdg_shell.Popup, err: Error) {
	client.next_id += 1
	id := client.next_id
	data, fds := encode_request_xdg_shell_surface_get_popup(req, id, allocator) or_return
	register_object(client, id, xdg_shell.POPUP_INTERFACE)
	submit(client, data, fds) or_return
	return xdg_shell.Popup(id), nil
}

queue_request_xdg_shell_surface_set_window_geometry :: proc(client: ^Client, req: xdg_shell.Surface_Set_Window_Geometry_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_surface_set_window_geometry(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_surface_ack_configure :: proc(client: ^Client, req: xdg_shell.Surface_Ack_Configure_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_surface_ack_configure(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_destroy :: proc(client: ^Client, req: xdg_shell.Toplevel_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.toplevel))
	return nil
}

queue_request_xdg_shell_toplevel_set_parent :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Parent_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_set_parent(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_set_title :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Title_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_set_title(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_set_app_id :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_App_Id_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_set_app_id(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_show_window_menu :: proc(client: ^Client, req: xdg_shell.Toplevel_Show_Window_Menu_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_show_window_menu(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_move :: proc(client: ^Client, req: xdg_shell.Toplevel_Move_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_move(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_resize :: proc(client: ^Client, req: xdg_shell.Toplevel_Resize_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_resize(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_set_max_size :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Max_Size_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_set_max_size(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_set_min_size :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Min_Size_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_set_min_size(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_set_maximized :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Maximized_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_set_maximized(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_unset_maximized :: proc(client: ^Client, req: xdg_shell.Toplevel_Unset_Maximized_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_unset_maximized(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_set_fullscreen :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Fullscreen_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_set_fullscreen(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_unset_fullscreen :: proc(client: ^Client, req: xdg_shell.Toplevel_Unset_Fullscreen_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_unset_fullscreen(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_toplevel_set_minimized :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Minimized_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_toplevel_set_minimized(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_popup_destroy :: proc(client: ^Client, req: xdg_shell.Popup_Destroy_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_popup_destroy(req, allocator) or_return
	submit(client, data, fds) or_return
	delete_key(&client.id_to_interface, u32(req.popup))
	return nil
}

queue_request_xdg_shell_popup_grab :: proc(client: ^Client, req: xdg_shell.Popup_Grab_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_popup_grab(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

queue_request_xdg_shell_popup_reposition :: proc(client: ^Client, req: xdg_shell.Popup_Reposition_Request, allocator := context.temp_allocator) -> Error {
	data, fds := encode_request_xdg_shell_popup_reposition(req, allocator) or_return
	submit(client, data, fds) or_return
	return nil
}

Event :: union {
	linux_dmabuf_v1.Dmabuf_Format_Event,
	linux_dmabuf_v1.Dmabuf_Modifier_Event,
	linux_dmabuf_v1.Buffer_Params_Created_Event,
	linux_dmabuf_v1.Buffer_Params_Failed_Event,
	linux_dmabuf_v1.Dmabuf_Feedback_Done_Event,
	linux_dmabuf_v1.Dmabuf_Feedback_Format_Table_Event,
	linux_dmabuf_v1.Dmabuf_Feedback_Main_Device_Event,
	linux_dmabuf_v1.Dmabuf_Feedback_Tranche_Done_Event,
	linux_dmabuf_v1.Dmabuf_Feedback_Tranche_Target_Device_Event,
	linux_dmabuf_v1.Dmabuf_Feedback_Tranche_Formats_Event,
	linux_dmabuf_v1.Dmabuf_Feedback_Tranche_Flags_Event,
	wayland.Display_Error_Event,
	wayland.Display_Delete_Id_Event,
	wayland.Registry_Global_Event,
	wayland.Registry_Global_Remove_Event,
	wayland.Callback_Done_Event,
	wayland.Shm_Format_Event,
	wayland.Buffer_Release_Event,
	wayland.Data_Offer_Offer_Event,
	wayland.Data_Offer_Source_Actions_Event,
	wayland.Data_Offer_Action_Event,
	wayland.Data_Source_Target_Event,
	wayland.Data_Source_Send_Event,
	wayland.Data_Source_Cancelled_Event,
	wayland.Data_Source_Dnd_Drop_Performed_Event,
	wayland.Data_Source_Dnd_Finished_Event,
	wayland.Data_Source_Action_Event,
	wayland.Data_Device_Data_Offer_Event,
	wayland.Data_Device_Enter_Event,
	wayland.Data_Device_Leave_Event,
	wayland.Data_Device_Motion_Event,
	wayland.Data_Device_Drop_Event,
	wayland.Data_Device_Selection_Event,
	wayland.Shell_Surface_Ping_Event,
	wayland.Shell_Surface_Configure_Event,
	wayland.Shell_Surface_Popup_Done_Event,
	wayland.Surface_Enter_Event,
	wayland.Surface_Leave_Event,
	wayland.Surface_Preferred_Buffer_Scale_Event,
	wayland.Surface_Preferred_Buffer_Transform_Event,
	wayland.Seat_Capabilities_Event,
	wayland.Seat_Name_Event,
	wayland.Pointer_Enter_Event,
	wayland.Pointer_Leave_Event,
	wayland.Pointer_Motion_Event,
	wayland.Pointer_Button_Event,
	wayland.Pointer_Axis_Event,
	wayland.Pointer_Frame_Event,
	wayland.Pointer_Axis_Source_Event,
	wayland.Pointer_Axis_Stop_Event,
	wayland.Pointer_Axis_Discrete_Event,
	wayland.Pointer_Axis_Value120_Event,
	wayland.Pointer_Axis_Relative_Direction_Event,
	wayland.Pointer_Warp_Event,
	wayland.Keyboard_Keymap_Event,
	wayland.Keyboard_Enter_Event,
	wayland.Keyboard_Leave_Event,
	wayland.Keyboard_Key_Event,
	wayland.Keyboard_Modifiers_Event,
	wayland.Keyboard_Repeat_Info_Event,
	wayland.Touch_Down_Event,
	wayland.Touch_Up_Event,
	wayland.Touch_Motion_Event,
	wayland.Touch_Frame_Event,
	wayland.Touch_Cancel_Event,
	wayland.Touch_Shape_Event,
	wayland.Touch_Orientation_Event,
	wayland.Output_Geometry_Event,
	wayland.Output_Mode_Event,
	wayland.Output_Done_Event,
	wayland.Output_Scale_Event,
	wayland.Output_Name_Event,
	wayland.Output_Description_Event,
	xdg_shell.Wm_Base_Ping_Event,
	xdg_shell.Surface_Configure_Event,
	xdg_shell.Toplevel_Configure_Event,
	xdg_shell.Toplevel_Close_Event,
	xdg_shell.Toplevel_Configure_Bounds_Event,
	xdg_shell.Toplevel_Wm_Capabilities_Event,
	xdg_shell.Popup_Configure_Event,
	xdg_shell.Popup_Popup_Done_Event,
	xdg_shell.Popup_Repositioned_Event,
}

parse_event :: proc(client: ^Client, interface: string, object_id: u32, opcode: u16, data: []byte, fds: ^[dynamic; 28]linux.Fd, allocator := context.temp_allocator) -> (ev: Event, ok: bool) {
	switch interface {
	case linux_dmabuf_v1.DMABUF_INTERFACE:
		switch opcode {
		case linux_dmabuf_v1.DMABUF_FORMAT_OPCODE:
			decoded := linux_dmabuf_v1.dmabuf_format_decode(data)
			decoded.dmabuf = linux_dmabuf_v1.Dmabuf(object_id)
			return Event(decoded), true
		case linux_dmabuf_v1.DMABUF_MODIFIER_OPCODE:
			decoded := linux_dmabuf_v1.dmabuf_modifier_decode(data)
			decoded.dmabuf = linux_dmabuf_v1.Dmabuf(object_id)
			return Event(decoded), true
		}
	case linux_dmabuf_v1.BUFFER_PARAMS_INTERFACE:
		switch opcode {
		case linux_dmabuf_v1.BUFFER_PARAMS_CREATED_OPCODE:
			decoded := linux_dmabuf_v1.buffer_params_created_decode(data)
			decoded.buffer_params = linux_dmabuf_v1.Buffer_Params(object_id)
			client.id_to_interface[u32(decoded.buffer)] = wayland.BUFFER_INTERFACE
			return Event(decoded), true
		case linux_dmabuf_v1.BUFFER_PARAMS_FAILED_OPCODE:
			decoded := linux_dmabuf_v1.buffer_params_failed_decode(data)
			decoded.buffer_params = linux_dmabuf_v1.Buffer_Params(object_id)
			return Event(decoded), true
		}
	case linux_dmabuf_v1.DMABUF_FEEDBACK_INTERFACE:
		switch opcode {
		case linux_dmabuf_v1.DMABUF_FEEDBACK_DONE_OPCODE:
			decoded := linux_dmabuf_v1.dmabuf_feedback_done_decode(data)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			return Event(decoded), true
		case linux_dmabuf_v1.DMABUF_FEEDBACK_FORMAT_TABLE_OPCODE:
			decoded := linux_dmabuf_v1.dmabuf_feedback_format_table_decode(data, fds)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			return Event(decoded), true
		case linux_dmabuf_v1.DMABUF_FEEDBACK_MAIN_DEVICE_OPCODE:
			decoded := linux_dmabuf_v1.dmabuf_feedback_main_device_decode(data, allocator)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			return Event(decoded), true
		case linux_dmabuf_v1.DMABUF_FEEDBACK_TRANCHE_DONE_OPCODE:
			decoded := linux_dmabuf_v1.dmabuf_feedback_tranche_done_decode(data)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			return Event(decoded), true
		case linux_dmabuf_v1.DMABUF_FEEDBACK_TRANCHE_TARGET_DEVICE_OPCODE:
			decoded := linux_dmabuf_v1.dmabuf_feedback_tranche_target_device_decode(data, allocator)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			return Event(decoded), true
		case linux_dmabuf_v1.DMABUF_FEEDBACK_TRANCHE_FORMATS_OPCODE:
			decoded := linux_dmabuf_v1.dmabuf_feedback_tranche_formats_decode(data, allocator)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			return Event(decoded), true
		case linux_dmabuf_v1.DMABUF_FEEDBACK_TRANCHE_FLAGS_OPCODE:
			decoded := linux_dmabuf_v1.dmabuf_feedback_tranche_flags_decode(data)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			return Event(decoded), true
		}
	case wayland.DISPLAY_INTERFACE:
		switch opcode {
		case wayland.DISPLAY_ERROR_OPCODE:
			decoded := wayland.display_error_decode(data, allocator)
			decoded.display = wayland.Display(object_id)
			return Event(decoded), true
		case wayland.DISPLAY_DELETE_ID_OPCODE:
			delete_key(&client.id_to_interface, wayland.display_delete_id_decode(data).id)
			return
		}
	case wayland.REGISTRY_INTERFACE:
		switch opcode {
		case wayland.REGISTRY_GLOBAL_OPCODE:
			decoded := wayland.registry_global_decode(data, allocator)
			decoded.registry = wayland.Registry(object_id)
			return Event(decoded), true
		case wayland.REGISTRY_GLOBAL_REMOVE_OPCODE:
			decoded := wayland.registry_global_remove_decode(data)
			decoded.registry = wayland.Registry(object_id)
			return Event(decoded), true
		}
	case wayland.CALLBACK_INTERFACE:
		switch opcode {
		case wayland.CALLBACK_DONE_OPCODE:
			delete_key(&client.id_to_interface, object_id)
			return
		}
	case wayland.COMPOSITOR_INTERFACE:
		switch opcode {
		}
	case wayland.SHM_POOL_INTERFACE:
		switch opcode {
		}
	case wayland.SHM_INTERFACE:
		switch opcode {
		case wayland.SHM_FORMAT_OPCODE:
			decoded := wayland.shm_format_decode(data)
			decoded.shm = wayland.Shm(object_id)
			return Event(decoded), true
		}
	case wayland.BUFFER_INTERFACE:
		switch opcode {
		case wayland.BUFFER_RELEASE_OPCODE:
			decoded := wayland.buffer_release_decode(data)
			decoded.buffer = wayland.Buffer(object_id)
			return Event(decoded), true
		}
	case wayland.DATA_OFFER_INTERFACE:
		switch opcode {
		case wayland.DATA_OFFER_OFFER_OPCODE:
			decoded := wayland.data_offer_offer_decode(data, allocator)
			decoded.data_offer = wayland.Data_Offer(object_id)
			return Event(decoded), true
		case wayland.DATA_OFFER_SOURCE_ACTIONS_OPCODE:
			decoded := wayland.data_offer_source_actions_decode(data)
			decoded.data_offer = wayland.Data_Offer(object_id)
			return Event(decoded), true
		case wayland.DATA_OFFER_ACTION_OPCODE:
			decoded := wayland.data_offer_action_decode(data)
			decoded.data_offer = wayland.Data_Offer(object_id)
			return Event(decoded), true
		}
	case wayland.DATA_SOURCE_INTERFACE:
		switch opcode {
		case wayland.DATA_SOURCE_TARGET_OPCODE:
			decoded := wayland.data_source_target_decode(data, allocator)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), true
		case wayland.DATA_SOURCE_SEND_OPCODE:
			decoded := wayland.data_source_send_decode(data, fds, allocator)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), true
		case wayland.DATA_SOURCE_CANCELLED_OPCODE:
			decoded := wayland.data_source_cancelled_decode(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), true
		case wayland.DATA_SOURCE_DND_DROP_PERFORMED_OPCODE:
			decoded := wayland.data_source_dnd_drop_performed_decode(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), true
		case wayland.DATA_SOURCE_DND_FINISHED_OPCODE:
			decoded := wayland.data_source_dnd_finished_decode(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), true
		case wayland.DATA_SOURCE_ACTION_OPCODE:
			decoded := wayland.data_source_action_decode(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), true
		}
	case wayland.DATA_DEVICE_INTERFACE:
		switch opcode {
		case wayland.DATA_DEVICE_DATA_OFFER_OPCODE:
			decoded := wayland.data_device_data_offer_decode(data)
			decoded.data_device = wayland.Data_Device(object_id)
			client.id_to_interface[u32(decoded.id)] = wayland.DATA_OFFER_INTERFACE
			return Event(decoded), true
		case wayland.DATA_DEVICE_ENTER_OPCODE:
			decoded := wayland.data_device_enter_decode(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), true
		case wayland.DATA_DEVICE_LEAVE_OPCODE:
			decoded := wayland.data_device_leave_decode(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), true
		case wayland.DATA_DEVICE_MOTION_OPCODE:
			decoded := wayland.data_device_motion_decode(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), true
		case wayland.DATA_DEVICE_DROP_OPCODE:
			decoded := wayland.data_device_drop_decode(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), true
		case wayland.DATA_DEVICE_SELECTION_OPCODE:
			decoded := wayland.data_device_selection_decode(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), true
		}
	case wayland.DATA_DEVICE_MANAGER_INTERFACE:
		switch opcode {
		}
	case wayland.SHELL_INTERFACE:
		switch opcode {
		}
	case wayland.SHELL_SURFACE_INTERFACE:
		switch opcode {
		case wayland.SHELL_SURFACE_PING_OPCODE:
			decoded := wayland.shell_surface_ping_decode(data)
			decoded.shell_surface = wayland.Shell_Surface(object_id)
			return Event(decoded), true
		case wayland.SHELL_SURFACE_CONFIGURE_OPCODE:
			decoded := wayland.shell_surface_configure_decode(data)
			decoded.shell_surface = wayland.Shell_Surface(object_id)
			return Event(decoded), true
		case wayland.SHELL_SURFACE_POPUP_DONE_OPCODE:
			decoded := wayland.shell_surface_popup_done_decode(data)
			decoded.shell_surface = wayland.Shell_Surface(object_id)
			return Event(decoded), true
		}
	case wayland.SURFACE_INTERFACE:
		switch opcode {
		case wayland.SURFACE_ENTER_OPCODE:
			decoded := wayland.surface_enter_decode(data)
			decoded.surface = wayland.Surface(object_id)
			return Event(decoded), true
		case wayland.SURFACE_LEAVE_OPCODE:
			decoded := wayland.surface_leave_decode(data)
			decoded.surface = wayland.Surface(object_id)
			return Event(decoded), true
		case wayland.SURFACE_PREFERRED_BUFFER_SCALE_OPCODE:
			decoded := wayland.surface_preferred_buffer_scale_decode(data)
			decoded.surface = wayland.Surface(object_id)
			return Event(decoded), true
		case wayland.SURFACE_PREFERRED_BUFFER_TRANSFORM_OPCODE:
			decoded := wayland.surface_preferred_buffer_transform_decode(data)
			decoded.surface = wayland.Surface(object_id)
			return Event(decoded), true
		}
	case wayland.SEAT_INTERFACE:
		switch opcode {
		case wayland.SEAT_CAPABILITIES_OPCODE:
			decoded := wayland.seat_capabilities_decode(data)
			decoded.seat = wayland.Seat(object_id)
			return Event(decoded), true
		case wayland.SEAT_NAME_OPCODE:
			decoded := wayland.seat_name_decode(data, allocator)
			decoded.seat = wayland.Seat(object_id)
			return Event(decoded), true
		}
	case wayland.POINTER_INTERFACE:
		switch opcode {
		case wayland.POINTER_ENTER_OPCODE:
			decoded := wayland.pointer_enter_decode(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), true
		case wayland.POINTER_LEAVE_OPCODE:
			decoded := wayland.pointer_leave_decode(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), true
		case wayland.POINTER_MOTION_OPCODE:
			decoded := wayland.pointer_motion_decode(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), true
		case wayland.POINTER_BUTTON_OPCODE:
			decoded := wayland.pointer_button_decode(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), true
		case wayland.POINTER_AXIS_OPCODE:
			decoded := wayland.pointer_axis_decode(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), true
		case wayland.POINTER_FRAME_OPCODE:
			decoded := wayland.pointer_frame_decode(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), true
		case wayland.POINTER_AXIS_SOURCE_OPCODE:
			decoded := wayland.pointer_axis_source_decode(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), true
		case wayland.POINTER_AXIS_STOP_OPCODE:
			decoded := wayland.pointer_axis_stop_decode(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), true
		case wayland.POINTER_AXIS_DISCRETE_OPCODE:
			decoded := wayland.pointer_axis_discrete_decode(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), true
		case wayland.POINTER_AXIS_VALUE120_OPCODE:
			decoded := wayland.pointer_axis_value120_decode(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), true
		case wayland.POINTER_AXIS_RELATIVE_DIRECTION_OPCODE:
			decoded := wayland.pointer_axis_relative_direction_decode(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), true
		case wayland.POINTER_WARP_OPCODE:
			decoded := wayland.pointer_warp_decode(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), true
		}
	case wayland.KEYBOARD_INTERFACE:
		switch opcode {
		case wayland.KEYBOARD_KEYMAP_OPCODE:
			decoded := wayland.keyboard_keymap_decode(data, fds)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), true
		case wayland.KEYBOARD_ENTER_OPCODE:
			decoded := wayland.keyboard_enter_decode(data, allocator)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), true
		case wayland.KEYBOARD_LEAVE_OPCODE:
			decoded := wayland.keyboard_leave_decode(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), true
		case wayland.KEYBOARD_KEY_OPCODE:
			decoded := wayland.keyboard_key_decode(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), true
		case wayland.KEYBOARD_MODIFIERS_OPCODE:
			decoded := wayland.keyboard_modifiers_decode(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), true
		case wayland.KEYBOARD_REPEAT_INFO_OPCODE:
			decoded := wayland.keyboard_repeat_info_decode(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), true
		}
	case wayland.TOUCH_INTERFACE:
		switch opcode {
		case wayland.TOUCH_DOWN_OPCODE:
			decoded := wayland.touch_down_decode(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), true
		case wayland.TOUCH_UP_OPCODE:
			decoded := wayland.touch_up_decode(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), true
		case wayland.TOUCH_MOTION_OPCODE:
			decoded := wayland.touch_motion_decode(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), true
		case wayland.TOUCH_FRAME_OPCODE:
			decoded := wayland.touch_frame_decode(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), true
		case wayland.TOUCH_CANCEL_OPCODE:
			decoded := wayland.touch_cancel_decode(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), true
		case wayland.TOUCH_SHAPE_OPCODE:
			decoded := wayland.touch_shape_decode(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), true
		case wayland.TOUCH_ORIENTATION_OPCODE:
			decoded := wayland.touch_orientation_decode(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), true
		}
	case wayland.OUTPUT_INTERFACE:
		switch opcode {
		case wayland.OUTPUT_GEOMETRY_OPCODE:
			decoded := wayland.output_geometry_decode(data, allocator)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), true
		case wayland.OUTPUT_MODE_OPCODE:
			decoded := wayland.output_mode_decode(data)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), true
		case wayland.OUTPUT_DONE_OPCODE:
			decoded := wayland.output_done_decode(data)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), true
		case wayland.OUTPUT_SCALE_OPCODE:
			decoded := wayland.output_scale_decode(data)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), true
		case wayland.OUTPUT_NAME_OPCODE:
			decoded := wayland.output_name_decode(data, allocator)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), true
		case wayland.OUTPUT_DESCRIPTION_OPCODE:
			decoded := wayland.output_description_decode(data, allocator)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), true
		}
	case wayland.REGION_INTERFACE:
		switch opcode {
		}
	case wayland.SUBCOMPOSITOR_INTERFACE:
		switch opcode {
		}
	case wayland.SUBSURFACE_INTERFACE:
		switch opcode {
		}
	case wayland.FIXES_INTERFACE:
		switch opcode {
		}
	case xdg_shell.WM_BASE_INTERFACE:
		switch opcode {
		case xdg_shell.WM_BASE_PING_OPCODE:
			decoded := xdg_shell.wm_base_ping_decode(data)
			decoded.wm_base = xdg_shell.Wm_Base(object_id)
			return Event(decoded), true
		}
	case xdg_shell.POSITIONER_INTERFACE:
		switch opcode {
		}
	case xdg_shell.SURFACE_INTERFACE:
		switch opcode {
		case xdg_shell.SURFACE_CONFIGURE_OPCODE:
			decoded := xdg_shell.surface_configure_decode(data)
			decoded.surface = xdg_shell.Surface(object_id)
			return Event(decoded), true
		}
	case xdg_shell.TOPLEVEL_INTERFACE:
		switch opcode {
		case xdg_shell.TOPLEVEL_CONFIGURE_OPCODE:
			decoded := xdg_shell.toplevel_configure_decode(data, allocator)
			decoded.toplevel = xdg_shell.Toplevel(object_id)
			return Event(decoded), true
		case xdg_shell.TOPLEVEL_CLOSE_OPCODE:
			decoded := xdg_shell.toplevel_close_decode(data)
			decoded.toplevel = xdg_shell.Toplevel(object_id)
			return Event(decoded), true
		case xdg_shell.TOPLEVEL_CONFIGURE_BOUNDS_OPCODE:
			decoded := xdg_shell.toplevel_configure_bounds_decode(data)
			decoded.toplevel = xdg_shell.Toplevel(object_id)
			return Event(decoded), true
		case xdg_shell.TOPLEVEL_WM_CAPABILITIES_OPCODE:
			decoded := xdg_shell.toplevel_wm_capabilities_decode(data, allocator)
			decoded.toplevel = xdg_shell.Toplevel(object_id)
			return Event(decoded), true
		}
	case xdg_shell.POPUP_INTERFACE:
		switch opcode {
		case xdg_shell.POPUP_CONFIGURE_OPCODE:
			decoded := xdg_shell.popup_configure_decode(data)
			decoded.popup = xdg_shell.Popup(object_id)
			return Event(decoded), true
		case xdg_shell.POPUP_POPUP_DONE_OPCODE:
			decoded := xdg_shell.popup_popup_done_decode(data)
			decoded.popup = xdg_shell.Popup(object_id)
			return Event(decoded), true
		case xdg_shell.POPUP_REPOSITIONED_OPCODE:
			decoded := xdg_shell.popup_repositioned_decode(data)
			decoded.popup = xdg_shell.Popup(object_id)
			return Event(decoded), true
		}
	}
	return
}

bind_dmabuf :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (linux_dmabuf_v1.Dmabuf, Error) {
	id, err := queue_request(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = linux_dmabuf_v1.DMABUF_INTERFACE,
		version   = e.version,
	})
	return linux_dmabuf_v1.Dmabuf(id), err
}

bind_compositor :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Compositor, Error) {
	id, err := queue_request(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.COMPOSITOR_INTERFACE,
		version   = e.version,
	})
	return wayland.Compositor(id), err
}

bind_shm :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Shm, Error) {
	id, err := queue_request(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.SHM_INTERFACE,
		version   = e.version,
	})
	return wayland.Shm(id), err
}

bind_data_device_manager :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Data_Device_Manager, Error) {
	id, err := queue_request(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.DATA_DEVICE_MANAGER_INTERFACE,
		version   = e.version,
	})
	return wayland.Data_Device_Manager(id), err
}

bind_shell :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Shell, Error) {
	id, err := queue_request(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.SHELL_INTERFACE,
		version   = e.version,
	})
	return wayland.Shell(id), err
}

bind_seat :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Seat, Error) {
	id, err := queue_request(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.SEAT_INTERFACE,
		version   = e.version,
	})
	return wayland.Seat(id), err
}

bind_output :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Output, Error) {
	id, err := queue_request(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.OUTPUT_INTERFACE,
		version   = e.version,
	})
	return wayland.Output(id), err
}

bind_subcompositor :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Subcompositor, Error) {
	id, err := queue_request(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.SUBCOMPOSITOR_INTERFACE,
		version   = e.version,
	})
	return wayland.Subcompositor(id), err
}

bind_fixes :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Fixes, Error) {
	id, err := queue_request(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.FIXES_INTERFACE,
		version   = e.version,
	})
	return wayland.Fixes(id), err
}

bind_wm_base :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (xdg_shell.Wm_Base, Error) {
	id, err := queue_request(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = xdg_shell.WM_BASE_INTERFACE,
		version   = e.version,
	})
	return xdg_shell.Wm_Base(id), err
}
