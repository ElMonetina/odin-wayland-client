package scanner

import "core:log"
import "core:unicode/utf8"
import "core:os"
import "core:strings"
import "core:encoding/xml"

TEMP_PATH :: "protocols"

Protocol :: struct {
	name:                    string,
	pkg:                     string,
	copyright:               string,
	interfaces:              [dynamic]Interface,
	current_interface_index: int,
	current_request_index  : int,
	current_event_index    : int,
	current_enum_index     : int,
}

Interface :: struct {
	name:        string,
	version:     string,
	description: string,
	prexif:      string,
	requests:    [dynamic]Message,
	events:      [dynamic]Message,
	enums:       [dynamic]Enum,
}

Message :: struct {
	name:          string,
	description:   string,
	is_destructor: bool,
	args:          [dynamic]Arg,
}

Arg :: struct {
	name:      string,
	type:      string,
	interface: string,
	enum_ref:  string,
}

Enum :: struct {
	name:        string,
	description: string,
	entries:     [dynamic]Entry,
	is_bit_set:  bool,
}

Entry :: struct {
	name: string,
	value: string,
}

create_protocol :: proc(elements: []xml.Element, file_name: string, allocator := context.temp_allocator) -> Protocol {
	p: Protocol

	// TODO(gabri): improve this, should read an interface and extract the namespace. e.g: zwp -> wp, zext -> ext, etc.
	p.pkg = package_name_from_file_name(file_name, allocator)
	p.interfaces = make([dynamic]Interface, allocator)
	p.current_interface_index = -1
	p.current_request_index   = -1
	p.current_event_index     = -1
	p.current_enum_index      = -1
	for elem in elements {
		switch elem.ident {
		case "protocol":
			p.name = elem.attribs[0].val
		case "copyright":
			p.copyright = elem.value[0].(string)
			parent := elem.parent
			parent_kind := elements[parent].ident
			switch parent_kind {
			case "protocol":
			}
		case "description":
			parent := elem.parent
			parent_kind := elements[parent].ident
			switch parent_kind {
			case "interface":
				interface := &p.interfaces[p.current_interface_index]
				interface.description = elem.value[0].(string)
			case "request":
				msg := &p.interfaces[p.current_interface_index].requests[p.current_request_index]
				if len(elem.value) > 0 {
					msg.description = elem.value[0].(string)
				}
			case "event":
				msg := &p.interfaces[p.current_interface_index].events[p.current_event_index]
				msg.description = elem.value[0].(string)
			case "enum":
				e := &p.interfaces[p.current_interface_index].enums[p.current_enum_index]
				e.description = elem.value[0].(string)
			}
		case "interface":
			interface := create_interface(elem, &p)
			append(&p.interfaces, interface)
		case "request":
			request  := create_message(elem)
			requests := &p.interfaces[p.current_interface_index].requests
			append(requests, request)
			p.current_request_index += 1
		case "event":
			event  := create_message(elem)
			events := &p.interfaces[p.current_interface_index].events
			append(events, event)
			p.current_event_index += 1
		case "enum":
			enumeration := create_enum(elem)
			enums       := &p.interfaces[p.current_interface_index].enums
			append(enums, enumeration)
			p.current_enum_index += 1
		case "arg":
			arg    := create_arg(elem)
			parent := elements[elem.parent]
			switch parent.ident {
			case "request":
				args := &p.interfaces[p.current_interface_index].requests[p.current_request_index].args
				append(args, arg)
			case "event":
				args := &p.interfaces[p.current_interface_index].events[p.current_event_index].args
				append(args, arg)
			}
		case "entry":
			entry   := create_entry(elem)
			entries := &p.interfaces[p.current_interface_index].enums[p.current_enum_index].entries
			append(entries, entry)
		}
	}
	for &interface in p.interfaces {
		if interface.name != "wl_registry" {
			continue
		}
		for &request in interface.requests {
			if request.name != "bind" {
				continue
			}
			clear(&request.args)
			append(&request.args, Arg{"name", "uint", "", ""})
			append(&request.args, Arg{"interface", "string", "", ""})
			append(&request.args, Arg{"version", "uint", "", ""})
			append(&request.args, Arg{"id", "new_id", "", ""})
		}
	}
	return p
}

create_interface :: proc(e: xml.Element, p: ^Protocol, allocator := context.temp_allocator) -> Interface {
	i: Interface
	i.requests = make([dynamic]Message, allocator)
	i.events   = make([dynamic]Message, allocator)
	i.enums    = make([dynamic]Enum, allocator)
	i.name     = e.attribs[0].val
	i.prexif   = find_prefix(i.name)
	i.version  = e.attribs[1].val
	p.current_interface_index += 1
	p.current_request_index   = -1
	p.current_event_index     = -1
	p.current_enum_index      = -1
	return i
}

create_message :: proc(e: xml.Element, allocator := context.temp_allocator) -> Message {
	m: Message
	m.name, _ = attrib_value(e, "name")
	m.args = make([dynamic]Arg, allocator)
	m.is_destructor = false
	// A destructor request destroys the object it is sent to, so the glue code
	// drops it from the object table.
	if kind, found := attrib_value(e, "type"); found {
		m.is_destructor = kind == "destructor"
	}
	return m
}

create_enum :: proc(e: xml.Element, allocator := context.temp_allocator) -> Enum {
	enumeration: Enum
	enumeration.name, _ = attrib_value(e, "name")
	enumeration.entries = make([dynamic]Entry, allocator)
	enumeration.is_bit_set = false
	if bitfield, found := attrib_value(e, "bitfield"); found {
		enumeration.is_bit_set = bitfield == "true"
	}
	return enumeration
}

create_entry := proc(e: xml.Element) -> Entry {
	entry: Entry
	entry.name, _  = attrib_value(e, "name")
	entry.value, _ = attrib_value(e, "value")
	return entry
}

attrib_value :: proc(e: xml.Element, key: string) -> (value: string, found: bool) {
	for attrib in e.attribs {
		if attrib.key == key {
			return attrib.val, true
		}
	}
	return "", false
}

create_arg :: proc(e: xml.Element) -> Arg {
	name, _ := attrib_value(e, "name")
	arg_type, _ := attrib_value(e, "type")
	interface, _ := attrib_value(e, "interface")
	enum_ref, _ := attrib_value(e, "enum")
	return {name, arg_type, interface, enum_ref}
}

// FIXME(gabri): this is stupid
package_name_from_file_name :: proc(name: string, allocator := context.temp_allocator) -> string {
	pkg_runes := make([dynamic]rune, allocator)
	for r in name {
		if strings.is_separator(r) {
			break
		}
		append(&pkg_runes, r)
	}
	candidate_prefix := utf8.runes_to_string(pkg_runes[:])
	if candidate_prefix == "xdg" {
		return candidate_prefix
	} else if candidate_prefix == "ext" {
		return candidate_prefix
	} else if name == "wayland.xml" {
		return os.stem(name)
	}
	return "wp"
}

// TODO(gabri): need a proc to find, given the name, the enum type for message args: store the index into the enums array
// in the arg struct.
// This will need to be done in a second pass, to have the full protocol representation ready.
