#!/usr/bin/env python3
"""Add the admin-only bypasstimer command to a Core3 DTII command table."""

from pathlib import Path
import argparse
import struct


def read_cstring(data: bytes, offset: int):
    end = data.index(0, offset)
    return data[offset:end].decode("latin1"), end + 1


def chunk(data: bytes, tag: bytes, start: int = 0):
    offset = data.index(tag, start)
    size = int.from_bytes(data[offset + 4:offset + 8], "big")
    return offset, size, offset + 8, offset + 8 + size


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("destination", type=Path)
    args = parser.parse_args()

    data = args.source.read_bytes()
    cols_at, cols_size, cols_start, _ = chunk(data, b"COLS")
    type_at, type_size, type_start, _ = chunk(data, b"TYPE", cols_at + 8 + cols_size)
    rows_at, rows_size, rows_start, rows_end = chunk(data, b"ROWS", type_at + 8 + type_size)

    offset = cols_start
    column_count = struct.unpack_from("<I", data, offset)[0]
    offset += 4
    columns = []
    for _ in range(column_count):
        value, offset = read_cstring(data, offset)
        columns.append(value)

    offset = type_start
    types = []
    for _ in range(column_count):
        value, offset = read_cstring(data, offset)
        types.append(value[0])

    offset = rows_start
    row_count = struct.unpack_from("<I", data, offset)[0]
    offset += 4
    rows = []
    values = []
    for _ in range(row_count):
        row_begin = offset
        row_values = []
        for cell_type in types:
            if cell_type == "s":
                value, offset = read_cstring(data, offset)
            elif cell_type == "f":
                value = struct.unpack_from("<f", data, offset)[0]
                offset += 4
            else:
                value = struct.unpack_from("<I", data, offset)[0]
                offset += 4
            row_values.append(value)
        rows.append(data[row_begin:offset])
        values.append(row_values)

    if offset != rows_end:
        raise ValueError("ROWS chunk did not parse cleanly")
    if any(row[0].lower() == "bypasstimer" for row in values):
        raise ValueError("bypasstimer already exists in this table")

    source_index = next(i for i, row in enumerate(values) if row[0] == "recalcForce")
    new_values = list(values[source_index])
    new_values[columns.index("commandName")] = "bypasstimer"
    new_values[columns.index("godLevel")] = 15

    encoded = bytearray()
    for cell_type, value in zip(types, new_values):
        if cell_type == "s":
            encoded.extend(value.encode("latin1") + b"\0")
        elif cell_type == "f":
            encoded.extend(struct.pack("<f", value))
        else:
            encoded.extend(struct.pack("<I", value))

    new_rows_payload = struct.pack("<I", row_count + 1) + data[rows_start + 4:rows_end] + encoded
    new_rows = b"ROWS" + len(new_rows_payload).to_bytes(4, "big") + new_rows_payload
    rebuilt = data[:rows_at] + new_rows + data[rows_end:]

    # Both enclosing FORM lengths cover everything after their 8-byte headers.
    rebuilt = bytearray(rebuilt)
    rebuilt[4:8] = (len(rebuilt) - 8).to_bytes(4, "big")
    rebuilt[0x10:0x14] = (len(rebuilt) - 0x14).to_bytes(4, "big")

    args.destination.parent.mkdir(parents=True, exist_ok=True)
    args.destination.write_bytes(rebuilt)
    print(f"created {args.destination} ({row_count + 1} rows, bypasstimer godLevel=15)")


if __name__ == "__main__":
    main()
