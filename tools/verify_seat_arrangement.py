#!/usr/bin/env python3
"""Verify that every pilot/operations/gunner containment value maps to the
matching slot in the arrangements the client and server actually load.

Containment -> slot group is `containment - 4` (ContainerComponent::transferObject),
and the group list comes from the *contained object's* arrangement file - the
player's own player.iff - so that is what we assert against.
"""
import re
import struct
import sys


EXPECTED = [
    ("RIDER", "rider"),
    ("SHIP_PILOT", "ship_pilot"),
    ("SHIP_OPERATIONS", "ship_operations"),
] + [(f"SHIP_GUNNER{i}", f"ship_gunner{i}") for i in range(8)] + [
    ("SHIP_PILOT_POB", "ship_pilot_pob"),
    ("SHIP_OPERATIONS_POB", "ship_operations_pob"),
] + [(f"SHIP_GUNNER{i}_POB", f"ship_gunner{i}_pob") for i in range(8)]


def groups(path):
    blob = open(path, "rb").read()
    names = []
    offset = 0
    while True:
        idx = blob.find(b"ARG ", offset)
        if idx < 0:
            break
        size = struct.unpack_from(">I", blob, idx + 4)[0]
        value = blob[idx + 8:idx + 8 + size]
        if value.endswith(b"\0"):
            names.append(value[:-1].decode("latin1"))
        offset = idx + 8 + size
    return names


def enum_values(header):
    text = open(header, encoding="latin1").read()
    body = text[text.index("enum {") + len("enum {"):]
    body = body[:body.index("};")]
    out = {}
    for name, value in re.findall(r"(\w+)\s*=\s*(\d+)", body):
        out[name] = int(value)
    return out


def main():
    arrangement = sys.argv[1]
    header = sys.argv[2] if len(sys.argv) > 2 else None

    slots = groups(arrangement)
    print(f"{arrangement}: {len(slots)} groups")
    for i, name in enumerate(slots):
        print(f"  group {i:2d} (containment {i + 4:2d}) = {name}")

    values = enum_values(header) if header else {name: idx for idx, (name, _) in enumerate(EXPECTED)}
    failures = 0
    print("\nseat check:")
    for enum_name, slot_name in EXPECTED:
        containment = values.get(enum_name)
        if containment is None:
            print(f"  MISSING {enum_name} in PlayerArrangement.h")
            failures += 1
            continue
        group = containment - 4
        actual = slots[group] if 0 <= group < len(slots) else "<out of range>"
        ok = actual == slot_name
        failures += 0 if ok else 1
        print(f"  {'OK  ' if ok else 'FAIL'} {enum_name} = {containment} -> group {group} -> {actual} (want {slot_name})")

    print("\nRESULT:", "all seats match" if failures == 0 else f"{failures} mismatches")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
