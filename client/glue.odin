package client

import "base:runtime"
import "core:sys/linux"
import "wayland"
import "wp"
import "xdg"

Request :: union {
	wayland.Display_Sync_Request,
	wayland.Display_Get_Registry_Request,
	wayland.Registry_Bind_Request,
	wayland.Compositor_Create_Surface_Request,
	wayland.Compositor_Create_Region_Request,
	wayland.Compositor_Release_Request,
	wayland.Shm_Pool_Create_Buffer_Request,
	wayland.Shm_Pool_Destroy_Request,
	wayland.Shm_Pool_Resize_Request,
	wayland.Shm_Create_Pool_Request,
	wayland.Shm_Release_Request,
	wayland.Buffer_Destroy_Request,
	wayland.Data_Offer_Accept_Request,
	wayland.Data_Offer_Receive_Request,
	wayland.Data_Offer_Destroy_Request,
	wayland.Data_Offer_Finish_Request,
	wayland.Data_Offer_Set_Actions_Request,
	wayland.Data_Source_Offer_Request,
	wayland.Data_Source_Destroy_Request,
	wayland.Data_Source_Set_Actions_Request,
	wayland.Data_Device_Start_Drag_Request,
	wayland.Data_Device_Set_Selection_Request,
	wayland.Data_Device_Release_Request,
	wayland.Data_Device_Manager_Create_Data_Source_Request,
	wayland.Data_Device_Manager_Get_Data_Device_Request,
	wayland.Data_Device_Manager_Release_Request,
	wayland.Shell_Get_Shell_Surface_Request,
	wayland.Shell_Surface_Pong_Request,
	wayland.Shell_Surface_Move_Request,
	wayland.Shell_Surface_Resize_Request,
	wayland.Shell_Surface_Set_Toplevel_Request,
	wayland.Shell_Surface_Set_Transient_Request,
	wayland.Shell_Surface_Set_Fullscreen_Request,
	wayland.Shell_Surface_Set_Popup_Request,
	wayland.Shell_Surface_Set_Maximized_Request,
	wayland.Shell_Surface_Set_Title_Request,
	wayland.Shell_Surface_Set_Class_Request,
	wayland.Surface_Destroy_Request,
	wayland.Surface_Attach_Request,
	wayland.Surface_Damage_Request,
	wayland.Surface_Frame_Request,
	wayland.Surface_Set_Opaque_Region_Request,
	wayland.Surface_Set_Input_Region_Request,
	wayland.Surface_Commit_Request,
	wayland.Surface_Set_Buffer_Transform_Request,
	wayland.Surface_Set_Buffer_Scale_Request,
	wayland.Surface_Damage_Buffer_Request,
	wayland.Surface_Offset_Request,
	wayland.Surface_Get_Release_Request,
	wayland.Seat_Get_Pointer_Request,
	wayland.Seat_Get_Keyboard_Request,
	wayland.Seat_Get_Touch_Request,
	wayland.Seat_Release_Request,
	wayland.Pointer_Set_Cursor_Request,
	wayland.Pointer_Release_Request,
	wayland.Keyboard_Release_Request,
	wayland.Touch_Release_Request,
	wayland.Output_Release_Request,
	wayland.Region_Destroy_Request,
	wayland.Region_Add_Request,
	wayland.Region_Subtract_Request,
	wayland.Subcompositor_Destroy_Request,
	wayland.Subcompositor_Get_Subsurface_Request,
	wayland.Subsurface_Destroy_Request,
	wayland.Subsurface_Set_Position_Request,
	wayland.Subsurface_Place_Above_Request,
	wayland.Subsurface_Place_Below_Request,
	wayland.Subsurface_Set_Sync_Request,
	wayland.Subsurface_Set_Desync_Request,
	wayland.Fixes_Destroy_Request,
	wayland.Fixes_Destroy_Registry_Request,
	wayland.Fixes_Ack_Global_Remove_Request,
	wp.Linux_Dmabuf_V1_Destroy_Request,
	wp.Linux_Dmabuf_V1_Create_Params_Request,
	wp.Linux_Dmabuf_V1_Get_Default_Feedback_Request,
	wp.Linux_Dmabuf_V1_Get_Surface_Feedback_Request,
	wp.Linux_Buffer_Params_V1_Destroy_Request,
	wp.Linux_Buffer_Params_V1_Add_Request,
	wp.Linux_Buffer_Params_V1_Create_Request,
	wp.Linux_Buffer_Params_V1_Create_Immed_Request,
	wp.Linux_Buffer_Params_V1_Set_Sampling_Device_Request,
	wp.Linux_Dmabuf_Feedback_V1_Destroy_Request,
	xdg.Wm_Base_Destroy_Request,
	xdg.Wm_Base_Create_Positioner_Request,
	xdg.Wm_Base_Get_Xdg_Surface_Request,
	xdg.Wm_Base_Pong_Request,
	xdg.Positioner_Destroy_Request,
	xdg.Positioner_Set_Size_Request,
	xdg.Positioner_Set_Anchor_Rect_Request,
	xdg.Positioner_Set_Anchor_Request,
	xdg.Positioner_Set_Gravity_Request,
	xdg.Positioner_Set_Constraint_Adjustment_Request,
	xdg.Positioner_Set_Offset_Request,
	xdg.Positioner_Set_Reactive_Request,
	xdg.Positioner_Set_Parent_Size_Request,
	xdg.Positioner_Set_Parent_Configure_Request,
	xdg.Surface_Destroy_Request,
	xdg.Surface_Get_Toplevel_Request,
	xdg.Surface_Get_Popup_Request,
	xdg.Surface_Set_Window_Geometry_Request,
	xdg.Surface_Ack_Configure_Request,
	xdg.Toplevel_Destroy_Request,
	xdg.Toplevel_Set_Parent_Request,
	xdg.Toplevel_Set_Title_Request,
	xdg.Toplevel_Set_App_Id_Request,
	xdg.Toplevel_Show_Window_Menu_Request,
	xdg.Toplevel_Move_Request,
	xdg.Toplevel_Resize_Request,
	xdg.Toplevel_Set_Max_Size_Request,
	xdg.Toplevel_Set_Min_Size_Request,
	xdg.Toplevel_Set_Maximized_Request,
	xdg.Toplevel_Unset_Maximized_Request,
	xdg.Toplevel_Set_Fullscreen_Request,
	xdg.Toplevel_Unset_Fullscreen_Request,
	xdg.Toplevel_Set_Minimized_Request,
	xdg.Popup_Destroy_Request,
	xdg.Popup_Grab_Request,
	xdg.Popup_Reposition_Request,
}

request_queue :: proc{
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
	linux_dmabuf_v1_linux_dmabuf_v1_destroy_queue,
	linux_dmabuf_v1_linux_dmabuf_v1_create_params_queue,
	linux_dmabuf_v1_linux_dmabuf_v1_get_default_feedback_queue,
	linux_dmabuf_v1_linux_dmabuf_v1_get_surface_feedback_queue,
	linux_dmabuf_v1_linux_buffer_params_v1_destroy_queue,
	linux_dmabuf_v1_linux_buffer_params_v1_add_queue,
	linux_dmabuf_v1_linux_buffer_params_v1_create_queue,
	linux_dmabuf_v1_linux_buffer_params_v1_create_immed_queue,
	linux_dmabuf_v1_linux_buffer_params_v1_set_sampling_device_queue,
	linux_dmabuf_v1_linux_dmabuf_feedback_v1_destroy_queue,
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

wayland_display_sync_queue :: proc(client: ^Client, req: wayland.Display_Sync_Request) -> (ret: wayland.Callback, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.display_sync_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.CALLBACK_INTERFACE)
	return wayland.Callback(id), nil
}

wayland_display_get_registry_queue :: proc(client: ^Client, req: wayland.Display_Get_Registry_Request) -> (ret: wayland.Registry, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.display_get_registry_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.REGISTRY_INTERFACE)
	return wayland.Registry(id), nil
}

wayland_registry_bind_queue :: proc(client: ^Client, req: wayland.Registry_Bind_Request) -> (ret: u32, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	rb := req
	switch rb.interface {
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
	case wp.LINUX_DMABUF_V1_INTERFACE:
		rb.version = min(rb.version, wp.LINUX_DMABUF_V1_VERSION)
		register_object(client, id, wp.LINUX_DMABUF_V1_INTERFACE)
	case xdg.WM_BASE_INTERFACE:
		rb.version = min(rb.version, xdg.WM_BASE_VERSION)
		register_object(client, id, xdg.WM_BASE_INTERFACE)
	}
	wayland.registry_bind_request_write(&client.requests_byte_buffer, rb, id) or_return
	return id, nil
}

wayland_compositor_create_surface_queue :: proc(client: ^Client, req: wayland.Compositor_Create_Surface_Request) -> (ret: wayland.Surface, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.compositor_create_surface_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.SURFACE_INTERFACE)
	return wayland.Surface(id), nil
}

wayland_compositor_create_region_queue :: proc(client: ^Client, req: wayland.Compositor_Create_Region_Request) -> (ret: wayland.Region, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.compositor_create_region_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.REGION_INTERFACE)
	return wayland.Region(id), nil
}

wayland_compositor_release_queue :: proc(client: ^Client, req: wayland.Compositor_Release_Request) -> runtime.Allocator_Error {
	wayland.compositor_release_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.compositor))
	return nil
}

wayland_shm_pool_create_buffer_queue :: proc(client: ^Client, req: wayland.Shm_Pool_Create_Buffer_Request) -> (ret: wayland.Buffer, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.shm_pool_create_buffer_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.BUFFER_INTERFACE)
	return wayland.Buffer(id), nil
}

wayland_shm_pool_destroy_queue :: proc(client: ^Client, req: wayland.Shm_Pool_Destroy_Request) -> runtime.Allocator_Error {
	wayland.shm_pool_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.shm_pool))
	return nil
}

wayland_shm_pool_resize_queue :: proc(client: ^Client, req: wayland.Shm_Pool_Resize_Request) -> runtime.Allocator_Error {
	wayland.shm_pool_resize_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shm_create_pool_queue :: proc(client: ^Client, req: wayland.Shm_Create_Pool_Request) -> (ret: wayland.Shm_Pool, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.shm_create_pool_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.SHM_POOL_INTERFACE)
	append(&client.outgoing_fds, req.fd)
	return wayland.Shm_Pool(id), nil
}

wayland_shm_release_queue :: proc(client: ^Client, req: wayland.Shm_Release_Request) -> runtime.Allocator_Error {
	wayland.shm_release_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.shm))
	return nil
}

wayland_buffer_destroy_queue :: proc(client: ^Client, req: wayland.Buffer_Destroy_Request) -> runtime.Allocator_Error {
	wayland.buffer_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.buffer))
	return nil
}

wayland_data_offer_accept_queue :: proc(client: ^Client, req: wayland.Data_Offer_Accept_Request) -> runtime.Allocator_Error {
	wayland.data_offer_accept_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_offer_receive_queue :: proc(client: ^Client, req: wayland.Data_Offer_Receive_Request) -> runtime.Allocator_Error {
	wayland.data_offer_receive_request_write(&client.requests_byte_buffer, req) or_return
	append(&client.outgoing_fds, req.fd)
	return nil
}

wayland_data_offer_destroy_queue :: proc(client: ^Client, req: wayland.Data_Offer_Destroy_Request) -> runtime.Allocator_Error {
	wayland.data_offer_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.data_offer))
	return nil
}

wayland_data_offer_finish_queue :: proc(client: ^Client, req: wayland.Data_Offer_Finish_Request) -> runtime.Allocator_Error {
	wayland.data_offer_finish_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_offer_set_actions_queue :: proc(client: ^Client, req: wayland.Data_Offer_Set_Actions_Request) -> runtime.Allocator_Error {
	wayland.data_offer_set_actions_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_source_offer_queue :: proc(client: ^Client, req: wayland.Data_Source_Offer_Request) -> runtime.Allocator_Error {
	wayland.data_source_offer_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_source_destroy_queue :: proc(client: ^Client, req: wayland.Data_Source_Destroy_Request) -> runtime.Allocator_Error {
	wayland.data_source_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.data_source))
	return nil
}

wayland_data_source_set_actions_queue :: proc(client: ^Client, req: wayland.Data_Source_Set_Actions_Request) -> runtime.Allocator_Error {
	wayland.data_source_set_actions_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_device_start_drag_queue :: proc(client: ^Client, req: wayland.Data_Device_Start_Drag_Request) -> runtime.Allocator_Error {
	wayland.data_device_start_drag_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_device_set_selection_queue :: proc(client: ^Client, req: wayland.Data_Device_Set_Selection_Request) -> runtime.Allocator_Error {
	wayland.data_device_set_selection_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_data_device_release_queue :: proc(client: ^Client, req: wayland.Data_Device_Release_Request) -> runtime.Allocator_Error {
	wayland.data_device_release_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.data_device))
	return nil
}

wayland_data_device_manager_create_data_source_queue :: proc(client: ^Client, req: wayland.Data_Device_Manager_Create_Data_Source_Request) -> (ret: wayland.Data_Source, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.data_device_manager_create_data_source_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.DATA_SOURCE_INTERFACE)
	return wayland.Data_Source(id), nil
}

wayland_data_device_manager_get_data_device_queue :: proc(client: ^Client, req: wayland.Data_Device_Manager_Get_Data_Device_Request) -> (ret: wayland.Data_Device, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.data_device_manager_get_data_device_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.DATA_DEVICE_INTERFACE)
	return wayland.Data_Device(id), nil
}

wayland_data_device_manager_release_queue :: proc(client: ^Client, req: wayland.Data_Device_Manager_Release_Request) -> runtime.Allocator_Error {
	wayland.data_device_manager_release_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.data_device_manager))
	return nil
}

wayland_shell_get_shell_surface_queue :: proc(client: ^Client, req: wayland.Shell_Get_Shell_Surface_Request) -> (ret: wayland.Shell_Surface, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.shell_get_shell_surface_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.SHELL_SURFACE_INTERFACE)
	return wayland.Shell_Surface(id), nil
}

wayland_shell_surface_pong_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Pong_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_pong_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_move_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Move_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_move_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_resize_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Resize_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_resize_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_toplevel_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Toplevel_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_toplevel_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_transient_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Transient_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_transient_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_fullscreen_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Fullscreen_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_fullscreen_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_popup_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Popup_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_popup_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_maximized_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Maximized_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_maximized_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_title_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Title_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_title_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_shell_surface_set_class_queue :: proc(client: ^Client, req: wayland.Shell_Surface_Set_Class_Request) -> runtime.Allocator_Error {
	wayland.shell_surface_set_class_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_destroy_queue :: proc(client: ^Client, req: wayland.Surface_Destroy_Request) -> runtime.Allocator_Error {
	wayland.surface_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.surface))
	return nil
}

wayland_surface_attach_queue :: proc(client: ^Client, req: wayland.Surface_Attach_Request) -> runtime.Allocator_Error {
	wayland.surface_attach_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_damage_queue :: proc(client: ^Client, req: wayland.Surface_Damage_Request) -> runtime.Allocator_Error {
	wayland.surface_damage_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_frame_queue :: proc(client: ^Client, req: wayland.Surface_Frame_Request) -> (ret: wayland.Callback, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.surface_frame_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.CALLBACK_INTERFACE)
	return wayland.Callback(id), nil
}

wayland_surface_set_opaque_region_queue :: proc(client: ^Client, req: wayland.Surface_Set_Opaque_Region_Request) -> runtime.Allocator_Error {
	wayland.surface_set_opaque_region_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_set_input_region_queue :: proc(client: ^Client, req: wayland.Surface_Set_Input_Region_Request) -> runtime.Allocator_Error {
	wayland.surface_set_input_region_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_commit_queue :: proc(client: ^Client, req: wayland.Surface_Commit_Request) -> runtime.Allocator_Error {
	wayland.surface_commit_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_set_buffer_transform_queue :: proc(client: ^Client, req: wayland.Surface_Set_Buffer_Transform_Request) -> runtime.Allocator_Error {
	wayland.surface_set_buffer_transform_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_set_buffer_scale_queue :: proc(client: ^Client, req: wayland.Surface_Set_Buffer_Scale_Request) -> runtime.Allocator_Error {
	wayland.surface_set_buffer_scale_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_damage_buffer_queue :: proc(client: ^Client, req: wayland.Surface_Damage_Buffer_Request) -> runtime.Allocator_Error {
	wayland.surface_damage_buffer_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_offset_queue :: proc(client: ^Client, req: wayland.Surface_Offset_Request) -> runtime.Allocator_Error {
	wayland.surface_offset_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_surface_get_release_queue :: proc(client: ^Client, req: wayland.Surface_Get_Release_Request) -> (ret: wayland.Callback, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.surface_get_release_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.CALLBACK_INTERFACE)
	return wayland.Callback(id), nil
}

wayland_seat_get_pointer_queue :: proc(client: ^Client, req: wayland.Seat_Get_Pointer_Request) -> (ret: wayland.Pointer, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.seat_get_pointer_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.POINTER_INTERFACE)
	return wayland.Pointer(id), nil
}

wayland_seat_get_keyboard_queue :: proc(client: ^Client, req: wayland.Seat_Get_Keyboard_Request) -> (ret: wayland.Keyboard, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.seat_get_keyboard_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.KEYBOARD_INTERFACE)
	return wayland.Keyboard(id), nil
}

wayland_seat_get_touch_queue :: proc(client: ^Client, req: wayland.Seat_Get_Touch_Request) -> (ret: wayland.Touch, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.seat_get_touch_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.TOUCH_INTERFACE)
	return wayland.Touch(id), nil
}

wayland_seat_release_queue :: proc(client: ^Client, req: wayland.Seat_Release_Request) -> runtime.Allocator_Error {
	wayland.seat_release_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.seat))
	return nil
}

wayland_pointer_set_cursor_queue :: proc(client: ^Client, req: wayland.Pointer_Set_Cursor_Request) -> runtime.Allocator_Error {
	wayland.pointer_set_cursor_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_pointer_release_queue :: proc(client: ^Client, req: wayland.Pointer_Release_Request) -> runtime.Allocator_Error {
	wayland.pointer_release_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.pointer))
	return nil
}

wayland_keyboard_release_queue :: proc(client: ^Client, req: wayland.Keyboard_Release_Request) -> runtime.Allocator_Error {
	wayland.keyboard_release_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.keyboard))
	return nil
}

wayland_touch_release_queue :: proc(client: ^Client, req: wayland.Touch_Release_Request) -> runtime.Allocator_Error {
	wayland.touch_release_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.touch))
	return nil
}

wayland_output_release_queue :: proc(client: ^Client, req: wayland.Output_Release_Request) -> runtime.Allocator_Error {
	wayland.output_release_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.output))
	return nil
}

wayland_region_destroy_queue :: proc(client: ^Client, req: wayland.Region_Destroy_Request) -> runtime.Allocator_Error {
	wayland.region_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.region))
	return nil
}

wayland_region_add_queue :: proc(client: ^Client, req: wayland.Region_Add_Request) -> runtime.Allocator_Error {
	wayland.region_add_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_region_subtract_queue :: proc(client: ^Client, req: wayland.Region_Subtract_Request) -> runtime.Allocator_Error {
	wayland.region_subtract_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_subcompositor_destroy_queue :: proc(client: ^Client, req: wayland.Subcompositor_Destroy_Request) -> runtime.Allocator_Error {
	wayland.subcompositor_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.subcompositor))
	return nil
}

wayland_subcompositor_get_subsurface_queue :: proc(client: ^Client, req: wayland.Subcompositor_Get_Subsurface_Request) -> (ret: wayland.Subsurface, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wayland.subcompositor_get_subsurface_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.SUBSURFACE_INTERFACE)
	return wayland.Subsurface(id), nil
}

wayland_subsurface_destroy_queue :: proc(client: ^Client, req: wayland.Subsurface_Destroy_Request) -> runtime.Allocator_Error {
	wayland.subsurface_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.subsurface))
	return nil
}

wayland_subsurface_set_position_queue :: proc(client: ^Client, req: wayland.Subsurface_Set_Position_Request) -> runtime.Allocator_Error {
	wayland.subsurface_set_position_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_subsurface_place_above_queue :: proc(client: ^Client, req: wayland.Subsurface_Place_Above_Request) -> runtime.Allocator_Error {
	wayland.subsurface_place_above_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_subsurface_place_below_queue :: proc(client: ^Client, req: wayland.Subsurface_Place_Below_Request) -> runtime.Allocator_Error {
	wayland.subsurface_place_below_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_subsurface_set_sync_queue :: proc(client: ^Client, req: wayland.Subsurface_Set_Sync_Request) -> runtime.Allocator_Error {
	wayland.subsurface_set_sync_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_subsurface_set_desync_queue :: proc(client: ^Client, req: wayland.Subsurface_Set_Desync_Request) -> runtime.Allocator_Error {
	wayland.subsurface_set_desync_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_fixes_destroy_queue :: proc(client: ^Client, req: wayland.Fixes_Destroy_Request) -> runtime.Allocator_Error {
	wayland.fixes_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.fixes))
	return nil
}

wayland_fixes_destroy_registry_queue :: proc(client: ^Client, req: wayland.Fixes_Destroy_Registry_Request) -> runtime.Allocator_Error {
	wayland.fixes_destroy_registry_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

wayland_fixes_ack_global_remove_queue :: proc(client: ^Client, req: wayland.Fixes_Ack_Global_Remove_Request) -> runtime.Allocator_Error {
	wayland.fixes_ack_global_remove_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

linux_dmabuf_v1_linux_dmabuf_v1_destroy_queue :: proc(client: ^Client, req: wp.Linux_Dmabuf_V1_Destroy_Request) -> runtime.Allocator_Error {
	wp.linux_dmabuf_v1_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.linux_dmabuf_v1))
	return nil
}

linux_dmabuf_v1_linux_dmabuf_v1_create_params_queue :: proc(client: ^Client, req: wp.Linux_Dmabuf_V1_Create_Params_Request) -> (ret: wp.Linux_Buffer_Params_V1, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wp.linux_dmabuf_v1_create_params_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wp.LINUX_BUFFER_PARAMS_V1_INTERFACE)
	return wp.Linux_Buffer_Params_V1(id), nil
}

linux_dmabuf_v1_linux_dmabuf_v1_get_default_feedback_queue :: proc(client: ^Client, req: wp.Linux_Dmabuf_V1_Get_Default_Feedback_Request) -> (ret: wp.Linux_Dmabuf_Feedback_V1, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wp.linux_dmabuf_v1_get_default_feedback_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wp.LINUX_DMABUF_FEEDBACK_V1_INTERFACE)
	return wp.Linux_Dmabuf_Feedback_V1(id), nil
}

linux_dmabuf_v1_linux_dmabuf_v1_get_surface_feedback_queue :: proc(client: ^Client, req: wp.Linux_Dmabuf_V1_Get_Surface_Feedback_Request) -> (ret: wp.Linux_Dmabuf_Feedback_V1, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wp.linux_dmabuf_v1_get_surface_feedback_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wp.LINUX_DMABUF_FEEDBACK_V1_INTERFACE)
	return wp.Linux_Dmabuf_Feedback_V1(id), nil
}

linux_dmabuf_v1_linux_buffer_params_v1_destroy_queue :: proc(client: ^Client, req: wp.Linux_Buffer_Params_V1_Destroy_Request) -> runtime.Allocator_Error {
	wp.linux_buffer_params_v1_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.linux_buffer_params_v1))
	return nil
}

linux_dmabuf_v1_linux_buffer_params_v1_add_queue :: proc(client: ^Client, req: wp.Linux_Buffer_Params_V1_Add_Request) -> runtime.Allocator_Error {
	wp.linux_buffer_params_v1_add_request_write(&client.requests_byte_buffer, req) or_return
	append(&client.outgoing_fds, req.fd)
	return nil
}

linux_dmabuf_v1_linux_buffer_params_v1_create_queue :: proc(client: ^Client, req: wp.Linux_Buffer_Params_V1_Create_Request) -> runtime.Allocator_Error {
	wp.linux_buffer_params_v1_create_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

linux_dmabuf_v1_linux_buffer_params_v1_create_immed_queue :: proc(client: ^Client, req: wp.Linux_Buffer_Params_V1_Create_Immed_Request) -> (ret: wayland.Buffer, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	wp.linux_buffer_params_v1_create_immed_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, wayland.BUFFER_INTERFACE)
	return wayland.Buffer(id), nil
}

linux_dmabuf_v1_linux_buffer_params_v1_set_sampling_device_queue :: proc(client: ^Client, req: wp.Linux_Buffer_Params_V1_Set_Sampling_Device_Request) -> runtime.Allocator_Error {
	wp.linux_buffer_params_v1_set_sampling_device_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

linux_dmabuf_v1_linux_dmabuf_feedback_v1_destroy_queue :: proc(client: ^Client, req: wp.Linux_Dmabuf_Feedback_V1_Destroy_Request) -> runtime.Allocator_Error {
	wp.linux_dmabuf_feedback_v1_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.linux_dmabuf_feedback_v1))
	return nil
}

xdg_shell_wm_base_destroy_queue :: proc(client: ^Client, req: xdg.Wm_Base_Destroy_Request) -> runtime.Allocator_Error {
	xdg.wm_base_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.wm_base))
	return nil
}

xdg_shell_wm_base_create_positioner_queue :: proc(client: ^Client, req: xdg.Wm_Base_Create_Positioner_Request) -> (ret: xdg.Positioner, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	xdg.wm_base_create_positioner_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, xdg.POSITIONER_INTERFACE)
	return xdg.Positioner(id), nil
}

xdg_shell_wm_base_get_xdg_surface_queue :: proc(client: ^Client, req: xdg.Wm_Base_Get_Xdg_Surface_Request) -> (ret: xdg.Surface, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	xdg.wm_base_get_xdg_surface_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, xdg.SURFACE_INTERFACE)
	return xdg.Surface(id), nil
}

xdg_shell_wm_base_pong_queue :: proc(client: ^Client, req: xdg.Wm_Base_Pong_Request) -> runtime.Allocator_Error {
	xdg.wm_base_pong_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_destroy_queue :: proc(client: ^Client, req: xdg.Positioner_Destroy_Request) -> runtime.Allocator_Error {
	xdg.positioner_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.positioner))
	return nil
}

xdg_shell_positioner_set_size_queue :: proc(client: ^Client, req: xdg.Positioner_Set_Size_Request) -> runtime.Allocator_Error {
	xdg.positioner_set_size_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_anchor_rect_queue :: proc(client: ^Client, req: xdg.Positioner_Set_Anchor_Rect_Request) -> runtime.Allocator_Error {
	xdg.positioner_set_anchor_rect_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_anchor_queue :: proc(client: ^Client, req: xdg.Positioner_Set_Anchor_Request) -> runtime.Allocator_Error {
	xdg.positioner_set_anchor_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_gravity_queue :: proc(client: ^Client, req: xdg.Positioner_Set_Gravity_Request) -> runtime.Allocator_Error {
	xdg.positioner_set_gravity_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_constraint_adjustment_queue :: proc(client: ^Client, req: xdg.Positioner_Set_Constraint_Adjustment_Request) -> runtime.Allocator_Error {
	xdg.positioner_set_constraint_adjustment_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_offset_queue :: proc(client: ^Client, req: xdg.Positioner_Set_Offset_Request) -> runtime.Allocator_Error {
	xdg.positioner_set_offset_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_reactive_queue :: proc(client: ^Client, req: xdg.Positioner_Set_Reactive_Request) -> runtime.Allocator_Error {
	xdg.positioner_set_reactive_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_parent_size_queue :: proc(client: ^Client, req: xdg.Positioner_Set_Parent_Size_Request) -> runtime.Allocator_Error {
	xdg.positioner_set_parent_size_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_positioner_set_parent_configure_queue :: proc(client: ^Client, req: xdg.Positioner_Set_Parent_Configure_Request) -> runtime.Allocator_Error {
	xdg.positioner_set_parent_configure_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_surface_destroy_queue :: proc(client: ^Client, req: xdg.Surface_Destroy_Request) -> runtime.Allocator_Error {
	xdg.surface_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.surface))
	return nil
}

xdg_shell_surface_get_toplevel_queue :: proc(client: ^Client, req: xdg.Surface_Get_Toplevel_Request) -> (ret: xdg.Toplevel, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	xdg.surface_get_toplevel_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, xdg.TOPLEVEL_INTERFACE)
	return xdg.Toplevel(id), nil
}

xdg_shell_surface_get_popup_queue :: proc(client: ^Client, req: xdg.Surface_Get_Popup_Request) -> (ret: xdg.Popup, err: runtime.Allocator_Error) #optional_allocator_error {
	client.next_id += 1
	id := client.next_id
	xdg.surface_get_popup_request_write(&client.requests_byte_buffer, req, id) or_return
	register_object(client, id, xdg.POPUP_INTERFACE)
	return xdg.Popup(id), nil
}

xdg_shell_surface_set_window_geometry_queue :: proc(client: ^Client, req: xdg.Surface_Set_Window_Geometry_Request) -> runtime.Allocator_Error {
	xdg.surface_set_window_geometry_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_surface_ack_configure_queue :: proc(client: ^Client, req: xdg.Surface_Ack_Configure_Request) -> runtime.Allocator_Error {
	xdg.surface_ack_configure_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_destroy_queue :: proc(client: ^Client, req: xdg.Toplevel_Destroy_Request) -> runtime.Allocator_Error {
	xdg.toplevel_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.toplevel))
	return nil
}

xdg_shell_toplevel_set_parent_queue :: proc(client: ^Client, req: xdg.Toplevel_Set_Parent_Request) -> runtime.Allocator_Error {
	xdg.toplevel_set_parent_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_title_queue :: proc(client: ^Client, req: xdg.Toplevel_Set_Title_Request) -> runtime.Allocator_Error {
	xdg.toplevel_set_title_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_app_id_queue :: proc(client: ^Client, req: xdg.Toplevel_Set_App_Id_Request) -> runtime.Allocator_Error {
	xdg.toplevel_set_app_id_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_show_window_menu_queue :: proc(client: ^Client, req: xdg.Toplevel_Show_Window_Menu_Request) -> runtime.Allocator_Error {
	xdg.toplevel_show_window_menu_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_move_queue :: proc(client: ^Client, req: xdg.Toplevel_Move_Request) -> runtime.Allocator_Error {
	xdg.toplevel_move_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_resize_queue :: proc(client: ^Client, req: xdg.Toplevel_Resize_Request) -> runtime.Allocator_Error {
	xdg.toplevel_resize_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_max_size_queue :: proc(client: ^Client, req: xdg.Toplevel_Set_Max_Size_Request) -> runtime.Allocator_Error {
	xdg.toplevel_set_max_size_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_min_size_queue :: proc(client: ^Client, req: xdg.Toplevel_Set_Min_Size_Request) -> runtime.Allocator_Error {
	xdg.toplevel_set_min_size_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_maximized_queue :: proc(client: ^Client, req: xdg.Toplevel_Set_Maximized_Request) -> runtime.Allocator_Error {
	xdg.toplevel_set_maximized_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_unset_maximized_queue :: proc(client: ^Client, req: xdg.Toplevel_Unset_Maximized_Request) -> runtime.Allocator_Error {
	xdg.toplevel_unset_maximized_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_fullscreen_queue :: proc(client: ^Client, req: xdg.Toplevel_Set_Fullscreen_Request) -> runtime.Allocator_Error {
	xdg.toplevel_set_fullscreen_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_unset_fullscreen_queue :: proc(client: ^Client, req: xdg.Toplevel_Unset_Fullscreen_Request) -> runtime.Allocator_Error {
	xdg.toplevel_unset_fullscreen_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_toplevel_set_minimized_queue :: proc(client: ^Client, req: xdg.Toplevel_Set_Minimized_Request) -> runtime.Allocator_Error {
	xdg.toplevel_set_minimized_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_popup_destroy_queue :: proc(client: ^Client, req: xdg.Popup_Destroy_Request) -> runtime.Allocator_Error {
	xdg.popup_destroy_request_write(&client.requests_byte_buffer, req) or_return
	delete_key(&client.id_to_interface, u32(req.popup))
	return nil
}

xdg_shell_popup_grab_queue :: proc(client: ^Client, req: xdg.Popup_Grab_Request) -> runtime.Allocator_Error {
	xdg.popup_grab_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

xdg_shell_popup_reposition_queue :: proc(client: ^Client, req: xdg.Popup_Reposition_Request) -> runtime.Allocator_Error {
	xdg.popup_reposition_request_write(&client.requests_byte_buffer, req) or_return
	return nil
}

Event :: union {
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
	wp.Linux_Dmabuf_V1_Format_Event,
	wp.Linux_Dmabuf_V1_Modifier_Event,
	wp.Linux_Buffer_Params_V1_Created_Event,
	wp.Linux_Buffer_Params_V1_Failed_Event,
	wp.Linux_Dmabuf_Feedback_V1_Done_Event,
	wp.Linux_Dmabuf_Feedback_V1_Format_Table_Event,
	wp.Linux_Dmabuf_Feedback_V1_Main_Device_Event,
	wp.Linux_Dmabuf_Feedback_V1_Tranche_Done_Event,
	wp.Linux_Dmabuf_Feedback_V1_Tranche_Target_Device_Event,
	wp.Linux_Dmabuf_Feedback_V1_Tranche_Formats_Event,
	wp.Linux_Dmabuf_Feedback_V1_Tranche_Flags_Event,
	xdg.Wm_Base_Ping_Event,
	xdg.Surface_Configure_Event,
	xdg.Toplevel_Configure_Event,
	xdg.Toplevel_Close_Event,
	xdg.Toplevel_Configure_Bounds_Event,
	xdg.Toplevel_Wm_Capabilities_Event,
	xdg.Popup_Configure_Event,
	xdg.Popup_Popup_Done_Event,
	xdg.Popup_Repositioned_Event,
}

event_read :: proc(client: ^Client, interface: string, object_id: u32, opcode: u16, data: []byte, fds: ^[dynamic; 28]linux.Fd) -> (ev: Event, err: runtime.Allocator_Error) {
	switch interface {
	case wayland.DISPLAY_INTERFACE:
		switch opcode {
		case wayland.DISPLAY_ERROR_EVENT_OPCODE:
			decoded, _ := wayland.display_error_event_read(data)
			decoded.display = wayland.Display(object_id)
			return Event(decoded), nil
		case wayland.DISPLAY_DELETE_ID_EVENT_OPCODE:
			decoded, _ := wayland.display_delete_id_event_read(data)
			delete_key(&client.id_to_interface, decoded.id)
			return {}, nil
		}
	case wayland.REGISTRY_INTERFACE:
		switch opcode {
		case wayland.REGISTRY_GLOBAL_EVENT_OPCODE:
			decoded, _ := wayland.registry_global_event_read(data)
			decoded.registry = wayland.Registry(object_id)
			return Event(decoded), nil
		case wayland.REGISTRY_GLOBAL_REMOVE_EVENT_OPCODE:
			decoded, _ := wayland.registry_global_remove_event_read(data)
			decoded.registry = wayland.Registry(object_id)
			return Event(decoded), nil
		}
	case wayland.CALLBACK_INTERFACE:
		switch opcode {
		case wayland.CALLBACK_DONE_EVENT_OPCODE:
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
		case wayland.SHM_FORMAT_EVENT_OPCODE:
			decoded, _ := wayland.shm_format_event_read(data)
			decoded.shm = wayland.Shm(object_id)
			return Event(decoded), nil
		}
	case wayland.BUFFER_INTERFACE:
		switch opcode {
		case wayland.BUFFER_RELEASE_EVENT_OPCODE:
			decoded, _ := wayland.buffer_release_event_read(data)
			decoded.buffer = wayland.Buffer(object_id)
			return Event(decoded), nil
		}
	case wayland.DATA_OFFER_INTERFACE:
		switch opcode {
		case wayland.DATA_OFFER_OFFER_EVENT_OPCODE:
			decoded, _ := wayland.data_offer_offer_event_read(data)
			decoded.data_offer = wayland.Data_Offer(object_id)
			return Event(decoded), nil
		case wayland.DATA_OFFER_SOURCE_ACTIONS_EVENT_OPCODE:
			decoded, _ := wayland.data_offer_source_actions_event_read(data)
			decoded.data_offer = wayland.Data_Offer(object_id)
			return Event(decoded), nil
		case wayland.DATA_OFFER_ACTION_EVENT_OPCODE:
			decoded, _ := wayland.data_offer_action_event_read(data)
			decoded.data_offer = wayland.Data_Offer(object_id)
			return Event(decoded), nil
		}
	case wayland.DATA_SOURCE_INTERFACE:
		switch opcode {
		case wayland.DATA_SOURCE_TARGET_EVENT_OPCODE:
			decoded, _ := wayland.data_source_target_event_read(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), nil
		case wayland.DATA_SOURCE_SEND_EVENT_OPCODE:
			decoded, _ := wayland.data_source_send_event_read(data, fds)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), nil
		case wayland.DATA_SOURCE_CANCELLED_EVENT_OPCODE:
			decoded, _ := wayland.data_source_cancelled_event_read(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), nil
		case wayland.DATA_SOURCE_DND_DROP_PERFORMED_EVENT_OPCODE:
			decoded, _ := wayland.data_source_dnd_drop_performed_event_read(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), nil
		case wayland.DATA_SOURCE_DND_FINISHED_EVENT_OPCODE:
			decoded, _ := wayland.data_source_dnd_finished_event_read(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), nil
		case wayland.DATA_SOURCE_ACTION_EVENT_OPCODE:
			decoded, _ := wayland.data_source_action_event_read(data)
			decoded.data_source = wayland.Data_Source(object_id)
			return Event(decoded), nil
		}
	case wayland.DATA_DEVICE_INTERFACE:
		switch opcode {
		case wayland.DATA_DEVICE_DATA_OFFER_EVENT_OPCODE:
			decoded, _ := wayland.data_device_data_offer_event_read(data)
			decoded.data_device = wayland.Data_Device(object_id)
			client.id_to_interface[u32(decoded.id)] = wayland.DATA_OFFER_INTERFACE
			return Event(decoded), nil
		case wayland.DATA_DEVICE_ENTER_EVENT_OPCODE:
			decoded, _ := wayland.data_device_enter_event_read(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), nil
		case wayland.DATA_DEVICE_LEAVE_EVENT_OPCODE:
			decoded, _ := wayland.data_device_leave_event_read(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), nil
		case wayland.DATA_DEVICE_MOTION_EVENT_OPCODE:
			decoded, _ := wayland.data_device_motion_event_read(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), nil
		case wayland.DATA_DEVICE_DROP_EVENT_OPCODE:
			decoded, _ := wayland.data_device_drop_event_read(data)
			decoded.data_device = wayland.Data_Device(object_id)
			return Event(decoded), nil
		case wayland.DATA_DEVICE_SELECTION_EVENT_OPCODE:
			decoded, _ := wayland.data_device_selection_event_read(data)
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
		case wayland.SHELL_SURFACE_PING_EVENT_OPCODE:
			decoded, _ := wayland.shell_surface_ping_event_read(data)
			decoded.shell_surface = wayland.Shell_Surface(object_id)
			return Event(decoded), nil
		case wayland.SHELL_SURFACE_CONFIGURE_EVENT_OPCODE:
			decoded, _ := wayland.shell_surface_configure_event_read(data)
			decoded.shell_surface = wayland.Shell_Surface(object_id)
			return Event(decoded), nil
		case wayland.SHELL_SURFACE_POPUP_DONE_EVENT_OPCODE:
			decoded, _ := wayland.shell_surface_popup_done_event_read(data)
			decoded.shell_surface = wayland.Shell_Surface(object_id)
			return Event(decoded), nil
		}
	case wayland.SURFACE_INTERFACE:
		switch opcode {
		case wayland.SURFACE_ENTER_EVENT_OPCODE:
			decoded, _ := wayland.surface_enter_event_read(data)
			decoded.surface = wayland.Surface(object_id)
			return Event(decoded), nil
		case wayland.SURFACE_LEAVE_EVENT_OPCODE:
			decoded, _ := wayland.surface_leave_event_read(data)
			decoded.surface = wayland.Surface(object_id)
			return Event(decoded), nil
		case wayland.SURFACE_PREFERRED_BUFFER_SCALE_EVENT_OPCODE:
			decoded, _ := wayland.surface_preferred_buffer_scale_event_read(data)
			decoded.surface = wayland.Surface(object_id)
			return Event(decoded), nil
		case wayland.SURFACE_PREFERRED_BUFFER_TRANSFORM_EVENT_OPCODE:
			decoded, _ := wayland.surface_preferred_buffer_transform_event_read(data)
			decoded.surface = wayland.Surface(object_id)
			return Event(decoded), nil
		}
	case wayland.SEAT_INTERFACE:
		switch opcode {
		case wayland.SEAT_CAPABILITIES_EVENT_OPCODE:
			decoded, _ := wayland.seat_capabilities_event_read(data)
			decoded.seat = wayland.Seat(object_id)
			return Event(decoded), nil
		case wayland.SEAT_NAME_EVENT_OPCODE:
			decoded, _ := wayland.seat_name_event_read(data)
			decoded.seat = wayland.Seat(object_id)
			return Event(decoded), nil
		}
	case wayland.POINTER_INTERFACE:
		switch opcode {
		case wayland.POINTER_ENTER_EVENT_OPCODE:
			decoded, _ := wayland.pointer_enter_event_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_LEAVE_EVENT_OPCODE:
			decoded, _ := wayland.pointer_leave_event_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_MOTION_EVENT_OPCODE:
			decoded, _ := wayland.pointer_motion_event_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_BUTTON_EVENT_OPCODE:
			decoded, _ := wayland.pointer_button_event_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_AXIS_EVENT_OPCODE:
			decoded, _ := wayland.pointer_axis_event_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_FRAME_EVENT_OPCODE:
			decoded, _ := wayland.pointer_frame_event_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_AXIS_SOURCE_EVENT_OPCODE:
			decoded, _ := wayland.pointer_axis_source_event_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_AXIS_STOP_EVENT_OPCODE:
			decoded, _ := wayland.pointer_axis_stop_event_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_AXIS_DISCRETE_EVENT_OPCODE:
			decoded, _ := wayland.pointer_axis_discrete_event_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_AXIS_VALUE120_EVENT_OPCODE:
			decoded, _ := wayland.pointer_axis_value120_event_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_AXIS_RELATIVE_DIRECTION_EVENT_OPCODE:
			decoded, _ := wayland.pointer_axis_relative_direction_event_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		case wayland.POINTER_WARP_EVENT_OPCODE:
			decoded, _ := wayland.pointer_warp_event_read(data)
			decoded.pointer = wayland.Pointer(object_id)
			return Event(decoded), nil
		}
	case wayland.KEYBOARD_INTERFACE:
		switch opcode {
		case wayland.KEYBOARD_KEYMAP_EVENT_OPCODE:
			decoded, _ := wayland.keyboard_keymap_event_read(data, fds)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), nil
		case wayland.KEYBOARD_ENTER_EVENT_OPCODE:
			decoded, _ := wayland.keyboard_enter_event_read(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), nil
		case wayland.KEYBOARD_LEAVE_EVENT_OPCODE:
			decoded, _ := wayland.keyboard_leave_event_read(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), nil
		case wayland.KEYBOARD_KEY_EVENT_OPCODE:
			decoded, _ := wayland.keyboard_key_event_read(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), nil
		case wayland.KEYBOARD_MODIFIERS_EVENT_OPCODE:
			decoded, _ := wayland.keyboard_modifiers_event_read(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), nil
		case wayland.KEYBOARD_REPEAT_INFO_EVENT_OPCODE:
			decoded, _ := wayland.keyboard_repeat_info_event_read(data)
			decoded.keyboard = wayland.Keyboard(object_id)
			return Event(decoded), nil
		}
	case wayland.TOUCH_INTERFACE:
		switch opcode {
		case wayland.TOUCH_DOWN_EVENT_OPCODE:
			decoded, _ := wayland.touch_down_event_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		case wayland.TOUCH_UP_EVENT_OPCODE:
			decoded, _ := wayland.touch_up_event_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		case wayland.TOUCH_MOTION_EVENT_OPCODE:
			decoded, _ := wayland.touch_motion_event_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		case wayland.TOUCH_FRAME_EVENT_OPCODE:
			decoded, _ := wayland.touch_frame_event_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		case wayland.TOUCH_CANCEL_EVENT_OPCODE:
			decoded, _ := wayland.touch_cancel_event_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		case wayland.TOUCH_SHAPE_EVENT_OPCODE:
			decoded, _ := wayland.touch_shape_event_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		case wayland.TOUCH_ORIENTATION_EVENT_OPCODE:
			decoded, _ := wayland.touch_orientation_event_read(data)
			decoded.touch = wayland.Touch(object_id)
			return Event(decoded), nil
		}
	case wayland.OUTPUT_INTERFACE:
		switch opcode {
		case wayland.OUTPUT_GEOMETRY_EVENT_OPCODE:
			decoded, _ := wayland.output_geometry_event_read(data)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), nil
		case wayland.OUTPUT_MODE_EVENT_OPCODE:
			decoded, _ := wayland.output_mode_event_read(data)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), nil
		case wayland.OUTPUT_DONE_EVENT_OPCODE:
			decoded, _ := wayland.output_done_event_read(data)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), nil
		case wayland.OUTPUT_SCALE_EVENT_OPCODE:
			decoded, _ := wayland.output_scale_event_read(data)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), nil
		case wayland.OUTPUT_NAME_EVENT_OPCODE:
			decoded, _ := wayland.output_name_event_read(data)
			decoded.output = wayland.Output(object_id)
			return Event(decoded), nil
		case wayland.OUTPUT_DESCRIPTION_EVENT_OPCODE:
			decoded, _ := wayland.output_description_event_read(data)
			decoded.output = wayland.Output(object_id)
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
	case wp.LINUX_DMABUF_V1_INTERFACE:
		switch opcode {
		case wp.LINUX_DMABUF_V1_FORMAT_EVENT_OPCODE:
			decoded, _ := wp.linux_dmabuf_v1_format_event_read(data)
			decoded.linux_dmabuf_v1 = wp.Linux_Dmabuf_V1(object_id)
			return Event(decoded), nil
		case wp.LINUX_DMABUF_V1_MODIFIER_EVENT_OPCODE:
			decoded, _ := wp.linux_dmabuf_v1_modifier_event_read(data)
			decoded.linux_dmabuf_v1 = wp.Linux_Dmabuf_V1(object_id)
			return Event(decoded), nil
		}
	case wp.LINUX_BUFFER_PARAMS_V1_INTERFACE:
		switch opcode {
		case wp.LINUX_BUFFER_PARAMS_V1_CREATED_EVENT_OPCODE:
			decoded, _ := wp.linux_buffer_params_v1_created_event_read(data)
			decoded.linux_buffer_params_v1 = wp.Linux_Buffer_Params_V1(object_id)
			client.id_to_interface[u32(decoded.buffer)] = wayland.BUFFER_INTERFACE
			return Event(decoded), nil
		case wp.LINUX_BUFFER_PARAMS_V1_FAILED_EVENT_OPCODE:
			decoded, _ := wp.linux_buffer_params_v1_failed_event_read(data)
			decoded.linux_buffer_params_v1 = wp.Linux_Buffer_Params_V1(object_id)
			return Event(decoded), nil
		}
	case wp.LINUX_DMABUF_FEEDBACK_V1_INTERFACE:
		switch opcode {
		case wp.LINUX_DMABUF_FEEDBACK_V1_DONE_EVENT_OPCODE:
			decoded, _ := wp.linux_dmabuf_feedback_v1_done_event_read(data)
			decoded.linux_dmabuf_feedback_v1 = wp.Linux_Dmabuf_Feedback_V1(object_id)
			return Event(decoded), nil
		case wp.LINUX_DMABUF_FEEDBACK_V1_FORMAT_TABLE_EVENT_OPCODE:
			decoded, _ := wp.linux_dmabuf_feedback_v1_format_table_event_read(data, fds)
			decoded.linux_dmabuf_feedback_v1 = wp.Linux_Dmabuf_Feedback_V1(object_id)
			return Event(decoded), nil
		case wp.LINUX_DMABUF_FEEDBACK_V1_MAIN_DEVICE_EVENT_OPCODE:
			decoded, _ := wp.linux_dmabuf_feedback_v1_main_device_event_read(data)
			decoded.linux_dmabuf_feedback_v1 = wp.Linux_Dmabuf_Feedback_V1(object_id)
			return Event(decoded), nil
		case wp.LINUX_DMABUF_FEEDBACK_V1_TRANCHE_DONE_EVENT_OPCODE:
			decoded, _ := wp.linux_dmabuf_feedback_v1_tranche_done_event_read(data)
			decoded.linux_dmabuf_feedback_v1 = wp.Linux_Dmabuf_Feedback_V1(object_id)
			return Event(decoded), nil
		case wp.LINUX_DMABUF_FEEDBACK_V1_TRANCHE_TARGET_DEVICE_EVENT_OPCODE:
			decoded, _ := wp.linux_dmabuf_feedback_v1_tranche_target_device_event_read(data)
			decoded.linux_dmabuf_feedback_v1 = wp.Linux_Dmabuf_Feedback_V1(object_id)
			return Event(decoded), nil
		case wp.LINUX_DMABUF_FEEDBACK_V1_TRANCHE_FORMATS_EVENT_OPCODE:
			decoded, _ := wp.linux_dmabuf_feedback_v1_tranche_formats_event_read(data)
			decoded.linux_dmabuf_feedback_v1 = wp.Linux_Dmabuf_Feedback_V1(object_id)
			return Event(decoded), nil
		case wp.LINUX_DMABUF_FEEDBACK_V1_TRANCHE_FLAGS_EVENT_OPCODE:
			decoded, _ := wp.linux_dmabuf_feedback_v1_tranche_flags_event_read(data)
			decoded.linux_dmabuf_feedback_v1 = wp.Linux_Dmabuf_Feedback_V1(object_id)
			return Event(decoded), nil
		}
	case xdg.WM_BASE_INTERFACE:
		switch opcode {
		case xdg.WM_BASE_PING_EVENT_OPCODE:
			decoded, _ := xdg.wm_base_ping_event_read(data)
			decoded.wm_base = xdg.Wm_Base(object_id)
			return Event(decoded), nil
		}
	case xdg.POSITIONER_INTERFACE:
		switch opcode {
		}
	case xdg.SURFACE_INTERFACE:
		switch opcode {
		case xdg.SURFACE_CONFIGURE_EVENT_OPCODE:
			decoded, _ := xdg.surface_configure_event_read(data)
			decoded.surface = xdg.Surface(object_id)
			return Event(decoded), nil
		}
	case xdg.TOPLEVEL_INTERFACE:
		switch opcode {
		case xdg.TOPLEVEL_CONFIGURE_EVENT_OPCODE:
			decoded, _ := xdg.toplevel_configure_event_read(data)
			decoded.toplevel = xdg.Toplevel(object_id)
			return Event(decoded), nil
		case xdg.TOPLEVEL_CLOSE_EVENT_OPCODE:
			decoded, _ := xdg.toplevel_close_event_read(data)
			decoded.toplevel = xdg.Toplevel(object_id)
			return Event(decoded), nil
		case xdg.TOPLEVEL_CONFIGURE_BOUNDS_EVENT_OPCODE:
			decoded, _ := xdg.toplevel_configure_bounds_event_read(data)
			decoded.toplevel = xdg.Toplevel(object_id)
			return Event(decoded), nil
		case xdg.TOPLEVEL_WM_CAPABILITIES_EVENT_OPCODE:
			decoded, _ := xdg.toplevel_wm_capabilities_event_read(data)
			decoded.toplevel = xdg.Toplevel(object_id)
			return Event(decoded), nil
		}
	case xdg.POPUP_INTERFACE:
		switch opcode {
		case xdg.POPUP_CONFIGURE_EVENT_OPCODE:
			decoded, _ := xdg.popup_configure_event_read(data)
			decoded.popup = xdg.Popup(object_id)
			return Event(decoded), nil
		case xdg.POPUP_POPUP_DONE_EVENT_OPCODE:
			decoded, _ := xdg.popup_popup_done_event_read(data)
			decoded.popup = xdg.Popup(object_id)
			return Event(decoded), nil
		case xdg.POPUP_REPOSITIONED_EVENT_OPCODE:
			decoded, _ := xdg.popup_repositioned_event_read(data)
			decoded.popup = xdg.Popup(object_id)
			return Event(decoded), nil
		}
	}
	return {}, nil
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

bind_linux_dmabuf_v1 :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (wp.Linux_Dmabuf_V1, Error) {
	id, err := request_queue(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = wp.LINUX_DMABUF_V1_INTERFACE,
		version   = e.version,
	})
	return wp.Linux_Dmabuf_V1(id), err
}

bind_wm_base :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> (xdg.Wm_Base, Error) {
	id, err := request_queue(client, wayland.Registry_Bind_Request {
		registry  = registry,
		name      = e.name,
		interface = xdg.WM_BASE_INTERFACE,
		version   = e.version,
	})
	return xdg.Wm_Base(id), err
}

