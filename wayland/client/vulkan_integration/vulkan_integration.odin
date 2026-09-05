/*
This package is a replacement for the default mesa WSI.
Since we do not use libwayland, we can't have the niceties mesa gives us,
like image memory allocation and swapchain management. 
*/
package window_system_integration

import vk "vendor:vulkan"
import client "../"
import dl "core:dynlib"

load_vulkan_instance_proc_addr :: proc() -> (ok: bool) {
	client.internal_state.vulkan_lib = dl.load_library("libvulkan.so", false, client.internal_state.temp_allocator) or_return
	get_proc_addr := dl.symbol_address(client.internal_state.vulkan_lib, "vkGetInstanceProcAddr", client.internal_state.temp_allocator)
	vk.load_proc_addresses(get_proc_addr)
	return
}