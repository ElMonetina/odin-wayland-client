// The scanner takes 2 arguments, "client" or "server" to generate according code
// and a folder containing the protocols.
//
// It outputs them in a wayland/client or wayland/server folder.
// These folders have the following structure:
// wayland_client/: # or wayland server
// 	wayland.odin
// 	client.odin
// 	glue.odin
//	wp/
// 		linux_dmabuf.odin
// 		...
// 	xdg/
// 		shell.odin
// 		...
//  .../
package scanner

import "core:unicode/utf8"
import "core:strings"
import "core:log"
import "core:os"

import "core:encoding/xml"

TEMP_PATH :: "protocols"

Protocol :: struct {
	copyright:               string,
	interfaces:              [dynamic]Interface,
	current_interface_index: int,
	current_request_index  : int,
	current_event_index    : int,
	current_enum_index     : int,

}

Interface :: struct {
	name:        string,
	description: string,
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
	name: string,
	type: string,
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

main :: proc() {
	args := os.args

	// TODO(gabri): Check for args validity

	context.logger = log.create_console_logger()
	protocols_dir, dir_err := os.read_directory_by_path(TEMP_PATH, 0, context.allocator)
	defer os.file_info_slice_delete(protocols_dir, context.allocator)
	if dir_err != nil {
		log.error(dir_err)
		return
	}

	target := "client"

	protocols := make([dynamic]Protocol)
	defer delete(protocols)

	for protocol_file in protocols_dir {
		p := create_protocol()
		file_name := strings.concatenate({TEMP_PATH, "/", protocol_file.name}, context.temp_allocator)
		doc, err := xml.load_from_file(file_name, options = xml.DEFAULT_OPTIONS, error_handler = xml.default_error_handler, allocator = context.temp_allocator)
		if err != nil {
			log.error(err)
			return
		}
		for elem in doc.elements {
			switch elem.ident {
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
				parent := doc.elements[elem.parent]
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
		log.debug(p)
		append(&protocols, p)
	}
}

create_protocol :: proc(allocator := context.temp_allocator) -> Protocol {
	p: Protocol
	p.interfaces = make([dynamic]Interface, allocator)
	p.current_interface_index = -1
	p.current_request_index   = -1
	p.current_event_index     = -1
	p.current_enum_index      = -1
	return p
}

create_interface :: proc(e: xml.Element, p: ^Protocol, allocator := context.temp_allocator) -> Interface {
	i: Interface
	i.requests = make([dynamic]Message, allocator)
	i.events   = make([dynamic]Message, allocator)
	i.enums    = make([dynamic]Enum, allocator)
	i.name     = e.attribs[0].val
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

find_protocol_prefix :: proc(name: string) -> string {
	prefix := make([dynamic]rune, context.temp_allocator)
	for r in name {
		append(&prefix, r)
		if r == '_' {
			return utf8.runes_to_string(prefix[:], context.temp_allocator)
		}
	}
	return ""
}

create_arg :: proc(e: xml.Element) -> Arg {
	name := e.attribs[0].val
	type := e.attribs[1].val
	type  = wayland_to_odin_type(type)
	return {name, type}
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
		return "cstring"
	case "fixed":
		return "util.Fixed"
	}
	return type
}
