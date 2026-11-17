#!/usr/bin/env python3
"""Add Force Intimidate 1 to the novice Force Defender discipline."""

from pathlib import Path
import argparse
import struct

SKILL = "force_discipline_defender_novice"
COMMAND = "forceIntimidate1"


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

    return columns, types, rows, rows_at


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


def rebuild(data, types, rows, rows_at):
    def chunk_end(tag):
        offset = data.index(tag)
        size = int.from_bytes(data[offset + 4:offset + 8], "big")
        return offset, offset + 8 + size

    rows_at, rows_end = chunk_end(b"ROWS")
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
        columns, types, rows, rows_at = parse(data)

        if rebuild(data, types, rows, rows_at) != data:
            raise ValueError(f"{path}: round trip changed the file, refusing to patch")

        name_col = columns.index("NAME")
        command_col = columns.index("COMMANDS")
        patched = False

        for row in rows:
            if row[name_col] != SKILL:
                continue

            commands = [c for c in row[command_col].split(",") if c]
            if COMMAND in commands:
                print(f"{path}: {SKILL} already has {COMMAND}")
                patched = True
                break

            commands.append(COMMAND)
            row[command_col] = ",".join(commands)
            patched = True
            break

        if not patched:
            raise ValueError(f"{path}: {SKILL} row not found")

        path.write_bytes(rebuild(data, types, rows, rows_at))
        print(f"patched {path}: {SKILL} -> {COMMAND}")


if __name__ == "__main__":
    main()
