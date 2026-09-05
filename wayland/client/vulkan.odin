package client

import vk "vendor:vulkan"
import dl "core:dynlib"

load_vulkan_instance_proc_addr :: proc() -> (ok: bool) {
	internal_state.vulkan_lib = dl.load_library("libvulkan.so", false, internal_state.temp_allocator) or_return
	get_proc_addr := dl.symbol_address(internal_state.vulkan_lib, "vkGetInstanceProcAddr", internal_state.temp_allocator)
	vk.load_proc_addresses(get_proc_addr)
	return
}