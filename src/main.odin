package main

import "core:slice"
import client "../"
import dmabuf "../linux_dmabuf_v1"
import wl "../wayland"
import xdg "../xdg_shell"
import "core:log"
import "core:math"
import "core:sys/linux"

State :: struct {
	wl_registry:   u32,
	wl_compositor: u32,
	wl_shm:        u32,
	xdg_wm_base:   u32,
	wl_surface:    u32,
	xdg_surface:   u32,
	xdg_toplevel:  u32,
	shm_file:      linux.Fd,
	shm_pool_data: []byte,
	shm_pool:      u32,
	wl_buffer:     u32,
	linux_dmabuf:  u32,
	w, h:          i32,
	dt:            f64,
	quitting:      bool,
}

Pixel :: [4]u8

main :: proc() {
	context.logger = log.create_console_logger()

	state: State

	conn_err := client.connect()
	if conn_err != nil {
		log.error(conn_err)
		return
	}
	defer client.disconnect()

	get_registry := wl.Display_Get_Registry_Request {
		display = wl.display,
	}
	state.wl_registry, _ = client.queue_request(get_registry)

	register_global_objects(&state)

	create_surface := wl.Compositor_Create_Surface_Request {
		compositor = state.wl_compositor,
	}
	state.wl_surface, _ = client.queue_request(create_surface)

	get_xdg_surface := xdg.Wm_Base_Get_Xdg_Surface_Request {
		wm_base = state.xdg_wm_base,
		surface = state.wl_surface,
	}
	state.xdg_surface, _ = client.queue_request(get_xdg_surface)

	get_toplevel := xdg.Surface_Get_Toplevel_Request {
		surface = state.xdg_surface,
	}
	state.xdg_toplevel, _ = client.queue_request(get_toplevel)

	surface_commit := wl.Surface_Commit_Request {
		surface = state.wl_surface,
	}
	client.queue_request(surface_commit)
	// client.roundtrip()

	state.w, state.h = 512, 512
	shm_file_size := state.w * state.h * 4 * 2
	state.shm_file, state.shm_pool_data, _ = client.create_shm_file(shm_file_size)

	free_all(context.temp_allocator)
	for !state.quitting {
		handle_event(&state)
	}
}

register_global_objects :: proc(state: ^State) -> client.Error {
	client.roundtrip()
	for ev in client.poll_event() {
		#partial switch p in ev {
		case wl.Event:
			#partial switch e in p {
			case wl.Display_Error_Event:
				log.error(e.message)
			case wl.Registry_Global_Event:
				registry_bind := wl.Registry_Bind_Request {
					registry  = state.wl_registry,
					name      = e.name,
					interface = e.interface,
					version   = e.version,
				}
				id := client.queue_request(registry_bind) or_return
				switch e.interface {
				case wl.COMPOSITOR_INTERFACE:
					state.wl_compositor = id
				case wl.SHM_INTERFACE:
					state.wl_shm = id
				case xdg.WM_BASE_INTERFACE:
					state.xdg_wm_base = id
				case dmabuf.DMABUF_INTERFACE:
					state.linux_dmabuf = id
				}
			}
		}
	}
	return nil
}

handle_event :: proc(state: ^State) {
	client.roundtrip()
	for ev in client.poll_event() {
		#partial switch p in ev {
		case wl.Event:
			#partial switch e in p {
			case wl.Display_Error_Event:
				log.error(e.object_id, wl.Display_Error(e.code), e.message)
			}
		case xdg.Event:
			#partial switch e in p {
			case xdg.Wm_Base_Ping_Event:
				pong := xdg.Wm_Base_Pong_Request {
					wm_base = state.xdg_wm_base,
					serial  = e.serial,
				}
				client.queue_request(pong)
			case xdg.Surface_Configure_Event:
				ack_configure := xdg.Surface_Ack_Configure_Request {
					surface = state.xdg_surface,
					serial  = e.serial,
				}
				client.queue_request(ack_configure)

				if state.shm_pool == 0 {
					shm_file_size := state.w * state.h * 4 * 2
					create_pool := wl.Shm_Create_Pool_Request {
						shm  = state.wl_shm,
						fd   = state.shm_file,
						size = shm_file_size,
					}
					state.shm_pool, _ = client.queue_request(create_pool)
				}

				if state.wl_buffer == 0 {
					create_buffer := wl.Shm_Pool_Create_Buffer_Request {
						shm_pool = state.shm_pool,
						format   = u32(wl.Shm_Format.Argb8888),
						width    = state.w,
						height   = state.h,
						stride   = state.w * 4,
						offset   = 0,
					}
					state.wl_buffer, _ = client.queue_request(create_buffer)
				}
				
				i := 0
				pixels := slice.reinterpret([]Pixel, state.shm_pool_data)
				for &pixel in pixels {
					pixel.r = 100
					pixel.g = 100
					pixel.b = 100
					pixel.a = 255
					// state.shm_pool_data[i + 0] = 100 // u8((math.sin(state.dt + math.PI/3) + 1) / 2 / 256)
					// state.shm_pool_data[i + 1] = 100 // u8((math.sin(state.dt + 2 * math.PI/3) + 1) / 2 / 256)
					// state.shm_pool_data[i + 2] = 100 // u8((math.sin(state.dt + 3 * math.PI/3) + 1) / 2 / 256)
					// state.shm_pool_data[i + 3] = 255
					i += 4
				}

				attach := wl.Surface_Attach_Request {
					surface = state.wl_surface,
					buffer  = state.wl_buffer,
				}
				client.queue_request(attach)

				// damage := wl.Surface_Damage_Request {
				// 	surface = state.wl_surface,
				// 	width   = state.w,
				// 	height  = state.h,
				// }
				// client.queue_request(damage)

				commit := wl.Surface_Commit_Request {
					surface = state.wl_surface,
				}
				client.queue_request(commit)
			case xdg.Toplevel_Close_Event:
				state.quitting = true
			}
		}
	}
}


