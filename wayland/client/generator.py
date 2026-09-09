#!/usr/bin/env python3
"""
Generate Odin Wayland bindings from protocol XML files.

Reads the canonical protocol XML (wayland.xml + wayland-protocols) and emits, per
protocol, a package named after the protocol's <protocol name="..."> attribute:

    <pkg>/generated.odin   -- protocol types (structs, unions, enums) and the
                              per-message encode/decode procs.

    generated.odin         -- the client-side dispatch: `queue_request()` (marshal +
                              object registration) and `dispatch_event()`
                              (demarshal by interface string + opcode), spanning
                              every protocol passed in.

Run with one directory containing the protocol XML files you need:

    python3 generator.py dir

Every `*.xml` found under that directory is parsed together, so the dispatch
accounts for all protocols in a single pass (rather than being overwritten by
whichever protocol was generated last).

Interface identifiers follow the protocol's own naming convention: an interface
is '<z-namespace>_<protocol name>[_<role>]_vN', so the generator strips the
prefix shared by every interface in the protocol (namespace + protocol name),
leaving the distinguishing part: zwp_linux_dmabuf_v1 -> 'dmabuf',
zwp_linux_buffer_params_v1 -> 'buffer_params', xdg_wm_base -> 'wm_base'.
Each protocol is its own package, so short names can't collide across protocols;
a collision inside one package would be a compile error, not silent.
"""

import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

OUT_DISPATCH = "generated.odin"

# ---------------------------------------------------------------------------
# Naming
# ---------------------------------------------------------------------------

def sanitize_pkg(name: str) -> str:
    """Protocol name -> Odin package/folder name (hyphens become underscores)."""
    return name.replace("-", "_")

def strip_version(name: str) -> str:
    """Drop the trailing '_vN' unstable-version suffix."""
    return re.sub(r"_v\d+$", "", name)

def interface_lcp(names):
    """Longest common prefix of a protocol's interface names.

    Per the wayland-protocols naming convention an interface is
    '<z-namespace>_<protocol name>[_<role>]_vN', so the common prefix is the
    namespace plus whatever part of the protocol name every interface shares.
    If the prefix is exactly one of the names (the primary interface the
    protocol is named after), it is used whole; otherwise it is trimmed back to
    the last '_' so it never cuts a word in half
    (wp_color_manage[ment] -> wp_color_).
    """
    if not names:
        return ""
    prefix = names[0]
    for n in names[1:]:
        while not n.startswith(prefix):
            prefix = prefix[:-1]
            if not prefix:
                return ""
    if prefix and prefix not in names:
        cut = prefix.rfind("_")
        prefix = prefix[:cut + 1] if cut != -1 else ""
    return prefix

def base_from(name: str, lcp: str) -> str:
    """Interface name -> identifier base, given the protocol's common prefix.
    An interface whose name is fully consumed by the prefix (the primary
    interface a protocol is named after) falls back to its last token."""
    deversioned = strip_version(name)
    base = deversioned[len(lcp):].lstrip("_") if lcp else deversioned
    return base or deversioned.split("_")[-1]

def pascal(s: str) -> str:
    """snake_case -> PascalCase_with_underscores."""
    return "_".join(part[:1].upper() + part[1:] for part in s.split("_"))

def upper(s: str) -> str:
    return s.upper()

def ident(name: str) -> str:
    """Make a valid Odin identifier, prefixing '_' for digit-leading names
    (e.g. the wl_output.transform entries '90', '180', '270')."""
    if not name:
        return "_"
    if not (name[0].isalpha() or name[0] == "_"):
        return "_" + name
    return name

# ---------------------------------------------------------------------------
# Arg type mapping
# ---------------------------------------------------------------------------

# Populated during parse: (interface_name, enum_name) -> base of owning interface.
# Used to resolve <arg enum="..."> references, including fully-qualified
# cross-interface refs like "wl_data_device_manager.dnd_action".
ENUMS = {}              # (iface_name, enum_name) -> owning iface's base (all enums)
BITFIELD_ENUMS = {}     # (iface_name, enum_name) -> owning iface's base (those with bitfield="true")
IFACE_BASE = {}         # iface_name -> base
IFACE_PKG = {}          # iface_name -> package (cross-package resolution)

FIELD_TYPE = {
    "int":    "i32",
    "uint":   "u32",
    "fixed":  "i32",
    "object": "u32",
    "new_id": "u32",
    "string": "string",
    "array":  "[]u8",
    "fd":     "linux.Fd",
    "fixed":  "util.Fixed",
}

READ_FN = {
    "int":    "read_i32",
    "uint":   "read_u32",
    "fixed":  "read_i32",
    "object": "read_u32",
    "new_id": "read_u32",
    "string": "read_string",
    "array":  "read_array",
    "fd":     None,       # fds arrive via SCM_RIGHTS, not the message body
    "fixed":  "read_fixed"
}

def resolve_enum_ref(iface, arg):
    """Resolve an arg's enum attribute to (owning_iface_name, enum_name).

    References may be bare (same interface) or fully-qualified
    ("wl_data_device_manager.dnd_action"). Returns None if the arg has no
    enum reference."""
    ref = arg.get("enum")
    if not ref:
        return None
    if "." in ref:
        iname, ename = ref.split(".", 1)
    else:
        iname, ename = iface.name, ref
    return iname, ename

def is_bitfield_arg(iface, arg):
    """True if this arg's type is a uint referencing a bitfield enum."""
    if arg.get("type") != "uint":
        return False
    ref = resolve_enum_ref(iface, arg)
    return ref is not None and ref in BITFIELD_ENUMS

def enum_field_type(iface, arg):
    """Odin enum type for a non-bitfield enum arg (None if not enum-typed).

    Like object ids, the typed field carries the enum's defining package when it
    lives in a different protocol."""
    if arg.get("type") not in ("int", "uint"):
        return None
    ref = resolve_enum_ref(iface, arg)
    if ref is None or ref not in ENUMS or ref in BITFIELD_ENUMS:
        return None
    iname, ename = ref
    owner_base = IFACE_BASE[iname]
    owner_pkg = IFACE_PKG[iname]
    typ = f"{pascal(owner_base)}_{pascal(ename)}"
    return typ if owner_pkg == iface.pkg else f"{owner_pkg}.{typ}"

def bitfield_type(iface, arg):
    """The named Odin bit_set type for a bitfield enum arg (e.g. Seat_Capability_Set).

    The bit_set is declared with an explicit u32 underlying integer (see enum_decl)
    so sizeof == 4 and it always matches the wire encoding."""
    iname, ename = resolve_enum_ref(iface, arg)
    owner_base = IFACE_BASE[iname]
    return f"{pascal(owner_base)}_{pascal(ename)}_Set"

def arg_field_type(iface, arg):
    """Odin field type for an arg, honoring bitfield and plain enum args."""
    if is_bitfield_arg(iface, arg):
        return bitfield_type(iface, arg)
    t = arg.get("type")
    if t in ("object", "new_id"):
        return obj_field_type(iface, arg)
    enum_t = enum_field_type(iface, arg)
    if enum_t is not None:
        return enum_t
    return FIELD_TYPE[t]

def obj_field_type(iface, arg):
    """Typed id for an object/new_id arg, resolving cross-package references.

    An object/new_id with an `interface` attribute becomes that interface's
    distinct type (qualified with the owning package when it lives in a
    different protocol). Without an interface attribute (e.g. wl_display.error's
    object_id, or wl_registry.bind's dynamic new_id) it stays a plain u32."""
    iname = arg.get("interface")
    if not iname or iname not in IFACE_PKG:
        return "u32"
    base = pascal(IFACE_BASE[iname])
    pkg = IFACE_PKG[iname]
    return base if pkg == iface.pkg else f"{pkg}.{base}"

def size_term(arg, accessor: str):
    t = arg.get("type")
    if t in ("int", "uint", "fixed", "object", "new_id"):
        return f"size_of({accessor})"
    if t == "string":
        return f"util.compute_string_size({accessor})"
    if t == "array":
        return f"util.compute_array_size({accessor})"
    return None  # fd: zero bytes in the body

def write_stmt(arg, accessor: str, iface=None):
    t = arg.get("type")
    if t == "fd":
        return None
    if iface is not None and is_bitfield_arg(iface, arg):
        # bit_set has no util.write overload; emit the raw u32
        return f"util.write_u32(&msg, transmute(u32){accessor})"
    if iface is not None and enum_field_type(iface, arg) is not None:
        # enum arg: cast back to the wire numeric type (int -> i32, uint -> u32)
        return f"util.write(&msg, {FIELD_TYPE[t]}({accessor}))"
    if iface is not None and t == "object" and obj_field_type(iface, arg) != "u32":
        # object args are typed distinct u32; cast back to the wire u32
        return f"util.write(&msg, u32({accessor}))"
    return f"util.write(&msg, {accessor})"

def decode_stmt(iface, arg):
    name = arg.get("name")
    t = arg.get("type")
    if is_bitfield_arg(iface, arg):
        # read the raw u32, then cast to the bit_set (underlying u32)
        return (f"\tval_{name}, _ := util.read_u32(data[n:]); n += 4\n"
                f"\te.{name} = transmute({bitfield_type(iface, arg)})val_{name}")
    if enum_field_type(iface, arg) is not None:
        # read the wire numeric type (int/i32, uint/u32), transmute to the enum
        # (the enum declares a u32 underlying, so 4 bytes either way)
        return (f"\tval_{name}, _ := util.{READ_FN[t]}(data[n:]); n += 4\n"
                f"\te.{name} = transmute({enum_field_type(iface, arg)})val_{name}")
    if t in ("object", "new_id") and obj_field_type(iface, arg) != "u32":
        # typed distinct u32: read the wire u32 and cast to the interface type
        return (f"\tval_{name}, _ := util.read_u32(data[n:]); n += 4\n"
                f"\te.{name} = {obj_field_type(iface, arg)}(val_{name})")
    fn = READ_FN[t]
    if fn is None:  # fd: travels via SCM_RIGHTS; pop it from the incoming queue
        return f"\te.{name} = pop_front(fds)"
    line = f"\te.{name}, r = util.{fn}(data[n:]); n += r"
    if t == "string":
        # borrows from the decode buffer; clone (arena alloc) so the event
        # owns it for this frame and remove_range can't clobber it
        line += f"\n\te.{name} = strings.clone(e.{name}, allocator)"
    elif t == "array":
        line += f"\n\te.{name} = bytes.clone(e.{name}, allocator)"
    return line

# ---------------------------------------------------------------------------
# The wl_registry.bind special case
#
# wayland.xml declares bind as (name, id) only; the real wire signature is
# 'usun' = name(uint), interface(string), version(uint), id(new_id). The
# scanner inserts the two extra args. Replicate that here.
# ---------------------------------------------------------------------------

def effective_args(iface_name: str, req_name: str, args):
    if iface_name == "wl_registry" and req_name == "bind":
        return [
            _arg("name", "uint"),
            _arg("interface", "string"),
            _arg("version", "uint"),
            _arg("id", "new_id"),
        ]
    return args

def _arg(name, typ, **attrs):
    a = {"name": name, "type": typ}
    a.update(attrs)
    return a

def _desc(el):
    """Extract (summary, description) from an element's <description> child."""
    d = el.find("description")
    if d is None:
        return "", ""
    return (d.get("summary") or "").strip(), (d.text or "").strip()

def _copyright(root):
    """Extract the protocol's <copyright> license text."""
    c = root.find("copyright")
    return (c.text or "").strip() if c is not None else ""

def copyright_lines(text):
    """Render a license block as `//` comment lines."""
    out = []
    for line in text.splitlines():
        s = line.strip()
        out.append(f"// {s}" if s else "//")
    return out

def doc_lines(summary, description, indent=""):
    """Render a <description> summary + text as `//` comment lines."""
    out = []
    if summary:
        out.append(f"{indent}// {summary}")
    if description:
        for line in description.splitlines():
            line = line.strip()
            if line:
                out.append(f"{indent}// {line}")
    return out

# ---------------------------------------------------------------------------
# Parsing
# ---------------------------------------------------------------------------

class Interface:
    def __init__(self, name, version, pkg):
        self.name = name
        self.version = version
        self.pkg = pkg
        self.base = strip_version(name)   # finalized per-protocol in parse_files
        self.summary = ""
        self.description = ""
        self.requests = []   # (name, [args], summary, description, destructor)
        self.events = []     # (name, [args], summary, description, destructor)
        self.enums = []      # (name, is_bitfield, [(entry, value, summary)], summary, description)

class Protocol:
    def __init__(self, pkg, copyright=""):
        self.pkg = pkg
        self.copyright = copyright
        self.interfaces = []

def parse_files(paths):
    protocols = []
    for p in paths:
        try:
            root = ET.parse(p).getroot()
        except Exception as e:
            print(f"WARNING: skipping unparseable XML {p}: {e}")
            continue
        if root.tag != "protocol" or "name" not in root.attrib:
            continue
        proto = Protocol(sanitize_pkg(root.attrib["name"]), _copyright(root))
        for el in root.findall("interface"):
            iface = Interface(el.attrib["name"], el.attrib["version"], proto.pkg)
            iface.summary, iface.description = _desc(el)
            for req in el.findall("request"):
                args = [a.attrib for a in req.findall("arg")]
                args = effective_args(iface.name, req.attrib["name"], args)
                s, d = _desc(req)
                iface.requests.append((req.attrib["name"], args, s, d, req.attrib.get("type") == "destructor"))
            for evt in el.findall("event"):
                args = [a.attrib for a in evt.findall("arg")]
                s, d = _desc(evt)
                iface.events.append((evt.attrib["name"], args, s, d, evt.attrib.get("type") == "destructor"))
            for en in el.findall("enum"):
                entries = [(e.attrib["name"], e.attrib["value"], e.attrib.get("summary", "")) for e in en.findall("entry")]
                s, d = _desc(en)
                is_bitfield = en.attrib.get("bitfield") == "true"
                iface.enums.append((en.attrib["name"], is_bitfield, entries, s, d))
                ENUMS[(el.attrib["name"], en.attrib["name"])] = True
                if is_bitfield:
                    BITFIELD_ENUMS[(el.attrib["name"], en.attrib["name"])] = True
            proto.interfaces.append(iface)
        # finalize interface identifier bases: strip the prefix (namespace +
        # protocol name) shared by every interface in this protocol
        lcp = interface_lcp([strip_version(i.name) for i in proto.interfaces])
        for iface in proto.interfaces:
            iface.base = base_from(iface.name, lcp)
            IFACE_BASE[iface.name] = iface.base
            IFACE_PKG[iface.name] = iface.pkg
        protocols.append(proto)
    return protocols

# ---------------------------------------------------------------------------
# Emission helpers
# ---------------------------------------------------------------------------

def struct_fields(iface, args, include_target: bool, skip_new_id: bool, indent="\t"):
    """Emit the field lines for a request/event struct.

    include_target: add the interface's own object id field (the object the
    message concerns). Requests and events both carry it, mirroring each other:
    e.g. wl_buffer.release -> `buffer: u32`, wl_surface.attach -> `surface: u32`.

    skip_new_id: requests pass the new id as an encode-proc parameter instead of
    a struct field; events arrive with a server-assigned id in the body, which
    IS a field."""
    fields = []
    if include_target:
        fields.append((iface.base, pascal(iface.base), "the object this event/request concerns"))
    for a in args:
        t = a.get("type")
        if skip_new_id and t == "new_id":
            continue
        fields.append((a.get("name"), arg_field_type(iface, a), a.get("summary", "")))
    if not fields:
        return []
    width = max(len(n) for n, _, _ in fields)
    lines = []
    for n, t, s in fields:
        line = f"{indent}{n}{' ' * (width - len(n) + 1)}: {t},"
        if s:
            line += f"  // {s.strip()}"
        lines.append(line)
    return lines

def has_new_id(args):
    return any(a.get("type") == "new_id" for a in args)

def has_fd(args):
    return any(a.get("type") == "fd" for a in args)

def has_string(args):
    return any(a.get("type") == "string" for a in args)

def has_array(args):
    return any(a.get("type") == "array" for a in args)

def needs_allocator(args):
    return has_string(args) or has_array(args)

def _accessor(a):
    return "new_id" if a.get("type") == "new_id" else f"req.{a.get('name')}"

def encode_proc(iface, req_name, args):
    base = iface.base
    struct = f"{pascal(base)}_{pascal(req_name)}_Request"
    opcode_const = f"{upper(base)}_{upper(req_name)}_OPCODE"
    proc = f"{base}_{req_name}_encode"

    sig = f"req: {struct}, "
    if has_new_id(args):
        sig += "new_id: u32, "
    sig += "allocator: mem.Allocator"

    size_terms = [size_term(a, _accessor(a)) for a in args]
    size_terms = [t for t in size_terms if t is not None]
    size = "8" + (" + " + " + ".join(size_terms) if size_terms else "")

    lines = []
    lines.append(f"{proc} :: proc({sig}) -> (encoded: []byte, err: mem.Allocator_Error) {{")
    lines.append(f"\tobject := u32(req.{base})")
    lines.append(f"\topcode := u16({opcode_const})")
    lines.append(f"\tsize := u16({size})")
    lines.append("\tmsg := make([dynamic]byte, 0, size, allocator) or_return")
    lines.append("\tutil.write(&msg, object, opcode, size)")
    for a in args:
        stmt = write_stmt(a, _accessor(a), iface)
        if stmt:
            lines.append(f"\t{stmt}")
        else:
            lines.append(f"\t// {a.get('name')}: fd — sent via SCM_RIGHTS, not in the body")
    lines.append("\tencoded = msg[:]")
    lines.append("\treturn")
    lines.append("}")
    return "\n".join(lines)

def decode_proc(iface, evt_name, args):
    base = iface.base
    struct = f"{pascal(base)}_{pascal(evt_name)}_Event"
    proc = f"{base}_{evt_name}_decode"
    sig = "data: []byte"
    if has_fd(args):
        sig += ", fds: ^[dynamic; 28]linux.Fd"
    if needs_allocator(args):
        sig += ", allocator: mem.Allocator"
    lines = []
    lines.append(f"{proc} :: proc({sig}) -> {struct} {{")
    lines.append(f"\te: {struct}")
    lines.append("\tr: int")
    lines.append("\tn := r")
    for a in args:
        lines.append(decode_stmt(iface, a))
    lines.append("\treturn e")
    lines.append("}")
    return "\n".join(lines)

def _parse_int(s: str) -> int:
    s = s.strip()
    return int(s, 0) if s.lower().startswith("0x") else int(s)

def enum_decl(iface, enum_name, is_bitfield, entries, summary, description):
    typ = f"{pascal(iface.base)}_{pascal(enum_name)}"
    lines = doc_lines(summary, description)
    lines.append(f"{typ} :: enum u32 {{")
    for ename, val, summ in entries:
        i = _parse_int(val)
        if is_bitfield:
            # Wayland bitfield entries are power-of-two MASK values, but Odin's
            # bit_set interprets each enum value as a BIT INDEX. Convert the mask
            # to its bit position (index = log2(mask)) so the two line up; the
            # underlying u32 then makes the storage bit pattern == the wire mask.
            # Skip zero-valued (empty flags) and composite (non power-of-two,
            # e.g. wl_shell_surface.resize.top_left = 5) entries.
            if i == 0 or i & (i - 1):
                continue
            i = i.bit_length() - 1
        line = f"\t{ident(pascal(ename))} = {i},"
        if summ:
            line += f"  // {summ.strip()}"
        lines.append(line)
    lines.append("}")
    if is_bitfield:
        # forced u32 underlying so sizeof == 4 (matches the u32 wire encoding)
        lines.append(f"{typ}_Set :: bit_set[{typ}; u32]")
    return "\n".join(lines)

# ---------------------------------------------------------------------------
# File emitters
# ---------------------------------------------------------------------------

def emit_struct(iface, name, args, include_target, skip_new_id, kind):
    """Emit a request/event struct declaration (kind = 'Request' or 'Event')."""
    struct = f"{pascal(iface.base)}_{pascal(name)}_{kind}"
    fields = struct_fields(iface, args, include_target, skip_new_id)
    if fields:
        return [f"{struct} :: struct {{", *fields, "}"]
    return [f"{struct} :: struct {{}}"]

def foreign_pkg_imports(proto):
    """Packages referenced by object/new_id args that live in another protocol."""
    refs = set()
    for iface in proto.interfaces:
        for name, args, _, _, _ in iface.requests + iface.events:
            for a in args:
                iname = a.get("interface")
                if a.get("type") in ("object", "new_id") and iname and iname in IFACE_PKG:
                    pkg = IFACE_PKG[iname]
                    if pkg != proto.pkg:
                        refs.add(pkg)
                eref = resolve_enum_ref(iface, a)
                if eref and eref in ENUMS and eref not in BITFIELD_ENUMS:
                    iname, _ = eref
                    if iname in IFACE_PKG:
                        pkg = IFACE_PKG[iname]
                        if pkg != proto.pkg:
                            refs.add(pkg)
    return sorted(refs)

def emit_types(proto):
    out = []
    out.append(f"package {proto.pkg}")
    out.append("")
    if proto.copyright:
        out.extend(copyright_lines(proto.copyright))
        out.append("")
    out.append('import util "../util"')
    out.append('import "core:bytes"')
    out.append('import "core:mem"')
    out.append('import "core:strings"')
    out.append('import "core:sys/linux"')
    for pkg in foreign_pkg_imports(proto):
        out.append(f'import {pkg} "../{pkg}"')
    out.append("")

    if proto.pkg == "wayland":
        out.append("// The core global object, it is always defined to be equal to 1")
        out.append("@(rodata)")
        out.append("display := Display(1)")
        out.append("")

    # One distinct type per interface, so object ids are type-safe.
    for iface in proto.interfaces:
        out.append(f"{pascal(iface.base)} :: distinct u32")
    out.append("")

    for iface in proto.interfaces:
        out.extend(doc_lines(iface.summary, iface.description))
        out.append(f"{upper(iface.base)}_INTERFACE :: \"{iface.name}\"")
        out.append(f"{upper(iface.base)}_VERSION :: {iface.version}")
        out.append("")

        for i, (name, args, summary, description, _) in enumerate(iface.requests):
            out.append(f"{upper(iface.base)}_{upper(name)}_OPCODE :: {i}")
            out.extend(doc_lines(summary, description))
            out.extend(emit_struct(iface, name, args, True, True, "Request"))
            out.append(encode_proc(iface, name, args))
            out.append("")

        for i, (name, args, summary, description, _) in enumerate(iface.events):
            out.append(f"{upper(iface.base)}_{upper(name)}_OPCODE :: {i}")
            out.extend(doc_lines(summary, description))
            out.extend(emit_struct(iface, name, args, True, False, "Event"))
            out.append(decode_proc(iface, name, args))
            out.append("")

        for name, is_bitfield, entries, summary, description in iface.enums:
            out.append(enum_decl(iface, name, is_bitfield, entries, summary, description))
            out.append("")

    return "\n".join(out)

def emit_dispatch(protocols):
    iface_to_pkg = {i.name: proto.pkg for proto in protocols for i in proto.interfaces}
    iface_to_base = {i.name: i.base for proto in protocols for i in proto.interfaces}

    # Globals are the interfaces advertised by wl_registry and therefore bindable.
    # Anything referenced as a new_id target (e.g. wl_surface from
    # wl_compositor.create_surface, wl_buffer from wl_shm_pool.create_buffer) is a
    # child object created by a request/event, never bound via the registry.
    created = set()
    for proto in protocols:
        for iface in proto.interfaces:
            for name, args, _, _, _ in iface.requests + iface.events:
                for a in args:
                    if a.get("type") == "new_id" and a.get("interface"):
                        created.add(a["interface"])
    global_consts = [(proto.pkg, i.base) for proto in protocols for i in proto.interfaces
                     if i.name not in created and i.name != "wl_display"]

    out = []
    out.append("package client")
    out.append("")
    out.append('import "core:sys/linux"')
    out.append("")
    for proto in protocols:
        out.append(f'import "{proto.pkg}"')
    out.append("")

    # encode_request is a flat procedure group: one overload per request struct.
    # It is pure marshalling — no Client state, no id allocation, no registration
    # — so it can be called from any thread. It returns the wire bytes and any fds
    # that must ride the same sendmsg.
    out.append("encode_request :: proc {")
    for proto in protocols:
        for iface in proto.interfaces:
            for name, args, _, _, _ in iface.requests:
                out.append(f"\tencode_request_{proto.pkg}_{iface.base}_{name},")
    out.append("}")
    out.append("")

    for proto in protocols:
        alias = proto.pkg
        for iface in proto.interfaces:
            for name, args, summary, description, destructor in iface.requests:
                struct = f"{alias}.{pascal(iface.base)}_{pascal(name)}_Request"
                proc = f"encode_request_{alias}_{iface.base}_{name}"
                encode = f"{alias}.{iface.base}_{name}_encode"
                new_id_arg = next((a for a in args if a.get("type") == "new_id"), None)
                fd_args = [a for a in args if a.get("type") == "fd"]

                sig = f"req: {struct}, "
                if new_id_arg is not None:
                    sig += "id: u32, "
                sig += "allocator := context.temp_allocator"

                out.append("")
                out.append(f"{proc} :: proc({sig}) -> (data: []byte, fds: []linux.Fd, err: Error) {{")
                if new_id_arg is not None:
                    out.append(f"\tdata = {encode}(req, id, allocator) or_return")
                else:
                    out.append(f"\tdata = {encode}(req, allocator) or_return")
                if fd_args:
                    out.append(f"\tfds = make([]linux.Fd, {len(fd_args)}, allocator) or_return")
                    for i, a in enumerate(fd_args):
                        out.append(f"\tfds[{i}] = req.{a.get('name')}")
                out.append("\treturn")
                out.append("}")
    out.append("")

    # queue_request is the convenience wrapper: allocate the id, encode, register
    # the new object, and submit. It must stay a per-request overload because it
    # allocates the id that encode_request needs as a parameter and returns the
    # typed id.
    out.append("queue_request :: proc {")
    for proto in protocols:
        for iface in proto.interfaces:
            for name, args, _, _, _ in iface.requests:
                out.append(f"\tqueue_request_{proto.pkg}_{iface.base}_{name},")
    out.append("}")
    out.append("")

    for proto in protocols:
        alias = proto.pkg
        for iface in proto.interfaces:
            for name, args, summary, description, destructor in iface.requests:
                struct = f"{alias}.{pascal(iface.base)}_{pascal(name)}_Request"
                proc = f"queue_request_{alias}_{iface.base}_{name}"
                enc = f"encode_request_{alias}_{iface.base}_{name}"
                new_id_arg = next((a for a in args if a.get("type") == "new_id"), None)

                if new_id_arg is None:
                    ret = "Error"
                else:
                    nid_iface = new_id_arg.get("interface")
                    if nid_iface is not None:
                        ret = f"(ret: {iface_to_pkg[nid_iface]}.{pascal(iface_to_base[nid_iface])}, err: Error)"
                    else:
                        ret = "(ret: u32, err: Error)"  # dynamic (registry.bind)

                out.append("")
                out.append(f"{proc} :: proc(client: ^Client, req: {struct}, allocator := context.temp_allocator) -> {ret} {{")
                if new_id_arg is not None:
                    out.append("\tclient.next_id += 1")
                    out.append("\tid := client.next_id")
                if new_id_arg is not None and new_id_arg.get("interface") is None:
                    # dynamic interface (bind): clamp the requested version to what
                    # the generated dispatcher supports, resolve the name to a static
                    # constant, and register it.
                    out.append("\trb := req")
                    out.append("\tswitch rb.interface {")
                    for pkg, base in global_consts:
                        const = f"{pkg}.{upper(base)}_INTERFACE"
                        out.append(f"\tcase {const}:")
                        out.append(f"\t\trb.version = min(rb.version, {pkg}.{upper(base)}_VERSION)")
                        out.append(f"\t\tregister_object(client, id, {const})")
                    out.append("\t}")
                    out.append(f"\tdata, fds := {enc}(rb, id, allocator) or_return")
                elif new_id_arg is not None:
                    out.append(f"\tdata, fds := {enc}(req, id, allocator) or_return")
                    nid_iface = new_id_arg["interface"]
                    pkg = iface_to_pkg[nid_iface]
                    out.append(f"\tregister_object(client, id, {pkg}.{upper(iface_to_base[nid_iface])}_INTERFACE)")
                else:
                    out.append(f"\tdata, fds := {enc}(req, allocator) or_return")
                out.append("\tsubmit(client, data, fds) or_return")
                if destructor:
                    out.append(f"\tdelete_key(&client.id_to_interface, u32(req.{iface.base}))")
                if new_id_arg is None:
                    out.append("\treturn nil")
                else:
                    nid_iface = new_id_arg.get("interface")
                    if nid_iface is not None:
                        out.append(f"\treturn {iface_to_pkg[nid_iface]}.{pascal(iface_to_base[nid_iface])}(id), nil")
                    else:
                        out.append("\treturn id, nil")
                out.append("}")
    out.append("")

    # A flat union of every event struct across all protocols, so users switch
    # directly on the event type without a nested per-protocol union.
    out.append("Event :: union {")
    for proto in protocols:
        for iface in proto.interfaces:
            for name, args, _, _, _ in iface.events:
                struct = f"{proto.pkg}.{pascal(iface.base)}_{pascal(name)}_Event"
                out.append(f"\t{struct},")
    out.append("}")
    out.append("")

    out.append("parse_event :: proc(client: ^Client, interface: string, object_id: u32, opcode: u16, data: []byte, fds: ^[dynamic; 28]linux.Fd, allocator := context.temp_allocator) -> (ev: Event, ok: bool) {")
    out.append("\tswitch interface {")
    for proto in protocols:
        alias = proto.pkg
        for iface in proto.interfaces:
            out.append(f"\tcase {alias}.{upper(iface.base)}_INTERFACE:")
            out.append("\t\tswitch opcode {")
            for i, (name, args, summary, description, _) in enumerate(iface.events):
                out.append(f"\t\tcase {alias}.{upper(iface.base)}_{upper(name)}_OPCODE:")
                if iface.name == "wl_display" and name == "delete_id":
                    out.append(f"\t\t\tdelete_key(&client.id_to_interface, {alias}.{iface.base}_{name}_decode(data).id)")
                    out.append("\t\t\treturn")
                elif iface.name == "wl_callback" and name == "done":
                    out.append("\t\t\tdelete_key(&client.id_to_interface, object_id)")
                    out.append("\t\t\treturn")
                else:
                    # An event that carries a new_id hands us a server-created
                    # object; register it so its own events can be dispatched.
                    new_id_arg = next((a for a in args if a.get("type") == "new_id"), None)
                    if new_id_arg is not None and new_id_arg.get("interface") in iface_to_pkg:
                        nid_iface = new_id_arg["interface"]
                        nid_pkg = iface_to_pkg[nid_iface]
                        nid_const = f"{nid_pkg}.{upper(iface_to_base[nid_iface])}_INTERFACE"
                        nid_field = new_id_arg.get("name")
                    call = f"{alias}.{iface.base}_{name}_decode(data"
                    if has_fd(args):
                        call += ", fds"
                    if needs_allocator(args):
                        call += ", allocator"
                    call += ")"
                    out.append(f"\t\t\tdecoded := {call}")
                    out.append(f"\t\t\tdecoded.{iface.base} = {alias}.{pascal(iface.base)}(object_id)")
                    if new_id_arg is not None and new_id_arg.get("interface") in iface_to_pkg:
                        out.append(f"\t\t\tclient.id_to_interface[u32(decoded.{nid_field})] = {nid_const}")
                    out.append(f"\t\t\treturn Event(decoded), true")
            out.append("\t\t}")
    out.append("\t}")
    out.append("\treturn")
    out.append("}")
    out.append("")

    # One bind helper per global: takes the registry + the global event and
    # returns the typed interface id, so users don't hand-write Registry_Bind_Request.
    for pkg, base in global_consts:
        iface_const = f"{pkg}.{upper(base)}_INTERFACE"
        out.append(f"bind_{base} :: proc(client: ^Client, registry: wayland.Registry, e: wayland.Registry_Global_Event) -> ({pkg}.{pascal(base)}, Error) {{")
        out.append(f"\tid, err := queue_request(client, wayland.Registry_Bind_Request {{")
        out.append("\t\tregistry  = registry,")
        out.append("\t\tname      = e.name,")
        out.append(f"\t\tinterface = {iface_const},")
        out.append("\t\tversion   = e.version,")
        out.append("\t})")
        out.append(f"\treturn {pkg}.{pascal(base)}(id), err")
        out.append("}")
        out.append("")

    return "\n".join(out)

# ---------------------------------------------------------------------------
# Dependency check
# ---------------------------------------------------------------------------

def check_deps(protocols):
    known = {i.name for proto in protocols for i in proto.interfaces}
    missing = set()
    for proto in protocols:
        for iface in proto.interfaces:
            for name, args, summary, description, _ in iface.requests + iface.events:
                for a in args:
                    if a.get("type") == "new_id" and a.get("interface") \
                       and a["interface"] not in known:
                        missing.add(a["interface"])
    if missing:
        print("WARNING: new_id args reference interfaces not in the input set:")
        for m in sorted(missing):
            print(f"  - {m} (add the protocol XML that defines it)")

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

def main():
    if len(sys.argv) != 2:
        print("usage: python3 generator.py <protocols-dir>")
        sys.exit(1)

    # All output is anchored relative to the generator's own directory, so the
    # script works no matter what the current working directory is.
    base = Path(__file__).resolve().parent

    d = Path(sys.argv[1])
    if not d.is_dir():
        print(f"not a directory: {d}")
        sys.exit(1)

    paths = sorted(d.rglob("*.xml"))
    if not paths:
        print(f"no .xml files found under {d}")
        sys.exit(1)

    protocols = parse_files(paths)
    check_deps(protocols)

    for proto in protocols:
        out = base / f"{proto.pkg}/generated.odin"
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(emit_types(proto))
        print(f"  -> {out} ({len(proto.interfaces)} interfaces)")

    out_dispatch = base / OUT_DISPATCH
    out_dispatch.write_text(emit_dispatch(protocols))
    print(f"  -> {out_dispatch}")

if __name__ == "__main__":
    main()
