// The scanner takes 2 arguments, "client" or "server" to generate according code
// and a folder containing the protocols.
//
// It outputs them in a wayland/client or wayland/server folder.
// These folders have the following structure:
// wayland_client/: # or wayland server
// 	glue.odin
// 	wayland/
// 		wayland.odin
//	wp/
// 		linux_dmabuf.odin
// 		...
// 	xdg/
// 		shell.odin
// 		...
//  .../
package scanner

import "core:strings"
import "core:log"
import "core:os"
import "core:fmt"
import "core:encoding/xml"

client_file := #load("client.odin.scan")

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
		file_name := fmt.tprintf("%v/%v", TEMP_PATH, protocol_file.name)
		doc, err := xml.load_from_file(file_name, options = xml.DEFAULT_OPTIONS, error_handler = xml.default_error_handler, allocator = context.temp_allocator)
		if err != nil {
			log.error(err)
			return
		}
		p := create_protocol(doc.elements[:], protocol_file.name)
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
		dir := fmt.tprintf("%v/%v/", target, protocol.pkg)
		file := fmt.tprintf("%v/%v.odin", dir, protocol.name)
		_ = os.remove_all(dir)
		dir_err := os.make_directory_all(dir)
		if dir_err != nil {
			log.error(dir_err)
			return
		}
		write_err := os.write_entire_file(file, sb.buf[:])
		if write_err != nil {
			log.error(write_err)
			return
		}
		strings.builder_reset(&sb)
	}
	write_client_glue_code(&sb, protocols[:])
	file_name := fmt.tprintf("client/glue.odin")
	write_err := os.write_entire_file(file_name, sb.buf[:])
	if write_err != nil {
		log.error(write_err)
		return
	}
	if target == "client" {
		_ = os.write_entire_file("client/client.odin", client_file)
	}
}
