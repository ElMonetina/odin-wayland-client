package client

import "wayland"

// Returns the ID of a new object, 0 if none was created.
queue_request :: proc { queue_request_wayland }

queue_request_wayland :: proc(req: wayland.Request) -> (id: u32, err: Error) {
	switch r in req {
	case wayland.Display_Sync_Request:
		id = new_id()
		data := wayland.display_sync_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.CALLBACK_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Display_Get_Registry_Request:
		id = new_id()
		data := wayland.display_get_registry_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.REGISTRY_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Registry_Bind_Request:
		id = new_id()
		data := wayland.registry_bind_encode(r, id, internal_state.temp_allocator) or_return
		switch r.interface {
			case wayland.COMPOSITOR_INTERFACE:
				internal_state.interface_map[id] = wayland.COMPOSITOR_INTERFACE
			case wayland.SHM_INTERFACE:
				internal_state.interface_map[id] = wayland.SHM_INTERFACE
			case wayland.DATA_DEVICE_MANAGER_INTERFACE:
				internal_state.interface_map[id] = wayland.DATA_DEVICE_MANAGER_INTERFACE
			case wayland.SHELL_INTERFACE:
				internal_state.interface_map[id] = wayland.SHELL_INTERFACE
			case wayland.SEAT_INTERFACE:
				internal_state.interface_map[id] = wayland.SEAT_INTERFACE
			case wayland.OUTPUT_INTERFACE:
				internal_state.interface_map[id] = wayland.OUTPUT_INTERFACE
			case wayland.SUBCOMPOSITOR_INTERFACE:
				internal_state.interface_map[id] = wayland.SUBCOMPOSITOR_INTERFACE
			case wayland.FIXES_INTERFACE:
				internal_state.interface_map[id] = wayland.FIXES_INTERFACE
		}
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Compositor_Create_Surface_Request:
		id = new_id()
		data := wayland.compositor_create_surface_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.SURFACE_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Compositor_Create_Region_Request:
		id = new_id()
		data := wayland.compositor_create_region_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.REGION_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Compositor_Release_Request:
		data := wayland.compositor_release_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.compositor)
	case wayland.Shm_Pool_Create_Buffer_Request:
		id = new_id()
		data := wayland.shm_pool_create_buffer_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.BUFFER_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shm_Pool_Destroy_Request:
		data := wayland.shm_pool_destroy_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.shm_pool)
	case wayland.Shm_Pool_Resize_Request:
		data := wayland.shm_pool_resize_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shm_Create_Pool_Request:
		id = new_id()
		append(&internal_state.outgoing_fds, r.fd)
		data := wayland.shm_create_pool_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.SHM_POOL_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shm_Release_Request:
		data := wayland.shm_release_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.shm)
	case wayland.Buffer_Destroy_Request:
		data := wayland.buffer_destroy_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.buffer)
	case wayland.Data_Offer_Accept_Request:
		data := wayland.data_offer_accept_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Data_Offer_Receive_Request:
		append(&internal_state.outgoing_fds, r.fd)
		data := wayland.data_offer_receive_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Data_Offer_Destroy_Request:
		data := wayland.data_offer_destroy_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.data_offer)
	case wayland.Data_Offer_Finish_Request:
		data := wayland.data_offer_finish_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Data_Offer_Set_Actions_Request:
		data := wayland.data_offer_set_actions_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Data_Source_Offer_Request:
		data := wayland.data_source_offer_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Data_Source_Destroy_Request:
		data := wayland.data_source_destroy_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.data_source)
	case wayland.Data_Source_Set_Actions_Request:
		data := wayland.data_source_set_actions_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Data_Device_Start_Drag_Request:
		data := wayland.data_device_start_drag_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Data_Device_Set_Selection_Request:
		data := wayland.data_device_set_selection_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Data_Device_Release_Request:
		data := wayland.data_device_release_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.data_device)
	case wayland.Data_Device_Manager_Create_Data_Source_Request:
		id = new_id()
		data := wayland.data_device_manager_create_data_source_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.DATA_SOURCE_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Data_Device_Manager_Get_Data_Device_Request:
		id = new_id()
		data := wayland.data_device_manager_get_data_device_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.DATA_DEVICE_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Data_Device_Manager_Release_Request:
		data := wayland.data_device_manager_release_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.data_device_manager)
	case wayland.Shell_Get_Shell_Surface_Request:
		id = new_id()
		data := wayland.shell_get_shell_surface_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.SHELL_SURFACE_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shell_Surface_Pong_Request:
		data := wayland.shell_surface_pong_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shell_Surface_Move_Request:
		data := wayland.shell_surface_move_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shell_Surface_Resize_Request:
		data := wayland.shell_surface_resize_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shell_Surface_Set_Toplevel_Request:
		data := wayland.shell_surface_set_toplevel_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shell_Surface_Set_Transient_Request:
		data := wayland.shell_surface_set_transient_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shell_Surface_Set_Fullscreen_Request:
		data := wayland.shell_surface_set_fullscreen_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shell_Surface_Set_Popup_Request:
		data := wayland.shell_surface_set_popup_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shell_Surface_Set_Maximized_Request:
		data := wayland.shell_surface_set_maximized_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shell_Surface_Set_Title_Request:
		data := wayland.shell_surface_set_title_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Shell_Surface_Set_Class_Request:
		data := wayland.shell_surface_set_class_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Surface_Destroy_Request:
		data := wayland.surface_destroy_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.surface)
	case wayland.Surface_Attach_Request:
		data := wayland.surface_attach_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Surface_Damage_Request:
		data := wayland.surface_damage_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Surface_Frame_Request:
		id = new_id()
		data := wayland.surface_frame_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.CALLBACK_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Surface_Set_Opaque_Region_Request:
		data := wayland.surface_set_opaque_region_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Surface_Set_Input_Region_Request:
		data := wayland.surface_set_input_region_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Surface_Commit_Request:
		data := wayland.surface_commit_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Surface_Set_Buffer_Transform_Request:
		data := wayland.surface_set_buffer_transform_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Surface_Set_Buffer_Scale_Request:
		data := wayland.surface_set_buffer_scale_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Surface_Damage_Buffer_Request:
		data := wayland.surface_damage_buffer_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Surface_Offset_Request:
		data := wayland.surface_offset_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Surface_Get_Release_Request:
		id = new_id()
		data := wayland.surface_get_release_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.CALLBACK_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Seat_Get_Pointer_Request:
		id = new_id()
		data := wayland.seat_get_pointer_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.POINTER_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Seat_Get_Keyboard_Request:
		id = new_id()
		data := wayland.seat_get_keyboard_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.KEYBOARD_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Seat_Get_Touch_Request:
		id = new_id()
		data := wayland.seat_get_touch_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.TOUCH_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Seat_Release_Request:
		data := wayland.seat_release_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.seat)
	case wayland.Pointer_Set_Cursor_Request:
		data := wayland.pointer_set_cursor_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Pointer_Release_Request:
		data := wayland.pointer_release_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.pointer)
	case wayland.Keyboard_Release_Request:
		data := wayland.keyboard_release_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.keyboard)
	case wayland.Touch_Release_Request:
		data := wayland.touch_release_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.touch)
	case wayland.Output_Release_Request:
		data := wayland.output_release_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.output)
	case wayland.Region_Destroy_Request:
		data := wayland.region_destroy_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.region)
	case wayland.Region_Add_Request:
		data := wayland.region_add_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Region_Subtract_Request:
		data := wayland.region_subtract_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Subcompositor_Destroy_Request:
		data := wayland.subcompositor_destroy_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.subcompositor)
	case wayland.Subcompositor_Get_Subsurface_Request:
		id = new_id()
		data := wayland.subcompositor_get_subsurface_encode(r, id, internal_state.temp_allocator) or_return
		internal_state.interface_map[id] = wayland.SUBSURFACE_INTERFACE
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Subsurface_Destroy_Request:
		data := wayland.subsurface_destroy_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.subsurface)
	case wayland.Subsurface_Set_Position_Request:
		data := wayland.subsurface_set_position_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Subsurface_Place_Above_Request:
		data := wayland.subsurface_place_above_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Subsurface_Place_Below_Request:
		data := wayland.subsurface_place_below_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Subsurface_Set_Sync_Request:
		data := wayland.subsurface_set_sync_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Subsurface_Set_Desync_Request:
		data := wayland.subsurface_set_desync_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Fixes_Destroy_Request:
		data := wayland.fixes_destroy_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
		delete_key(&internal_state.interface_map, r.fixes)
	case wayland.Fixes_Destroy_Registry_Request:
		data := wayland.fixes_destroy_registry_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	case wayland.Fixes_Ack_Global_Remove_Request:
		data := wayland.fixes_ack_global_remove_encode(r, internal_state.temp_allocator) or_return
		append(&internal_state.requests_byte_buffer, ..data[:])
	}
	return
}

Event :: union {
	wayland.Event,
}

parse_event :: proc(object_id: u32, opcode: u16, data: []byte) -> (ev: Event, ok: bool) {
	interface := internal_state.interface_map[object_id]
	switch interface {
	case wayland.DISPLAY_INTERFACE:
		switch opcode {
		case wayland.DISPLAY_ERROR_OPCODE:
			return Event(wayland.Event(wayland.display_error_decode(data, internal_state.temp_allocator))), true
		case wayland.DISPLAY_DELETE_ID_OPCODE:
			delete_key(&internal_state.interface_map, wayland.display_delete_id_decode(data).id)
			return {}, false
		}
	case wayland.REGISTRY_INTERFACE:
		switch opcode {
		case wayland.REGISTRY_GLOBAL_OPCODE:
			return Event(wayland.Event(wayland.registry_global_decode(data, internal_state.temp_allocator))), true
		case wayland.REGISTRY_GLOBAL_REMOVE_OPCODE:
			return Event(wayland.Event(wayland.registry_global_remove_decode(data))), true
		}
	case wayland.CALLBACK_INTERFACE:
		switch opcode {
		case wayland.CALLBACK_DONE_OPCODE:
			delete_key(&internal_state.interface_map, object_id)
			return {}, false
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
			return Event(wayland.Event(wayland.shm_format_decode(data))), true
		}
	case wayland.BUFFER_INTERFACE:
		switch opcode {
		case wayland.BUFFER_RELEASE_OPCODE:
			return Event(wayland.Event(wayland.buffer_release_decode(data))), true
		}
	case wayland.DATA_OFFER_INTERFACE:
		switch opcode {
		case wayland.DATA_OFFER_OFFER_OPCODE:
			return Event(wayland.Event(wayland.data_offer_offer_decode(data, internal_state.temp_allocator))), true
		case wayland.DATA_OFFER_SOURCE_ACTIONS_OPCODE:
			return Event(wayland.Event(wayland.data_offer_source_actions_decode(data))), true
		case wayland.DATA_OFFER_ACTION_OPCODE:
			return Event(wayland.Event(wayland.data_offer_action_decode(data))), true
		}
	case wayland.DATA_SOURCE_INTERFACE:
		switch opcode {
		case wayland.DATA_SOURCE_TARGET_OPCODE:
			return Event(wayland.Event(wayland.data_source_target_decode(data, internal_state.temp_allocator))), true
		case wayland.DATA_SOURCE_SEND_OPCODE:
			return Event(wayland.Event(wayland.data_source_send_decode(data, &internal_state.incoming_fds, internal_state.temp_allocator))), true
		case wayland.DATA_SOURCE_CANCELLED_OPCODE:
			return Event(wayland.Event(wayland.data_source_cancelled_decode(data))), true
		case wayland.DATA_SOURCE_DND_DROP_PERFORMED_OPCODE:
			return Event(wayland.Event(wayland.data_source_dnd_drop_performed_decode(data))), true
		case wayland.DATA_SOURCE_DND_FINISHED_OPCODE:
			return Event(wayland.Event(wayland.data_source_dnd_finished_decode(data))), true
		case wayland.DATA_SOURCE_ACTION_OPCODE:
			return Event(wayland.Event(wayland.data_source_action_decode(data))), true
		}
	case wayland.DATA_DEVICE_INTERFACE:
		switch opcode {
		case wayland.DATA_DEVICE_DATA_OFFER_OPCODE:
			return Event(wayland.Event(wayland.data_device_data_offer_decode(data))), true
		case wayland.DATA_DEVICE_ENTER_OPCODE:
			return Event(wayland.Event(wayland.data_device_enter_decode(data))), true
		case wayland.DATA_DEVICE_LEAVE_OPCODE:
			return Event(wayland.Event(wayland.data_device_leave_decode(data))), true
		case wayland.DATA_DEVICE_MOTION_OPCODE:
			return Event(wayland.Event(wayland.data_device_motion_decode(data))), true
		case wayland.DATA_DEVICE_DROP_OPCODE:
			return Event(wayland.Event(wayland.data_device_drop_decode(data))), true
		case wayland.DATA_DEVICE_SELECTION_OPCODE:
			return Event(wayland.Event(wayland.data_device_selection_decode(data))), true
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
			return Event(wayland.Event(wayland.shell_surface_ping_decode(data))), true
		case wayland.SHELL_SURFACE_CONFIGURE_OPCODE:
			return Event(wayland.Event(wayland.shell_surface_configure_decode(data))), true
		case wayland.SHELL_SURFACE_POPUP_DONE_OPCODE:
			return Event(wayland.Event(wayland.shell_surface_popup_done_decode(data))), true
		}
	case wayland.SURFACE_INTERFACE:
		switch opcode {
		case wayland.SURFACE_ENTER_OPCODE:
			return Event(wayland.Event(wayland.surface_enter_decode(data))), true
		case wayland.SURFACE_LEAVE_OPCODE:
			return Event(wayland.Event(wayland.surface_leave_decode(data))), true
		case wayland.SURFACE_PREFERRED_BUFFER_SCALE_OPCODE:
			return Event(wayland.Event(wayland.surface_preferred_buffer_scale_decode(data))), true
		case wayland.SURFACE_PREFERRED_BUFFER_TRANSFORM_OPCODE:
			return Event(wayland.Event(wayland.surface_preferred_buffer_transform_decode(data))), true
		}
	case wayland.SEAT_INTERFACE:
		switch opcode {
		case wayland.SEAT_CAPABILITIES_OPCODE:
			return Event(wayland.Event(wayland.seat_capabilities_decode(data))), true
		case wayland.SEAT_NAME_OPCODE:
			return Event(wayland.Event(wayland.seat_name_decode(data, internal_state.temp_allocator))), true
		}
	case wayland.POINTER_INTERFACE:
		switch opcode {
		case wayland.POINTER_ENTER_OPCODE:
			return Event(wayland.Event(wayland.pointer_enter_decode(data))), true
		case wayland.POINTER_LEAVE_OPCODE:
			return Event(wayland.Event(wayland.pointer_leave_decode(data))), true
		case wayland.POINTER_MOTION_OPCODE:
			return Event(wayland.Event(wayland.pointer_motion_decode(data))), true
		case wayland.POINTER_BUTTON_OPCODE:
			return Event(wayland.Event(wayland.pointer_button_decode(data))), true
		case wayland.POINTER_AXIS_OPCODE:
			return Event(wayland.Event(wayland.pointer_axis_decode(data))), true
		case wayland.POINTER_FRAME_OPCODE:
			return Event(wayland.Event(wayland.pointer_frame_decode(data))), true
		case wayland.POINTER_AXIS_SOURCE_OPCODE:
			return Event(wayland.Event(wayland.pointer_axis_source_decode(data))), true
		case wayland.POINTER_AXIS_STOP_OPCODE:
			return Event(wayland.Event(wayland.pointer_axis_stop_decode(data))), true
		case wayland.POINTER_AXIS_DISCRETE_OPCODE:
			return Event(wayland.Event(wayland.pointer_axis_discrete_decode(data))), true
		case wayland.POINTER_AXIS_VALUE120_OPCODE:
			return Event(wayland.Event(wayland.pointer_axis_value120_decode(data))), true
		case wayland.POINTER_AXIS_RELATIVE_DIRECTION_OPCODE:
			return Event(wayland.Event(wayland.pointer_axis_relative_direction_decode(data))), true
		case wayland.POINTER_WARP_OPCODE:
			return Event(wayland.Event(wayland.pointer_warp_decode(data))), true
		}
	case wayland.KEYBOARD_INTERFACE:
		switch opcode {
		case wayland.KEYBOARD_KEYMAP_OPCODE:
			return Event(wayland.Event(wayland.keyboard_keymap_decode(data, &internal_state.incoming_fds))), true
		case wayland.KEYBOARD_ENTER_OPCODE:
			return Event(wayland.Event(wayland.keyboard_enter_decode(data, internal_state.temp_allocator))), true
		case wayland.KEYBOARD_LEAVE_OPCODE:
			return Event(wayland.Event(wayland.keyboard_leave_decode(data))), true
		case wayland.KEYBOARD_KEY_OPCODE:
			return Event(wayland.Event(wayland.keyboard_key_decode(data))), true
		case wayland.KEYBOARD_MODIFIERS_OPCODE:
			return Event(wayland.Event(wayland.keyboard_modifiers_decode(data))), true
		case wayland.KEYBOARD_REPEAT_INFO_OPCODE:
			return Event(wayland.Event(wayland.keyboard_repeat_info_decode(data))), true
		}
	case wayland.TOUCH_INTERFACE:
		switch opcode {
		case wayland.TOUCH_DOWN_OPCODE:
			return Event(wayland.Event(wayland.touch_down_decode(data))), true
		case wayland.TOUCH_UP_OPCODE:
			return Event(wayland.Event(wayland.touch_up_decode(data))), true
		case wayland.TOUCH_MOTION_OPCODE:
			return Event(wayland.Event(wayland.touch_motion_decode(data))), true
		case wayland.TOUCH_FRAME_OPCODE:
			return Event(wayland.Event(wayland.touch_frame_decode(data))), true
		case wayland.TOUCH_CANCEL_OPCODE:
			return Event(wayland.Event(wayland.touch_cancel_decode(data))), true
		case wayland.TOUCH_SHAPE_OPCODE:
			return Event(wayland.Event(wayland.touch_shape_decode(data))), true
		case wayland.TOUCH_ORIENTATION_OPCODE:
			return Event(wayland.Event(wayland.touch_orientation_decode(data))), true
		}
	case wayland.OUTPUT_INTERFACE:
		switch opcode {
		case wayland.OUTPUT_GEOMETRY_OPCODE:
			return Event(wayland.Event(wayland.output_geometry_decode(data, internal_state.temp_allocator))), true
		case wayland.OUTPUT_MODE_OPCODE:
			return Event(wayland.Event(wayland.output_mode_decode(data))), true
		case wayland.OUTPUT_DONE_OPCODE:
			return Event(wayland.Event(wayland.output_done_decode(data))), true
		case wayland.OUTPUT_SCALE_OPCODE:
			return Event(wayland.Event(wayland.output_scale_decode(data))), true
		case wayland.OUTPUT_NAME_OPCODE:
			return Event(wayland.Event(wayland.output_name_decode(data, internal_state.temp_allocator))), true
		case wayland.OUTPUT_DESCRIPTION_OPCODE:
			return Event(wayland.Event(wayland.output_description_decode(data, internal_state.temp_allocator))), true
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
	}
	return {}, false
}
