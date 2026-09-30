package scanner

import "core:unicode/utf8"
import "core:unicode"
import "core:fmt"
import "core:strconv"
import "core:strings"

ident :: proc(name: string) -> string {
	trimmed := strings.trim_space(name)
	if trimmed == "" {
		return "_"
	}
	first, _ := utf8.decode_rune_in_string(trimmed)
	if unicode.is_digit(first) {
		return fmt.tprintf("_%v", trimmed)
	}
	return trimmed
}

parse_enum_value :: proc(value: string) -> int {
	parsed, ok := strconv.parse_int(strings.trim_space(value))
	assert(ok, fmt.tprintf("invalid enum value: %q", value))
	return parsed
}

bit_index :: proc(mask: int) -> int {
	if mask <= 0 || (mask & (mask - 1)) != 0 {
		return -1
	}
	index := 0
	for rest := mask; rest > 1; rest >>= 1 {
		index += 1
	}
	return index
}

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
