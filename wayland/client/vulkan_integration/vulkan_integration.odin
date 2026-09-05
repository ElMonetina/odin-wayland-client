/*
This package is a replacement for the default mesa WSI.
Since we do not use libwayland, we can't have the niceties mesa gives us,
like image memory allocation and swapchain management. 
*/
package vulkan_integration

import vk "vendor:vulkan"
import client "../"
import dl "core:dynlib"

Library :: dl.Library

load_instance_proc_addr :: proc(allocator := context.temp_allocator) -> (vk_lib: Library, loaded: bool) {
	vk_lib = dl.load_library("libvulkan.so", false, allocator) or_return
	get_proc_addr := dl.symbol_address(vk_lib, "vkGetInstanceProcAddr", allocator)
	vk.load_proc_addresses(get_proc_addr)
	loaded = true
	return
}