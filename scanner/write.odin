package scanner

import "core:log"
import "core:fmt"
import "core:strings"

write_client_protocol :: proc(sb: ^strings.Builder, p: Protocol, allocator := context.temp_allocator) {
	fmt.sbprintf(sb, "package %v\n\n", p.pkg)
	fmt.sbprintf(sb, "import \"../../util\"\n")
	if p.pkg != "wayland" {
		fmt.sbprintf(sb, "import \"../wayland\"\n")
	}
	fmt.sbprintf(sb, "import \"core:sys/linux\"\n")
	fmt.sbprintf(sb, "import \"base:runtime\"\n\n")
	fmt.sbprintf(sb, "/*\n\t%v\n*/\n\n", p.copyright)
	if p.pkg == "wayland" {
		fmt.sbprintf(sb, "@(rodata)\n")
		fmt.sbprintf(sb, "display := Display(1)\n\n")
	}
	for interface in p.interfaces {
		write_client_interface(sb, p, interface, p.pkg, allocator)
	}
}

write_client_interface :: proc(sb: ^strings.Builder, p: Protocol, interface: Interface, pkg_name: string, allocator := context.temp_allocator) {
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
			write_arg(sb, p, pkg_name, interface.name, arg, allocator)
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
				_, is_bitfield, has_enum := enum_arg_type(p, interface.name, arg, allocator)
				switch {
				case has_enum && is_bitfield:
					fmt.sbprintf(sb, "\tnum_appended += util.write(buf, transmute(u32)req.%v) or_return\n", arg.name)
				case has_enum:
					fmt.sbprintf(sb, "\tnum_appended += util.write(buf, %v(req.%v)) or_return\n", wayland_to_odin_type(arg.type), arg.name)
				case arg.type == "object":
					fmt.sbprintf(sb, "\tnum_appended += util.write(buf, u32(req.%v)) or_return\n", arg.name)
				case:
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
	for ev, i in interface.events {
		stripped_name = strings.to_ada_case(stripped_name, allocator)
		ev_name := strings.to_ada_case(fmt.tprintf("%v_Event", ev.name), allocator)
		event := fmt.tprintf("%v_%v", strings.to_lower(stripped_name, allocator), strings.to_lower(ev_name, allocator))
		opcode := fmt.tprintf("%v_%v_OPCODE", strings.to_upper(stripped_name, allocator), strings.to_upper(ev_name, allocator))
		fmt.sbprintf(sb, "%v :: %v\n", opcode, i)
		write_description(sb, ev.description)
		fmt.sbprintf(sb, "%v :: struct {{\n", strings.to_ada_case(event, allocator))
		fmt.sbprintf(sb, "\t%v: %v,\n", strings.to_lower(stripped_name, allocator), strings.to_ada_case(stripped_name, allocator))
		has_fd: bool
		for arg in ev.args {
			write_arg(sb, p, pkg_name, interface.name, arg, allocator)
			if arg.type == "fd" {
				has_fd = true
			}
		}
		fmt.sbprintf(sb, "}\n")
		fmt.sbprintf(sb, "%v_read :: proc(buf: []byte", event)
		if has_fd {
			fmt.sbprintf(sb, ", fds: ^[dynamic; 28]linux.Fd")
		}
		fmt.sbprintf(sb, ") -> (%v, int) {{\n", strings.to_ada_case(event, allocator))
		fmt.sbprintf(sb, "\te: %v\n", strings.to_ada_case(event, allocator))
		fmt.sbprintf(sb, "\tr: int\n")
		fmt.sbprintf(sb, "\tn := r\n")
		for arg in ev.args {
			if arg.type == "fd" {
				fmt.sbprintf(sb, "\te.%v = pop_front(fds)\n", arg.name)
				continue
			}
			if arg.type == "new_id" {
				fmt.sbprintf(sb, "\t%v: u32\n", arg.name)
				fmt.sbprintf(sb, "\t%v, r = util.read_u32(buf[n:]); n += r\n", arg.name)
				fmt.sbprintf(sb, "\te.%v = %v(%v)\n", arg.name, interface_type_name(arg.interface, pkg_name, allocator), arg.name)
				continue
			}
			if enum_type, _, has_enum := enum_arg_type(p, interface.name, arg, allocator); has_enum {
				fmt.sbprintf(sb, "\tval_%v, _ := util.read_%v(buf[n:]); n += 4\n", arg.name, wayland_to_odin_type(arg.type))
				fmt.sbprintf(sb, "\te.%v = transmute(%v)val_%v\n", arg.name, enum_type, arg.name)
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

interface_type_name :: proc(interface_name: string, pkg_name: string, allocator := context.temp_allocator) -> string {
	prefix := find_prefix(interface_name)
	object := strings.to_ada_case(strings.trim_prefix(interface_name, prefix), allocator)
	if prefix == "wl_" && pkg_name != "wayland" {
		return fmt.tprintf("wayland.%v", object)
	}
	return object
}

lookup_enum :: proc(p: Protocol, iface_name, ref: string, allocator := context.temp_allocator) -> (type_name: string, is_bitfield: bool, found: bool) {
	if ref == "" {
		return "", false, false
	}
	owner_name := iface_name
	enum_name := ref
	if dot := strings.index_byte(ref, '.'); dot >= 0 {
		owner_name = ref[:dot]
		enum_name = ref[dot + 1:]
	}
	for i in p.interfaces {
		if i.name != owner_name {
			continue
		}
		base := interface_base_name(i, allocator)
		for e in i.enums {
			if e.name == enum_name {
				return fmt.tprintf("%v_%v", base, strings.to_ada_case(enum_name, allocator)), e.is_bit_set, true
			}
		}
	}
	return "", false, false
}

enum_arg_type :: proc(p: Protocol, iface_name: string, arg: Arg, allocator := context.temp_allocator) -> (type_name: string, is_bitfield: bool, found: bool) {
	if arg.type != "int" && arg.type != "uint" {
		return "", false, false
	}
	name, bitfield, ok := lookup_enum(p, iface_name, arg.enum_ref, allocator)
	if !ok {
		return "", false, false
	}
	if bitfield {
		name = fmt.tprintf("%v_Set", name)
	}
	return name, bitfield, true
}

write_arg :: proc(sb: ^strings.Builder, p: Protocol, pkg_name, iface_name: string, arg: Arg, allocator := context.temp_allocator) {
	odin_type := wayland_to_odin_type(arg.type)
	enum_type, _, has_enum := enum_arg_type(p, iface_name, arg, allocator)
	if arg.name == "object_id" {
		fmt.sbprintf(sb, "\t%v: u32,\n", arg.name)
	} else if has_enum {
		fmt.sbprintf(sb, "\t%v: %v,\n", arg.name, enum_type)
	} else if arg.interface != "" {
		fmt.sbprintf(sb, "\t%v: %v,\n", arg.name, interface_type_name(arg.interface, pkg_name, allocator))
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

interface_base_name :: proc(interface: Interface, allocator := context.temp_allocator) -> string {
	stripped := strings.trim_prefix(interface.name, find_prefix(interface.name))
	return strings.to_ada_case(strings.to_upper(stripped, allocator), allocator)
}

interface_const_name :: proc(interface: Interface, allocator := context.temp_allocator) -> string {
	return fmt.tprintf("%v_INTERFACE", strings.to_upper(interface_base_name(interface, allocator), allocator))
}

request_queue_proc_name :: proc(p: Protocol, interface: Interface, request: Message, allocator := context.temp_allocator) -> string {
	request_name := strings.to_lower(strings.to_ada_case(request.name, allocator), allocator)
	return fmt.tprintf("%v_%v_%v_queue", p.name, strings.to_lower(interface_base_name(interface, allocator), allocator), request_name)
}

request_struct_name :: proc(p: Protocol, interface: Interface, request: Message, allocator := context.temp_allocator) -> string {
	request_name := strings.to_ada_case(fmt.tprintf("%v_Request", request.name), allocator)
	return fmt.tprintf("%v.%v_%v", p.pkg, interface_base_name(interface, allocator), request_name)
}

request_write_proc_name :: proc(p: Protocol, interface: Interface, request: Message, allocator := context.temp_allocator) -> string {
	request_name := strings.to_lower(strings.to_ada_case(fmt.tprintf("%v_Request", request.name), allocator), allocator)
	return fmt.tprintf("%v.%v_%v_write", p.pkg, strings.to_lower(interface_base_name(interface, allocator), allocator), request_name)
}

lookup_interface :: proc(protocols: []Protocol, interface_name: string, allocator := context.temp_allocator) -> (pkg: string, base: string, found: bool) {
	if interface_name == "" {
		return "", "", false
	}
	for p in protocols {
		for i in p.interfaces {
			if i.name == interface_name {
				return p.pkg, interface_base_name(i, allocator), true
			}
		}
	}
	return "", "", false
}

write_client_request_queue :: proc(sb: ^strings.Builder, protocols: []Protocol, allocator := context.temp_allocator) {
	fmt.sbprintf(sb, "request_queue :: proc{{\n")
	for p in protocols {
		for i in p.interfaces {
			for req in i.requests {
				fmt.sbprintf(sb, "\t%v,\n", request_queue_proc_name(p, i, req, allocator))
			}
		}
	}
	fmt.sbprintf(sb, "}\n\n")
	for p in protocols {
		for i in p.interfaces {
			for req in i.requests {
				write_request_queue_proc(sb, protocols, p, i, req, allocator)
			}
		}
	}
}

write_request_queue_proc :: proc(sb: ^strings.Builder, protocols: []Protocol, p: Protocol, interface: Interface, request: Message, allocator := context.temp_allocator) {
	new_id_arg: Arg
	returns_new_id := false
	for arg in request.args {
		if arg.type == "new_id" {
			new_id_arg = arg
			returns_new_id = true
			break
		}
	}
	new_id_pkg, new_id_base: string
	new_id_is_object := false
	if returns_new_id {
		new_id_pkg, new_id_base, new_id_is_object = lookup_interface(protocols, new_id_arg.interface, allocator)
	}

	fmt.sbprintf(sb, "%v :: proc(client: ^Client, req: %v) -> ", request_queue_proc_name(p, interface, request, allocator), request_struct_name(p, interface, request, allocator))
	switch {
	case !returns_new_id:
		fmt.sbprintf(sb, "runtime.Allocator_Error {{\n")
	case new_id_is_object:
		fmt.sbprintf(sb, "(ret: %v.%v, err: runtime.Allocator_Error) #optional_allocator_error {{\n", new_id_pkg, new_id_base)
	case:
		fmt.sbprintf(sb, "(ret: u32, err: runtime.Allocator_Error) #optional_allocator_error {{\n")
	}

	if !returns_new_id {
		fmt.sbprintf(sb, "\t%v(&client.requests_byte_buffer, req) or_return\n", request_write_proc_name(p, interface, request, allocator))
	} else {
		fmt.sbprintf(sb, "\tclient.next_id += 1\n")
		fmt.sbprintf(sb, "\tid := client.next_id\n")
		fmt.sbprintf(sb, "\t%v(&client.requests_byte_buffer, req, id) or_return\n", request_write_proc_name(p, interface, request, allocator))
		if new_id_is_object {
			fmt.sbprintf(sb, "\tregister_object(client, id, %v.%v)\n", new_id_pkg, interface_const_name_by_base(new_id_base, allocator))
		}
	}
	for arg in request.args {
		if arg.type == "fd" {
			fmt.sbprintf(sb, "\tappend(&client.outgoing_fds, req.%v)\n", arg.name)
		}
	}
	if request.is_destructor {
		fmt.sbprintf(sb, "\tdelete_key(&client.id_to_interface, u32(req.%v))\n", strings.to_lower(interface_base_name(interface, allocator), allocator))
	}

	switch {
	case !returns_new_id:
		fmt.sbprintf(sb, "\treturn nil\n")
	case new_id_is_object:
		fmt.sbprintf(sb, "\treturn %v.%v(id), nil\n", new_id_pkg, new_id_base)
	case:
		fmt.sbprintf(sb, "\treturn id, nil\n")
	}
	fmt.sbprintf(sb, "}\n\n")
}

interface_const_name_by_base :: proc(base: string, allocator := context.temp_allocator) -> string {
	return fmt.tprintf("%v_INTERFACE", strings.to_upper(base, allocator))
}

write_client_event_read :: proc(sb: ^strings.Builder, protocols: []Protocol, allocator := context.temp_allocator) {
	fmt.sbprintf(sb, "event_read :: proc(client: ^Client, interface: string, object_id: u32, opcode: u16, data: []byte, fds: ^[dynamic; 28]linux.Fd) -> (ev: Event, err: runtime.Allocator_Error) {{\n")
	fmt.sbprintf(sb, "\tswitch interface {{\n")
	for p in protocols {
		for i in p.interfaces {
			base := interface_base_name(i, allocator)
			fmt.sbprintf(sb, "\tcase %v.%v:\n", p.pkg, interface_const_name(i, allocator))
			fmt.sbprintf(sb, "\t\tswitch opcode {{\n")
			for ev in i.events {
				ev_name := strings.to_ada_case(fmt.tprintf("%v_Event", ev.name), allocator)
				read_proc := fmt.tprintf("%v.%v_%v_read", p.pkg, strings.to_lower(base, allocator), strings.to_lower(ev_name, allocator))
				fmt.sbprintf(sb, "\t\tcase %v.%v_%v_OPCODE:\n", p.pkg, strings.to_upper(base, allocator), strings.to_upper(ev_name, allocator))
				switch {
				case i.name == "wl_display" && ev.name == "delete_id":
					fmt.sbprintf(sb, "\t\t\tdecoded, _ := %v(data)\n", read_proc)
					fmt.sbprintf(sb, "\t\t\tdelete_key(&client.id_to_interface, decoded.id)\n")
					fmt.sbprintf(sb, "\t\t\treturn {{}}, nil\n")
				case i.name == "wl_callback" && ev.name == "done":
					fmt.sbprintf(sb, "\t\t\tdelete_key(&client.id_to_interface, object_id)\n")
					fmt.sbprintf(sb, "\t\t\treturn {{}}, nil\n")
				case:
					new_id_arg: Arg
					has_new_id := false
					has_fd := false
					for arg in ev.args {
						if arg.type == "fd" {
							has_fd = true
						}
						if arg.type == "new_id" && arg.interface != "" && !has_new_id {
							new_id_arg = arg
							has_new_id = true
						}
					}
					if has_fd {
						fmt.sbprintf(sb, "\t\t\tdecoded, _ := %v(data, fds)\n", read_proc)
					} else {
						fmt.sbprintf(sb, "\t\t\tdecoded, _ := %v(data)\n", read_proc)
					}
					fmt.sbprintf(sb, "\t\t\tdecoded.%v = %v.%v(object_id)\n", strings.to_lower(base, allocator), p.pkg, base)
					if has_new_id {
						nid_pkg, nid_base, found := lookup_interface(protocols, new_id_arg.interface, allocator)
						if found {
							fmt.sbprintf(sb, "\t\t\tclient.id_to_interface[u32(decoded.%v)] = %v.%v\n", new_id_arg.name, nid_pkg, interface_const_name_by_base(nid_base, allocator))
						}
					}
					fmt.sbprintf(sb, "\t\t\treturn Event(decoded), nil\n")
				}
			}
			fmt.sbprintf(sb, "\t\t}}\n")
		}
	}
	fmt.sbprintf(sb, "\t}}\n")
	fmt.sbprintf(sb, "\treturn {{}}, nil\n")
	fmt.sbprintf(sb, "}}\n\n")
}

write_client_glue_code :: proc(sb: ^strings.Builder, protocols: []Protocol, allocator := context.temp_allocator) {
	fmt.sbprintf(sb, "package client\n\n")
	fmt.sbprintf(sb, "import \"base:runtime\"\n")
	fmt.sbprintf(sb, "import \"core:sys/linux\"\n")
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

	write_client_request_queue(sb, protocols, allocator)
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

	write_client_event_read(sb, protocols, allocator)
}
