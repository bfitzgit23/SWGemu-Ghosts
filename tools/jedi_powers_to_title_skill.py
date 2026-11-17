#!/usr/bin/env python3
"""Grant Electric Judgment and Battle Meditation to every Jedi through the
force_title_jedi_rank_02 title skill (dark and light alike), instead of only
through the Force Lightning discipline branch."""

from pathlib import Path
import argparse
import struct

ELECTRIC = [
    "electricJudgmentSingle1",
    "electricJudgmentCone1",
    "electricJudgmentSingle2",
    "electricJudgmentCone2",
]
BATTLE = "battleMeditation"
TARGET_SKILL = "force_title_jedi_rank_02"


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
        command_col = columns.index("COMMANDS")
        changed = []

        for row in rows:
            name = row[name_col]
            if name.startswith("force_discipline_powers_lightning_"):
                commands = [c for c in row[command_col].split(",") if c and c not in ELECTRIC and c != BATTLE]
                new_commands = ",".join(commands)
                if new_commands != row[command_col]:
                    row[command_col] = new_commands
                    changed.append(name)
            elif name == TARGET_SKILL:
                commands = [c for c in row[command_col].split(",") if c]
                for command in ELECTRIC + [BATTLE]:
                    if command not in commands:
                        commands.append(command)
                row[command_col] = ",".join(commands)
                changed.append(name)

        if TARGET_SKILL not in changed:
            raise ValueError(f"{path}: {TARGET_SKILL} row not found")

        rebuilt = rebuild(data, types, rows, rows_at, rows_start, rows_end)
        path.write_bytes(rebuilt)
        print(f"patched {path}: {len(rebuilt)} bytes, changed {changed}")


if __name__ == "__main__":
    main()
