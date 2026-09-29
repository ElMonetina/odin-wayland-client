package scanner

import "core:unicode/utf8"

wayland_to_odin_type :: proc(type: string) -> string {
	switch type {
	case "uint":
		return "u32"
	case "int":
		return "i32"
	case "new_id":
		return "u32"
	case "fd":
		return "linux.Fd"
	case "string":
		return "string"
	case "fixed":
		return "util.Fixed"
	case "array":
		return "[]u8"
	}
	return type
}

find_prefix :: proc(name: string) -> string {
	prefix := make([dynamic]rune, context.temp_allocator)
	for r in name {
		append(&prefix, r)
		if r == '_' {
			return utf8.runes_to_string(prefix[:], context.temp_allocator)
		}
	}
	return ""
}
