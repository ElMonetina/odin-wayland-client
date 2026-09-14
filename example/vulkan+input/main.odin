package main

import "core:log"
import "core:os"
import "core:sys/linux"
import vk "vendor:vulkan"
import "wayland:client"
import dmabuf "wayland:client/linux_dmabuf_v1"
import vki "wayland:client/vulkan_integration"
import wl "wayland:client/wayland"
import xdg "wayland:client/xdg_shell"
import xkb "./xkb"

App :: struct {
	client_state:     client.Client,
	wl_registry:      wl.Registry,
	wl_compositor:    wl.Compositor,
	xdg_wm_base:      xdg.Wm_Base,
	wl_seat:          wl.Seat,
	wl_surface:       wl.Surface,
	xdg_surface:      xdg.Surface,
	configured:       bool,
	img_free:         bool,
	xdg_toplevel:     xdg.Toplevel,
	linux_dmabuf:     dmabuf.Dmabuf,
	w, h:             i32,
	quitting:         bool,

	// Keyboard + xkbcommon
	wl_keyboard:      wl.Keyboard,
	xkb_ctx:          ^xkb.ctx,
	xkb_keymap:       ^xkb.keymap,
	xkb_state:        ^xkb.state,
	keymap_ptr:       rawptr,
	keymap_size:      uint,
	color_index:      u32,

	// Vulkan section
	surface:          vki.Surface,
	swapchain:        vki.Swapchain,
	instance:         vk.Instance,
	p_device:         vk.PhysicalDevice,
	device:           vk.Device,
	gfx_family_idx:   u32,
	gfx_queue:        vk.Queue,
	cmd_pool:         vk.CommandPool,
	cmd_bufs:         [FRAMES_IN_FLIGHT]vk.CommandBuffer,
	frame_rendered:   [FRAMES_IN_FLIGHT]bool,
	lib:              vki.Library,
}

ENABLED_LAYERS :: []cstring{"VK_LAYER_KHRONOS_validation"}

FRAMES_IN_FLIGHT :: 2

CLEAR_COLORS := [3]vk.ClearColorValue {
	{float32 = {0.0, 0.5, 1.0, 1.0}},
	{float32 = {0.0, 1.0, 0.6, 1.0}},
	{float32 = {1.0, 0.4, 0.1, 1.0}},
}

main :: proc() {
	context.logger = log.create_console_logger()

	app := new(App)
	defer free(app)

	client_err: client.Error
	app.client_state, client_err = client.create()
	ensure(client_err == nil)
	defer client.destroy(&app.client_state)

	app.xkb_ctx = xkb.context_new({})
	ensure(app.xkb_ctx != nil)
	defer {
		if app.xkb_state != nil {
			xkb.state_unref(app.xkb_state)
		}
		if app.xkb_keymap != nil {
			xkb.keymap_unref(app.xkb_keymap)
		}
		xkb.context_unref(app.xkb_ctx)
		if app.keymap_ptr != nil {
			linux.munmap(app.keymap_ptr, app.keymap_size)
		}
	}

	init_app(app, 1280, 720)
	free_all(context.temp_allocator)

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
	loaded: bool
	app.lib, loaded = vki.load_instance_proc_addr()
	ensure(loaded == true)

	vk_allocator := vki.make_allocator()
	defer vki.destroy_allocator(vk_allocator)

	res: vk.Result
	res = vk.CreateInstance(&instance_ci, &vk_allocator, &app.instance)
	ensure(res == .SUCCESS)
	defer vk.DestroyInstance(app.instance, &vk_allocator)
	vk.load_proc_addresses(app.instance)

	p_devices: []vk.PhysicalDevice
	p_devices, res = make_physical_devices(app.instance)
	ensure(res == .SUCCESS)

	p_device, found := select_physical_device(p_devices)
	if found {
		app.p_device = p_device
	} else {
		return
	}

	qfp_count: u32
	vk.GetPhysicalDeviceQueueFamilyProperties(app.p_device, &qfp_count, nil)
	qfps := make([]vk.QueueFamilyProperties, qfp_count, context.temp_allocator)
	vk.GetPhysicalDeviceQueueFamilyProperties(app.p_device, &qfp_count, raw_data(qfps))
	for qfp, i in qfps {
		if .GRAPHICS in qfp.queueFlags {
			app.gfx_family_idx = u32(i)
			break
		}
	}
	q_priority := f32(1.0)
	queue_ci := vk.DeviceQueueCreateInfo {
		sType            = .DEVICE_QUEUE_CREATE_INFO,
		queueCount       = 1,
		queueFamilyIndex = app.gfx_family_idx,
		pQueuePriorities = &q_priority,
	}
	device_ci := vk.DeviceCreateInfo {
		sType                   = .DEVICE_CREATE_INFO,
		enabledExtensionCount   = u32(len(vki.REQUIRED_DEVICE_EXTENSIONS)),
		ppEnabledExtensionNames = raw_data(vki.REQUIRED_DEVICE_EXTENSIONS),
		queueCreateInfoCount    = 1,
		pQueueCreateInfos       = &queue_ci,
	}
	res = vk.CreateDevice(app.p_device, &device_ci, &vk_allocator, &app.device)
	ensure(res == .SUCCESS)
	defer vk.DestroyDevice(app.device, &vk_allocator)

	vk.GetDeviceQueue(app.device, app.gfx_family_idx, 0, &app.gfx_queue)

	img_ci := vki.Image_Create_Info {
		initial_layout      = .UNDEFINED,
		type                = .D2,
		mip_levels          = 1,
		array_layers        = 1,
		samples             = {._1},
		usage               = {.TRANSFER_DST},
		extent              = {u32(app.w), u32(app.h), 1},
		format              = .B8G8R8A8_UNORM,
		drm_format_modifier = vki.DRM_FORMAT_MOD_LINEAR,
		plane_layouts       = {{offset = 0, rowPitch = vk.DeviceSize(app.w * 4)}},
		handleTypes         = {.DMA_BUF_EXT},
	}
	swapchain_ci := vki.Swapchain_Create_Info {
		surface     = app.surface,
		img_ci      = img_ci,
		image_count = FRAMES_IN_FLIGHT,
	}
	app.swapchain, res = vki.create_swapchain(app.p_device, app.device, app.gfx_queue, swapchain_ci, &vk_allocator)
	ensure(res == .SUCCESS)
	defer vki.destroy_swapchain(&app.swapchain, &vk_allocator)

	cmd_pool_ci := vk.CommandPoolCreateInfo {
		sType            = .COMMAND_POOL_CREATE_INFO,
		flags            = {.RESET_COMMAND_BUFFER},
		queueFamilyIndex = app.gfx_family_idx,
	}
	res = vk.CreateCommandPool(app.device, &cmd_pool_ci, &vk_allocator, &app.cmd_pool)
	if res != .SUCCESS {
		log.error(res)
		return
	}
	defer vk.DestroyCommandPool(app.device, app.cmd_pool, &vk_allocator)
	defer vk.DeviceWaitIdle(app.device)

	cmd_buf_ai := vk.CommandBufferAllocateInfo {
		sType              = .COMMAND_BUFFER_ALLOCATE_INFO,
		commandPool        = app.cmd_pool,
		level              = .PRIMARY,
		commandBufferCount = len(app.cmd_bufs),
	}
	vk.AllocateCommandBuffers(app.device, &cmd_buf_ai, &app.cmd_bufs[0])

	for !app.quitting {
		free_all(context.temp_allocator)
		handle_event(app)
		if app.configured && app.img_free {
			render(app)
		}
	}
}

render :: proc(app: ^App) {
	res: vk.Result
	image, idx, _ := vki.swapchain_acquire_next_image(&app.swapchain)
	cmd_buf := app.cmd_bufs[idx]

	res = vk.ResetCommandBuffer(cmd_buf, {})
	ensure(res == .SUCCESS)
	cmd_buf_bi := vk.CommandBufferBeginInfo {
		sType = .COMMAND_BUFFER_BEGIN_INFO,
		flags = {.ONE_TIME_SUBMIT},
	}
	res = vk.BeginCommandBuffer(cmd_buf, &cmd_buf_bi)
	ensure(res == .SUCCESS)

	subresource := vk.ImageSubresourceRange {
		aspectMask     = {.COLOR},
		baseMipLevel   = 0,
		levelCount     = 1,
		baseArrayLayer = 0,
		layerCount     = 1,
	}
	old_layout := vk.ImageLayout.GENERAL if app.frame_rendered[idx] else .UNDEFINED
	barrier := vk.ImageMemoryBarrier {
		sType               = .IMAGE_MEMORY_BARRIER,
		dstAccessMask       = {.TRANSFER_WRITE},
		oldLayout           = old_layout,
		newLayout           = .TRANSFER_DST_OPTIMAL,
		srcQueueFamilyIndex = max(u32),
		dstQueueFamilyIndex = max(u32),
		image               = image,
		subresourceRange    = subresource,
	}
	vk.CmdPipelineBarrier(cmd_buf, {.TOP_OF_PIPE}, {.TRANSFER}, {}, 0, nil, 0, nil, 1, &barrier)
	color: vk.ClearColorValue = CLEAR_COLORS[app.color_index]

	vk.CmdClearColorImage(cmd_buf, image, .TRANSFER_DST_OPTIMAL, &color, 1, &subresource)

	barrier.srcAccessMask = {.TRANSFER_WRITE}
	barrier.oldLayout = .TRANSFER_DST_OPTIMAL
	barrier.newLayout = .GENERAL
	vk.CmdPipelineBarrier(cmd_buf, {.TRANSFER}, {.ALL_COMMANDS}, {}, 0, nil, 0, nil, 1, &barrier)

	vk.EndCommandBuffer(cmd_buf)

	submit := vk.SubmitInfo {
		sType              = .SUBMIT_INFO,
		commandBufferCount = 1,
		pCommandBuffers    = &cmd_buf,
	}
	res = vki.swapchain_present(&app.swapchain, idx, []vk.SubmitInfo{submit})
	ensure(res == .SUCCESS)

	app.frame_rendered[idx] = true
	app.img_free = false
}

init_app :: proc(app: ^App, width, height: i32) {
	get_registry := wl.Display_Get_Registry_Request {
		display = wl.display,
	}
	app.wl_registry, _ = client.queue_request(&app.client_state, get_registry)

	err := register_global_objects(app)
	ensure(err == nil)
	free_all(context.temp_allocator)

	create_surface := wl.Compositor_Create_Surface_Request {
		compositor = app.wl_compositor,
	}
	app.wl_surface, _ = client.queue_request(&app.client_state, create_surface)
	app.surface = {
		client       = &app.client_state,
		wl_surface   = app.wl_surface,
		linux_dmabuf = app.linux_dmabuf,
		w            = width,
		h            = height,
	}

	get_xdg_surface := xdg.Wm_Base_Get_Xdg_Surface_Request {
		wm_base = app.xdg_wm_base,
		surface = app.wl_surface,
	}
	app.xdg_surface, _ = client.queue_request(&app.client_state, get_xdg_surface)

	get_toplevel := xdg.Surface_Get_Toplevel_Request {
		surface = app.xdg_surface,
	}
	app.xdg_toplevel, _ = client.queue_request(&app.client_state, get_toplevel)

	get_keyboard := wl.Seat_Get_Keyboard_Request {
		seat = app.wl_seat,
	}
	app.wl_keyboard, _ = client.queue_request(&app.client_state, get_keyboard)

	surface_commit := wl.Surface_Commit_Request {
		surface = app.wl_surface,
	}
	client.queue_request(&app.client_state, surface_commit)

	app.w, app.h = width, height
}

register_global_objects :: proc(app: ^App) -> client.Error {
	client.roundtrip(&app.client_state) or_return
	for ev in client.poll_event(&app.client_state) {
		#partial switch e in ev {
		case wl.Display_Error_Event:
			log.error(e.message)
		case wl.Registry_Global_Event:
			switch e.interface {
			case wl.COMPOSITOR_INTERFACE:
				app.wl_compositor = client.bind_compositor(&app.client_state, app.wl_registry, e) or_return
			case xdg.WM_BASE_INTERFACE:
				app.xdg_wm_base = client.bind_wm_base(&app.client_state, app.wl_registry, e) or_return
			case dmabuf.DMABUF_INTERFACE:
				app.linux_dmabuf = client.bind_dmabuf(&app.client_state, app.wl_registry, e) or_return
			case wl.SEAT_INTERFACE:
				app.wl_seat = client.bind_seat(&app.client_state, app.wl_registry, e) or_return
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

handle_event :: proc(app: ^App) {
	err := client.roundtrip(&app.client_state)
	if err != nil {
		log.error(err)
		os.exit(1)
	}
	for ev in client.poll_event(&app.client_state) {
		#partial switch e in ev {
		case wl.Display_Error_Event:
			log.error(e.object_id, e.code, e.message)
		case wl.Buffer_Release_Event:
			app.img_free = true
		case wl.Keyboard_Keymap_Event:
			if e.format == .Xkb_V1 {
				load_keymap(app, e.fd, e.size)
			}
		case wl.Keyboard_Key_Event:
			handle_key(app, e.key, e.state)
		case wl.Keyboard_Modifiers_Event:
			handle_mods(app, e)
		case xdg.Wm_Base_Ping_Event:
			pong := xdg.Wm_Base_Pong_Request {
				wm_base = app.xdg_wm_base,
				serial  = e.serial,
			}
			client.queue_request(&app.client_state, pong)
		case xdg.Surface_Configure_Event:
			ack_configure := xdg.Surface_Ack_Configure_Request {
				surface = app.xdg_surface,
				serial  = e.serial,
			}
			client.queue_request(&app.client_state, ack_configure)
			app.configured = true
			app.img_free = true

		case xdg.Toplevel_Close_Event:
			app.quitting = true
		}
	}
}

load_keymap :: proc(app: ^App, fd: linux.Fd, size: u32) {
	// mmap requires a size; a zero-sized keymap is a protocol violation, so bail.
	if size == 0 {
		log.error("keymap event with size 0")
		linux.close(fd)
		return
	}
	ptr, err := linux.mmap(0, uint(size), {.READ}, {.PRIVATE}, fd, 0)
	linux.close(fd)
	if err != nil {
		log.error("keymap mmap failed:", err)
		return
	}
	log.info("keymap mapped", size, "bytes")
	if app.keymap_ptr != nil {
		linux.munmap(app.keymap_ptr, app.keymap_size)
	}
	app.keymap_ptr = ptr
	app.keymap_size = uint(size)

	keymap := xkb.keymap_new_from_string(app.xkb_ctx, cstring(ptr), .TEXT_V1, {})
	if keymap == nil {
		log.error("xkb_keymap_new_from_string failed")
		return
	}
	log.info("keymap parsed ok")
	state := xkb.state_new(keymap)
	if state == nil {
		xkb.keymap_unref(keymap)
		log.error("xkb_state_new failed")
		return
	}
	if app.xkb_state != nil {
		xkb.state_unref(app.xkb_state)
	}
	if app.xkb_keymap != nil {
		xkb.keymap_unref(app.xkb_keymap)
	}
	app.xkb_keymap = keymap
	app.xkb_state = state
	log.info("xkb_state ready")
}

handle_key :: proc(app: ^App, key: u32, state: wl.Keyboard_Key_State) {
	if app.xkb_state == nil {
		return
	}

	kc := xkb.keycode_t(key) + 8
	direction := xkb.key_direction.DOWN if state == .Pressed || state == .Repeated else .UP
	xkb.state_update_key(app.xkb_state, kc, direction)
	if state == .Pressed {
		sym := xkb.state_key_get_one_sym(app.xkb_state, kc)
		if sym == xkb.keysym_from_name("space", {}) {
			app.color_index = (app.color_index + 1) % u32(len(CLEAR_COLORS))
			log.info("color ->", app.color_index)
		}
	}
}

handle_mods :: proc(app: ^App, e: wl.Keyboard_Modifiers_Event) {
	if app.xkb_state == nil {
		return
	}
	group := xkb.layout_index_t(e.group)
	xkb.state_update_mask(
		app.xkb_state,
		xkb.mod_mask_t(e.mods_depressed),
		xkb.mod_mask_t(e.mods_latched),
		xkb.mod_mask_t(e.mods_locked),
		group,
		group,
		group,
	)
}