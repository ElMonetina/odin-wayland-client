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
	defer free_all(context.temp_allocator)
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
		file_name := strings.concatenate({TEMP_PATH, "/", protocol_file.name}, context.temp_allocator)
		doc, err := xml.load_from_file(file_name, options = xml.DEFAULT_OPTIONS, error_handler = xml.default_error_handler, allocator = context.temp_allocator)
		if err != nil {
			log.error(err)
			return
		}
		p := create_protocol(doc.elements[:])
		append(&protocols, p)
	}
	sb: strings.Builder
	strings.builder_init(&sb, context.temp_allocator)
	for protocol in protocols {
		switch target {
		case "client":
			write_client_protocol(&sb, protocol)
		case "server":
		}
	}
	log.debug(protocols[0])
}
