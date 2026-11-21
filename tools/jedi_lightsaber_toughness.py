#!/usr/bin/env python3
"""Set lightsaber_toughness on the Pre-CU Force Discipline Lightsaber tree.

Design (server owner, 2026-11-21):
  Lightsaber Novice ................ 10
  One-hand  01/02/03/04 ............ 5 / 10 / 15 / 20  = 50
  Two-hand  01/02/03/04 ............ 5 / 10 / 15 / 20  = 50
  Polearm   01/02/03/04 ............ 5 / 10 / 15 / 20  = 50
  Technique 01/02/03/04 ............ 5 / 10 / 15 / 20  = 50
  Lightsaber Master ................ 15
  -------------------------------------------------
  Maximum from skill boxes ......... 225

A CA (clothing attachment) skill tape with lightsaber_toughness is rolled from
lootableClothingAttachmentStatMods in scripts/managers/loot_manager.lua and
stacks on top of the 225.

Stray lightsaber_toughness on the other discipline trees, the defender branch
capstones and the Grand Master / Dark Lord trees is removed so that 225 is the
true maximum a character can reach from skill boxes.  The mod is a percentage
damage reduction against lightsaber attacks (CombatManager
::getDefenderToughnessModifier), so the total is capped by game design here, not
by the client.
"""

from pathlib import Path
import argparse
import struct

MOD = "lightsaber_toughness"

TARGETS = {
    "force_discipline_light_saber_novice": 10,
    "force_discipline_light_saber_master": 15,
}
for branch in ("one_hand", "two_hand", "polearm", "technique"):
    for tier, value in zip(("01", "02", "03", "04"), (5, 10, 15, 20)):
        TARGETS["force_discipline_light_saber_%s_%s" % (branch, tier)] = value

EXPECTED_TOTAL = 225


def parse(data):
    def chunk(tag, start=0):
        offset = data.index(tag, start)
        size = int.from_bytes(data[offset + 4:offset + 8], "big")
        return offset, size, offset + 8, offset + 8 + size

    def cstring(offset):
        end = data.index(0, offset)
        return data[offset:end].decode("latin1"), end + 1

    cols_at, cols_size, cols_start, _ = chunk(b"COLS")
    type_at, type_size, type_start, _ = chunk(b"TYPE", cols_at + 8 + cols_size)
    rows_at, rows_size, rows_start, rows_end = chunk(b"ROWS", type_at + 8 + type_size)

    offset = cols_start
    column_count = struct.unpack_from("<I", data, offset)[0]
    offset += 4
    columns = []
    for _ in range(column_count):
        value, offset = cstring(offset)
        columns.append(value)

    offset = type_start
    types = []
    for _ in range(column_count):
        value, offset = cstring(offset)
        types.append(value[0])

    offset = rows_start
    row_count = struct.unpack_from("<I", data, offset)[0]
    offset += 4
    rows = []
    for _ in range(row_count):
        values = []
        for cell_type in types:
            if cell_type == "s":
                value, offset = cstring(offset)
            elif cell_type == "f":
                value = struct.unpack_from("<f", data, offset)[0]
                offset += 4
            else:
                value = struct.unpack_from("<I", data, offset)[0]
                offset += 4
            values.append(value)
        rows.append(values)

    if offset != rows_end:
        raise ValueError("ROWS chunk did not parse cleanly")

    return columns, types, rows, rows_at, rows_start, rows_end


def encode_row(types, values):
    encoded = bytearray()
    for cell_type, value in zip(types, values):
        if cell_type == "s":
            encoded.extend(value.encode("latin1") + b"\0")
        elif cell_type == "f":
            encoded.extend(struct.pack("<f", value))
        else:
            encoded.extend(struct.pack("<I", value))
    return bytes(encoded)


def rebuild(data, types, rows, rows_at, rows_start, rows_end):
    payload = struct.pack("<I", len(rows)) + b"".join(encode_row(types, row) for row in rows)
    chunk = b"ROWS" + len(payload).to_bytes(4, "big") + payload
    rebuilt = bytearray(data[:rows_at] + chunk + data[rows_end:])
    rebuilt[4:8] = (len(rebuilt) - 8).to_bytes(4, "big")
    rebuilt[0x10:0x14] = (len(rebuilt) - 0x14).to_bytes(4, "big")
    return bytes(rebuilt)


def set_toughness(modstring, value):
    tokens = [t for t in modstring.split(",") if t]
    out = []
    placed = False
    for token in tokens:
        if token.split("=", 1)[0] == MOD:
            if value is None:
                continue
            out.append("%s=%d" % (MOD, value))
            placed = True
        else:
            out.append(token)
    if value is not None and not placed:
        out.append("%s=%d" % (MOD, value))
    return ",".join(out)


def parse_value(modstring):
    for token in modstring.split(","):
        if token.split("=", 1)[0] == MOD:
            return int(token.split("=", 1)[1])
    return 0


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("path", type=Path)
    args = parser.parse_args()
    path = args.path

    data = path.read_bytes()
    columns, types, rows, rows_at, rows_start, rows_end = parse(data)

    if rebuild(data, types, rows, rows_at, rows_start, rows_end) != data:
        raise ValueError("%s: round trip changed the file, refusing to patch" % path)

    name_col = columns.index("NAME")
    mods_col = columns.index("SKILL_MODS")

    seen = {}
    total = 0
    for row in rows:
        name = row[name_col]
        old = parse_value(row[mods_col])
        if name in TARGETS:
            row[mods_col] = set_toughness(row[mods_col], TARGETS[name])
            seen[name] = TARGETS[name]
            total += TARGETS[name]
        elif old:
            row[mods_col] = set_toughness(row[mods_col], None)
            print("  cleared %-46s -%d" % (name, old))

    missing = sorted(set(TARGETS) - set(seen))
    if missing:
        raise ValueError("rows missing from %s: %s" % (path, missing))
    if total != EXPECTED_TOTAL:
        raise ValueError("target total %d != expected %d" % (total, EXPECTED_TOTAL))

    rebuilt = rebuild(data, types, rows, rows_at, rows_start, rows_end)
    path.write_bytes(rebuilt)
    print("patched %s: %d bytes" % (path, len(rebuilt)))
    print("  lightsaber tree lightsaber_toughness total: %d" % total)

    # verify from the written file
    columns, types, rows, _, _, _ = parse(path.read_bytes())
    name_col = columns.index("NAME")
    mods_col = columns.index("SKILL_MODS")
    verify_total = 0
    for row in rows:
        value = parse_value(row[mods_col])
        if value:
            verify_total += value
            print("  %-46s %d" % (row[name_col], value))
    if verify_total != EXPECTED_TOTAL:
        raise ValueError("verify total %d != %d" % (verify_total, EXPECTED_TOTAL))


if __name__ == "__main__":
    main()
