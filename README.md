# README

This is a native to Odin implementation of Wayland, an alternative to libwayland, the project also includes a `generator.py` script,

## Overview

As of the time of writing, only client side generation is supported. It will be handled after I
manage to solve an [`interesting`](https://wayland-book.com/surfaces/dmabuf.html) problem.

### API Design

There are no callbacks! The user simply queues requests to the server an polls on the events.

```Odin
package main

import client "wayland-client" // Client glue code and helpers
import wl "wayland-client/wayland" // The generated protocol code
import xdg "wayland-client/xdg_shell"

main :: proc() {
	client.connect()
	defer client.disconnect()

	get_registry := wl.Display_Get_Registry_Request{
		display = wl.display // This is a special case, since wl_display is a global object id.
	}
	wl_registry, _ := client.queue_request(get_registry) // Can return an error!!!

	client.roundtrip()
	for ev in client.poll_event() {
		#partial switch p in ev {
		case wl.Event:
			#partial e in p {
			case wl.Registry_Global_Event:
				registry_bind := wl.Registry_Bind_Request {
					registry  = state.wl_registry,
					name      = e.name,
					interface = e.interface,
					version   = e.version,
				}
				id := client.queue_request(registry_bind)
				// wl_compositor = id
			}
		}
	}
}
```

- `connect()`: Creates a connection with the running wayland server as well as initializing
 internal state. `allocator` and `temp_allocator` can optionally be passed. Be sure that the 
 temporary one supports calling `free_all(temp_allocator)`.
- `queue_request(req)`: Queues the request data into an internal buffer, the procedure is 
essentially a big type switcher on `req`. This allows for a very straight forward surface API, 
initialize a `*_Request` struct and pass it to the proc.
- `roundtrip()`: Sends all buffered request data and reads all incoming event data, encoding it in an 
internal `events` array. **Must be called before `poll_event`**
- `poll_event()`: Returns `event, true` if available, `nil, false` otherwise. The `event` is a 
double union, the first switch is to know which protocol the event belongs to, the second switch 
is to get the actual event. Finally its fields can be read from to initialize requests for queueing.

### The generator

`generator.py` is written by an LLM slave, because I couldn't be bothered. I will write a proper
executable file in the future.

For now its quiet dumb, it needs to be run where `client.odin` is, takes a directory as a single 
argument and generates the protocols in their own directory. It is important to run it with all needed xml files, If one or more is ever removed or added the generator must be re-run.

### The **interesting** problem

Using vulkan without libwayland is a pain, the Swapchain extension expects the use of 
libwayland's wl_surface, which I don't have. So TL:DR I need to implement my own swapchain, this 
is hard but I will try and **succed**.
