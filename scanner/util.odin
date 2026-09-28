package scanner

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
		return "cstring"
	case "fixed":
		return "util.Fixed"
	}
	return type
}
