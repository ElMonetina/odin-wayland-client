// DISCLAIMER: LLM generated example

package main

import "core:log"
import "core:os"
import "core:sys/linux"
import "wayland:client"
import wl "wayland:client/wayland"
import xdg "wayland:client/xdg_shell"

WIDTH :: i32(800)
HEIGHT :: i32(600)
STRIDE :: 4 * WIDTH
TILE :: int(64)

App :: struct {
	wayland:       client.Client,
	wl_registry:   wl.Registry,
	wl_compositor: wl.Compositor,
	wl_shm:        wl.Shm,
	xdg_wm_base:   xdg.Wm_Base,
	wl_surface:    wl.Surface,
	xdg_surface:   xdg.Surface,
	xdg_toplevel:  xdg.Toplevel,
	shm_pool:      wl.Shm_Pool,
	wl_buffer:     wl.Buffer,
	shm_fd:        linux.Fd,
	pool_data:     []byte,
	configured:    bool,
	quitting:      bool,
}

main :: proc() {
	context.logger = log.create_console_logger()

	app: App

	created, client_err := client.create()
	ensure(client_err == nil)
	app.wayland = created
	defer client.destroy(&app.wayland)
	free_all(context.temp_allocator)

	registry := wl.Display_Get_Registry_Request { display = wl.display }
	app.wl_registry, client_err = client.queue_request(&app.wayland, registry)
	ensure(client_err == nil)
	err := register_globals(&app)
	ensure(err == nil)

	create_surface := wl.Compositor_Create_Surface_Request { compositor = app.wl_compositor }
	app.wl_surface, client_err = client.queue_request(&app.wayland, create_surface)
	ensure(client_err == nil)

	get_xdg := xdg.Wm_Base_Get_Xdg_Surface_Request {
		wm_base = app.xdg_wm_base,
		surface = app.wl_surface,
	}
	app.xdg_surface, client_err = client.queue_request(&app.wayland, get_xdg)
	ensure(client_err == nil)

	get_toplevel := xdg.Surface_Get_Toplevel_Request { surface = app.xdg_surface }
	app.xdg_toplevel, client_err = client.queue_request(&app.wayland, get_toplevel)
	ensure(client_err == nil)

	set_title := xdg.Toplevel_Set_Title_Request {
		toplevel = app.xdg_toplevel,
		title    = "checkerboard",
	}
	client.queue_request(&app.wayland, set_title)

	commit := wl.Surface_Commit_Request { surface = app.wl_surface }
	client.queue_request(&app.wayland, commit)

	event_loop(&app)
}

register_globals :: proc(app: ^App) -> client.Error {
	client.roundtrip(&app.wayland) or_return
	for ev in client.poll_event(&app.wayland) {
		#partial switch e in ev {
		case wl.Registry_Global_Event:
			switch e.interface {
			case wl.COMPOSITOR_INTERFACE:
				app.wl_compositor = client.bind_compositor(&app.wayland, app.wl_registry, e) or_return
			case wl.SHM_INTERFACE:
				app.wl_shm = client.bind_shm(&app.wayland, app.wl_registry, e) or_return
			case xdg.WM_BASE_INTERFACE:
				app.xdg_wm_base = client.bind_wm_base(&app.wayland, app.wl_registry, e) or_return
			}
		}
	}
	return nil
}

event_loop :: proc(app: ^App) {
	for !app.quitting {
		free_all(context.temp_allocator)
		handle_events(app)
	}
}

handle_events :: proc(app: ^App) {
	err := client.roundtrip(&app.wayland)
	if err != nil {
		log.error(err)
		app.quitting = true
		return
	}
	for ev in client.poll_event(&app.wayland) {
		#partial switch e in ev {
		case wl.Display_Error_Event:
			log.error(e.object_id, wl.Display_Error(e.code), e.message)
			app.quitting = true
		case xdg.Surface_Configure_Event:
			ack := xdg.Surface_Ack_Configure_Request {
				surface = app.xdg_surface,
				serial  = e.serial,
			}
			client.queue_request(&app.wayland, ack)
			if !app.configured {
				create_shm_buffer(app)
				draw(app)
				present(app)
				app.configured = true
			}
		case xdg.Wm_Base_Ping_Event:
			pong := xdg.Wm_Base_Pong_Request {
				wm_base = app.xdg_wm_base,
				serial  = e.serial,
			}
			client.queue_request(&app.wayland, pong)
		case xdg.Toplevel_Close_Event:
			app.quitting = true
		}
	}
}

create_shm_buffer :: proc(app: ^App) {
	pool_size := i32(WIDTH * HEIGHT * 4)
	file_size := pool_size

	app.shm_fd, app.pool_data, _ = client.create_shm_file(file_size)
	create_pool := wl.Shm_Create_Pool_Request {
		shm  = app.wl_shm,
		fd   = app.shm_fd,
		size = pool_size,
	}
	app.shm_pool, _ = client.queue_request(&app.wayland, create_pool)

	create_buffer := wl.Shm_Pool_Create_Buffer_Request {
		shm_pool = app.shm_pool,
		offset   = 0,
		width    = WIDTH,
		height   = HEIGHT,
		stride   = STRIDE,
		format   = wl.Shm_Format.Xrgb8888,
	}
	app.wl_buffer, _ = client.queue_request(&app.wayland, create_buffer)
}

draw :: proc(app: ^App) {
	pixels := ([^]u32)(raw_data(app.pool_data))
	light := u32(0xff_ff_ff)
	dark := u32(0x22_22_22)
	for y in 0 ..< HEIGHT {
		row := int(y) / TILE
		for x in 0 ..< WIDTH {
			col := int(x) / TILE
			color := dark
			if (row + col) % 2 == 0 {
				color = light
			}
			pixels[int(y) * int(WIDTH) + int(x)] = color
		}
	}
}

present :: proc(app: ^App) {
	attach := wl.Surface_Attach_Request {
		surface = app.wl_surface,
		buffer  = app.wl_buffer,
		x       = 0,
		y       = 0,
	}
	client.queue_request(&app.wayland, attach)

	damage := wl.Surface_Damage_Request {
		surface = app.wl_surface,
		x       = 0,
		y       = 0,
		width   = WIDTH,
		height  = HEIGHT,
	}
	client.queue_request(&app.wayland, damage)

	commit := wl.Surface_Commit_Request { surface = app.wl_surface }
	client.queue_request(&app.wayland, commit)
}
