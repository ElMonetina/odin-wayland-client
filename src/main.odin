package main

import client "../" // Client glue code and helpers
import wl "../wayland" // The generated protocol code

main :: proc() {
	client.connect()
	defer client.disconnect()

	get_registry := wl.Display_Get_Registry_Request{
		display = wl.display, // This is a special case, since wl_display is a global object id.
	}
	wl_registry, _ := client.queue_request(get_registry) // Can return an error!!!

	client.roundtrip()
	for ev in client.poll_event() {
		#partial switch p in ev {
		case wl.Event:
			#partial switch e in p {
			case wl.Registry_Global_Event:
				registry_bind := wl.Registry_Bind_Request {
					registry  = wl_registry,
					name      = e.name,
					interface = e.interface,
					version   = e.version,
				}
				id, _ := client.queue_request(registry_bind)
				_ = id
			}
		}
	}
}
