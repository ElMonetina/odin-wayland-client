package scanner

import "core:log"
import "core:rexcode/isa/ppc_vle/tablegen/generated"
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
	name:        string,
	description: string,
	args:        [dynamic]Arg,
}

Arg :: struct {
	name:      string,
	type:      string,
	interface: string,
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
	p.pkg = package_name_from_file_name(file_name, allocator)
	log.debug(p.pkg)
	p.interfaces = make([dynamic]Interface, allocator)
	p.current_interface_index = -1
	p.current_request_index   = -1
	p.current_event_index     = -1
	p.current_enum_index      = -1
	for elem in elements {
		switch elem.ident {
		case "protocol":
			p.name = elem.attribs[0].val
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
	m.name = e.attribs[0].val
	m.args = make([dynamic]Arg, allocator)
	return m
}

create_enum :: proc(e: xml.Element, allocator := context.temp_allocator) -> Enum {
	enumeration: Enum
	enumeration.name = e.attribs[0].val
	enumeration.entries = make([dynamic]Entry, allocator)
	if len(e.attribs) > 1 {
		enumeration.is_bit_set = e.attribs[1].key == "bitfield"
	}
	return enumeration
}

create_entry := proc(e: xml.Element) -> Entry {
	entry: Entry
	entry.name  = e.attribs[0].val
	entry.value = e.attribs[1].val
	return entry
}

create_arg :: proc(e: xml.Element) -> Arg {
	name := e.attribs[0].val
	type := e.attribs[1].val
	interface: string
	if len(e.attribs) > 2 {
		interface = e.attribs[2].val if e.attribs[2].key == "interface" else ""
	}
	return {name, type, interface}
}

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
