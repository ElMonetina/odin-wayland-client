package client

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

// Copyright © 2008-2013 Kristian Høgsberg
// Copyright © 2013      Rafael Antognolli
// Copyright © 2013      Jasper St. Pierre
// Copyright © 2010-2013 Intel Corporation
// Copyright © 2015-2017 Samsung Electronics Co., Ltd
// Copyright © 2015-2017 Red Hat Inc.
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

import "linux_dmabuf_v1"
import "wayland"
import "xdg_shell"

Request :: union {
	linux_dmabuf_v1.Request,
	wayland.Request,
	xdg_shell.Request,
}

// Returns the ID of a new object, 0 if none was created.
queue_request :: proc(req: Request) -> (id: u32, err: Error) {
	switch p in req {
	case linux_dmabuf_v1.Request:
		switch r in p {
		case linux_dmabuf_v1.Dmabuf_Destroy_Request:
			data := linux_dmabuf_v1.dmabuf_destroy_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
			delete_key(&internal_state.interface_map, r.dmabuf)
		case linux_dmabuf_v1.Dmabuf_Create_Params_Request:
			id = new_id()
			data := linux_dmabuf_v1.dmabuf_create_params_encode(r, id, internal_state.temp_allocator) or_return
			internal_state.interface_map[id] = linux_dmabuf_v1.BUFFER_PARAMS_INTERFACE
			append(&internal_state.requests_byte_buffer, ..data[:])
		case linux_dmabuf_v1.Dmabuf_Get_Default_Feedback_Request:
			id = new_id()
			data := linux_dmabuf_v1.dmabuf_get_default_feedback_encode(r, id, internal_state.temp_allocator) or_return
			internal_state.interface_map[id] = linux_dmabuf_v1.DMABUF_FEEDBACK_INTERFACE
			append(&internal_state.requests_byte_buffer, ..data[:])
		case linux_dmabuf_v1.Dmabuf_Get_Surface_Feedback_Request:
			id = new_id()
			data := linux_dmabuf_v1.dmabuf_get_surface_feedback_encode(r, id, internal_state.temp_allocator) or_return
			internal_state.interface_map[id] = linux_dmabuf_v1.DMABUF_FEEDBACK_INTERFACE
			append(&internal_state.requests_byte_buffer, ..data[:])
		case linux_dmabuf_v1.Buffer_Params_Destroy_Request:
			data := linux_dmabuf_v1.buffer_params_destroy_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
			delete_key(&internal_state.interface_map, r.buffer_params)
		case linux_dmabuf_v1.Buffer_Params_Add_Request:
			append(&internal_state.outgoing_fds, r.fd)
			data := linux_dmabuf_v1.buffer_params_add_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case linux_dmabuf_v1.Buffer_Params_Create_Request:
			data := linux_dmabuf_v1.buffer_params_create_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case linux_dmabuf_v1.Buffer_Params_Create_Immed_Request:
			id = new_id()
			data := linux_dmabuf_v1.buffer_params_create_immed_encode(r, id, internal_state.temp_allocator) or_return
			internal_state.interface_map[id] = wayland.BUFFER_INTERFACE
			append(&internal_state.requests_byte_buffer, ..data[:])
		case linux_dmabuf_v1.Buffer_Params_Set_Sampling_Device_Request:
			data := linux_dmabuf_v1.buffer_params_set_sampling_device_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case linux_dmabuf_v1.Dmabuf_Feedback_Destroy_Request:
			data := linux_dmabuf_v1.dmabuf_feedback_destroy_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
			delete_key(&internal_state.interface_map, r.dmabuf_feedback)
		}
	case wayland.Request:
		switch r in p {
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
			case linux_dmabuf_v1.DMABUF_INTERFACE:
				internal_state.interface_map[id] = linux_dmabuf_v1.DMABUF_INTERFACE
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
			case xdg_shell.WM_BASE_INTERFACE:
				internal_state.interface_map[id] = xdg_shell.WM_BASE_INTERFACE
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
	case xdg_shell.Request:
		switch r in p {
		case xdg_shell.Wm_Base_Destroy_Request:
			data := xdg_shell.wm_base_destroy_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
			delete_key(&internal_state.interface_map, r.wm_base)
		case xdg_shell.Wm_Base_Create_Positioner_Request:
			id = new_id()
			data := xdg_shell.wm_base_create_positioner_encode(r, id, internal_state.temp_allocator) or_return
			internal_state.interface_map[id] = xdg_shell.POSITIONER_INTERFACE
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Wm_Base_Get_Xdg_Surface_Request:
			id = new_id()
			data := xdg_shell.wm_base_get_xdg_surface_encode(r, id, internal_state.temp_allocator) or_return
			internal_state.interface_map[id] = xdg_shell.SURFACE_INTERFACE
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Wm_Base_Pong_Request:
			data := xdg_shell.wm_base_pong_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Positioner_Destroy_Request:
			data := xdg_shell.positioner_destroy_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
			delete_key(&internal_state.interface_map, r.positioner)
		case xdg_shell.Positioner_Set_Size_Request:
			data := xdg_shell.positioner_set_size_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Positioner_Set_Anchor_Rect_Request:
			data := xdg_shell.positioner_set_anchor_rect_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Positioner_Set_Anchor_Request:
			data := xdg_shell.positioner_set_anchor_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Positioner_Set_Gravity_Request:
			data := xdg_shell.positioner_set_gravity_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Positioner_Set_Constraint_Adjustment_Request:
			data := xdg_shell.positioner_set_constraint_adjustment_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Positioner_Set_Offset_Request:
			data := xdg_shell.positioner_set_offset_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Positioner_Set_Reactive_Request:
			data := xdg_shell.positioner_set_reactive_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Positioner_Set_Parent_Size_Request:
			data := xdg_shell.positioner_set_parent_size_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Positioner_Set_Parent_Configure_Request:
			data := xdg_shell.positioner_set_parent_configure_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Surface_Destroy_Request:
			data := xdg_shell.surface_destroy_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
			delete_key(&internal_state.interface_map, r.surface)
		case xdg_shell.Surface_Get_Toplevel_Request:
			id = new_id()
			data := xdg_shell.surface_get_toplevel_encode(r, id, internal_state.temp_allocator) or_return
			internal_state.interface_map[id] = xdg_shell.TOPLEVEL_INTERFACE
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Surface_Get_Popup_Request:
			id = new_id()
			data := xdg_shell.surface_get_popup_encode(r, id, internal_state.temp_allocator) or_return
			internal_state.interface_map[id] = xdg_shell.POPUP_INTERFACE
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Surface_Set_Window_Geometry_Request:
			data := xdg_shell.surface_set_window_geometry_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Surface_Ack_Configure_Request:
			data := xdg_shell.surface_ack_configure_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Destroy_Request:
			data := xdg_shell.toplevel_destroy_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
			delete_key(&internal_state.interface_map, r.toplevel)
		case xdg_shell.Toplevel_Set_Parent_Request:
			data := xdg_shell.toplevel_set_parent_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Set_Title_Request:
			data := xdg_shell.toplevel_set_title_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Set_App_Id_Request:
			data := xdg_shell.toplevel_set_app_id_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Show_Window_Menu_Request:
			data := xdg_shell.toplevel_show_window_menu_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Move_Request:
			data := xdg_shell.toplevel_move_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Resize_Request:
			data := xdg_shell.toplevel_resize_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Set_Max_Size_Request:
			data := xdg_shell.toplevel_set_max_size_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Set_Min_Size_Request:
			data := xdg_shell.toplevel_set_min_size_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Set_Maximized_Request:
			data := xdg_shell.toplevel_set_maximized_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Unset_Maximized_Request:
			data := xdg_shell.toplevel_unset_maximized_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Set_Fullscreen_Request:
			data := xdg_shell.toplevel_set_fullscreen_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Unset_Fullscreen_Request:
			data := xdg_shell.toplevel_unset_fullscreen_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Toplevel_Set_Minimized_Request:
			data := xdg_shell.toplevel_set_minimized_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Popup_Destroy_Request:
			data := xdg_shell.popup_destroy_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
			delete_key(&internal_state.interface_map, r.popup)
		case xdg_shell.Popup_Grab_Request:
			data := xdg_shell.popup_grab_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		case xdg_shell.Popup_Reposition_Request:
			data := xdg_shell.popup_reposition_encode(r, internal_state.temp_allocator) or_return
			append(&internal_state.requests_byte_buffer, ..data[:])
		}
	}
	return
}

Event :: union {
	linux_dmabuf_v1.Event,
	wayland.Event,
	xdg_shell.Event,
}

dispatch_event :: proc(object_id: u32, opcode: u16, data: []byte) {
	interface := internal_state.interface_map[object_id]
	switch interface {
	case linux_dmabuf_v1.DMABUF_INTERFACE:
		switch opcode {
		case linux_dmabuf_v1.DMABUF_FORMAT_OPCODE:
			append(&internal_state.events, linux_dmabuf_v1.dmabuf_format_decode(data))
		case linux_dmabuf_v1.DMABUF_MODIFIER_OPCODE:
			append(&internal_state.events, linux_dmabuf_v1.dmabuf_modifier_decode(data))
		}
	case linux_dmabuf_v1.BUFFER_PARAMS_INTERFACE:
		switch opcode {
		case linux_dmabuf_v1.BUFFER_PARAMS_CREATED_OPCODE:
			append(&internal_state.events, linux_dmabuf_v1.buffer_params_created_decode(data))
		case linux_dmabuf_v1.BUFFER_PARAMS_FAILED_OPCODE:
			append(&internal_state.events, linux_dmabuf_v1.buffer_params_failed_decode(data))
		}
	case linux_dmabuf_v1.DMABUF_FEEDBACK_INTERFACE:
		switch opcode {
		case linux_dmabuf_v1.DMABUF_FEEDBACK_DONE_OPCODE:
			append(&internal_state.events, linux_dmabuf_v1.dmabuf_feedback_done_decode(data))
		case linux_dmabuf_v1.DMABUF_FEEDBACK_FORMAT_TABLE_OPCODE:
			append(&internal_state.events, linux_dmabuf_v1.dmabuf_feedback_format_table_decode(data, &internal_state.incoming_fds))
		case linux_dmabuf_v1.DMABUF_FEEDBACK_MAIN_DEVICE_OPCODE:
			append(&internal_state.events, linux_dmabuf_v1.dmabuf_feedback_main_device_decode(data, internal_state.temp_allocator))
		case linux_dmabuf_v1.DMABUF_FEEDBACK_TRANCHE_DONE_OPCODE:
			append(&internal_state.events, linux_dmabuf_v1.dmabuf_feedback_tranche_done_decode(data))
		case linux_dmabuf_v1.DMABUF_FEEDBACK_TRANCHE_TARGET_DEVICE_OPCODE:
			append(&internal_state.events, linux_dmabuf_v1.dmabuf_feedback_tranche_target_device_decode(data, internal_state.temp_allocator))
		case linux_dmabuf_v1.DMABUF_FEEDBACK_TRANCHE_FORMATS_OPCODE:
			append(&internal_state.events, linux_dmabuf_v1.dmabuf_feedback_tranche_formats_decode(data, internal_state.temp_allocator))
		case linux_dmabuf_v1.DMABUF_FEEDBACK_TRANCHE_FLAGS_OPCODE:
			append(&internal_state.events, linux_dmabuf_v1.dmabuf_feedback_tranche_flags_decode(data))
		}
	case wayland.DISPLAY_INTERFACE:
		switch opcode {
		case wayland.DISPLAY_ERROR_OPCODE:
			append(&internal_state.events, wayland.display_error_decode(data, internal_state.temp_allocator))
		case wayland.DISPLAY_DELETE_ID_OPCODE:
			delete_key(&internal_state.interface_map, wayland.display_delete_id_decode(data).id)
		}
	case wayland.REGISTRY_INTERFACE:
		switch opcode {
		case wayland.REGISTRY_GLOBAL_OPCODE:
			append(&internal_state.events, wayland.registry_global_decode(data, internal_state.temp_allocator))
		case wayland.REGISTRY_GLOBAL_REMOVE_OPCODE:
			append(&internal_state.events, wayland.registry_global_remove_decode(data))
		}
	case wayland.CALLBACK_INTERFACE:
		switch opcode {
		case wayland.CALLBACK_DONE_OPCODE:
			delete_key(&internal_state.interface_map, object_id)
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
			append(&internal_state.events, wayland.shm_format_decode(data))
		}
	case wayland.BUFFER_INTERFACE:
		switch opcode {
		case wayland.BUFFER_RELEASE_OPCODE:
			append(&internal_state.events, wayland.buffer_release_decode(data))
		}
	case wayland.DATA_OFFER_INTERFACE:
		switch opcode {
		case wayland.DATA_OFFER_OFFER_OPCODE:
			append(&internal_state.events, wayland.data_offer_offer_decode(data, internal_state.temp_allocator))
		case wayland.DATA_OFFER_SOURCE_ACTIONS_OPCODE:
			append(&internal_state.events, wayland.data_offer_source_actions_decode(data))
		case wayland.DATA_OFFER_ACTION_OPCODE:
			append(&internal_state.events, wayland.data_offer_action_decode(data))
		}
	case wayland.DATA_SOURCE_INTERFACE:
		switch opcode {
		case wayland.DATA_SOURCE_TARGET_OPCODE:
			append(&internal_state.events, wayland.data_source_target_decode(data, internal_state.temp_allocator))
		case wayland.DATA_SOURCE_SEND_OPCODE:
			append(&internal_state.events, wayland.data_source_send_decode(data, &internal_state.incoming_fds, internal_state.temp_allocator))
		case wayland.DATA_SOURCE_CANCELLED_OPCODE:
			append(&internal_state.events, wayland.data_source_cancelled_decode(data))
		case wayland.DATA_SOURCE_DND_DROP_PERFORMED_OPCODE:
			append(&internal_state.events, wayland.data_source_dnd_drop_performed_decode(data))
		case wayland.DATA_SOURCE_DND_FINISHED_OPCODE:
			append(&internal_state.events, wayland.data_source_dnd_finished_decode(data))
		case wayland.DATA_SOURCE_ACTION_OPCODE:
			append(&internal_state.events, wayland.data_source_action_decode(data))
		}
	case wayland.DATA_DEVICE_INTERFACE:
		switch opcode {
		case wayland.DATA_DEVICE_DATA_OFFER_OPCODE:
			append(&internal_state.events, wayland.data_device_data_offer_decode(data))
		case wayland.DATA_DEVICE_ENTER_OPCODE:
			append(&internal_state.events, wayland.data_device_enter_decode(data))
		case wayland.DATA_DEVICE_LEAVE_OPCODE:
			append(&internal_state.events, wayland.data_device_leave_decode(data))
		case wayland.DATA_DEVICE_MOTION_OPCODE:
			append(&internal_state.events, wayland.data_device_motion_decode(data))
		case wayland.DATA_DEVICE_DROP_OPCODE:
			append(&internal_state.events, wayland.data_device_drop_decode(data))
		case wayland.DATA_DEVICE_SELECTION_OPCODE:
			append(&internal_state.events, wayland.data_device_selection_decode(data))
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
			append(&internal_state.events, wayland.shell_surface_ping_decode(data))
		case wayland.SHELL_SURFACE_CONFIGURE_OPCODE:
			append(&internal_state.events, wayland.shell_surface_configure_decode(data))
		case wayland.SHELL_SURFACE_POPUP_DONE_OPCODE:
			append(&internal_state.events, wayland.shell_surface_popup_done_decode(data))
		}
	case wayland.SURFACE_INTERFACE:
		switch opcode {
		case wayland.SURFACE_ENTER_OPCODE:
			append(&internal_state.events, wayland.surface_enter_decode(data))
		case wayland.SURFACE_LEAVE_OPCODE:
			append(&internal_state.events, wayland.surface_leave_decode(data))
		case wayland.SURFACE_PREFERRED_BUFFER_SCALE_OPCODE:
			append(&internal_state.events, wayland.surface_preferred_buffer_scale_decode(data))
		case wayland.SURFACE_PREFERRED_BUFFER_TRANSFORM_OPCODE:
			append(&internal_state.events, wayland.surface_preferred_buffer_transform_decode(data))
		}
	case wayland.SEAT_INTERFACE:
		switch opcode {
		case wayland.SEAT_CAPABILITIES_OPCODE:
			append(&internal_state.events, wayland.seat_capabilities_decode(data))
		case wayland.SEAT_NAME_OPCODE:
			append(&internal_state.events, wayland.seat_name_decode(data, internal_state.temp_allocator))
		}
	case wayland.POINTER_INTERFACE:
		switch opcode {
		case wayland.POINTER_ENTER_OPCODE:
			append(&internal_state.events, wayland.pointer_enter_decode(data))
		case wayland.POINTER_LEAVE_OPCODE:
			append(&internal_state.events, wayland.pointer_leave_decode(data))
		case wayland.POINTER_MOTION_OPCODE:
			append(&internal_state.events, wayland.pointer_motion_decode(data))
		case wayland.POINTER_BUTTON_OPCODE:
			append(&internal_state.events, wayland.pointer_button_decode(data))
		case wayland.POINTER_AXIS_OPCODE:
			append(&internal_state.events, wayland.pointer_axis_decode(data))
		case wayland.POINTER_FRAME_OPCODE:
			append(&internal_state.events, wayland.pointer_frame_decode(data))
		case wayland.POINTER_AXIS_SOURCE_OPCODE:
			append(&internal_state.events, wayland.pointer_axis_source_decode(data))
		case wayland.POINTER_AXIS_STOP_OPCODE:
			append(&internal_state.events, wayland.pointer_axis_stop_decode(data))
		case wayland.POINTER_AXIS_DISCRETE_OPCODE:
			append(&internal_state.events, wayland.pointer_axis_discrete_decode(data))
		case wayland.POINTER_AXIS_VALUE120_OPCODE:
			append(&internal_state.events, wayland.pointer_axis_value120_decode(data))
		case wayland.POINTER_AXIS_RELATIVE_DIRECTION_OPCODE:
			append(&internal_state.events, wayland.pointer_axis_relative_direction_decode(data))
		case wayland.POINTER_WARP_OPCODE:
			append(&internal_state.events, wayland.pointer_warp_decode(data))
		}
	case wayland.KEYBOARD_INTERFACE:
		switch opcode {
		case wayland.KEYBOARD_KEYMAP_OPCODE:
			append(&internal_state.events, wayland.keyboard_keymap_decode(data, &internal_state.incoming_fds))
		case wayland.KEYBOARD_ENTER_OPCODE:
			append(&internal_state.events, wayland.keyboard_enter_decode(data, internal_state.temp_allocator))
		case wayland.KEYBOARD_LEAVE_OPCODE:
			append(&internal_state.events, wayland.keyboard_leave_decode(data))
		case wayland.KEYBOARD_KEY_OPCODE:
			append(&internal_state.events, wayland.keyboard_key_decode(data))
		case wayland.KEYBOARD_MODIFIERS_OPCODE:
			append(&internal_state.events, wayland.keyboard_modifiers_decode(data))
		case wayland.KEYBOARD_REPEAT_INFO_OPCODE:
			append(&internal_state.events, wayland.keyboard_repeat_info_decode(data))
		}
	case wayland.TOUCH_INTERFACE:
		switch opcode {
		case wayland.TOUCH_DOWN_OPCODE:
			append(&internal_state.events, wayland.touch_down_decode(data))
		case wayland.TOUCH_UP_OPCODE:
			append(&internal_state.events, wayland.touch_up_decode(data))
		case wayland.TOUCH_MOTION_OPCODE:
			append(&internal_state.events, wayland.touch_motion_decode(data))
		case wayland.TOUCH_FRAME_OPCODE:
			append(&internal_state.events, wayland.touch_frame_decode(data))
		case wayland.TOUCH_CANCEL_OPCODE:
			append(&internal_state.events, wayland.touch_cancel_decode(data))
		case wayland.TOUCH_SHAPE_OPCODE:
			append(&internal_state.events, wayland.touch_shape_decode(data))
		case wayland.TOUCH_ORIENTATION_OPCODE:
			append(&internal_state.events, wayland.touch_orientation_decode(data))
		}
	case wayland.OUTPUT_INTERFACE:
		switch opcode {
		case wayland.OUTPUT_GEOMETRY_OPCODE:
			append(&internal_state.events, wayland.output_geometry_decode(data, internal_state.temp_allocator))
		case wayland.OUTPUT_MODE_OPCODE:
			append(&internal_state.events, wayland.output_mode_decode(data))
		case wayland.OUTPUT_DONE_OPCODE:
			append(&internal_state.events, wayland.output_done_decode(data))
		case wayland.OUTPUT_SCALE_OPCODE:
			append(&internal_state.events, wayland.output_scale_decode(data))
		case wayland.OUTPUT_NAME_OPCODE:
			append(&internal_state.events, wayland.output_name_decode(data, internal_state.temp_allocator))
		case wayland.OUTPUT_DESCRIPTION_OPCODE:
			append(&internal_state.events, wayland.output_description_decode(data, internal_state.temp_allocator))
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
			append(&internal_state.events, xdg_shell.wm_base_ping_decode(data))
		}
	case xdg_shell.POSITIONER_INTERFACE:
		switch opcode {
		}
	case xdg_shell.SURFACE_INTERFACE:
		switch opcode {
		case xdg_shell.SURFACE_CONFIGURE_OPCODE:
			append(&internal_state.events, xdg_shell.surface_configure_decode(data))
		}
	case xdg_shell.TOPLEVEL_INTERFACE:
		switch opcode {
		case xdg_shell.TOPLEVEL_CONFIGURE_OPCODE:
			append(&internal_state.events, xdg_shell.toplevel_configure_decode(data, internal_state.temp_allocator))
		case xdg_shell.TOPLEVEL_CLOSE_OPCODE:
			append(&internal_state.events, xdg_shell.toplevel_close_decode(data))
		case xdg_shell.TOPLEVEL_CONFIGURE_BOUNDS_OPCODE:
			append(&internal_state.events, xdg_shell.toplevel_configure_bounds_decode(data))
		case xdg_shell.TOPLEVEL_WM_CAPABILITIES_OPCODE:
			append(&internal_state.events, xdg_shell.toplevel_wm_capabilities_decode(data, internal_state.temp_allocator))
		}
	case xdg_shell.POPUP_INTERFACE:
		switch opcode {
		case xdg_shell.POPUP_CONFIGURE_OPCODE:
			append(&internal_state.events, xdg_shell.popup_configure_decode(data))
		case xdg_shell.POPUP_POPUP_DONE_OPCODE:
			append(&internal_state.events, xdg_shell.popup_popup_done_decode(data))
		case xdg_shell.POPUP_REPOSITIONED_OPCODE:
			append(&internal_state.events, xdg_shell.popup_repositioned_decode(data))
		}
	}
}
