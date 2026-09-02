package client

import vk "vendor:vulkan"
import "core:dynlib"

create_vulkan_instance :: proc(create_info: ^vk.InstanceCreateInfo, allocator: ^vk.AllocationCallbacks) -> (instance: vk.Instance, ok: bool) {
	lib := dynlib.load_library("libvulkan.so", false, internal_state.temp_allocator) or_return
	proc_ptr := dynlib.symbol_address(lib, "vkCreateInstance", internal_state.temp_allocator) or_return
	vk.load_proc_addresses(proc_ptr)
	dynlib.unload_library(lib) or_return

	vk.CreateInstance(create_info, allocator, &instance)
	return
}
