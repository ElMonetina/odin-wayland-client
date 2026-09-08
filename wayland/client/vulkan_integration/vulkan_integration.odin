/*
This package is a replacement for the default mesa WSI.
Since we do not use libwayland, we can't have the niceties mesa gives us,
like image memory allocation and swapchain management. 
*/
package vulkan_integration

import client "../"
import dmabuf "../linux_dmabuf_v1"
import wl "../wayland"
import "base:runtime"
import dl "core:dynlib"
import "core:mem"
import "core:sys/linux"
import vk "vendor:vulkan"

Library :: dl.Library

load_instance_proc_addr :: proc(allocator := context.temp_allocator) -> (vk_lib: Library, loaded: bool) {
	vk_lib = dl.load_library("libvulkan.so", false, allocator) or_return
	get_proc_addr := dl.symbol_address(vk_lib, "vkGetInstanceProcAddr", allocator)
	vk.load_proc_addresses(get_proc_addr)
	loaded = true
	return
}

EXT_EXTERNAL_MEMORY_FD :: "VK_KHR_external_memory_fd"
REQUIRED_DEVICE_EXTENSIONS :: []cstring{vk.EXT_EXTERNAL_MEMORY_DMA_BUF_EXTENSION_NAME, vk.EXT_IMAGE_DRM_FORMAT_MODIFIER_EXTENSION_NAME, vk.KHR_IMAGE_FORMAT_LIST_EXTENSION_NAME, EXT_EXTERNAL_MEMORY_FD}

// Merged struct for image creation, it includes:
// - ImageCreateInfo
// - ImageDrmFormatModifierExplicitCreateInfoEXT
// - ExternalMemoryImageCreateInfo
// It removes pNext member as it is not needed, sType is handled automatically
// When possible types are made more odin friendly.

Image_Create_Info :: struct {
	// - ImageCreateInfo
	flags:                vk.ImageCreateFlags,
	type:                 vk.ImageType,
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
	drm_format_modifier:  u64,
	plane_layouts:        []vk.SubresourceLayout,

	// - ExternalMemoryImageCreateInfo
	handleTypes:          vk.ExternalMemoryHandleTypeFlags,

	// If you wish to extend it further
	next:                 rawptr,
}

create_image :: proc(device: vk.Device, create_info: Image_Create_Info, allocator: ^vk.AllocationCallbacks = nil) -> (image: vk.Image, res: vk.Result) {
	img_ci := vk.ImageCreateInfo {
		sType                 = .IMAGE_CREATE_INFO,
		flags                 = create_info.flags,
		imageType             = create_info.type,
		format                = create_info.format,
		extent                = create_info.extent,
		mipLevels             = create_info.mip_levels,
		arrayLayers           = create_info.array_layers,
		samples               = create_info.samples,
		tiling                = .DRM_FORMAT_MODIFIER_EXT,
		usage                 = create_info.usage,
		sharingMode           = create_info.sharing_mode,
		queueFamilyIndexCount = u32(len(create_info.queue_family_indices)),
		pQueueFamilyIndices   = raw_data(create_info.queue_family_indices),
		initialLayout         = create_info.initial_layout,
	}
	img_drm_format_mod_ci := vk.ImageDrmFormatModifierExplicitCreateInfoEXT {
		sType                       = .IMAGE_DRM_FORMAT_MODIFIER_EXPLICIT_CREATE_INFO_EXT,
		drmFormatModifier           = create_info.drm_format_modifier,
		drmFormatModifierPlaneCount = u32(len(create_info.plane_layouts)),
		pPlaneLayouts               = raw_data(create_info.plane_layouts),
	}
	ext_mem_img_ci := vk.ExternalMemoryImageCreateInfo {
		sType       = .EXTERNAL_MEMORY_IMAGE_CREATE_INFO,
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

allocate_image_memory :: proc(p_device: vk.PhysicalDevice, device: vk.Device, image: vk.Image, image_format: vk.Format, image_type: vk.ImageType, usage: vk.ImageUsageFlags, allocator: ^vk.AllocationCallbacks = nil) -> (mem: vk.DeviceMemory, res: vk.Result) {
	img_mem_reqs := vk.ImageMemoryRequirementsInfo2 {
		sType = .IMAGE_MEMORY_REQUIREMENTS_INFO_2,
		image = image,
	}
	dedicated_reqs := vk.MemoryDedicatedRequirements {
		sType = .MEMORY_DEDICATED_REQUIREMENTS,
	}
	mem_reqs2 := vk.MemoryRequirements2 {
		sType = .MEMORY_REQUIREMENTS_2,
	}
	mem_reqs2.pNext = &dedicated_reqs
	vk.GetImageMemoryRequirements2(device, &img_mem_reqs, &mem_reqs2)
	mem_reqs := mem_reqs2.memoryRequirements
	mem_props: vk.PhysicalDeviceMemoryProperties
	vk.GetPhysicalDeviceMemoryProperties(p_device, &mem_props)
	bit_found: bool
	mem_type_bit: u32
	for i in 0 ..< 32 {
		if (mem_reqs.memoryTypeBits >> u32(i)) & 1 == 0 {continue}
		mt := mem_props.memoryTypes[i]
		if .DEVICE_LOCAL not_in mt.propertyFlags {continue}
		info2 := vk.PhysicalDeviceImageFormatInfo2 {
			sType  = .PHYSICAL_DEVICE_IMAGE_FORMAT_INFO_2,
			format = image_format,
			type   = image_type,
			tiling = .DRM_FORMAT_MODIFIER_EXT,
			usage  = usage,
		}
		modifier_info := vk.PhysicalDeviceImageDrmFormatModifierInfoEXT {
			sType             = .PHYSICAL_DEVICE_IMAGE_DRM_FORMAT_MODIFIER_INFO_EXT,
			drmFormatModifier = DRM_FORMAT_MOD_LINEAR,
		}
		external_info := vk.PhysicalDeviceExternalImageFormatInfo {
			sType      = .PHYSICAL_DEVICE_EXTERNAL_IMAGE_FORMAT_INFO,
			handleType = {.DMA_BUF_EXT},
		}
		info2.pNext = &modifier_info
		modifier_info.pNext = &external_info
		props := vk.ImageFormatProperties2 {
			sType = .IMAGE_FORMAT_PROPERTIES_2,
		}
		external := vk.ExternalImageFormatProperties {
			sType = .EXTERNAL_IMAGE_FORMAT_PROPERTIES,
		}
		props.pNext = &external
		res = vk.GetPhysicalDeviceImageFormatProperties2(p_device, &info2, &props)
		if res != .SUCCESS {
			continue
		}
		if .EXPORTABLE in external.externalMemoryProperties.externalMemoryFeatures {
			// Exportable to dmabuf
			mem_type_bit = u32(i)
			bit_found = true
			break
		}
	}
	if !bit_found {
		return {}, .ERROR_INCOMPATIBLE_DRIVER
	}

	alloc := vk.MemoryAllocateInfo {
		sType           = .MEMORY_ALLOCATE_INFO,
		allocationSize  = mem_reqs.size,
		memoryTypeIndex = mem_type_bit,
	}
	dedicated_alloc := vk.MemoryDedicatedAllocateInfo {
		sType = .MEMORY_DEDICATED_ALLOCATE_INFO,
		image = image,
	}
	export_alloc := vk.ExportMemoryAllocateInfo {
		sType       = .EXPORT_MEMORY_ALLOCATE_INFO,
		handleTypes = {.DMA_BUF_EXT},
	}
	alloc.pNext = &dedicated_alloc
	dedicated_alloc.pNext = &export_alloc
	res = vk.AllocateMemory(device, &alloc, allocator, &mem)
	return
}

query_memory_fd :: proc(device: vk.Device, mem: vk.DeviceMemory) -> (fd: linux.Fd, res: vk.Result) {
	fd_info := vk.MemoryGetFdInfoKHR {
		sType      = .MEMORY_GET_FD_INFO_KHR,
		memory     = mem,
		handleType = {.DMA_BUF_EXT},
	}
	ifd: i32
	vk.GetMemoryFdKHR(device, &fd_info, &ifd) or_return
	fd = linux.Fd(ifd)
	return
}

Surface :: struct {
	client:       ^client.Client,
	wl_surface:   wl.Surface,
	linux_dmabuf: dmabuf.Dmabuf,
	w, h:         i32,
}

destroy_surface :: proc() {}

Swapchain :: struct {
	surface:       Surface,
	device:        vk.Device,
	queue:         vk.Queue,
	images:        []vk.Image,
	images_mem:    []vk.DeviceMemory,
	dmabuf_fd:     []linux.Fd,
	wl_buffers:    []wl.Buffer,
	buffer_params: []dmabuf.Buffer_Params,
	fences:        []vk.Fence,
	image_index:   int,
}

// TODO: have an image count, allocate slices to that length.<
// also have a buffer_params config.
Swapchain_Create_Info :: struct {
	surface:             Surface,
	buffer_params_flags: dmabuf.Buffer_Params_Flags_Set,
	img_ci:              Image_Create_Info,
	image_count:         uint,
}

create_swapchain :: proc(p_device: vk.PhysicalDevice, device: vk.Device, queue: vk.Queue, create_info: Swapchain_Create_Info, allocator: ^vk.AllocationCallbacks = nil) -> (sc: Swapchain, res: vk.Result) {
	sc.surface = create_info.surface
	sc.device = device
	sc.queue = queue

	fourcc := fourcc_from_vulkan(create_info.img_ci.format)
	stride := u32(create_info.img_ci.plane_layouts[0].rowPitch)
	image_count := create_info.image_count
	if image_count == 0 {
		image_count = 2
	}

	sc.images = make([]vk.Image, image_count)
	sc.images_mem = make([]vk.DeviceMemory, image_count)
	sc.dmabuf_fd = make([]linux.Fd, image_count)
	sc.wl_buffers = make([]wl.Buffer, image_count)
	sc.buffer_params = make([]dmabuf.Buffer_Params, image_count)
	sc.fences = make([]vk.Fence, image_count)


	for i in 0 ..< image_count {
		sc.images[i] = create_image(device, create_info.img_ci, allocator) or_return
		sc.images_mem[i] = allocate_image_memory(p_device, device, sc.images[i], create_info.img_ci.format, create_info.img_ci.type, create_info.img_ci.usage) or_return
		vk.BindImageMemory(device, sc.images[i], sc.images_mem[i], 0) or_return
		sc.dmabuf_fd[i] = query_memory_fd(device, sc.images_mem[i]) or_return

		// Register the fd as a dmabuf buffer with the compositor.
		create_params := dmabuf.Dmabuf_Create_Params_Request {
			dmabuf = create_info.surface.linux_dmabuf,
		}
		params_id, _ := client.queue_request(create_info.surface.client, create_params)
		sc.buffer_params[i] = params_id

		params_add := dmabuf.Buffer_Params_Add_Request {
			buffer_params = params_id,
			fd            = sc.dmabuf_fd[i],
			offset        = 0,
			stride        = stride,
			modifier_lo   = u32(create_info.img_ci.drm_format_modifier),
			modifier_hi   = u32(create_info.img_ci.drm_format_modifier >> 32),
		}
		client.queue_request(create_info.surface.client, params_add)

		create_immed := dmabuf.Buffer_Params_Create_Immed_Request {
			buffer_params = params_id,
			width         = create_info.surface.w,
			height        = create_info.surface.h,
			format        = fourcc,
			flags         = create_info.buffer_params_flags,
		}
		sc.wl_buffers[i], _ = client.queue_request(create_info.surface.client, create_immed)

		fence_ci := vk.FenceCreateInfo {
			sType = .FENCE_CREATE_INFO,
			flags = {.SIGNALED},
		}
		vk.CreateFence(device, &fence_ci, allocator, &sc.fences[i]) or_return
	}

	sc.image_index = 0
	return
}

destroy_swapchain :: proc(sc: ^Swapchain, allocator: ^vk.AllocationCallbacks = nil) -> vk.Result {
	// Wait for all in-flight submissions to finish, so no fence is in use and
	// no command buffer is pending before we tear anything down.
	vk.DeviceWaitIdle(sc.device) or_return

	for i in 0 ..< len(sc.images) {
		// Tell the compositor to release the buffer + params, then drop our fd.
		destroy := wl.Buffer_Destroy_Request {
			buffer = sc.wl_buffers[i],
		}
		client.queue_request(sc.surface.client, destroy)
		params_destroy := dmabuf.Buffer_Params_Destroy_Request {
			buffer_params = sc.buffer_params[i],
		}
		client.queue_request(sc.surface.client, params_destroy)
		linux.close(sc.dmabuf_fd[i])

		vk.DestroyFence(sc.device, sc.fences[i], allocator)
		vk.FreeMemory(sc.device, sc.images_mem[i], allocator)
		vk.DestroyImage(sc.device, sc.images[i], allocator)
	}
	delete(sc.images)
	delete(sc.images_mem)
	delete(sc.dmabuf_fd)
	delete(sc.wl_buffers)
	delete(sc.buffer_params)
	delete(sc.fences)
	return .SUCCESS
}

swapchain_acquire_next_image :: proc(sc: ^Swapchain) -> (image: vk.Image, idx: int, res: vk.Result) {
	idx = sc.image_index
	vk.WaitForFences(sc.device, 1, &sc.fences[idx], true, max(u64)) or_return
	vk.ResetFences(sc.device, 1, &sc.fences[idx]) or_return

	image = sc.images[idx]
	sc.image_index = (idx + 1) % len(sc.images)
	return
}

swapchain_present :: proc(sc: ^Swapchain, idx: int, submit_info: []vk.SubmitInfo) -> vk.Result {
	vk.QueueSubmit(sc.queue, u32(len(submit_info)), raw_data(submit_info), sc.fences[idx]) or_return
	attach := wl.Surface_Attach_Request {
		surface = sc.surface.wl_surface,
		buffer  = sc.wl_buffers[idx],
	}
	client.queue_request(sc.surface.client, attach)
	commit := wl.Surface_Commit_Request {
		surface = sc.surface.wl_surface,
	}
	client.queue_request(sc.surface.client, commit)
	return .SUCCESS
}

make_allocator :: proc(allocator := context.allocator) -> vk.AllocationCallbacks {
	// The Compat_Allocator must outlive the callbacks, so it lives on the heap
	// and is reached via pUserData. The callbacks never free it themselves.
	compat := new(mem.Compat_Allocator, allocator)
	mem.compat_allocator_init(compat, allocator)

	cb: vk.AllocationCallbacks
	cb.pUserData = compat
	cb.pfnAllocation = mem_allocate
	cb.pfnReallocation = mem_realloc
	cb.pfnFree = mem_free
	return cb
}

destroy_allocator :: proc(vulkan_allocator: vk.AllocationCallbacks, init_allocator := context.allocator) {
	free(vulkan_allocator.pUserData, init_allocator)
}

mem_allocate :: proc "system" (user_data: rawptr, size: int, alignment: int, allocation_scope: vk.SystemAllocationScope) -> rawptr {
	context = runtime.default_context()
	memory, err := mem.compat_allocator_proc(user_data, .Alloc, size, alignment, nil, 0)
	if err != .None {
		return nil
	}
	return raw_data(memory)
}

mem_realloc :: proc "system" (user_data: rawptr, original: rawptr, size: int, alignment: int, allocation_scope: vk.SystemAllocationScope) -> rawptr {
	context = runtime.default_context()
	memory, err := mem.compat_allocator_proc(user_data, .Resize, size, alignment, original, 0)
	if err != .None {
		return nil
	}
	return raw_data(memory)
}

mem_free :: proc "system" (user_data: rawptr, memory: rawptr) {
	context = runtime.default_context()
	mem.compat_allocator_proc(user_data, .Free, 0, 0, memory, 0)
}
