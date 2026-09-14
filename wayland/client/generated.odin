package client

import "base:runtime"
import "core:strings"
import "core:bytes"
import "core:sys/linux"

import "linux_dmabuf_v1"
import "wayland"
import "xdg_shell"

request_write :: proc {
	linux_dmabuf_v1.dmabuf_destroy_write,
	linux_dmabuf_v1.dmabuf_create_params_write,
	linux_dmabuf_v1.dmabuf_get_default_feedback_write,
	linux_dmabuf_v1.dmabuf_get_surface_feedback_write,
	linux_dmabuf_v1.buffer_params_destroy_write,
	linux_dmabuf_v1.buffer_params_add_write,
	linux_dmabuf_v1.buffer_params_create_write,
	linux_dmabuf_v1.buffer_params_create_immed_write,
	linux_dmabuf_v1.buffer_params_set_sampling_device_write,
	linux_dmabuf_v1.dmabuf_feedback_destroy_write,
	wayland.display_sync_write,
	wayland.display_get_registry_write,
	wayland.registry_bind_write,
	wayland.compositor_create_surface_write,
	wayland.compositor_create_region_write,
	wayland.compositor_release_write,
	wayland.shm_pool_create_buffer_write,
	wayland.shm_pool_destroy_write,
	wayland.shm_pool_resize_write,
	wayland.shm_create_pool_write,
	wayland.shm_release_write,
	wayland.buffer_destroy_write,
	wayland.data_offer_accept_write,
	wayland.data_offer_receive_write,
	wayland.data_offer_destroy_write,
	wayland.data_offer_finish_write,
	wayland.data_offer_set_actions_write,
	wayland.data_source_offer_write,
	wayland.data_source_destroy_write,
	wayland.data_source_set_actions_write,
	wayland.data_device_start_drag_write,
	wayland.data_device_set_selection_write,
	wayland.data_device_release_write,
	wayland.data_device_manager_create_data_source_write,
	wayland.data_device_manager_get_data_device_write,
	wayland.data_device_manager_release_write,
	wayland.shell_get_shell_surface_write,
	wayland.shell_surface_pong_write,
	wayland.shell_surface_move_write,
	wayland.shell_surface_resize_write,
	wayland.shell_surface_set_toplevel_write,
	wayland.shell_surface_set_transient_write,
	wayland.shell_surface_set_fullscreen_write,
	wayland.shell_surface_set_popup_write,
	wayland.shell_surface_set_maximized_write,
	wayland.shell_surface_set_title_write,
	wayland.shell_surface_set_class_write,
	wayland.surface_destroy_write,
	wayland.surface_attach_write,
	wayland.surface_damage_write,
	wayland.surface_frame_write,
	wayland.surface_set_opaque_region_write,
	wayland.surface_set_input_region_write,
	wayland.surface_commit_write,
	wayland.surface_set_buffer_transform_write,
	wayland.surface_set_buffer_scale_write,
	wayland.surface_damage_buffer_write,
	wayland.surface_offset_write,
	wayland.surface_get_release_write,
	wayland.seat_get_pointer_write,
	wayland.seat_get_keyboard_write,
	wayland.seat_get_touch_write,
	wayland.seat_release_write,
	wayland.pointer_set_cursor_write,
	wayland.pointer_release_write,
	wayland.keyboard_release_write,
	wayland.touch_release_write,
	wayland.output_release_write,
	wayland.region_destroy_write,
	wayland.region_add_write,
	wayland.region_subtract_write,
	wayland.subcompositor_destroy_write,
	wayland.subcompositor_get_subsurface_write,
	wayland.subsurface_destroy_write,
	wayland.subsurface_set_position_write,
	wayland.subsurface_place_above_write,
	wayland.subsurface_place_below_write,
	wayland.subsurface_set_sync_write,
	wayland.subsurface_set_desync_write,
	wayland.fixes_destroy_write,
	wayland.fixes_destroy_registry_write,
	wayland.fixes_ack_global_remove_write,
	xdg_shell.wm_base_destroy_write,
	xdg_shell.wm_base_create_positioner_write,
	xdg_shell.wm_base_get_xdg_surface_write,
	xdg_shell.wm_base_pong_write,
	xdg_shell.positioner_destroy_write,
	xdg_shell.positioner_set_size_write,
	xdg_shell.positioner_set_anchor_rect_write,
	xdg_shell.positioner_set_anchor_write,
	xdg_shell.positioner_set_gravity_write,
	xdg_shell.positioner_set_constraint_adjustment_write,
	xdg_shell.positioner_set_offset_write,
	xdg_shell.positioner_set_reactive_write,
	xdg_shell.positioner_set_parent_size_write,
	xdg_shell.positioner_set_parent_configure_write,
	xdg_shell.surface_destroy_write,
	xdg_shell.surface_get_toplevel_write,
	xdg_shell.surface_get_popup_write,
	xdg_shell.surface_set_window_geometry_write,
	xdg_shell.surface_ack_configure_write,
	xdg_shell.toplevel_destroy_write,
	xdg_shell.toplevel_set_parent_write,
	xdg_shell.toplevel_set_title_write,
	xdg_shell.toplevel_set_app_id_write,
	xdg_shell.toplevel_show_window_menu_write,
	xdg_shell.toplevel_move_write,
	xdg_shell.toplevel_resize_write,
	xdg_shell.toplevel_set_max_size_write,
	xdg_shell.toplevel_set_min_size_write,
	xdg_shell.toplevel_set_maximized_write,
	xdg_shell.toplevel_unset_maximized_write,
	xdg_shell.toplevel_set_fullscreen_write,
	xdg_shell.toplevel_unset_fullscreen_write,
	xdg_shell.toplevel_set_minimized_write,
	xdg_shell.popup_destroy_write,
	xdg_shell.popup_grab_write,
	xdg_shell.popup_reposition_write,
}

request_queue :: proc {
	linux_dmabuf_v1_dmabuf_destroy_queue,
	linux_dmabuf_v1_dmabuf_create_params_queue,
	linux_dmabuf_v1_dmabuf_get_default_feedback_queue,
	linux_dmabuf_v1_dmabuf_get_surface_feedback_queue,
	linux_dmabuf_v1_buffer_params_destroy_queue,
	linux_dmabuf_v1_buffer_params_add_queue,
	linux_dmabuf_v1_buffer_params_create_queue,
	linux_dmabuf_v1_buffer_params_create_immed_queue,
	linux_dmabuf_v1_buffer_params_set_sampling_device_queue,
	linux_dmabuf_v1_dmabuf_feedback_destroy_queue,
	wayland_display_sync_queue,
	wayland_display_get_registry_queue,
	wayland_registry_bind_queue,
	wayland_compositor_create_surface_queue,
	wayland_compositor_create_region_queue,
	wayland_compositor_release_queue,
	wayland_shm_pool_create_buffer_queue,
	wayland_shm_pool_destroy_queue,
	wayland_shm_pool_resize_queue,
	wayland_shm_create_pool_queue,
	wayland_shm_release_queue,
	wayland_buffer_destroy_queue,
	wayland_data_offer_accept_queue,
	wayland_data_offer_receive_queue,
	wayland_data_offer_destroy_queue,
	wayland_data_offer_finish_queue,
	wayland_data_offer_set_actions_queue,
	wayland_data_source_offer_queue,
	wayland_data_source_destroy_queue,
	wayland_data_source_set_actions_queue,
	wayland_data_device_start_drag_queue,
	wayland_data_device_set_selection_queue,
	wayland_data_device_release_queue,
	wayland_data_device_manager_create_data_source_queue,
	wayland_data_device_manager_get_data_device_queue,
	wayland_data_device_manager_release_queue,
	wayland_shell_get_shell_surface_queue,
	wayland_shell_surface_pong_queue,
	wayland_shell_surface_move_queue,
	wayland_shell_surface_resize_queue,
	wayland_shell_surface_set_toplevel_queue,
	wayland_shell_surface_set_transient_queue,
	wayland_shell_surface_set_fullscreen_queue,
	wayland_shell_surface_set_popup_queue,
	wayland_shell_surface_set_maximized_queue,
	wayland_shell_surface_set_title_queue,
	wayland_shell_surface_set_class_queue,
	wayland_surface_destroy_queue,
	wayland_surface_attach_queue,
	wayland_surface_damage_queue,
	wayland_surface_frame_queue,
	wayland_surface_set_opaque_region_queue,
	wayland_surface_set_input_region_queue,
	wayland_surface_commit_queue,
	wayland_surface_set_buffer_transform_queue,
	wayland_surface_set_buffer_scale_queue,
	wayland_surface_damage_buffer_queue,
	wayland_surface_offset_queue,
	wayland_surface_get_release_queue,
	wayland_seat_get_pointer_queue,
	wayland_seat_get_keyboard_queue,
	wayland_seat_get_touch_queue,
	wayland_seat_release_queue,
	wayland_pointer_set_cursor_queue,
	wayland_pointer_release_queue,
	wayland_keyboard_release_queue,
	wayland_touch_release_queue,
	wayland_output_release_queue,
	wayland_region_destroy_queue,
	wayland_region_add_queue,
	wayland_region_subtract_queue,
	wayland_subcompositor_destroy_queue,
	wayland_subcompositor_get_subsurface_queue,
	wayland_subsurface_destroy_queue,
	wayland_subsurface_set_position_queue,
	wayland_subsurface_place_above_queue,
	wayland_subsurface_place_below_queue,
	wayland_subsurface_set_sync_queue,
	wayland_subsurface_set_desync_queue,
	wayland_fixes_destroy_queue,
	wayland_fixes_destroy_registry_queue,
	wayland_fixes_ack_global_remove_queue,
	xdg_shell_wm_base_destroy_queue,
	xdg_shell_wm_base_create_positioner_queue,
	xdg_shell_wm_base_get_xdg_surface_queue,
	xdg_shell_wm_base_pong_queue,
	xdg_shell_positioner_destroy_queue,
	xdg_shell_positioner_set_size_queue,
	xdg_shell_positioner_set_anchor_rect_queue,
	xdg_shell_positioner_set_anchor_queue,
	xdg_shell_positioner_set_gravity_queue,
	xdg_shell_positioner_set_constraint_adjustment_queue,
	xdg_shell_positioner_set_offset_queue,
	xdg_shell_positioner_set_reactive_queue,
	xdg_shell_positioner_set_parent_size_queue,
	xdg_shell_positioner_set_parent_configure_queue,
	xdg_shell_surface_destroy_queue,
	xdg_shell_surface_get_toplevel_queue,
	xdg_shell_surface_get_popup_queue,
	xdg_shell_surface_set_window_geometry_queue,
	xdg_shell_surface_ack_configure_queue,
	xdg_shell_toplevel_destroy_queue,
	xdg_shell_toplevel_set_parent_queue,
	xdg_shell_toplevel_set_title_queue,
	xdg_shell_toplevel_set_app_id_queue,
	xdg_shell_toplevel_show_window_menu_queue,
	xdg_shell_toplevel_move_queue,
	xdg_shell_toplevel_resize_queue,
	xdg_shell_toplevel_set_max_size_queue,
	xdg_shell_toplevel_set_min_size_queue,
	xdg_shell_toplevel_set_maximized_queue,
	xdg_shell_toplevel_unset_maximized_queue,
	xdg_shell_toplevel_set_fullscreen_queue,
	xdg_shell_toplevel_unset_fullscreen_queue,
	xdg_shell_toplevel_set_minimized_queue,
	xdg_shell_popup_destroy_queue,
	xdg_shell_popup_grab_queue,
	xdg_shell_popup_reposition_queue,
}


linux_dmabuf_v1_dmabuf_destroy_queue :: proc(client: ^Client, req: linux_dmabuf_v1.Dmabuf_Destroy_Request) -> runtime.Allocator_Error {
	linux_dmabuf_v1.dmabuf_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.dmabuf))
	return nil
}

linux_dmabuf_v1_dmabuf_create_params_queue :: proc(client: ^Client, req: linux_dmabuf_v1.Dmabuf_Create_Params_Request) -> (ret: linux_dmabuf_v1.Buffer_Params, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	linux_dmabuf_v1.dmabuf_create_params_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, linux_dmabuf_v1.BUFFER_PARAMS_INTERFACE)
	return linux_dmabuf_v1.Buffer_Params(id), nil
}

linux_dmabuf_v1_dmabuf_get_default_feedback_queue :: proc(client: ^Client, req: linux_dmabuf_v1.Dmabuf_Get_Default_Feedback_Request) -> (ret: linux_dmabuf_v1.Dmabuf_Feedback, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	linux_dmabuf_v1.dmabuf_get_default_feedback_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, linux_dmabuf_v1.DMABUF_FEEDBACK_INTERFACE)
	return linux_dmabuf_v1.Dmabuf_Feedback(id), nil
}

linux_dmabuf_v1_dmabuf_get_surface_feedback_queue :: proc(client: ^Client, req: linux_dmabuf_v1.Dmabuf_Get_Surface_Feedback_Request) -> (ret: linux_dmabuf_v1.Dmabuf_Feedback, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	linux_dmabuf_v1.dmabuf_get_surface_feedback_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, linux_dmabuf_v1.DMABUF_FEEDBACK_INTERFACE)
	return linux_dmabuf_v1.Dmabuf_Feedback(id), nil
}

linux_dmabuf_v1_buffer_params_destroy_queue :: proc(client: ^Client, req: linux_dmabuf_v1.Buffer_Params_Destroy_Request) -> runtime.Allocator_Error {
	linux_dmabuf_v1.buffer_params_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.buffer_params))
	return nil
}

linux_dmabuf_v1_buffer_params_add_queue :: proc(client: ^Client, req: linux_dmabuf_v1.Buffer_Params_Add_Request) -> runtime.Allocator_Error {
	linux_dmabuf_v1.buffer_params_add_write(&client.requests_byte_buffer, req) or_return
	append(&client.outgoing_fds, req.fd)
	return nil
}

linux_dmabuf_v1_buffer_params_create_queue :: proc(client: ^Client, req: linux_dmabuf_v1.Buffer_Params_Create_Request) -> runtime.Allocator_Error {
	linux_dmabuf_v1.buffer_params_create_write(&client.requests_byte_buffer, req) or_return
	return nil
}

linux_dmabuf_v1_buffer_params_create_immed_queue :: proc(client: ^Client, req: linux_dmabuf_v1.Buffer_Params_Create_Immed_Request) -> (ret: wayland.Buffer, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	linux_dmabuf_v1.buffer_params_create_immed_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.BUFFER_INTERFACE)
	return wayland.Buffer(id), nil
}

linux_dmabuf_v1_buffer_params_set_sampling_device_queue :: proc(client: ^Client, req: linux_dmabuf_v1.Buffer_Params_Set_Sampling_Device_Request) -> runtime.Allocator_Error {
	linux_dmabuf_v1.buffer_params_set_sampling_device_write(&client.requests_byte_buffer, req) or_return
	return nil
}

linux_dmabuf_v1_dmabuf_feedback_destroy_queue :: proc(client: ^Client, req: linux_dmabuf_v1.Dmabuf_Feedback_Destroy_Request) -> runtime.Allocator_Error {
	linux_dmabuf_v1.dmabuf_feedback_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.dmabuf_feedback))
	return nil
}

wayland_display_sync_queue :: proc(client: ^Client, req: wayland.Display_Sync_Request) -> (ret: wayland.Callback, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.display_sync_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.CALLBACK_INTERFACE)
	return wayland.Callback(id), nil
}

wayland_display_get_registry_queue :: proc(client: ^Client, req: wayland.Display_Get_Registry_Request) -> (ret: wayland.Registry, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.display_get_registry_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.REGISTRY_INTERFACE)
	return wayland.Registry(id), nil
}

wayland_registry_bind_queue :: proc(client: ^Client, req: wayland.Registry_Bind_Request) -> (ret: u32, err: runtime.Allocator_Error) #optional_allocator_error {
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
	wayland.registry_bind_write(&client.requests_byte_buffer, rb, id) or_return
	return id, nil
}

wayland_compositor_create_surface_queue :: proc(client: ^Client, req: wayland.Compositor_Create_Surface_Request) -> (ret: wayland.Surface, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.compositor_create_surface_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.SURFACE_INTERFACE)
	return wayland.Surface(id), nil
}

wayland_compositor_create_region_queue :: proc(client: ^Client, req: wayland.Compositor_Create_Region_Request) -> (ret: wayland.Region, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.compositor_create_region_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.REGION_INTERFACE)
	return wayland.Region(id), nil
}

wayland_compositor_release_queue :: proc(client: ^Client, req: wayland.Compositor_Release_Request) -> runtime.Allocator_Error {
	wayland.compositor_release_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.compositor))
	return nil
}

wayland_shm_pool_create_buffer_queue :: proc(client: ^Client, req: wayland.Shm_Pool_Create_Buffer_Request) -> (ret: wayland.Buffer, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.shm_pool_create_buffer_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.BUFFER_INTERFACE)
	return wayland.Buffer(id), nil
}

wayland_shm_pool_destroy_queue :: proc(client: ^Client, req: wayland.Shm_Pool_Destroy_Request) -> runtime.Allocator_Error {
	wayland.shm_pool_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.shm_pool))
	return nil
}

wayland_shm_pool_resize_queue :: proc(client: ^Client, req: wayland.Shm_Pool_Resize_Request) -> runtime.Allocator_Error {
	wayland.shm_pool_resize_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shm_create_pool_queue :: proc(client: ^Client, req: wayland.Shm_Create_Pool_Request) -> (ret: wayland.Shm_Pool, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.shm_create_pool_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.SHM_POOL_INTERFACE)
	append(&client.outgoing_fds, req.fd)
	return wayland.Shm_Pool(id), nil
}

wayland_shm_release_queue :: proc(client: ^Client, req: wayland.Shm_Release_Request) -> runtime.Allocator_Error {
	wayland.shm_release_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.shm))
	return nil
}

wayland_buffer_destroy_queue :: proc(client: ^Client, req: wayland.Buffer_Destroy_Request) -> runtime.Allocator_Error {
	wayland.buffer_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.buffer))
	return nil
}

wayland_data_offer_accept_queue :: proc(client: ^Client, req: wayland.Data_Offer_Accept_Request) -> runtime.Allocator_Error {
	wayland.data_offer_accept_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_offer_receive_queue :: proc(client: ^Client, req: wayland.Data_Offer_Receive_Request) -> runtime.Allocator_Error {
	wayland.data_offer_receive_write(&client.requests_byte_buffer, req) or_return
	append(&client.outgoing_fds, req.fd)
	return nil
}

wayland_data_offer_destroy_queue :: proc(client: ^Client, req: wayland.Data_Offer_Destroy_Request) -> runtime.Allocator_Error {
	wayland.data_offer_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.data_offer))
	return nil
}

wayland_data_offer_finish_queue :: proc(client: ^Client, req: wayland.Data_Offer_Finish_Request) -> runtime.Allocator_Error {
	wayland.data_offer_finish_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_offer_set_actions_queue :: proc(client: ^Client, req: wayland.Data_Offer_Set_Actions_Request) -> runtime.Allocator_Error {
	wayland.data_offer_set_actions_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_source_offer_queue :: proc(client: ^Client, req: wayland.Data_Source_Offer_Request) -> runtime.Allocator_Error {
	wayland.data_source_offer_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_source_destroy_queue :: proc(client: ^Client, req: wayland.Data_Source_Destroy_Request) -> runtime.Allocator_Error {
	wayland.data_source_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.data_source))
	return nil
}

wayland_data_source_set_actions_queue :: proc(client: ^Client, req: wayland.Data_Source_Set_Actions_Request) -> runtime.Allocator_Error {
	wayland.data_source_set_actions_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_device_start_drag_queue :: proc(client: ^Client, req: wayland.Data_Device_Start_Drag_Request) -> runtime.Allocator_Error {
	wayland.data_device_start_drag_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_device_set_selection_queue :: proc(client: ^Client, req: wayland.Data_Device_Set_Selection_Request) -> runtime.Allocator_Error {
	wayland.data_device_set_selection_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_device_release_queue :: proc(client: ^Client, req: wayland.Data_Device_Release_Request) -> runtime.Allocator_Error {
	wayland.data_device_release_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.data_device))
	return nil
}

wayland_data_device_manager_create_data_source_queue :: proc(client: ^Client, req: wayland.Data_Device_Manager_Create_Data_Source_Request) -> (ret: wayland.Data_Source, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.data_device_manager_create_data_source_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.DATA_SOURCE_INTERFACE)
	return wayland.Data_Source(id), nil
}

wayland_data_device_manager_get_data_device_queue :: proc(client: ^Client, req: wayland.Data_Device_Manager_Get_Data_Device_Request) -> (ret: wayland.Data_Device, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.data_device_manager_get_data_device_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.DATA_DEVICE_INTERFACE)
	return wayland.Data_Device(id), nil
}

wayland_data_device_manager_release_queue :: proc(client: ^Client, req: wayland.Data_Device_Manager_Release_Request) -> runtime.Allocator_Error {
	wayland.data_device_manager_release_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.data_device_manager))
	return nil
}

wayland_shell_get_shell_surface_queue :: proc(client: ^Client, req: wayland.Shell_Get_Shell_Surface_Request) -> (ret: wayland.Shell_Surface, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.shell_get_shell_surface_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.SHELL_SURFACE_INTERFACE)
	return wayland.Shell_Surface(id), nil
}

wayland_shell_surface_pong_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Pong_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_pong_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_move_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Move_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_move_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_resize_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Resize_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_resize_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_toplevel_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Toplevel_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_toplevel_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_transient_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Transient_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_transient_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_fullscreen_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Fullscreen_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_fullscreen_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_popup_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Popup_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_popup_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_maximized_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Maximized_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_maximized_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_title_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Title_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_title_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_class_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Class_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_class_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_destroy_queue :: proc(client: ^Client, req: wayland.Surface_Destroy_Request) -> runtime.Allocator_Error {
	wayland.surface_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.surface))
	return nil
}

wayland_surface_attach_queue :: proc(client: ^Client, req: wayland.Surface_Attach_Request) -> runtime.Allocator_Error {
	wayland.surface_attach_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_damage_queue :: proc(client: ^Client, req: wayland.Surface_Damage_Request) -> runtime.Allocator_Error {
	wayland.surface_damage_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_frame_queue :: proc(client: ^Client, req: wayland.Surface_Frame_Request) -> (ret: wayland.Callback, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.surface_frame_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.CALLBACK_INTERFACE)
	return wayland.Callback(id), nil
}

wayland_surface_set_opaque_region_queue :: proc(client: ^Client, req: wayland.Surface_Set_Opaque_Region_Request) -> runtime.Allocator_Error {
	wayland.surface_set_opaque_region_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_set_input_region_queue :: proc(client: ^Client, req: wayland.Surface_Set_Input_Region_Request) -> runtime.Allocator_Error {
	wayland.surface_set_input_region_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_commit_queue :: proc(client: ^Client, req: wayland.Surface_Commit_Request) -> runtime.Allocator_Error {
	wayland.surface_commit_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_set_buffer_transform_queue :: proc(client: ^Client, req: wayland.Surface_Set_Buffer_Transform_Request) -> runtime.Allocator_Error {
	wayland.surface_set_buffer_transform_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_set_buffer_scale_queue :: proc(client: ^Client, req: wayland.Surface_Set_Buffer_Scale_Request) -> runtime.Allocator_Error {
	wayland.surface_set_buffer_scale_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_damage_buffer_queue :: proc(client: ^Client, req: wayland.Surface_Damage_Buffer_Request) -> runtime.Allocator_Error {
	wayland.surface_damage_buffer_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_offset_queue :: proc(client: ^Client, req: wayland.Surface_Offset_Request) -> runtime.Allocator_Error {
	wayland.surface_offset_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_get_release_queue :: proc(client: ^Client, req: wayland.Surface_Get_Release_Request) -> (ret: wayland.Callback, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.surface_get_release_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.CALLBACK_INTERFACE)
	return wayland.Callback(id), nil
}

wayland_seat_get_pointer_queue :: proc(client: ^Client, req: wayland.Seat_Get_Pointer_Request) -> (ret: wayland.Pointer, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.seat_get_pointer_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.POINTER_INTERFACE)
	return wayland.Pointer(id), nil
}

wayland_seat_get_keyboard_queue :: proc(client: ^Client, req: wayland.Seat_Get_Keyboard_Request) -> (ret: wayland.Keyboard, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.seat_get_keyboard_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.KEYBOARD_INTERFACE)
	return wayland.Keyboard(id), nil
}

wayland_seat_get_touch_queue :: proc(client: ^Client, req: wayland.Seat_Get_Touch_Request) -> (ret: wayland.Touch, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.seat_get_touch_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.TOUCH_INTERFACE)
	return wayland.Touch(id), nil
}

wayland_seat_release_queue :: proc(client: ^Client, req: wayland.Seat_Release_Request) -> runtime.Allocator_Error {
	wayland.seat_release_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.seat))
	return nil
}

wayland_pointer_set_cursor_queue :: proc(client: ^Client, req: wayland.Pointer_Set_Cursor_Request) -> runtime.Allocator_Error {
	wayland.pointer_set_cursor_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_pointer_release_queue :: proc(client: ^Client, req: wayland.Pointer_Release_Request) -> runtime.Allocator_Error {
	wayland.pointer_release_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.pointer))
	return nil
}

wayland_keyboard_release_queue :: proc(client: ^Client, req: wayland.Keyboard_Release_Request) -> runtime.Allocator_Error {
	wayland.keyboard_release_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.keyboard))
	return nil
}

wayland_touch_release_queue :: proc(client: ^Client, req: wayland.Touch_Release_Request) -> runtime.Allocator_Error {
	wayland.touch_release_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.touch))
	return nil
}

wayland_output_release_queue :: proc(client: ^Client, req: wayland.Output_Release_Request) -> runtime.Allocator_Error {
	wayland.output_release_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.output))
	return nil
}

wayland_region_destroy_queue :: proc(client: ^Client, req: wayland.Region_Destroy_Request) -> runtime.Allocator_Error {
	wayland.region_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.region))
	return nil
}

wayland_region_add_queue :: proc(client: ^Client, req: wayland.Region_Add_Request) -> runtime.Allocator_Error {
	wayland.region_add_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_region_subtract_queue :: proc(client: ^Client, req: wayland.Region_Subtract_Request) -> runtime.Allocator_Error {
	wayland.region_subtract_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_subcompositor_destroy_queue :: proc(client: ^Client, req: wayland.Subcompositor_Destroy_Request) -> runtime.Allocator_Error {
	wayland.subcompositor_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.subcompositor))
	return nil
}

wayland_subcompositor_get_subsurface_queue :: proc(client: ^Client, req: wayland.Subcompositor_Get_Subsurface_Request) -> (ret: wayland.Subsurface, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.subcompositor_get_subsurface_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.SUBSURFACE_INTERFACE)
	return wayland.Subsurface(id), nil
}

wayland_subsurface_destroy_queue :: proc(client: ^Client, req: wayland.Subsurface_Destroy_Request) -> runtime.Allocator_Error {
	wayland.subsurface_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.subsurface))
	return nil
}

wayland_subsurface_set_position_queue :: proc(client: ^Client, req: wayland.Subsurface_Set_Position_Request) -> runtime.Allocator_Error {
	wayland.subsurface_set_position_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_subsurface_place_above_queue :: proc(client: ^Client, req: wayland.Subsurface_Place_Above_Request) -> runtime.Allocator_Error {
	wayland.subsurface_place_above_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_subsurface_place_below_queue :: proc(client: ^Client, req: wayland.Subsurface_Place_Below_Request) -> runtime.Allocator_Error {
	wayland.subsurface_place_below_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_subsurface_set_sync_queue :: proc(client: ^Client, req: wayland.Subsurface_Set_Sync_Request) -> runtime.Allocator_Error {
	wayland.subsurface_set_sync_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_subsurface_set_desync_queue :: proc(client: ^Client, req: wayland.Subsurface_Set_Desync_Request) -> runtime.Allocator_Error {
	wayland.subsurface_set_desync_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_fixes_destroy_queue :: proc(client: ^Client, req: wayland.Fixes_Destroy_Request) -> runtime.Allocator_Error {
	wayland.fixes_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.fixes))
	return nil
}

wayland_fixes_destroy_registry_queue :: proc(client: ^Client, req: wayland.Fixes_Destroy_Registry_Request) -> runtime.Allocator_Error {
	wayland.fixes_destroy_registry_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_fixes_ack_global_remove_queue :: proc(client: ^Client, req: wayland.Fixes_Ack_Global_Remove_Request) -> runtime.Allocator_Error {
	wayland.fixes_ack_global_remove_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_wm_base_destroy_queue :: proc(client: ^Client, req: xdg_shell.Wm_Base_Destroy_Request) -> runtime.Allocator_Error {
	xdg_shell.wm_base_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.wm_base))
	return nil
}

xdg_shell_wm_base_create_positioner_queue :: proc(client: ^Client, req: xdg_shell.Wm_Base_Create_Positioner_Request) -> (ret: xdg_shell.Positioner, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	xdg_shell.wm_base_create_positioner_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, xdg_shell.POSITIONER_INTERFACE)
	return xdg_shell.Positioner(id), nil
}

xdg_shell_wm_base_get_xdg_surface_queue :: proc(client: ^Client, req: xdg_shell.Wm_Base_Get_Xdg_Surface_Request) -> (ret: xdg_shell.Surface, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	xdg_shell.wm_base_get_xdg_surface_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, xdg_shell.SURFACE_INTERFACE)
	return xdg_shell.Surface(id), nil
}

xdg_shell_wm_base_pong_queue :: proc(client: ^Client, req: xdg_shell.Wm_Base_Pong_Request) -> runtime.Allocator_Error {
	xdg_shell.wm_base_pong_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_destroy_queue :: proc(client: ^Client, req: xdg_shell.Positioner_Destroy_Request) -> runtime.Allocator_Error {
	xdg_shell.positioner_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.positioner))
	return nil
}

xdg_shell_positioner_set_size_queue :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Size_Request) -> runtime.Allocator_Error {
	xdg_shell.positioner_set_size_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_anchor_rect_queue :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Anchor_Rect_Request) -> runtime.Allocator_Error {
	xdg_shell.positioner_set_anchor_rect_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_anchor_queue :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Anchor_Request) -> runtime.Allocator_Error {
	xdg_shell.positioner_set_anchor_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_gravity_queue :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Gravity_Request) -> runtime.Allocator_Error {
	xdg_shell.positioner_set_gravity_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_constraint_adjustment_queue :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Constraint_Adjustment_Request) -> runtime.Allocator_Error {
	xdg_shell.positioner_set_constraint_adjustment_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_offset_queue :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Offset_Request) -> runtime.Allocator_Error {
	xdg_shell.positioner_set_offset_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_reactive_queue :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Reactive_Request) -> runtime.Allocator_Error {
	xdg_shell.positioner_set_reactive_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_parent_size_queue :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Parent_Size_Request) -> runtime.Allocator_Error {
	xdg_shell.positioner_set_parent_size_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_parent_configure_queue :: proc(client: ^Client, req: xdg_shell.Positioner_Set_Parent_Configure_Request) -> runtime.Allocator_Error {
	xdg_shell.positioner_set_parent_configure_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_surface_destroy_queue :: proc(client: ^Client, req: xdg_shell.Surface_Destroy_Request) -> runtime.Allocator_Error {
	xdg_shell.surface_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.surface))
	return nil
}

xdg_shell_surface_get_toplevel_queue :: proc(client: ^Client, req: xdg_shell.Surface_Get_Toplevel_Request) -> (ret: xdg_shell.Toplevel, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	xdg_shell.surface_get_toplevel_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, xdg_shell.TOPLEVEL_INTERFACE)
	return xdg_shell.Toplevel(id), nil
}

xdg_shell_surface_get_popup_queue :: proc(client: ^Client, req: xdg_shell.Surface_Get_Popup_Request) -> (ret: xdg_shell.Popup, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	xdg_shell.surface_get_popup_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, xdg_shell.POPUP_INTERFACE)
	return xdg_shell.Popup(id), nil
}

xdg_shell_surface_set_window_geometry_queue :: proc(client: ^Client, req: xdg_shell.Surface_Set_Window_Geometry_Request) -> runtime.Allocator_Error {
	xdg_shell.surface_set_window_geometry_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_surface_ack_configure_queue :: proc(client: ^Client, req: xdg_shell.Surface_Ack_Configure_Request) -> runtime.Allocator_Error {
	xdg_shell.surface_ack_configure_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_destroy_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Destroy_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.toplevel))
	return nil
}

xdg_shell_toplevel_set_parent_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Parent_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_set_parent_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_title_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Title_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_set_title_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_app_id_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_App_Id_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_set_app_id_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_show_window_menu_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Show_Window_Menu_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_show_window_menu_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_move_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Move_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_move_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_resize_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Resize_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_resize_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_max_size_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Max_Size_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_set_max_size_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_min_size_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Min_Size_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_set_min_size_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_maximized_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Maximized_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_set_maximized_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_unset_maximized_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Unset_Maximized_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_unset_maximized_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_fullscreen_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Fullscreen_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_set_fullscreen_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_unset_fullscreen_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Unset_Fullscreen_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_unset_fullscreen_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_minimized_queue :: proc(client: ^Client, req: xdg_shell.Toplevel_Set_Minimized_Request) -> runtime.Allocator_Error {
	xdg_shell.toplevel_set_minimized_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_popup_destroy_queue :: proc(client: ^Client, req: xdg_shell.Popup_Destroy_Request) -> runtime.Allocator_Error {
	xdg_shell.popup_destroy_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.popup))
	return nil
}

xdg_shell_popup_grab_queue :: proc(client: ^Client, req: xdg_shell.Popup_Grab_Request) -> runtime.Allocator_Error {
	xdg_shell.popup_grab_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_popup_reposition_queue :: proc(client: ^Client, req: xdg_shell.Popup_Reposition_Request) -> runtime.Allocator_Error {
	xdg_shell.popup_reposition_write(&client.requests_byte_buffer, req) or_return
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

event_read :: proc(client: ^Client, interface: string, object_id: u32, opcode: u16, data: []byte, fds: ^[dynamic; 28]linux.Fd, allocator := context.temp_allocator) -> (ev: Event, err: runtime.Allocator_Error) #optional_allocator_error {
	switch interface {
	case linux_dmabuf_v1.DMABUF_INTERFACE:
		switch opcode {
		case linux_dmabuf_v1.DMABUF_FORMAT_OPCODE:
			decoded, _ := linux_dmabuf_v1.dmabuf_format_read(data)
			decoded.dmabuf = linux_dmabuf_v1.Dmabuf(object_id)
			return Event(decoded), nil
		case linux_dmabuf_v1.DMABUF_MODIFIER_OPCODE:
			decoded, _ := linux_dmabuf_v1.dmabuf_modifier_read(data)
			decoded.dmabuf = linux_dmabuf_v1.Dmabuf(object_id)
			return Event(decoded), nil
		}
	case linux_dmabuf_v1.BUFFER_PARAMS_INTERFACE:
		switch opcode {
		case linux_dmabuf_v1.BUFFER_PARAMS_CREATED_OPCODE:
			decoded, _ := linux_dmabuf_v1.buffer_params_created_read(data)
			decoded.buffer_params = linux_dmabuf_v1.Buffer_Params(object_id)
			client.id_to_interface[u32(decoded.buffer)] = wayland.BUFFER_INTERFACE
			return Event(decoded), nil
		case linux_dmabuf_v1.BUFFER_PARAMS_FAILED_OPCODE:
			decoded, _ := linux_dmabuf_v1.buffer_params_failed_read(data)
			decoded.buffer_params = linux_dmabuf_v1.Buffer_Params(object_id)
			return Event(decoded), nil
		}
	case linux_dmabuf_v1.DMABUF_FEEDBACK_INTERFACE:
		switch opcode {
		case linux_dmabuf_v1.DMABUF_FEEDBACK_DONE_OPCODE:
			decoded, _ := linux_dmabuf_v1.dmabuf_feedback_done_read(data)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			return Event(decoded), nil
		case linux_dmabuf_v1.DMABUF_FEEDBACK_FORMAT_TABLE_OPCODE:
			decoded, _ := linux_dmabuf_v1.dmabuf_feedback_format_table_read(data, fds)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			return Event(decoded), nil
		case linux_dmabuf_v1.DMABUF_FEEDBACK_MAIN_DEVICE_OPCODE:
			decoded, _ := linux_dmabuf_v1.dmabuf_feedback_main_device_read(data)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			decoded.device = bytes.clone_safe(decoded.device, allocator) or_return
			return Event(decoded), nil
		case linux_dmabuf_v1.DMABUF_FEEDBACK_TRANCHE_DONE_OPCODE:
			decoded, _ := linux_dmabuf_v1.dmabuf_feedback_tranche_done_read(data)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			return Event(decoded), nil
		case linux_dmabuf_v1.DMABUF_FEEDBACK_TRANCHE_TARGET_DEVICE_OPCODE:
			decoded, _ := linux_dmabuf_v1.dmabuf_feedback_tranche_target_device_read(data)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			decoded.device = bytes.clone_safe(decoded.device, allocator) or_return
			return Event(decoded), nil
		case linux_dmabuf_v1.DMABUF_FEEDBACK_TRANCHE_FORMATS_OPCODE:
			decoded, _ := linux_dmabuf_v1.dmabuf_feedback_tranche_formats_read(data)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			decoded.indices = bytes.clone_safe(decoded.indices, allocator) or_return
			return Event(decoded), nil
		case linux_dmabuf_v1.DMABUF_FEEDBACK_TRANCHE_FLAGS_OPCODE:
			decoded, _ := linux_dmabuf_v1.dmabuf_feedback_tranche_flags_read(data)
			decoded.dmabuf_feedback = linux_dmabuf_v1.Dmabuf_Feedback(object_id)
			return Event(decoded), nil
		}
	case wayland.DISPLAY_INTERFACE:
		switch opcode {
		case wayland.DISPLAY_ERROR_OPCODE:
			decoded, _ := wayland.display_error_read(data)
			decoded.display = wayland.Display(object_id)
			decoded.message = strings.clone(decoded.message, allocator) or_return
			return Event(decoded), nil
		case wayland.DISPLAY_DELETE_ID_OPCODE:
			decoded, _ := wayland.display_delete_id_read(data)
			delete_key(&client.id_to_interface, decoded.id)
			return {}, nil
		}
	case wayland.REGISTRY_INTERFACE:
		switch opcode {
		case wayland.REGISTRY_GLOBAL_OPCODE:
			decoded, _ := wayland.registry_global_read(data)
			decoded.registry = wayland.Registry(object_id)
			decoded.interface = strings.clone(decoded.interface, allocator) or_return
			return Event(decoded), nil
		case wayland.REGISTRY_GLOBAL_REMOVE_OPCODE:
			decoded, _ := wayland.registry_global_remove_read(data)
			decoded.registry = wayland.Registry(object_id)
			return Event(decoded), nil
		}
	case wayland.CALLBACK_INTERFACE:
		switch opcode {
		case wayland.CALLBACK_DONE_OPCODE:
			delete_key(&client.id_to_interface, object_id)
			return {}, nil
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
			decoded, _ := wayland.shm_format_read(data)
			decoded.shm = wayland.Shm(object_id)
			return Event(decoded), nil
		}
	case wayland.BUFFER_INTERFACE:
		switch opcode {
		case wayland.BUFFER_RELEASE_OPCODE:
			decoded, _ := wayland.buffer_release_read(data)
			decoded.buffer = wayland.Buffer(object_id)
			return Event(decoded), nil
		}
	case wayland.DATA_OFFER_INTERFACE:
		switch opcode {
		case wayland.DATA_OFFER_OFFER_OPCODE:
			decoded, _ := wayland.data_offer_offer_read(data)
			decoded.data_offer = wayland.Data_Offer(object_id)
			decoded.mime_type = strings.clone(decoded.mime_type, allocator) or_return
			return Event(decoded), nil
		case wayland.DATA_OFFER_SOURCE_ACTIONS_OPCODE:
			decoded, _ := wayland.data_offer_source_actions_read(data)
			decoded.data_offer = wayland.Data_Offer(object_id)
			return Event(decoded), nil
		case wayland.DATA_OFFER_ACTION_OPCODE:
			decoded, _ := wayland.data_offer_action_read(data)
			decoded.data_offer = wayland.Data_Offer(object_id)
			return Event(decoded), nil
		}
	case wayland.DATA_SOURCE_INTERFACE:
		switch opcode {
		case wayland.DATA_SOURCE_TARGET_OPCODE:
			decoded, _ := wayland.data_source_target_read(data)
			decoded.data_source = wayland.Data_Source(object_id)
			decoded.mime_type = strings.clone(decoded.mime_type, allocator) or_return
			return Event(decoded), nil
		case wayland.DATA_SOURCE_SEND_OPCODE:
			decoded, _ := wayland.data_source_send_read(data, fds)
			decoded.data_source = wayland.Data_Source(object_id)
			decoded.mime_type = strings.clone(decoded.mime_type, allocator) or_return
			return Event(decoded), nil
		case wayland.DATA_SOURCE_CANCELLED_OPCODE:
			decoded, _ := wayland.data_source_cancelled_read(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), nil
		case wayland.DATA_SOURCE_DND_DROP_PERFORMED_OPCODE:
			decoded, _ := wayland.data_source_dnd_drop_performed_read(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), nil
		case wayland.DATA_SOURCE_DND_FINISHED_OPCODE:
			decoded, _ := wayland.data_source_dnd_finished_read(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), nil
		case wayland.DATA_SOURCE_ACTION_OPCODE:
			decoded, _ := wayland.data_source_action_read(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), nil
		}
	case wayland.DATA_DEVICE_INTERFACE:
		switch opcode {
		case wayland.DATA_DEVICE_DATA_OFFER_OPCODE:
			decoded, _ := wayland.data_device_data_offer_read(data)
			decoded.data_device = wayland.Data_Device(object_id)
			client.id_to_interface[u32(decoded.id)] = wayland.DATA_OFFER_INTERFACE
			return Event(decoded), nil
		case wayland.DATA_DEVICE_ENTER_OPCODE:
			decoded, _ := wayland.data_device_enter_read(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), nil
		case wayland.DATA_DEVICE_LEAVE_OPCODE:
			decoded, _ := wayland.data_device_leave_read(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), nil
		case wayland.DATA_DEVICE_MOTION_OPCODE:
			decoded, _ := wayland.data_device_motion_read(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), nil
		case wayland.DATA_DEVICE_DROP_OPCODE:
			decoded, _ := wayland.data_device_drop_read(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), nil
		case wayland.DATA_DEVICE_SELECTION_OPCODE:
			decoded, _ := wayland.data_device_selection_read(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), nil
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
			decoded, _ := wayland.shell_surface_ping_read(data)
			decoded.shell_surface = wayland.Shell_Surface(object_id)
			return Event(decoded), nil
		case wayland.SHELL_SURFACE_CONFIGURE_OPCODE:
			decoded, _ := wayland.shell_surface_configure_read(data)
			decoded.shell_surface = wayland.Shell_Surface(object_id)
			return Event(decoded), nil
		case wayland.SHELL_SURFACE_POPUP_DONE_OPCODE:
			decoded, _ := wayland.shell_surface_popup_done_read(data)
			decoded.shell_surface = wayland.Shell_Surface(object_id)
			return Event(decoded), nil
		}
	case wayland.SURFACE_INTERFACE:
		switch opcode {
		case wayland.SURFACE_ENTER_OPCODE:
			decoded, _ := wayland.surface_enter_read(data)
			decoded.surface = wayland.Surface(object_id)
			return Event(decoded), nil
		case wayland.SURFACE_LEAVE_OPCODE:
			decoded, _ := wayland.surface_leave_read(data)
			decoded.surface = wayland.Surface(object_id)
			return Event(decoded), nil
		case wayland.SURFACE_PREFERRED_BUFFER_SCALE_OPCODE:
			decoded, _ := wayland.surface_preferred_buffer_scale_read(data)
			decoded.surface = wayland.Surface(object_id)
			return Event(decoded), nil
		case wayland.SURFACE_PREFERRED_BUFFER_TRANSFORM_OPCODE:
			decoded, _ := wayland.surface_preferred_buffer_transform_read(data)
			decoded.surface = wayland.Surface(object_id)
			return Event(decoded), nil
		}
	case wayland.SEAT_INTERFACE:
		switch opcode {
		case wayland.SEAT_CAPABILITIES_OPCODE:
			decoded, _ := wayland.seat_capabilities_read(data)
			decoded.seat = wayland.Seat(object_id)
			return Event(decoded), nil
		case wayland.SEAT_NAME_OPCODE:
			decoded, _ := wayland.seat_name_read(data)
			decoded.seat = wayland.Seat(object_id)
			decoded.name = strings.clone(decoded.name, allocator) or_return
			return Event(decoded), nil
		}
	case wayland.POINTER_INTERFACE:
		switch opcode {
		case wayland.POINTER_ENTER_OPCODE:
			decoded, _ := wayland.pointer_enter_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_LEAVE_OPCODE:
			decoded, _ := wayland.pointer_leave_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_MOTION_OPCODE:
			decoded, _ := wayland.pointer_motion_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_BUTTON_OPCODE:
			decoded, _ := wayland.pointer_button_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_AXIS_OPCODE:
			decoded, _ := wayland.pointer_axis_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_FRAME_OPCODE:
			decoded, _ := wayland.pointer_frame_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_AXIS_SOURCE_OPCODE:
			decoded, _ := wayland.pointer_axis_source_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_AXIS_STOP_OPCODE:
			decoded, _ := wayland.pointer_axis_stop_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_AXIS_DISCRETE_OPCODE:
			decoded, _ := wayland.pointer_axis_discrete_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_AXIS_VALUE120_OPCODE:
			decoded, _ := wayland.pointer_axis_value120_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_AXIS_RELATIVE_DIRECTION_OPCODE:
			decoded, _ := wayland.pointer_axis_relative_direction_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_WARP_OPCODE:
			decoded, _ := wayland.pointer_warp_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		}
	case wayland.KEYBOARD_INTERFACE:
		switch opcode {
		case wayland.KEYBOARD_KEYMAP_OPCODE:
			decoded, _ := wayland.keyboard_keymap_read(data, fds)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), nil
		case wayland.KEYBOARD_ENTER_OPCODE:
			decoded, _ := wayland.keyboard_enter_read(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			decoded.keys = bytes.clone_safe(decoded.keys, allocator) or_return
			return Event(decoded), nil
		case wayland.KEYBOARD_LEAVE_OPCODE:
			decoded, _ := wayland.keyboard_leave_read(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), nil
		case wayland.KEYBOARD_KEY_OPCODE:
			decoded, _ := wayland.keyboard_key_read(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), nil
		case wayland.KEYBOARD_MODIFIERS_OPCODE:
			decoded, _ := wayland.keyboard_modifiers_read(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), nil
		case wayland.KEYBOARD_REPEAT_INFO_OPCODE:
			decoded, _ := wayland.keyboard_repeat_info_read(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), nil
		}
	case wayland.TOUCH_INTERFACE:
		switch opcode {
		case wayland.TOUCH_DOWN_OPCODE:
			decoded, _ := wayland.touch_down_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		case wayland.TOUCH_UP_OPCODE:
			decoded, _ := wayland.touch_up_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		case wayland.TOUCH_MOTION_OPCODE:
			decoded, _ := wayland.touch_motion_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		case wayland.TOUCH_FRAME_OPCODE:
			decoded, _ := wayland.touch_frame_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		case wayland.TOUCH_CANCEL_OPCODE:
			decoded, _ := wayland.touch_cancel_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		case wayland.TOUCH_SHAPE_OPCODE:
			decoded, _ := wayland.touch_shape_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		case wayland.TOUCH_ORIENTATION_OPCODE:
			decoded, _ := wayland.touch_orientation_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		}
	case wayland.OUTPUT_INTERFACE:
		switch opcode {
		case wayland.OUTPUT_GEOMETRY_OPCODE:
			decoded, _ := wayland.output_geometry_read(data)
			decoded.output = wayland.Output(object_id)
			decoded.make = strings.clone(decoded.make, allocator) or_return
			decoded.model = strings.clone(decoded.model, allocator) or_return
			return Event(decoded), nil
		case wayland.OUTPUT_MODE_OPCODE:
			decoded, _ := wayland.output_mode_read(data)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), nil
		case wayland.OUTPUT_DONE_OPCODE:
			decoded, _ := wayland.output_done_read(data)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), nil
		case wayland.OUTPUT_SCALE_OPCODE:
			decoded, _ := wayland.output_scale_read(data)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), nil
		case wayland.OUTPUT_NAME_OPCODE:
			decoded, _ := wayland.output_name_read(data)
			decoded.output = wayland.Output(object_id)
			decoded.name = strings.clone(decoded.name, allocator) or_return
			return Event(decoded), nil
		case wayland.OUTPUT_DESCRIPTION_OPCODE:
			decoded, _ := wayland.output_description_read(data)
			decoded.output = wayland.Output(object_id)
			decoded.description = strings.clone(decoded.description, allocator) or_return
			return Event(decoded), nil
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
			decoded, _ := xdg_shell.wm_base_ping_read(data)
			decoded.wm_base = xdg_shell.Wm_Base(object_id)
			return Event(decoded), nil
		}
	case xdg_shell.POSITIONER_INTERFACE:
		switch opcode {
		}
	case xdg_shell.SURFACE_INTERFACE:
		switch opcode {
		case xdg_shell.SURFACE_CONFIGURE_OPCODE:
			decoded, _ := xdg_shell.surface_configure_read(data)
			decoded.surface = xdg_shell.Surface(object_id)
			return Event(decoded), nil
		}
	case xdg_shell.TOPLEVEL_INTERFACE:
		switch opcode {
		case xdg_shell.TOPLEVEL_CONFIGURE_OPCODE:
			decoded, _ := xdg_shell.toplevel_configure_read(data)
			decoded.toplevel = xdg_shell.Toplevel(object_id)
			decoded.states = bytes.clone_safe(decoded.states, allocator) or_return
			return Event(decoded), nil
		case xdg_shell.TOPLEVEL_CLOSE_OPCODE:
			decoded, _ := xdg_shell.toplevel_close_read(data)
			decoded.toplevel = xdg_shell.Toplevel(object_id)
			return Event(decoded), nil
		case xdg_shell.TOPLEVEL_CONFIGURE_BOUNDS_OPCODE:
			decoded, _ := xdg_shell.toplevel_configure_bounds_read(data)
			decoded.toplevel = xdg_shell.Toplevel(object_id)
			return Event(decoded), nil
		case xdg_shell.TOPLEVEL_WM_CAPABILITIES_OPCODE:
			decoded, _ := xdg_shell.toplevel_wm_capabilities_read(data)
			decoded.toplevel = xdg_shell.Toplevel(object_id)
			decoded.capabilities = bytes.clone_safe(decoded.capabilities, allocator) or_return
			return Event(decoded), nil
		}
	case xdg_shell.POPUP_INTERFACE:
		switch opcode {
		case xdg_shell.POPUP_CONFIGURE_OPCODE:
			decoded, _ := xdg_shell.popup_configure_read(data)
			decoded.popup = xdg_shell.Popup(object_id)
			return Event(decoded), nil
		case xdg_shell.POPUP_POPUP_DONE_OPCODE:
			decoded, _ := xdg_shell.popup_popup_done_read(data)
			decoded.popup = xdg_shell.Popup(object_id)
			return Event(decoded), nil
		case xdg_shell.POPUP_REPOSITIONED_OPCODE:
			decoded, _ := xdg_shell.popup_repositioned_read(data)
			decoded.popup = xdg_shell.Popup(object_id)
			return Event(decoded), nil
		}
	}
	return {}, nil
}

bind_dmabuf :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (linux_dmabuf_v1.Dmabuf, Error) {
	id, err := request_queue(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = linux_dmabuf_v1.DMABUF_INTERFACE,
		version   = e.version,
	})
	return linux_dmabuf_v1.Dmabuf(id), err
}

bind_compositor :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Compositor, Error) {
	id, err := request_queue(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.COMPOSITOR_INTERFACE,
		version   = e.version,
	})
	return wayland.Compositor(id), err
}

bind_shm :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Shm, Error) {
	id, err := request_queue(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.SHM_INTERFACE,
		version   = e.version,
	})
	return wayland.Shm(id), err
}

bind_data_device_manager :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Data_Device_Manager, Error) {
	id, err := request_queue(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.DATA_DEVICE_MANAGER_INTERFACE,
		version   = e.version,
	})
	return wayland.Data_Device_Manager(id), err
}

bind_shell :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Shell, Error) {
	id, err := request_queue(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.SHELL_INTERFACE,
		version   = e.version,
	})
	return wayland.Shell(id), err
}

bind_seat :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Seat, Error) {
	id, err := request_queue(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.SEAT_INTERFACE,
		version   = e.version,
	})
	return wayland.Seat(id), err
}

bind_output :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Output, Error) {
	id, err := request_queue(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.OUTPUT_INTERFACE,
		version   = e.version,
	})
	return wayland.Output(id), err
}

bind_subcompositor :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Subcompositor, Error) {
	id, err := request_queue(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.SUBCOMPOSITOR_INTERFACE,
		version   = e.version,
	})
	return wayland.Subcompositor(id), err
}

bind_fixes :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wayland.Fixes, Error) {
	id, err := request_queue(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wayland.FIXES_INTERFACE,
		version   = e.version,
	})
	return wayland.Fixes(id), err
}

bind_wm_base :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (xdg_shell.Wm_Base, Error) {
	id, err := request_queue(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = xdg_shell.WM_BASE_INTERFACE,
		version   = e.version,
	})
	return xdg_shell.Wm_Base(id), err
}
