package scanner

import "core:log"
import "core:fmt"
import "core:strings"

write_client_protocol :: proc(sb: ^strings.Builder, p: Protocol, allocator := context.temp_allocator) {
	fmt.sbprintf(sb, "package %v\n\n", p.pkg)
	fmt.sbprintf(sb, "import \"../../util\"\n")
	if p.pkg != "wayland" {
		fmt.sbprintf(sb, "import wayland \"../wayland\"\n")
	}
	fmt.sbprintf(sb, "import \"core:sys/linux\"\n")
	fmt.sbprintf(sb, "import \"base:runtime\"\n\n")
	fmt.sbprintf(sb, "/*%v\n*/\n\n", p.copyright)
	for interface in p.interfaces {
		write_client_interface(sb, interface, p.pkg, allocator)
	}
}

write_client_interface :: proc(sb: ^strings.Builder, interface: Interface, pkg_name: string, allocator := context.temp_allocator) {
	name := interface.name
	stripped_name := strings.trim_prefix(name, find_prefix(name))
	stripped_name = strings.to_upper(stripped_name, allocator)
	fmt.sbprintf(sb, "%v_INTERFACE :: \"%v\"\n", stripped_name, name)
	fmt.sbprintf(sb, "%v_VERSION   :: %v\n\n", stripped_name, interface.version)
	write_description(sb, interface.description)
	stripped_name = strings.to_ada_case(stripped_name, allocator)
	fmt.sbprintf(sb, "%v :: distinct u32\n", stripped_name)
	fmt.sbprintf(sb, "\n")
	for req, i in interface.requests {
		stripped_name = strings.to_ada_case(stripped_name, allocator)
		req_name := fmt.tprintf("%v_Request", req.name)
		req_name = strings.to_ada_case(req_name, allocator)
		opcode := fmt.tprintf("%v_%v_OPCODE", strings.to_upper(stripped_name, allocator), strings.to_upper(req_name, allocator))
		fmt.sbprintf(sb, "%v :: %v\n", opcode, i)
		write_description(sb, req.description)
		fmt.sbprintf(sb, "%v_%v :: struct {{\n", stripped_name, req_name)
		fmt.sbprintf(sb, "\t%v: %v,\n", strings.to_lower(stripped_name, allocator), strings.to_ada_case(stripped_name, allocator))
		returns_new_id: bool
		for arg in req.args {
			write_arg(sb, arg, pkg_name, allocator)
			if arg.type == "new_id" {
				returns_new_id = true
			}
		}
		fmt.sbprintf(sb, "}\n")
		fmt.sbprintf(sb, "%v_%v_write :: proc(buf: ^[dynamic]byte, req: %v_%v", strings.to_lower(stripped_name, allocator), strings.to_lower(req_name, allocator), strings.to_ada_case(stripped_name, allocator), strings.to_ada_case(req_name, allocator))
		if returns_new_id {
			fmt.sbprintf(sb, ", new_id: u32")
		}
		fmt.sbprintf(sb, ") -> (num_appended: int, err: runtime.Allocator_Error) #optional_allocator_error {{\n")
		fmt.sbprintf(sb, "\tobject := u32(req.%v)\n", strings.to_lower(stripped_name, allocator))
		fmt.sbprintf(sb, "\topcode := u16(%v)\n", opcode)
		fmt.sbprintf(sb, "\tsize   := u16(8")
		for arg in req.args {
			if arg.type == "new_id" {
				continue
			}
			prefix := find_prefix(arg.interface)
			arg_interface := strings.trim_prefix(arg.interface, prefix)
			if arg.type == "string" {
				fmt.sbprintf(sb, " + util.compute_string_size(req.%v)", arg.name)
			} else if arg.name != "id" && arg.name != arg_interface{
				fmt.sbprintf(sb, " + size_of(req.%v)", arg.name)
			}
		}
		if returns_new_id {
			fmt.sbprintf(sb, " + size_of(new_id)")
		}
		fmt.sbprintf(sb, ")\n")
		fmt.sbprintf(sb, "\tnum_appended += util.write(buf, object, opcode, size) or_return\n")
		for arg in req.args {
			if arg.type == "new_id" {
				continue
			}
			prefix := find_prefix(arg.interface)
			arg_interface := strings.trim_prefix(arg.interface, prefix)
			if arg.type == "fd" {
				continue
			}
			if arg.name != "id" && arg.name != arg_interface {
				if arg.type == "object" {
					fmt.sbprintf(sb, "\tnum_appended += util.write(buf, u32(req.%v)) or_return\n", arg.name)
				} else {
					fmt.sbprintf(sb, "\tnum_appended += util.write(buf, req.%v) or_return\n", arg.name)
				}
			}
		}
		if returns_new_id {
			fmt.sbprintf(sb, "\tnum_appended += util.write(buf, new_id) or_return\n")
		}
		fmt.sbprintf(sb, "\treturn\n")
		fmt.sbprintf(sb, "}\n")
		fmt.sbprintf(sb, "\n")
	}
	for ev in interface.events {
		stripped_name = strings.to_ada_case(stripped_name, allocator)
		ev_name := fmt.tprintf("%v_Event", ev.name)
		event := fmt.tprintf("%v_%v", strings.to_lower(stripped_name, allocator), strings.to_lower(ev_name, allocator))
		write_description(sb, ev.description)
		fmt.sbprintf(sb, "%v :: struct {{\n", strings.to_ada_case(event, allocator))
		fmt.sbprintf(sb, "\t%v: %v,\n", strings.to_lower(stripped_name, allocator), strings.to_ada_case(stripped_name, allocator))
		returns_new_id: bool
		for arg in ev.args {
			write_arg(sb, arg, pkg_name, allocator)
			if arg.type == "new_id" {
				returns_new_id = true
			}
		}
		fmt.sbprintf(sb, "}\n")
		fmt.sbprintf(sb, "%v_read :: proc(buf: []byte) -> (%v, int) {{\n", event, strings.to_ada_case(event, allocator))
		fmt.sbprintf(sb, "\te: %v\n", strings.to_ada_case(event, allocator))
		fmt.sbprintf(sb, "\tr: int\n")
		fmt.sbprintf(sb, "\tn := r\n")
		for arg in ev.args {
			if arg.type == "fd" {
				continue
			}
			if arg.type == "new_id" {
				continue
			}
			read_type := wayland_to_odin_type(arg.type)
			switch read_type {
			case "object":
				prefix := find_prefix(arg.interface)
				type_name := strings.trim_prefix(arg.interface, prefix)
				fmt.sbprintf(sb, "\t%v: u32\n", arg.name)
				fmt.sbprintf(sb, "\t%v, r = util.read_u32(buf[n:]); n += r\n", arg.name)
				fmt.sbprintf(sb, "\te.%v = %v(%v)\n", arg.name, strings.to_ada_case(type_name), arg.name)
			case "util.Fixed":
				fmt.sbprintf(sb, "\te.%v, r = util.read_fixed(buf[n:]); n += r\n", arg.name)
			case "[]u8":
				fmt.sbprintf(sb, "\te.%v, r = util.read_array(buf[n:]); n += r\n", arg.name)
			case:
				if arg.name == "id" && arg.interface != "" {
					prefix := find_prefix(arg.interface)
					type_name := strings.trim_prefix(arg.interface, prefix)
					fmt.sbprintf(sb, "\tid: u32\n")
					fmt.sbprintf(sb, "\tid, r =util.read_%v(buf[n:]); n += r\n", read_type)
					fmt.sbprintf(sb, "\te.id = %v(id)\n", strings.to_ada_case(type_name))
				} else {
					fmt.sbprintf(sb, "\te.%v, r = util.read_%v(buf[n:]); n += r\n", arg.name, read_type)
				}
			}
		}
		fmt.sbprintf(sb, "\treturn e, n\n")
		fmt.sbprintf(sb, "}\n")
		fmt.sbprintf(sb, "\n")
	}
	for e in interface.enums {
		write_description(sb, e.description)
		enum_name := fmt.tprintf("%v_%v", strings.to_ada_case(stripped_name, allocator), strings.to_ada_case(e.name, allocator))
		fmt.sbprintf(sb, "%v :: enum u32 {{\n", enum_name)
		for entry in e.entries {
			value := parse_enum_value(entry.value)
			if e.is_bit_set {
				index := bit_index(value)
				if index < 0 {
					continue
				}
				value = index
			}
			fmt.sbprintf(sb, "\t%v = %v,\n", ident(strings.to_ada_case(entry.name, allocator)), value)
		}
		fmt.sbprintf(sb, "}\n")
		if e.is_bit_set {
			fmt.sbprintf(sb, "%v_Set :: bit_set[%v; u32]\n\n", enum_name, enum_name)
		} else {
			fmt.sbprintf(sb, "\n")
		}
	}
}

write_arg :: proc(sb: ^strings.Builder, arg: Arg, pkg_name: string, allocator := context.temp_allocator) {
	odin_type := wayland_to_odin_type(arg.type)
	if arg.name == "object_id" {
		fmt.sbprintf(sb, "\t%v: u32,\n", arg.name)
	} else if arg.interface != "" {
		prefix := find_prefix(arg.interface)
		object := strings.to_ada_case(strings.trim_prefix(arg.interface, prefix), allocator)
		if prefix == "wl_" && pkg_name != "wayland" {
			fmt.sbprintf(sb, "\t%v: wayland.%v,\n", arg.name, object)
		} else {
			fmt.sbprintf(sb, "\t%v: %v,\n", arg.name, object)
		}
	} else {
		fmt.sbprintf(sb, "\t%v: %v,\n", arg.name, odin_type)
	}
}

write_description :: proc(sb: ^strings.Builder, desc: string) {
	if desc == "" {
		return
	}
	fmt.sbprintf(sb, "/*\n\t%v\n*/\n", desc)
}

write_client_glue_code :: proc(sb: ^strings.Builder, protocols: []Protocol, allocator := context.temp_allocator) {
	fmt.sbprintf(sb, "package client\n\n")
	fmt.sbprintf(sb, "import \"wayland\"\n")
	for p in protocols {
		if p.pkg != "wayland" {
			fmt.sbprintf(sb, "import \"%v\"\n", p.pkg)
		}
	}
	fmt.sbprintf(sb, "\n")
	fmt.sbprintf(sb, "Request :: union {{\n")
	for p in protocols {
		for i in p.interfaces {
			prefix := find_prefix(i.name)
			stripped_name := strings.trim_prefix(i.name, prefix)
			for req in i.requests {
				name := fmt.tprintf("%v.%v_%v_Request", p.pkg, strings.to_ada_case(stripped_name, allocator), strings.to_ada_case(req.name, allocator))
				fmt.sbprintf(sb, "\t%v,\n", name)
			}
		}
	}
	fmt.sbprintf(sb, "}\n\n")
	fmt.sbprintf(sb, "Event :: union {{\n")
	for p in protocols {
		for i in p.interfaces {
			prefix := find_prefix(i.name)
			stripped_name := strings.trim_prefix(i.name, prefix)
			for ev in i.events {
				name := fmt.tprintf("%v.%v_%v_Event", p.pkg, strings.to_ada_case(stripped_name, allocator), strings.to_ada_case(ev.name, allocator))
				fmt.sbprintf(sb, "\t%v,\n", name)
			}
		}
	}
	fmt.sbprintf(sb, "}\n\n")

}
