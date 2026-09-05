package main

import "core:log"
import "core:sys/linux"
import vk "vendor:vulkan"
import "wayland:client"
import dmabuf "wayland:client/linux_dmabuf_v1"
import wl "wayland:client/wayland"
import xdg "wayland:client/xdg_shell"

Wayland_State :: struct {
	wl_registry:      u32,
	wl_compositor:    u32,
	wl_shm:           u32,
	xdg_wm_base:      u32,
	wl_surface:       u32,
	xdg_surface:      u32,
	configured:       bool,
	img_free:         bool,
	xdg_toplevel:     u32,
	shm_file:         linux.Fd,
	shm_pool_data:    []byte,
	shm_pool:         u32,
	wl_buffer:        u32,
	linux_dmabuf:     u32,
	dmabuf_fd:        linux.Fd,
	dmabuf_params_id: u32,
	dmabuf_buffer:    u32,
	w, h:             i32,
	dt:               f64,
	quitting:         bool,
}

Vulkan_State :: struct {
	instance:       vk.Instance,
	p_device:       vk.PhysicalDevice,
	device:         vk.Device,
	gfx_family_idx: u32,
	gfx_queue:      vk.Queue,
	cmd_pool:       vk.CommandPool,
	cmd_buf:        vk.CommandBuffer,
	img:            vk.Image,
	image_mem:      vk.DeviceMemory,
	mem_type_bit:   u32,
	img_view:       vk.ImageView,
	present_fence:  vk.Fence,
}

ENABLED_LAYERS :: []cstring{"VK_LAYER_KHRONOS_validation"}

EXT_EXTERNAL_MEMORY_FD :: "VK_KHR_external_memory_fd"
ENABLED_DEVICE_EXTENSIONS :: []cstring {
	vk.EXT_EXTERNAL_MEMORY_DMA_BUF_EXTENSION_NAME,
	vk.EXT_IMAGE_DRM_FORMAT_MODIFIER_EXTENSION_NAME,
	vk.KHR_IMAGE_FORMAT_LIST_EXTENSION_NAME,
	EXT_EXTERNAL_MEMORY_FD,
}

DRM_FORMAT_MOD_LINEAR :: 0 // DRM_FORMAT_MOD_LINEAR
DRM_FORMAT_ARGB8888 :: 0x34325241 // little-endian B,G,R,A -> VK_FORMAT_B8G8R8A8_UNORM

main :: proc() {
	context.logger = log.create_console_logger()

	vk_state: Vulkan_State

	conn_err := client.connect()
	if conn_err != nil {
		log.error(conn_err)
		return
	}
	defer client.disconnect()

	wl_state: Wayland_State
	init_wayland_state(&wl_state, 1280, 720)
	// Vulkan initialization

	app_info := vk.ApplicationInfo {
		sType      = .APPLICATION_INFO,
		apiVersion = vk.API_VERSION_1_1,
	}
	instance_ci := vk.InstanceCreateInfo {
		sType               = .INSTANCE_CREATE_INFO,
		enabledLayerCount   = u32(len(ENABLED_LAYERS)),
		ppEnabledLayerNames = raw_data(ENABLED_LAYERS),
		pApplicationInfo    = &app_info,
	}
	client.load_vulkan_instance_proc_addr()

	res: vk.Result
	res = vk.CreateInstance(&instance_ci, nil, &vk_state.instance)
	ensure(res == .SUCCESS)
	defer vk.DestroyInstance(vk_state.instance, nil)
	vk.load_proc_addresses(vk_state.instance)

	p_devices: []vk.PhysicalDevice
	p_devices, res = make_physical_devices(vk_state.instance)
	ensure(res == .SUCCESS)

	p_device, found := select_physical_device(p_devices)
	if found {
		vk_state.p_device = p_device
	} else {
		return
	}

	qfp_count: u32
	vk.GetPhysicalDeviceQueueFamilyProperties(vk_state.p_device, &qfp_count, nil)
	qfps := make([]vk.QueueFamilyProperties, qfp_count, context.temp_allocator)
	vk.GetPhysicalDeviceQueueFamilyProperties(vk_state.p_device, &qfp_count, raw_data(qfps))
	for qfp, i in qfps {
		if .GRAPHICS in qfp.queueFlags {
			vk_state.gfx_family_idx = u32(i)
			break
		}
	}
	q_priority := f32(1.0)
	queue_ci := vk.DeviceQueueCreateInfo {
		sType            = .DEVICE_QUEUE_CREATE_INFO,
		queueCount       = 1,
		queueFamilyIndex = vk_state.gfx_family_idx,
		pQueuePriorities = &q_priority,
	}
	device_ci := vk.DeviceCreateInfo {
		sType                   = .DEVICE_CREATE_INFO,
		enabledExtensionCount   = u32(len(ENABLED_DEVICE_EXTENSIONS)),
		ppEnabledExtensionNames = raw_data(ENABLED_DEVICE_EXTENSIONS),
		queueCreateInfoCount    = 1,
		pQueueCreateInfos       = &queue_ci,
	}
	res = vk.CreateDevice(vk_state.p_device, &device_ci, nil, &vk_state.device)
	ensure(res == .SUCCESS)
	defer vk.DestroyDevice(vk_state.device, nil)

	image_ci := vk.ImageCreateInfo {
		sType         = .IMAGE_CREATE_INFO,
		initialLayout = .UNDEFINED,
		imageType     = .D2,
		mipLevels     = 1,
		arrayLayers   = 1,
		samples       = {._1},
		tiling        = .DRM_FORMAT_MODIFIER_EXT,
		usage         = {.TRANSFER_DST},
		extent        = {u32(wl_state.w), u32(wl_state.h), 1},
		format        = .B8G8R8A8_UNORM,
	}
	img_drm_format_modifier_ci := vk.ImageDrmFormatModifierExplicitCreateInfoEXT {
		sType                       = .IMAGE_DRM_FORMAT_MODIFIER_EXPLICIT_CREATE_INFO_EXT,
		drmFormatModifier           = DRM_FORMAT_MOD_LINEAR,
		pPlaneLayouts               = &vk.SubresourceLayout{offset = 0, rowPitch = vk.DeviceSize(wl_state.w * 4)},
		drmFormatModifierPlaneCount = 1,
	}
	ext_mem_img_ci := vk.ExternalMemoryImageCreateInfo {
		sType       = .EXTERNAL_MEMORY_IMAGE_CREATE_INFO,
		handleTypes = {.DMA_BUF_EXT},
	}
	image_ci.pNext = &img_drm_format_modifier_ci
	img_drm_format_modifier_ci.pNext = &ext_mem_img_ci
	res = vk.CreateImage(vk_state.device, &image_ci, nil, &vk_state.img)
	ensure(res == .SUCCESS)
	defer vk.DestroyImage(vk_state.device, vk_state.img, nil)

	img_mem_reqs := vk.ImageMemoryRequirementsInfo2 {
		sType = .IMAGE_MEMORY_REQUIREMENTS_INFO_2,
		image = vk_state.img,
	}
	dedicated_reqs := vk.MemoryDedicatedRequirements {
		sType = .MEMORY_DEDICATED_REQUIREMENTS,
	}
	mem_reqs2 := vk.MemoryRequirements2 {
		sType = .MEMORY_REQUIREMENTS_2,
	}
	mem_reqs2.pNext = &dedicated_reqs
	vk.GetImageMemoryRequirements2(vk_state.device, &img_mem_reqs, &mem_reqs2)
	mem_reqs := mem_reqs2.memoryRequirements
	mem_props: vk.PhysicalDeviceMemoryProperties
	vk.GetPhysicalDeviceMemoryProperties(vk_state.p_device, &mem_props)
	bit_found: bool
	for i in 0 ..< 32 {
		if (mem_reqs.memoryTypeBits >> u32(i)) & 1 == 0 {continue}
		mt := mem_props.memoryTypes[i]
		if .DEVICE_LOCAL not_in mt.propertyFlags {continue}
		info2 := vk.PhysicalDeviceImageFormatInfo2 {
			sType  = .PHYSICAL_DEVICE_IMAGE_FORMAT_INFO_2,
			format = image_ci.format,
			type   = image_ci.imageType,
			tiling = image_ci.tiling,
			usage  = image_ci.usage,
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
		res = vk.GetPhysicalDeviceImageFormatProperties2(vk_state.p_device, &info2, &props)
		if res != .SUCCESS {
			continue
		}
		if .EXPORTABLE in external.externalMemoryProperties.externalMemoryFeatures {
			// Exportable to dmabud
			vk_state.mem_type_bit = u32(i)
			bit_found = true
			break
		}
	}
	if !bit_found {
		log.error("Compatible memory type not found!")
		return
	}

	alloc := vk.MemoryAllocateInfo {
		sType           = .MEMORY_ALLOCATE_INFO,
		allocationSize  = mem_reqs.size,
		memoryTypeIndex = vk_state.mem_type_bit,
	}
	dedicated_alloc := vk.MemoryDedicatedAllocateInfo {
		sType = .MEMORY_DEDICATED_ALLOCATE_INFO,
		image = vk_state.img,
	}
	export_alloc := vk.ExportMemoryAllocateInfo {
		sType       = .EXPORT_MEMORY_ALLOCATE_INFO,
		handleTypes = {.DMA_BUF_EXT},
	}
	alloc.pNext = &dedicated_alloc
	dedicated_alloc.pNext = &export_alloc
	res = vk.AllocateMemory(vk_state.device, &alloc, nil, &vk_state.image_mem)
	ensure(res == .SUCCESS)
	defer vk.FreeMemory(vk_state.device, vk_state.image_mem, nil)

	res = vk.BindImageMemory(vk_state.device, vk_state.img, vk_state.image_mem, 0)
	ensure(res == .SUCCESS)

	fd_info := vk.MemoryGetFdInfoKHR {
		sType      = .MEMORY_GET_FD_INFO_KHR,
		memory     = vk_state.image_mem,
		handleType = {.DMA_BUF_EXT},
	}
	fd: i32
	res = vk.GetMemoryFdKHR(vk_state.device, &fd_info, &fd)
	ensure(res == .SUCCESS)
	wl_state.dmabuf_fd = linux.Fd(fd)

	create_params := dmabuf.Dmabuf_Create_Params_Request {
		dmabuf = wl_state.linux_dmabuf,
	}
	wl_state.dmabuf_params_id, _ = client.queue_request(create_params)

	params_add := dmabuf.Buffer_Params_Add_Request {
		buffer_params = wl_state.dmabuf_params_id,
		fd            = wl_state.dmabuf_fd,
		offset        = 0,
		stride        = u32(wl_state.w * 4),
		modifier_lo   = u32(DRM_FORMAT_MOD_LINEAR),
		modifier_hi   = u32(DRM_FORMAT_MOD_LINEAR >> 32),
	}
	client.queue_request(params_add)

	create_immed := dmabuf.Buffer_Params_Create_Immed_Request {
		buffer_params = wl_state.dmabuf_params_id,
		width         = wl_state.w,
		height        = wl_state.h,
		format        = DRM_FORMAT_ARGB8888, // same as the vulkan side
	}
	wl_state.dmabuf_buffer, _ = client.queue_request(create_immed)

	fence_ci := vk.FenceCreateInfo {
		sType = .FENCE_CREATE_INFO,
		flags = {.SIGNALED},
	}
	res = vk.CreateFence(vk_state.device, &fence_ci, nil, &vk_state.present_fence)
	ensure(res == .SUCCESS)
	defer vk.DestroyFence(vk_state.device, vk_state.present_fence, nil)

	vk.GetDeviceQueue(vk_state.device, vk_state.gfx_family_idx, 0, &vk_state.gfx_queue)

	cmd_pool_ci := vk.CommandPoolCreateInfo {
		sType            = .COMMAND_POOL_CREATE_INFO,
		flags            = {.RESET_COMMAND_BUFFER},
		queueFamilyIndex = vk_state.gfx_family_idx,
	}
	res = vk.CreateCommandPool(vk_state.device, &cmd_pool_ci, nil, &vk_state.cmd_pool)
	if res != .SUCCESS {
		log.error(res)
		return
	}
	defer vk.DestroyCommandPool(vk_state.device, vk_state.cmd_pool, nil)

	cmd_buf_ai := vk.CommandBufferAllocateInfo {
		sType              = .COMMAND_BUFFER_ALLOCATE_INFO,
		commandPool        = vk_state.cmd_pool,
		level              = .PRIMARY,
		commandBufferCount = 1,
	}
	vk.AllocateCommandBuffers(vk_state.device, &cmd_buf_ai, &vk_state.cmd_buf)

	cmd_buf_bi := vk.CommandBufferBeginInfo {
		sType = .COMMAND_BUFFER_BEGIN_INFO,
		flags = {.ONE_TIME_SUBMIT},
	}
	res = vk.BeginCommandBuffer(vk_state.cmd_buf, &cmd_buf_bi)
	ensure(res == .SUCCESS)

	subresource := vk.ImageSubresourceRange {
		aspectMask     = {.COLOR},
		baseMipLevel   = 0,
		levelCount     = 1,
		baseArrayLayer = 0,
		layerCount     = 1,
	}
	barrier := vk.ImageMemoryBarrier {
		sType               = .IMAGE_MEMORY_BARRIER,
		dstAccessMask       = {.TRANSFER_WRITE},
		oldLayout           = .UNDEFINED,
		newLayout           = .TRANSFER_DST_OPTIMAL,
		srcQueueFamilyIndex = max(u32),
		dstQueueFamilyIndex = max(u32),
		image               = vk_state.img,
		subresourceRange    = subresource,
	}
	vk.CmdPipelineBarrier(vk_state.cmd_buf, {.TOP_OF_PIPE}, {.TRANSFER}, {}, 0, nil, 0, nil, 1, &barrier)
	color := vk.ClearColorValue {
		float32 = {0, 0.5, 1.0, 1.0},
	}

	vk.CmdClearColorImage(vk_state.cmd_buf, vk_state.img, .TRANSFER_DST_OPTIMAL, &color, 1, &subresource)

	barrier.srcAccessMask = {.TRANSFER_WRITE}
	barrier.oldLayout = .TRANSFER_DST_OPTIMAL
	barrier.newLayout = .GENERAL
	vk.CmdPipelineBarrier(vk_state.cmd_buf, {.TRANSFER}, {.ALL_COMMANDS}, {}, 0, nil, 0, nil, 1, &barrier)

	vk.EndCommandBuffer(vk_state.cmd_buf)

	submit := vk.SubmitInfo {
		sType              = .SUBMIT_INFO,
		commandBufferCount = 1,
		pCommandBuffers    = &vk_state.cmd_buf,
	}
	res = vk.ResetFences(vk_state.device, 1, &vk_state.present_fence)
	ensure(res == .SUCCESS)
	res = vk.QueueSubmit(vk_state.gfx_queue, 1, &submit, vk_state.present_fence)
	ensure(res == .SUCCESS)
	res = vk.WaitForFences(vk_state.device, 1, &vk_state.present_fence, true, max(u64))
	ensure(res == .SUCCESS)

	free_all(context.temp_allocator)

	for !wl_state.quitting {
		handle_event(&wl_state)
		if wl_state.configured && wl_state.img_free {
			res = vk.ResetCommandBuffer(vk_state.cmd_buf, {})
			ensure(res == .SUCCESS)
			cmd_buf_bi := vk.CommandBufferBeginInfo {
				sType = .COMMAND_BUFFER_BEGIN_INFO,
				flags = {.ONE_TIME_SUBMIT},
			}
			res = vk.BeginCommandBuffer(vk_state.cmd_buf, &cmd_buf_bi)
			ensure(res == .SUCCESS)

			subresource := vk.ImageSubresourceRange {
				aspectMask     = {.COLOR},
				baseMipLevel   = 0,
				levelCount     = 1,
				baseArrayLayer = 0,
				layerCount     = 1,
			}
			barrier := vk.ImageMemoryBarrier {
				sType               = .IMAGE_MEMORY_BARRIER,
				dstAccessMask       = {.TRANSFER_WRITE},
				oldLayout           = .UNDEFINED,
				newLayout           = .TRANSFER_DST_OPTIMAL,
				srcQueueFamilyIndex = max(u32),
				dstQueueFamilyIndex = max(u32),
				image               = vk_state.img,
				subresourceRange    = subresource,
			}
			vk.CmdPipelineBarrier(vk_state.cmd_buf, {.TOP_OF_PIPE}, {.TRANSFER}, {}, 0, nil, 0, nil, 1, &barrier)
			color := vk.ClearColorValue {
				float32 = {0, 0.5, 1.0, 1.0},
			}

			vk.CmdClearColorImage(vk_state.cmd_buf, vk_state.img, .TRANSFER_DST_OPTIMAL, &color, 1, &subresource)

			barrier.srcAccessMask = {.TRANSFER_WRITE}
			barrier.oldLayout = .TRANSFER_DST_OPTIMAL
			barrier.newLayout = .GENERAL
			vk.CmdPipelineBarrier(vk_state.cmd_buf, {.TRANSFER}, {.ALL_COMMANDS}, {}, 0, nil, 0, nil, 1, &barrier)

			vk.EndCommandBuffer(vk_state.cmd_buf)

			res = vk.ResetFences(vk_state.device, 1, &vk_state.present_fence)
			ensure(res == .SUCCESS)
			res = vk.QueueSubmit(vk_state.gfx_queue, 1, &submit, vk_state.present_fence)
			ensure(res == .SUCCESS)
			res = vk.WaitForFences(vk_state.device, 1, &vk_state.present_fence, true, max(u64))
			ensure(res == .SUCCESS)

			attach := wl.Surface_Attach_Request {
				buffer  = wl_state.dmabuf_buffer,
				surface = wl_state.wl_surface,
			}
			client.queue_request(attach)
			commit := wl.Surface_Commit_Request {
				surface = wl_state.wl_surface,
			}
			client.queue_request(commit)
			wl_state.img_free = false
		}
	}
}

init_wayland_state :: proc(state: ^Wayland_State, shm_width, shm_height: i32) {
	get_registry := wl.Display_Get_Registry_Request {
		display = wl.display,
	}
	state.wl_registry, _ = client.queue_request(get_registry)

	register_global_objects(state)

	create_surface := wl.Compositor_Create_Surface_Request {
		compositor = state.wl_compositor,
	}
	state.wl_surface, _ = client.queue_request(create_surface)

	get_xdg_surface := xdg.Wm_Base_Get_Xdg_Surface_Request {
		wm_base = state.xdg_wm_base,
		surface = state.wl_surface,
	}
	state.xdg_surface, _ = client.queue_request(get_xdg_surface)

	get_toplevel := xdg.Surface_Get_Toplevel_Request {
		surface = state.xdg_surface,
	}
	state.xdg_toplevel, _ = client.queue_request(get_toplevel)

	surface_commit := wl.Surface_Commit_Request {
		surface = state.wl_surface,
	}
	client.queue_request(surface_commit)
	// client.roundtrip()

	state.w, state.h = shm_width, shm_height
	shm_file_size := state.w * state.h * 4 * 2
	state.shm_file, state.shm_pool_data, _ = client.create_shm_file(shm_file_size)
}

register_global_objects :: proc(state: ^Wayland_State) -> client.Error {
	client.roundtrip()
	for ev in client.poll_event() {
		#partial switch p in ev {
		case wl.Event:
			#partial switch e in p {
			case wl.Display_Error_Event:
				log.error(e.message)
			case wl.Registry_Global_Event:
				registry_bind := wl.Registry_Bind_Request {
					registry  = state.wl_registry,
					name      = e.name,
					interface = e.interface,
					version   = e.version,
				}
				id := client.queue_request(registry_bind) or_return
				switch e.interface {
				case wl.COMPOSITOR_INTERFACE:
					state.wl_compositor = id
				case wl.SHM_INTERFACE:
					state.wl_shm = id
				case xdg.WM_BASE_INTERFACE:
					state.xdg_wm_base = id
				case dmabuf.DMABUF_INTERFACE:
					state.linux_dmabuf = id
				}
			}
		}
	}
	return nil
}

make_physical_devices :: proc(instance: vk.Instance, allocator := context.temp_allocator) -> (p_devices: []vk.PhysicalDevice, res: vk.Result) {
	p_device_count: u32
	vk.EnumeratePhysicalDevices(instance, &p_device_count, nil) or_return
	p_devices = make([]vk.PhysicalDevice, p_device_count, allocator)
	vk.EnumeratePhysicalDevices(instance, &p_device_count, raw_data(p_devices)) or_return
	return
}

select_physical_device :: proc(p_devices: []vk.PhysicalDevice) -> (vk.PhysicalDevice, bool) {
	for p_device in p_devices {
		props := vk.PhysicalDeviceProperties2 {
			sType = .PHYSICAL_DEVICE_PROPERTIES_2,
		}
		vk.GetPhysicalDeviceProperties2(p_device, &props)
		if props.properties.deviceType == .DISCRETE_GPU {
			return p_device, true
		}
	}
	return {}, false
}

handle_event :: proc(state: ^Wayland_State) {
	client.roundtrip()
	for ev in client.poll_event() {
		#partial switch p in ev {
		case wl.Event:
			#partial switch e in p {
			case wl.Display_Error_Event:
				log.error(e.object_id, wl.Display_Error(e.code), e.message)
			case wl.Buffer_Release_Event:
				state.img_free = true
			}
		case xdg.Event:
			#partial switch e in p {
			case xdg.Wm_Base_Ping_Event:
				pong := xdg.Wm_Base_Pong_Request {
					wm_base = state.xdg_wm_base,
					serial  = e.serial,
				}
				client.queue_request(pong)
			case xdg.Surface_Configure_Event:
				ack_configure := xdg.Surface_Ack_Configure_Request {
					surface = state.xdg_surface,
					serial  = e.serial,
				}
				client.queue_request(ack_configure)
				state.configured = true
				state.img_free = true

			case xdg.Toplevel_Close_Event:
				state.quitting = true
			}
		}
	}
}
