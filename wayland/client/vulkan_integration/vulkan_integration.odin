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

EXT_EXTERNAL_MEMORY_FD :: "VK_KHR_external_memory_fd"
REQUIRED_DEVICE_EXTENSIONS :: []cstring {
	vk.EXT_EXTERNAL_MEMORY_DMA_BUF_EXTENSION_NAME,
	vk.EXT_IMAGE_DRM_FORMAT_MODIFIER_EXTENSION_NAME,
	vk.KHR_IMAGE_FORMAT_LIST_EXTENSION_NAME,
	EXT_EXTERNAL_MEMORY_FD,
}

// Merged struct for image creation, it includes:
// - ImageCreateInfo
// - ImageDrmFormatModifierExplicitCreateInfoEXT
// - ExternalMemoryImageCreateInfo
// It removes pNext member as it is not needed, sType is handled automatically
// When possible types are made more odin friendly.

Image_Create_Info :: struct {
	// - ImageCreateInfo
	flags:                vk.ImageCreateFlags,
	image_type:           vk.ImageType,
	format:               vk.Format,
	extent:               vk.Extent3D,
	mip_levels:           u32,
	array_layers:         u32,
	samples:              vk.SampleCountFlags,
	usage:                vk.ImageUsageFlags,
	sharing_mode:         vk.SharingMode,
	queue_family_indices: []u32,
	initial_layout:       vk.ImageLayout,
	
	// - ImageDrmFormatModifierExplicitCreateInfoEXT
	drm_format_modifier: u64,
	plane_layouts:       []vk.SubresourceLayout,

	// - ExternalMemoryImageCreateInfo
	handleTypes: vk.ExternalMemoryHandleTypeFlags,

	// If you wish to extend it further
	next: rawptr,
}

create_image :: proc(device: vk.Device, create_info: Image_Create_Info, allocator: ^vk.AllocationCallbacks) -> (image: vk.Image, res: vk.Result) {
	img_ci := vk.ImageCreateInfo {
		sType = .IMAGE_CREATE_INFO,
		
		flags = create_info.flags,
		imageType = create_info.image_type,
		format = create_info.format,
		extent = create_info.extent,
		mipLevels = create_info.mip_levels,
		arrayLayers = create_info.array_layers,
		samples = create_info.samples,
		tiling = .DRM_FORMAT_MODIFIER_EXT,
		usage = create_info.usage,
		sharingMode = create_info.sharing_mode,
		queueFamilyIndexCount = u32(len(create_info.queue_family_indices)),
		pQueueFamilyIndices = raw_data(create_info.queue_family_indices),
		initialLayout = create_info.initial_layout,
	}
	img_drm_format_mod_ci := vk.ImageDrmFormatModifierExplicitCreateInfoEXT {
		sType = .IMAGE_DRM_FORMAT_MODIFIER_EXPLICIT_CREATE_INFO_EXT,

		drmFormatModifier = create_info.drm_format_modifier,
		drmFormatModifierPlaneCount = u32(len(create_info.plane_layouts)),
		pPlaneLayouts = raw_data(create_info.plane_layouts),
	}
	ext_mem_img_ci := vk.ExternalMemoryImageCreateInfo {
		sType = .EXTERNAL_MEMORY_IMAGE_CREATE_INFO,
		handleTypes = create_info.handleTypes,
	}
	img_ci.pNext = &img_drm_format_mod_ci
	img_drm_format_mod_ci.pNext = &ext_mem_img_ci
	if create_info.next != nil {
		ext_mem_img_ci.pNext = create_info.next
	}
	vk.CreateImage(device, &img_ci, allocator, &image) or_return
	return
}
