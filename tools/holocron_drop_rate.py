#!/usr/bin/env python3
"""Set the holocron drop rate across every loot group that can roll one.

The Jedi/Sith holocrons are reached through the "holocron_dark" and
"holocron_light" group templates, which NPC tier groups list next to junk,
weapons and resources.  A group picks one entry in proportion to its weight, so
the rate is weight / sum(weights) and differs per group; this tool rewrites
those two weights in every group so each holocron lands on the requested
percentage of that group's rolls, leaving every other entry untouched.

Usage:
  holocron_drop_rate.py --percent 0.2 [--dry-run] [--root <scripts dir>]

The percentages are per holocron, so 0.2 means 0.2% dark and 0.2% light (0.4%
for either).  Group blocks that contain nothing but holocrons are left alone.
"""

import argparse
import os
import re
import sys

HOLOCRONS = ("holocron_dark", "holocron_light")

ENTRY = re.compile(r'\{ ?(\w+) = "([^"]+)", weight = (\d+) ?\}')
BLOCK = re.compile(r"(lootItems\s*=\s*\{)(.*?)(\n\t\})", re.S)


def wanted_weight(other_total, percent):
    """Weight giving `percent` chance to one entry beside `other_total`."""
    share = percent / 100.0
    return int(round(share * other_total / (1.0 - 2.0 * share)))


def patch_file(path, percent, dry_run):
    with open(path, "r", encoding="latin1", newline="") as handle:
        text = handle.read()

    newline = "\r\n" if "\r\n" in text else "\n"
    changed = 0
    report = []

    def fix(match):
        nonlocal changed
        head, body, tail = match.group(1), match.group(2), match.group(3)

        entries = ENTRY.findall(body)
        names = [name for kind, name, _ in entries if kind == "groupTemplate"]

        if not any(name in HOLOCRONS for name in names):
            return match.group(0)

        holocron_weights = [int(weight) for kind, name, weight in entries if name in HOLOCRONS]
        others = sum(int(weight) for kind, name, weight in entries if name not in HOLOCRONS)

        if others <= 0:
            report.append("  skipped (holocron-only block)")
            return match.group(0)

        target = wanted_weight(others, percent)

        def swap(entry):
            nonlocal changed
            kind, name, weight = entry.groups()
            if name not in HOLOCRONS:
                return entry.group(0)
            changed += 1
            return entry.group(0).replace("weight = " + weight, "weight = %d" % target)

        new_body = ENTRY.sub(swap, body)
        old_share = [100.0 * w / (others + sum(holocron_weights)) for w in holocron_weights]
        new_share = [100.0 * target / (others + target * len(holocron_weights))]
        report.append("  %s -> %s (%.3f%% -> %.3f%%)" % (
            "/".join(str(w) for w in holocron_weights), target,
            max(old_share), new_share[0]))
        return head + new_body + tail

    updated = BLOCK.sub(fix, text.replace("\r\n", "\n"))
    if newline == "\r\n":
        updated = updated.replace("\n", "\r\n")

    if changed and not dry_run:
        with open(path, "w", encoding="latin1", newline="") as handle:
            handle.write(updated)

    return changed, report


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--percent", type=float, required=True)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--root", default="bin/scripts/loot")
    args = parser.parse_args()

    if not 0 < args.percent < 50:
        sys.exit("percent must be between 0 and 50")

    real_root = args.root
    if not os.path.isdir(real_root):
        here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        real_root = os.path.join(here, args.root)
    if not os.path.isdir(real_root):
        sys.exit("loot scripts not found at " + real_root)

    files = 0
    entries = 0
    for base, _, names in os.walk(real_root):
        for name in sorted(names):
            if not name.endswith(".lua") or ".bak" in name:
                continue
            path = os.path.join(base, name)
            changed, report = patch_file(path, args.percent, args.dry_run)
            if changed:
                files += 1
                entries += changed
                print("%s" % os.path.relpath(path, real_root))
                for line in report:
                    print(line)

    print("%s %d holocron weights across %d files to %.3f%% each"
          % ("would set" if args.dry_run else "set", entries, files, args.percent))


if __name__ == "__main__":
    main()
