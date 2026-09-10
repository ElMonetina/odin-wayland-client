// Minimal DRM constants needed for dmabuf presentation.
package vulkan_integration

import vk "vendor:vulkan"

// Format modifiers.
DRM_FORMAT_MOD_LINEAR  :: u64(0)
DRM_FORMAT_MOD_INVALID :: u64(0x00ffffffffffffff)

// Map a Vulkan format to its DRM fourcc code (little-endian byte order).
// Returns DRM_FORMAT_INVALID (0) for unsupported formats.
fourcc_from_vulkan :: proc(format: vk.Format) -> u32 {
	#partial switch format {
	case .R8_UNORM:             return 0x20203852 // R8
	case .R8G8_UNORM:           return 0x38385247 // GR88
	case .R8G8B8_UNORM:         return 0x34324742 // BGR888
	case .B8G8R8_UNORM:         return 0x34324752 // RGB888
	case .R8G8B8A8_UNORM:       return 0x34324241 // ABGR8888
	case .B8G8R8A8_UNORM:       return 0x34325241 // ARGB8888
	case .A8B8G8R8_UNORM_PACK32: return 0x34324152 // RGBA8888
	case .R8G8B8A8_SRGB:        return 0x34324241 // ABGR8888
	case .B8G8R8A8_SRGB:        return 0x34325241 // ARGB8888
	case .R5G6B5_UNORM_PACK16:  return 0x36314742 // BGR565
	case .B5G6R5_UNORM_PACK16:  return 0x36314752 // RGB565
	case .R16_UNORM:            return 0x20363152 // R16
	case .R16G16B16A16_UNORM:   return 0x38344241 // ABGR16161616
	}
	return 0
}
