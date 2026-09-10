# README

This is a native to Odin implementation of Wayland, an alternative to libwayland, the project also includes a `generator.py` script,

## Overview

As of the time of writing, only client side generation is supported. 
Vulkan integration is also provided, solving an [`interesting`](https://wayland-book.com/surfaces/dmabuf.html) problem.

### Client API Design

There are no callbacks! The user simply queues requests to the server an polls on the events.

```Odin
package main

import client "wayland/client" // Client glue code and helpers
import wl "wayland/client/wayland" // The generated protocol code
import xdg "wayland/client/xdg_shell"

main :: proc() {
	client := client.create()
	defer client.destroy(&client)

	get_registry := wl.Display_Get_Registry_Request{
		display = wl.display // This is a special case, since wl_display is a global object id.
	}
	wl_registry := client.queue_request(get_registry)

	free_all(context.temp_allocator) // Very important!!! Always call before roundtrip()
	client.roundtrip(&client)
	for ev in client.poll_event(&client) {
		#partial switch ev {
		case wl.Registry_Global:
			switch ev.interface {
			case wl.COMPOSITOR_INTERFACE:
				wl_compositor := client.bind_compositor(&client, wl_registry, ev) or_return
			case wl.SHM_INTERFACE:
				wl_shm := client.bind_shm(&client, wl_registry, ev) or_return
			case xdg.WM_BASE_INTERFACE:
				xdg_wm_base := client.bind_wm_base(&client, wl_registry, ev) or_return
			}
		}
	}
}
```

- `create()`: Creates a connection with the running wayland server as well as initializing
 a state that is returned top the user.
- `queue_request(req)`: Queues the request data into an internal buffer, the procedure is 
essentially a big type switcher on `req`. This allows for a very straight forward surface API, 
initialize a `*_Request` struct and pass it to the proc.
- `roundtrip()`: Sends all buffered request data and reads all incoming event data.
- `poll_event()`: returns a single event if present, exits when no more events can be parsed.

### The generator

`generator.py` is written by an LLM slave, because I couldn't be bothered. I will write a proper
executable file in the future.

For now its quite dumb, it needs to be run where `client.odin` is, takes a directory as a single 
argument and generates the protocols in their own directory. It is important to run it with all needed xml files, If one or more is ever removed or added the generator must be re-run.

### The **interesting** problem

Using vulkan without libwayland is a pain, the Swapchain extension expects the use of 
libwayland's wl_surface, which I don't have. So TL:DR I need to implement my own swapchain, this 
is hard but I will try and **succed**.
