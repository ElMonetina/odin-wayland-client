package scanner

import "core:unicode/utf8"
import "core:encoding/xml"

create_protocol :: proc(elements: []xml.Element, allocator := context.temp_allocator) -> Protocol {
	p: Protocol
	p.interfaces = make([dynamic]Interface, allocator)
	p.current_interface_index = -1
	p.current_request_index   = -1
	p.current_event_index     = -1
	p.current_enum_index      = -1
	for elem in elements {
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
	return {name, type}
}
