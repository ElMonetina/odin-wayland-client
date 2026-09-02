package client

import vk "vendor:vulkan"
import "core:dynlib"

create_vulkan_instance :: proc(create_info: ^vk.InstanceCreateInfo, allocator: ^vk.AllocationCallbacks) -> (instance: vk.Instance, ok: bool) {
	lib := dynlib.load_library("libvulkan.so", false, internal_state.temp_allocator) or_return
	defer dynlib.unload_library(lib)

	get_proc_addr := dynlib.symbol_address(lib, "vkGetInstanceProcAddr", internal_state.temp_allocator) or_return
	vk.load_proc_addresses(get_proc_addr)

	result := vk.CreateInstance(create_info, allocator, &instance)
	if result != .SUCCESS {
		return {}, false
	}
	vk.load_proc_addresses(instance)
	free_all(internal_state.temp_allocator)
	return instance, true
}
