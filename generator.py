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

Interface identifiers are derived by dropping everything up to and including the
first underscore, e.g. 'wl_display' -> 'display', 'xdg_wm_base' -> 'wm_base'.
Because each protocol gets its own package, short names can't collide across
protocols.
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

def base_ident(name: str) -> str:
    """Interface name -> identifier base: drop a trailing '_vN' version suffix,
    then drop everything up to and including the first underscore.
    'wl_display' -> 'display', 'xdg_wm_base' -> 'wm_base',
    'zwp_linux_dmabuf_v1' -> 'linux_dmabuf'."""
    n = re.sub(r"_v\d+$", "", name)
    if "_" in n:
        n = n[n.index("_") + 1:]
    return n

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

FIELD_TYPE = {
    "int":    "i32",
    "uint":   "u32",
    "fixed":  "i32",
    "object": "u32",
    "new_id": "u32",
    "string": "string",
    "array":  "[]u8",
    "fd":     "linux.Fd",
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
}

def size_term(arg, accessor: str):
    t = arg.get("type")
    if t in ("int", "uint", "fixed", "object", "new_id"):
        return f"size_of({accessor})"
    if t == "string":
        return f"util.compute_string_size({accessor})"
    if t == "array":
        return f"util.compute_array_size({accessor})"
    return None  # fd: zero bytes in the body

def write_stmt(arg, accessor: str):
    t = arg.get("type")
    if t == "fd":
        return None
    return f"util.write(&msg, {accessor})"

def decode_stmt(arg):
    name = arg.get("name")
    t = arg.get("type")
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
        self.base = base_ident(name)
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
                iface.enums.append((en.attrib["name"], en.attrib.get("bitfield") == "true", entries, s, d))
            proto.interfaces.append(iface)
        protocols.append(proto)
    return protocols

# ---------------------------------------------------------------------------
# Emission helpers
# ---------------------------------------------------------------------------

def struct_fields(iface, args, target_object: bool, indent="\t"):
    fields = []
    if target_object:
        fields.append((iface.base, "u32", ""))
    for a in args:
        t = a.get("type")
        if t == "new_id" and target_object:
            # new_id in REQUESTS is the encode proc's param, not a field.
            # In EVENTS it is a server-assigned object id and IS a field.
            continue
        fields.append((a.get("name"), FIELD_TYPE[t], a.get("summary", "")))
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
    lines.append(f"\tobject := req.{base}")
    lines.append(f"\topcode := u16({opcode_const})")
    lines.append(f"\tsize := u16({size})")
    lines.append("\tmsg := make([dynamic]byte, 0, size, allocator) or_return")
    lines.append("\tutil.write(&msg, object, opcode, size)")
    for a in args:
        stmt = write_stmt(a, _accessor(a))
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
        sig += ", fds: ^[dynamic]linux.Fd"
    if needs_allocator(args):
        sig += ", allocator: mem.Allocator"
    lines = []
    lines.append(f"{proc} :: proc({sig}) -> {struct} {{")
    lines.append(f"\te: {struct}")
    lines.append("\tr: int")
    lines.append("\tn := r")
    for a in args:
        lines.append(decode_stmt(a))
    lines.append("\treturn e")
    lines.append("}")
    return "\n".join(lines)

def enum_decl(iface, enum_name, is_bitfield, entries, summary, description):
    typ = f"{pascal(iface.base)}_{pascal(enum_name)}"
    lines = doc_lines(summary, description)
    lines.append(f"{typ} :: enum u32 {{")
    for ename, val, summ in entries:
        line = f"\t{ident(pascal(ename))} = {val},"
        if summ:
            line += f"  // {summ.strip()}"
        lines.append(line)
    lines.append("}")
    return "\n".join(lines)

# ---------------------------------------------------------------------------
# File emitters
# ---------------------------------------------------------------------------

def emit_struct(iface, name, args, target_object, kind):
    """Emit a request/event struct declaration (kind = 'Request' or 'Event')."""
    struct = f"{pascal(iface.base)}_{pascal(name)}_{kind}"
    fields = struct_fields(iface, args, target_object)
    if fields:
        return [f"{struct} :: struct {{", *fields, "}"]
    return [f"{struct} :: struct {{}}"]

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
    out.append("")

    if proto.pkg == "wayland":
        out.append("// The core global object, it is always defined to be equal to 1")
        out.append("@(rodata)")
        out.append("display := u32(1)")
        out.append("")

    req_names = [f"{pascal(i.base)}_{pascal(r)}_Request" for i in proto.interfaces for r, _, _, _, _ in i.requests]
    evt_names = [f"{pascal(i.base)}_{pascal(e)}_Event" for i in proto.interfaces for e, _, _, _, _ in i.events]

    out.append("Request :: union #no_nil {")
    for n in req_names:
        out.append(f"\t{n},")
    out.append("}")
    out.append("")
    out.append("Event :: union #no_nil {")
    for n in evt_names:
        out.append(f"\t{n},")
    out.append("}")
    out.append("")

    for iface in proto.interfaces:
        out.extend(doc_lines(iface.summary, iface.description))
        out.append(f"{upper(iface.base)}_INTERFACE :: \"{iface.name}\"")
        out.append(f"{upper(iface.base)}_VERSION :: {iface.version}")
        out.append("")

        for i, (name, args, summary, description, _) in enumerate(iface.requests):
            out.extend(doc_lines(summary, description))
            out.append(f"{upper(iface.base)}_{upper(name)}_OPCODE :: {i}")
            out.extend(emit_struct(iface, name, args, True, "Request"))
            out.append(encode_proc(iface, name, args))
            out.append("")

        for i, (name, args, summary, description, _) in enumerate(iface.events):
            out.extend(doc_lines(summary, description))
            out.append(f"{upper(iface.base)}_{upper(name)}_OPCODE :: {i}")
            out.extend(emit_struct(iface, name, args, False, "Event"))
            out.append(decode_proc(iface, name, args))
            out.append("")

        for name, is_bitfield, entries, summary, description in iface.enums:
            out.append(enum_decl(iface, name, is_bitfield, entries, summary, description))
            out.append("")

    return "\n".join(out)

def emit_dispatch(protocols):
    iface_to_pkg = {i.name: proto.pkg for proto in protocols for i in proto.interfaces}

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
    for proto in protocols:
        if proto.copyright:
            out.extend(copyright_lines(proto.copyright))
            out.append("")
    for proto in protocols:
        out.append(f'import "{proto.pkg}"')
    out.append("")

    out.append("Request :: union {")
    for proto in protocols:
        out.append(f"\t{proto.pkg}.Request,")
    out.append("}")
    out.append("")

    out.append("// Returns the ID of a new object, 0 if none was created.")
    out.append("queue_request :: proc(req: Request) -> (id: u32, err: Error) {")
    out.append("\tswitch p in req {")
    for proto in protocols:
        alias = proto.pkg
        out.append(f"\tcase {alias}.Request:")
        out.append("\t\tswitch r in p {")
        for iface in proto.interfaces:
            for name, args, summary, description, destructor in iface.requests:
                struct = f"{alias}.{pascal(iface.base)}_{pascal(name)}_Request"
                proc = f"{alias}.{iface.base}_{name}_encode"
                out.append(f"\t\tcase {struct}:")
                new_id_arg = next((a for a in args if a.get("type") == "new_id"), None)
                if new_id_arg is not None:
                    out.append("\t\t\tid = new_id()")
                for a in args:
                    if a.get("type") == "fd":
                        out.append(f"\t\t\tappend(&internal_state.outgoing_fds, r.{a.get('name')})")
                if new_id_arg is not None:
                    out.append(f"\t\t\tdata := {proc}(r, id, internal_state.temp_allocator) or_return")
                else:
                    out.append(f"\t\t\tdata := {proc}(r, internal_state.temp_allocator) or_return")
                if new_id_arg is not None:
                    nid_iface = new_id_arg.get("interface")
                    if nid_iface is not None:
                        pkg = iface_to_pkg[nid_iface]
                        out.append(f"\t\t\tinternal_state.interface_map[id] = {pkg}.{upper(base_ident(nid_iface))}_INTERFACE")
                    else:
                        # dynamic interface (bind): resolve the name to a static
                        # constant instead of cloning, so the map never holds
                        # heap-allocated strings
                        out.append("\t\t\tswitch r.interface {")
                        for pkg, base in global_consts:
                            const = f"{pkg}.{upper(base)}_INTERFACE"
                            out.append(f"\t\t\tcase {const}:")
                            out.append(f"\t\t\t\tinternal_state.interface_map[id] = {const}")
                        out.append("\t\t\t}")
                out.append("\t\t\tappend(&internal_state.requests_byte_buffer, ..data[:])")
                if destructor:
                    out.append(f"\t\t\tdelete_key(&internal_state.interface_map, r.{iface.base})")
        out.append("\t\t}")
    out.append("\t}")
    out.append("\treturn")
    out.append("}")
    out.append("")

    out.append("Event :: union {")
    for proto in protocols:
        out.append(f"\t{proto.pkg}.Event,")
    out.append("}")
    out.append("")

    out.append("dispatch_event :: proc(object_id: u32, opcode: u16, data: []byte) {")
    out.append("\tinterface := internal_state.interface_map[object_id]")
    out.append("\tswitch interface {")
    for proto in protocols:
        alias = proto.pkg
        for iface in proto.interfaces:
            out.append(f"\tcase {alias}.{upper(iface.base)}_INTERFACE:")
            out.append("\t\tswitch opcode {")
            for i, (name, args, summary, description, _) in enumerate(iface.events):
                out.append(f"\t\tcase {alias}.{upper(iface.base)}_{upper(name)}_OPCODE:")
                if iface.name == "wl_display" and name == "delete_id":
                    # server freed a server-created object: drop it from the table
                    out.append(f"\t\t\tdelete_key(&internal_state.interface_map, {alias}.{iface.base}_{name}_decode(data).id)")
                elif iface.name == "wl_callback" and name == "done":
                    # callbacks self-destruct after firing: drop their id
                    out.append("\t\t\tdelete_key(&internal_state.interface_map, object_id)")
                else:
                    call = f"{alias}.{iface.base}_{name}_decode(data"
                    if has_fd(args):
                        call += ", &internal_state.incoming_fds"
                    if needs_allocator(args):
                        call += ", internal_state.temp_allocator"
                    call += ")"
                    out.append(f"\t\t\tappend(&internal_state.events, {call})")
            out.append("\t\t}")
    out.append("\t}")
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
        out = Path(f"{proto.pkg}/generated.odin")
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(emit_types(proto))
        print(f"  -> {out} ({len(proto.interfaces)} interfaces)")

    Path(OUT_DISPATCH).write_text(emit_dispatch(protocols))
    print(f"  -> {OUT_DISPATCH}")

if __name__ == "__main__":
    main()
