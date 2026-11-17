#!/usr/bin/env python3
"""Audit every ship template on the server for the arrangement it uses.

Resolves each Lua ship template's parent chain and reports the arrangement
descriptor each one ends up with, so we can prove the rebuilt
arrangement_ship.iff applies to every ship and not just the ones we tested.
"""
import re
import sys
from pathlib import Path

ROOT = Path(sys.argv[1] if len(sys.argv) > 1 else ".")

BLOCK_RE = re.compile(r"(object_ship_[\w]*?)\s*=\s*(object_ship_[\w]*?|SharedShipObjectTemplate)\s*:\s*new\s*\{", re.S)


def blocks():
    found = {}
    for path in ROOT.rglob("*.lua"):
        if "custom_content" in str(path):
            continue
        text = path.read_text(encoding="latin1", errors="replace")
        for match in BLOCK_RE.finditer(text):
            ident, parent = match.group(1), match.group(2)
            start = match.end()
            depth = 1
            i = start
            while i < len(text) and depth:
                if text[i] == "{":
                    depth += 1
                elif text[i] == "}":
                    depth -= 1
                i += 1
            body = text[start:i]
            arr = re.search(r"arrangementDescriptorFilename\s*=\s*\"([^\"]*)\"", body)
            found.setdefault(ident, (path, parent, arr.group(1) if arr else None))
    return found


def resolve(ident, table, seen=None):
    seen = seen or set()
    if ident in seen or ident not in table:
        return None
    seen.add(ident)
    _, parent, arr = table[ident]
    if arr:
        return arr
    return resolve(parent, table, seen)


def main():
    table = blocks()
    print(f"parsed {len(table)} ship template definitions")

    counts = {}
    missing = []
    for ident, (path, parent, arr) in sorted(table.items()):
        resolved = resolve(ident, table)
        key = resolved if resolved else "<none>"
        counts[key] = counts.get(key, 0) + 1
        if resolved is None:
            missing.append((ident, parent, str(path)))

    print("\narrangement in effect (resolved through the parent chain):")
    for key, count in sorted(counts.items(), key=lambda kv: -kv[1]):
        print(f"  {count:4d}  {key}")

    if missing:
        print(f"\ntemplates with no arrangement anywhere in the chain: {len(missing)}")
        for ident, parent, path in missing[:20]:
            print(f"  {ident}  (parent {parent})  {path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
