// Bindings for libxkbcommon
// Sectioned as they are found at https://xkbcommon.org/doc/current/topics.html

package libxkbcommon

foreign import lib "system:xkbcommon"

// Rules types

rule_names :: struct {
	rules:   cstring,
	model:   cstring,
	layout:  cstring,
	variant: cstring,
	options: cstring,
}

component_names :: struct {
	keycodes:      cstring,
	compatibility: cstring,
	geometry:      cstring,
	symbols:       cstring,
	types:         cstring,
}

rmlvo_builder_flag :: enum u8 {}
rmlvo_builder_flags :: bit_set[rmlvo_builder_flag; u32]

rmlvo_builder :: struct {}

// Keysyms types

KEYSYM_MAX :: 0x1fffffff

keysym_t :: distinct u32

keysym_flag :: enum u8 {
	CASE_INTENSITIVE, // (1 << 0)
}
keysym_flags :: bit_set[keysym_flag; u32]

// Context types

ctx :: struct {}

ctxflag :: enum u8 {
	NO_DEFAULT_INCLUDES,  // (1 << 0)
	NO_ENVIRONMENT_NAMES, // (1 << 1)
	NO_SECURE_GETENV,     // (1 << 2)
}
ctxflags :: bit_set[ctxflag; u32]

// Logging types

log_fn :: #type proc "c" (xkb_ctx: ^ctx, level: log_level, format: cstring, #c_vararg args: ..any)

log_level :: enum i32 {
	CRITICAL = 10,
	ERROR    = 20,
	WARNING  = 30,
	INFO     = 40,
	DEBUG    = 50,
}

// Keymap creation types

keymap :: struct {}

keymap_compile_flag :: enum u8 {}
keymap_compile_flags :: bit_set[keymap_compile_flag; u32]

keymap_format :: enum i32 {
	TEXT_V1 = 1,
	TEXT_V2 = 2,
}

keymap_serialize_flag :: enum u8 {
	PRETTY,      // (1 << 0)
	KEEP_UNUSED, // (1 << 1)
}
keymap_serialize_flags :: bit_set[keymap_serialize_flag; u32]

KEYMAP_USE_ORIGINAL_FORMAT :: keymap_format(-1)

// Keymap components types

keycode_t :: distinct u32

mod_index_t :: distinct u32

mod_mask_t :: distinct u32

layout_index_t :: distinct u32

layout_mask_t :: distinct u32

led_index_t :: distinct u32

led_mask_t :: distinct u32

level_index_t :: distinct u32

KEYCODE_INVALID :: keycode_t(0xffffffff)
LAYOUT_INVALID  :: layout_index_t(0xffffffff)
LEVEL_INVALID   :: level_index_t(0xffffffff)
MOD_INVALID     :: mod_index_t(0xffffffff)
LED_INVALID     :: led_index_t(0xffffffff)
KEYCODE_MAX     :: keycode_t(0xffffffff - 1)

keymap_key_iter_t :: #type proc "c" (xkb_keymap: ^keymap, keycode: keycode_t, data: rawptr)

// Keyboard state types

state :: struct {}

key_direction :: enum i32 {
	UP,
	DOWN,
}

state_component_flag :: enum u8 {
	MODS_DEPRESSED,   // (1 << 0)
	MODS_LATCHED,     // (1 << 1)
	MODS_LOCKED,      // (1 << 2)
	MODS_EFFECTIVE,   // (1 << 3)
	LAYOUT_DEPRESSED, // (1 << 4)
	LAYOUT_LATCHED,   // (1 << 5)
	LAYOUT_LOCKED,    // (1 << 6)
	LAYOUT_EFFECTIVE, // (1 << 7)
	LEDS,             // (1 << 8)
}
state_component :: bit_set[state_component_flag; u32]

state_match_flag :: enum u8 {
	MATCH_ANY           = 0,  // (1 << 0)
	MATCH_ALL           = 1,  // (1 << 1)
	MATCH_NON_EXCLUSIVE = 16, // (1 << 16)
}
state_match :: bit_set[state_match_flag; u32]

consumed_mode :: enum i32 {
	XKB,
	GTK,
}

// Predefined names

// Real modifiers names
MOD_NAME_SHIFT :: "Shift"
MOD_NAME_CAPS  :: "Lock"
MOD_NAME_CTRL  :: "Control"
MOD_NAME_MOD1  :: "Mod1"
MOD_NAME_MOD2  :: "Mod2"
MOD_NAME_MOD3  :: "Mod3"
MOD_NAME_MOD4  :: "Mod4"
MOD_NAME_MOD5  :: "Mod5"

// Virtual modifiers names
VMOD_NAME_ALT    :: "Alt"
VMOD_NAME_HYPER  :: "Hyper"
VMOD_NAME_LEVEL3 :: "LevelThree"
VMOD_NAME_LEVEL5 :: "LevelFive"
VMOD_NAME_META   :: "Meta"
VMOD_NAME_NUM    :: "NumLock"
VMOD_NAME_SCROLL :: "ScrollLock"
VMOD_NAME_SUPER  :: "Super"

// Legacy virtual modifiers names
MOD_NAME_ALT  :: "Mod1"
MOD_NAME_LOGO :: "Mod4"
MOD_NAME_NUM  :: "Mod2"

// LEDs names
LED_NAME_NUM     :: "Num Lock"
LED_NAME_CAPS    :: "Caps Lock"
LED_NAME_SCROLL  :: "Scroll Lock"
LED_NAME_COMPOSE :: "Compose"
LED_NAME_KANA    :: "Kana"

// RMLVO queries types

r_context :: struct {}

r_model :: struct {}

r_layout :: struct {}

r_option_group :: struct {}

r_option :: struct {}

r_iso639_code :: struct {}

r_iso3166_code :: struct {}

r_popularity :: enum i32 {
	STANDARD = 1,
	EXOTIC,
}

r_context_flag :: enum u8 {
	NO_DEFAULT_INCLUDES,  // (1 << 0)
	LOAD_EXOTIC_RULES,    // (1 << 1)
	NO_SECURE_GETENV,     // (1 << 2)
}
r_context_flags :: bit_set[r_context_flag; u32]

r_log_level :: enum i32 {
	CRITICAL = 10,
	ERROR    = 20,
	WARNING  = 30,
	INFO     = 40,
	DEBUG    = 50,
}

// Compose types

compose_table :: struct {}

compose_state :: struct {}

compose_table_entry :: struct {}

compose_table_iterator :: struct {}

compose_compile_flag :: enum u8 {}
compose_compile_flags :: bit_set[compose_compile_flag; u32]

compose_format :: enum i32 {
	TEXT_V1 = 1,
}

compose_state_flag :: enum u8 {}
compose_state_flags :: bit_set[compose_state_flag; u32]

compose_status :: enum i32 {
	NOTHING,
	COMPOSING,
	COMPOSED,
	CANCELLED,
}

compose_feed_result :: enum i32 {
	IGNORED,
	ACCEPTED,
}

@(default_calling_convention = "c", link_prefix = "xkb_")
foreign lib {
	// Rules procs
	rmlvo_builder_new :: proc(ctx: ^ctx, rules: cstring, model: cstring, flags: rmlvo_builder_flags) -> ^rmlvo_builder ---
	rmlvo_builder_append_layout :: proc(rmlvo: ^rmlvo_builder, layout: cstring, variant: cstring, options: [^]cstring, options_len: int) -> bool ---
	rmlvo_builder_append_option :: proc(rmlvo: ^rmlvo_builder, option: cstring) -> bool ---
	rmlvo_builder_ref :: proc(rmlvo: ^rmlvo_builder) -> ^rmlvo_builder ---
	rmlvo_builder_unref :: proc(rmlvo: ^rmlvo_builder) ---
	components_names_from_rules :: proc(ctx: ^ctx, rmlvo_in: ^rule_names, rmlvo_out: ^rule_names, components_out: ^component_names) -> bool ---

	// Keysyms procs
	keysym_get_name :: proc(keysym: keysym_t, buffer: [^]u8, size: uint) -> i32 ---
	keysym_from_name :: proc(name: cstring, flags: keysym_flags) -> keysym_t ---
	keysym_to_utf8 :: proc(keysym: keysym_t, buffer: [^]u8, size: uint) -> i32 ---
	keysym_to_utf32 :: proc(keysym: keysym_t) -> u32 ---
	utf32_to_keysym :: proc(ucs: u32) -> keysym_t ---
	keysym_to_upper :: proc(ks: keysym_t) -> keysym_t ---
	keysym_to_lower :: proc(ks: keysym_t) -> keysym_t ---

	// Context procs
	context_new :: proc(flags: ctxflags) -> ^ctx ---
	context_ref :: proc(xkb_ctx: ^ctx) -> ^ctx ---
	context_unref :: proc(xkb_ctx: ^ctx) ---
	context_set_user_data :: proc(ctx: ^ctx, user_data: rawptr) ---
	context_get_user_data :: proc(ctx: ^ctx) -> rawptr ---

	// Include paths procs
	context_include_path_append :: proc(xkb_ctx: ^ctx, path: cstring) -> i32 ---
	context_include_path_append_default :: proc(xkb_ctx: ^ctx) -> i32 ---
	context_include_path_reset_defaults :: proc(xkb_ctx: ^ctx) -> i32 ---
	context_include_path_clear :: proc(xkb_ctx: ^ctx) ---
	context_num_include_paths :: proc(xkb_ctx: ^ctx) -> u32 ---
	context_include_path_get :: proc(xkb_ctx: ^ctx, index: u32) -> cstring ---

	// Logging procs
	context_set_log_level :: proc(xkb_ctx: ^ctx, level: log_level) ---
	context_get_log_level :: proc(xkb_ctx: ^ctx) -> log_level ---
	context_set_log_verbosity :: proc(xkb_ctx: ^ctx, verbosity: i32) ---
	context_get_log_verbosity :: proc(xkb_ctx: ^ctx) -> i32 ---
	context_set_log_fn :: proc(xkb_ctx: ^ctx, fn: log_fn) ---

	// Keymap creation procs
	keymap_new_from_rmlvo :: proc(rmlvo: ^rmlvo_builder, format: keymap_format, flags: keymap_compile_flags) -> ^keymap ---
	keymap_new_from_names :: proc(xkb_ctx: ^ctx, names: ^rule_names, flags: keymap_compile_flags) -> ^keymap ---
	keymap_new_from_names2 :: proc(xkb_ctx: ^ctx, names: ^rule_names, format: keymap_format, flags: keymap_compile_flags) -> ^keymap ---
	keymap_new_from_file :: proc(xkb_ctx: ^ctx, file: rawptr, format: keymap_format, flags: keymap_compile_flags) -> ^keymap ---
	keymap_new_from_string :: proc(ctx_: ^ctx, str: cstring, format: keymap_format, flags: keymap_compile_flags) -> ^keymap ---
	keymap_new_from_buffer :: proc(xkb_ctx: ^ctx, buffer: [^]u8, length: u32, format: keymap_format, flags: keymap_compile_flags) -> ^keymap ---
	keymap_ref :: proc(xkb_keymap: ^keymap) -> ^keymap ---
	keymap_unref :: proc(xkb_keymap: ^keymap) ---
	keymap_get_as_string :: proc(xkb_keymap: ^keymap, format: keymap_format) -> cstring ---
	keymap_get_as_string2 :: proc(xkb_keymap: ^keymap, format: keymap_format, flags: keymap_serialize_flags) -> cstring ---

	// Keymap components procs
	keymap_min_keycode :: proc(xkb_keymap: ^keymap) -> keycode_t ---
	keymap_max_keycode :: proc(xkb_keymap: ^keymap) -> keycode_t ---
	keymap_key_for_each :: proc(xkb_keymap: ^keymap, iter: keymap_key_iter_t, data: rawptr) ---
	keymap_key_get_name :: proc(xkb_keymap: ^keymap, key: keycode_t) -> cstring ---
	keymap_key_by_name :: proc(xkb_keymap: ^keymap, name: cstring) -> keycode_t ---
	keymap_num_mods :: proc(xkb_keymap: ^keymap) -> mod_index_t ---
	keymap_mod_get_name :: proc(xkb_keymap: ^keymap, idx: mod_index_t) -> cstring ---
	keymap_mod_get_index :: proc(xkb_keymap: ^keymap, name: cstring) -> mod_index_t ---
	keymap_mod_get_mask :: proc(xkb_keymap: ^keymap, name: cstring) -> mod_mask_t ---
	keymap_mod_get_mask2 :: proc(xkb_keymap: ^keymap, idx: mod_index_t) -> mod_mask_t ---
	keymap_num_layouts :: proc(xkb_keymap: ^keymap) -> layout_index_t ---
	keymap_layout_get_name :: proc(xkb_keymap: ^keymap, idx: layout_index_t) -> cstring ---
	keymap_layout_get_index :: proc(xkb_keymap: ^keymap, name: cstring) -> layout_index_t ---
	keymap_num_leds :: proc(xkb_keymap: ^keymap) -> led_index_t ---
	keymap_led_get_name :: proc(xkb_keymap: ^keymap, idx: led_index_t) -> cstring ---
	keymap_led_get_index :: proc(xkb_keymap: ^keymap, name: cstring) -> led_index_t ---
	keymap_num_layouts_for_key :: proc(xkb_keymap: ^keymap, key: keycode_t) -> layout_index_t ---
	keymap_num_levels_for_key :: proc(xkb_keymap: ^keymap, key: keycode_t, layout: layout_index_t) -> level_index_t ---
	keymap_key_get_mods_for_level :: proc(xkb_keymap: ^keymap, key: keycode_t, layout: layout_index_t, level: level_index_t, masks_out: [^]mod_mask_t, masks_size: uint) -> uint ---
	keymap_key_get_syms_by_level :: proc(xkb_keymap: ^keymap, key: keycode_t, layout: layout_index_t, level: level_index_t, syms_out: ^^keysym_t) -> i32 ---
	keymap_key_repeats :: proc(xkb_keymap: ^keymap, key: keycode_t) -> i32 ---

	// Compose procs
	compose_table_new_from_locale :: proc(ctx: ^ctx, locale: cstring, flags: compose_compile_flags) -> ^compose_table ---
	compose_table_new_from_file :: proc(ctx: ^ctx, file: rawptr, locale: cstring, format: compose_format, flags: compose_compile_flags) -> ^compose_table ---
	compose_table_new_from_buffer :: proc(ctx: ^ctx, buffer: [^]u8, length: uint, locale: cstring, format: compose_format, flags: compose_compile_flags) -> ^compose_table ---
	compose_table_ref :: proc(table: ^compose_table) -> ^compose_table ---
	compose_table_unref :: proc(table: ^compose_table) ---
	compose_table_entry_sequence :: proc(entry: ^compose_table_entry, sequence_length: ^uint) -> [^]keysym_t ---
	compose_table_entry_keysym :: proc(entry: ^compose_table_entry) -> keysym_t ---
	compose_table_entry_utf8 :: proc(entry: ^compose_table_entry) -> cstring ---
	compose_table_iterator_new :: proc(table: ^compose_table) -> ^compose_table_iterator ---
	compose_table_iterator_free :: proc(iter: ^compose_table_iterator) ---
	compose_table_iterator_next :: proc(iter: ^compose_table_iterator) -> ^compose_table_entry ---
	compose_state_new :: proc(table: ^compose_table, flags: compose_state_flags) -> ^compose_state ---
	compose_state_ref :: proc(state: ^compose_state) -> ^compose_state ---
	compose_state_unref :: proc(state: ^compose_state) ---
	compose_state_get_compose_table :: proc(state: ^compose_state) -> ^compose_table ---
	compose_state_feed :: proc(state: ^compose_state, keysym: keysym_t) -> compose_feed_result ---
	compose_state_reset :: proc(state: ^compose_state) ---
	compose_state_get_status :: proc(state: ^compose_state) -> compose_status ---
	compose_state_get_utf8 :: proc(state: ^compose_state, buffer: [^]u8, size: uint) -> i32 ---
	compose_state_get_one_sym :: proc(state: ^compose_state) -> keysym_t ---

	// Keyboard state procs
	state_new :: proc(xkb_keymap: ^keymap) -> ^state ---
	state_ref :: proc(xkb_state: ^state) -> ^state ---
	state_unref :: proc(xkb_state: ^state) ---
	state_get_keymap :: proc(xkb_state: ^state) -> ^keymap ---
	state_update_key :: proc(xkb_state: ^state, key: keycode_t, direction: key_direction) -> state_component ---
	state_update_latched_locked :: proc(xkb_state: ^state, affect_latched_mods, latched_mods: mod_mask_t, affect_latched_layout: bool, latched_layout: i32, affect_locked_mods, locked_mods: mod_mask_t, affect_locked_layout: bool, locked_layout: i32) -> state_component ---
	state_update_mask :: proc(xkb_state: ^state, depressed_mods, latched_mods, locked_mods: mod_mask_t, depressed_layout, latched_layout, locked_layout: layout_index_t) -> state_component ---
	state_key_get_syms :: proc(xkb_state: ^state, key: keycode_t, syms_out: ^^keysym_t) -> i32 ---
	state_key_get_utf8 :: proc(xkb_state: ^state, key: keycode_t, buffer: [^]u8, size: uint) -> i32 ---
	state_key_get_utf32 :: proc(xkb_state: ^state, key: keycode_t) -> u32 ---
	state_key_get_one_sym :: proc(xkb_state: ^state, key: keycode_t) -> keysym_t ---
	state_key_get_layout :: proc(xkb_state: ^state, key: keycode_t) -> layout_index_t ---
	state_key_get_level :: proc(xkb_state: ^state, key: keycode_t, layout: layout_index_t) -> level_index_t ---
	state_serialize_mods :: proc(xkb_state: ^state, components: state_component) -> mod_mask_t ---
	state_serialize_layout :: proc(xkb_state: ^state, components: state_component) -> layout_index_t ---
	state_mod_name_is_active :: proc(xkb_state: ^state, name: cstring, type: state_component) -> i32 ---
	state_mod_names_are_active :: proc(xkb_state: ^state, type: state_component, match: state_match, #c_vararg names: ..cstring) -> i32 ---
	state_mod_index_is_active :: proc(xkb_state: ^state, idx: mod_index_t, type: state_component) -> i32 ---
	state_mod_indices_are_active :: proc(xkb_state: ^state, type: state_component, match: state_match, #c_vararg indices: ..mod_index_t) -> i32 ---
	state_key_get_consumed_mods :: proc(xkb_state: ^state, key: keycode_t) -> mod_mask_t ---
	state_key_get_consumed_mods2 :: proc(xkb_state: ^state, key: keycode_t, mode: consumed_mode) -> mod_mask_t ---
	state_mod_index_is_consumed :: proc(xkb_state: ^state, key: keycode_t, idx: mod_index_t) -> i32 ---
	state_mod_index_is_consumed2 :: proc(xkb_state: ^state, key: keycode_t, idx: mod_index_t, mode: consumed_mode) -> i32 ---
	state_mod_mask_remove_consumed :: proc(xkb_state: ^state, key: keycode_t, mask: mod_mask_t) -> mod_mask_t ---
	state_layout_name_is_active :: proc(xkb_state: ^state, name: cstring, type: state_component) -> i32 ---
	state_layout_index_is_active :: proc(xkb_state: ^state, idx: layout_index_t, type: state_component) -> i32 ---
	state_led_name_is_active :: proc(xkb_state: ^state, name: cstring) -> i32 ---
	state_led_index_is_active :: proc(xkb_state: ^state, idx: led_index_t) -> i32 ---
}
