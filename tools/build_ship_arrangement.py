#!/usr/bin/env python3
"""Rebuild abstract/slot/arrangement/arrangement_ship.iff so ships actually
have the pilot/operations/gunner slots the server sends, instead of the single
ship_control_device slot that made pilots float inside their ship.

Slot order mirrors the 28-group player.iff shipped in ghosts10.tre, so
containment = slot + 4 lines up for both the ship and the player.
"""

import struct
from pathlib import Path

GROUPS = [
    "ship_control_device",
    "rider1",
    "rider2",
    "rider3",
    "rider4",
    "rider5",
    "rider6",
    "rider7",
    "ship_pilot",
    "ship_operations",
    "ship_gunner0",
    "ship_gunner1",
    "ship_gunner2",
    "ship_gunner3",
    "ship_gunner4",
    "ship_gunner5",
    "ship_gunner6",
    "ship_gunner7",
    "ship_pilot_pob",
    "ship_operations_pob",
    "ship_gunner0_pob",
    "ship_gunner1_pob",
    "ship_gunner2_pob",
    "ship_gunner3_pob",
    "ship_gunner4_pob",
    "ship_gunner5_pob",
    "ship_gunner6_pob",
    "ship_gunner7_pob",
]


def chunk(tag, payload):
    return tag.encode("latin1") + struct.pack(">I", len(payload)) + payload


def build(groups):
    slots = b"".join(chunk("ARG ", name.encode("latin1") + b"\0") for name in groups)
    inner = b"FORM" + struct.pack(">I", 4 + len(slots)) + b"0000" + slots
    outer = b"FORM" + struct.pack(">I", 4 + len(inner)) + b"ARGD" + inner
    return outer


def parse(blob):
    """Minimal reader used only to prove the file we just built is well formed."""
    assert blob[:4] == b"FORM", "missing FORM"
    size = struct.unpack_from(">I", blob, 4)[0]
    assert size == len(blob) - 8, f"FORM size {size} != {len(blob) - 8}"
    assert blob[8:12] == b"ARGD", "wrong form type"

    offset = 12
    names = []
    while offset < len(blob):
        tag = blob[offset:offset + 4]
        chunk_size = struct.unpack_from(">I", blob, offset + 4)[0]
        body = blob[offset + 8:offset + 8 + chunk_size]
        assert len(body) == chunk_size, f"{tag!r} truncated"
        if tag == b"FORM":
            assert body[:4] == b"0000", "wrong inner form type"
            inner = body[4:]
            while inner:
                inner_tag = inner[:4]
                inner_size = struct.unpack_from(">I", inner, 4)[0]
                value = inner[8:8 + inner_size]
                assert inner_tag == b"ARG ", f"unexpected chunk {inner_tag!r}"
                assert value.endswith(b"\0"), "slot name not terminated"
                names.append(value[:-1].decode("latin1"))
                inner = inner[8 + inner_size:]
        else:
            raise AssertionError(f"unexpected top chunk {tag!r}")
        offset += 8 + chunk_size
    return names


def main():
    blob = build(GROUPS)
    parsed = parse(blob)
    assert parsed == GROUPS, "round trip mismatch"
    print(f"built {len(blob)} bytes, {len(parsed)} slots, ship_pilot at index {parsed.index('ship_pilot')}")
    print("  " + ", ".join(parsed))


if __name__ == "__main__":
    main()
