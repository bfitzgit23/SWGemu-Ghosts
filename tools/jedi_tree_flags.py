#!/usr/bin/env python3
"""Put the five Pre-CU Force Discipline trees in the skill window, keep the
Grand Master and Dark Lord apex trees, and take the old padawan / light side /
dark side ladder out.

The discipline trees ship in skills.iff marked IS_HIDDEN=1 / SEARCHABLE=0, so
the client never lists them beside the normal professions, while the legacy
jedi_* ladder is visible.  This tool unhides the discipline trees and the apex
trees and hides the padawan / light side / dark side ladder.  No skill row is
added or removed, so characters that already own legacy skills keep them.
"""

from pathlib import Path
import argparse
import struct

DISCIPLINE_ROOT = "force_discipline"
DISCIPLINE_TREES = (
    "force_discipline_light_saber",
    "force_discipline_powers",
    "force_discipline_healing",
    "force_discipline_enhancements",
    "force_discipline_defender",
)
# The padawan / light side / dark side ladder the discipline trees replace.
LEGACY_PREFIXES = ("jedi_padawan", "jedi_light_side_", "jedi_dark_side_")
# The Grand Master and Dark Lord trees stay in the window.
APEX_ROOTS = ("jedi_grand_master", "jedi_dark_lord")


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


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("paths", nargs="+", type=Path)
    args = parser.parse_args()

    for path in args.paths:
        data = path.read_bytes()
        columns, types, rows, rows_at, rows_start, rows_end = parse(data)

        if rebuild(data, types, rows, rows_at, rows_start, rows_end) != data:
            raise ValueError(f"{path}: round trip changed the file, refusing to patch")

        name_col = columns.index("NAME")
        hidden_col = columns.index("IS_HIDDEN")
        search_col = columns.index("SEARCHABLE")

        shown, hidden, apex = [], [], []
        seen_trees = set()

        for row in rows:
            name = row[name_col]

            if name == DISCIPLINE_ROOT or name.startswith(DISCIPLINE_ROOT + "_"):
                row[hidden_col] = 0
                if name in DISCIPLINE_TREES:
                    row[search_col] = 1
                    seen_trees.add(name)
                shown.append(name)
            elif name.startswith(LEGACY_PREFIXES):
                row[hidden_col] = 1
                row[search_col] = 0
                hidden.append(name)
            elif name.startswith(APEX_ROOTS):
                row[hidden_col] = 0
                if name in APEX_ROOTS:
                    row[search_col] = 1
                apex.append(name)

        missing = set(DISCIPLINE_TREES) - seen_trees
        if missing:
            raise ValueError(f"{path}: discipline tree(s) missing from skills.iff: {sorted(missing)}")
        if not hidden:
            raise ValueError(f"{path}: no legacy jedi ladder rows found")
        missing_apex = [root for root in APEX_ROOTS if root not in apex]
        if missing_apex:
            raise ValueError(f"{path}: apex tree(s) missing from skills.iff: {missing_apex}")

        rebuilt = rebuild(data, types, rows, rows_at, rows_start, rows_end)
        path.write_bytes(rebuilt)
        print(f"patched {path}: {len(rebuilt)} bytes")
        print(f"  discipline rows visible: {len(shown)} (trees: {len(seen_trees)})")
        print(f"  apex rows visible: {len(apex)} (roots: {sorted(set(apex) & set(APEX_ROOTS))})")
        print(f"  padawan/light/dark ladder rows hidden: {len(hidden)}")


if __name__ == "__main__":
    main()
