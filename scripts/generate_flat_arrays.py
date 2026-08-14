#!/usr/bin/env python3
"""Regenerate Sources/ListFormatData/Lib.swift's flat UInt8 buffers + offset
tables from a source Swift file containing InlineArray<N, StaticString> literals.

Usage:
    python3 scripts/generate_flat_arrays.py <input.swift> <output.swift>
"""

import re
import sys


def extract_array(varname, text):
    pattern = r'private let %s: InlineArray<\d+, StaticString> = \[\n(.*?)\n\]' % varname
    m = re.search(pattern, text, re.S)
    if not m:
        raise ValueError(f"could not find array {varname!r} in input")
    items = []
    for line in m.group(1).split("\n"):
        line = line.strip()
        if not line:
            continue
        mm = re.match(r'^"(.*)",?$', line)
        if not mm:
            raise ValueError(f"unparsable literal line: {line!r}")
        items.append(mm.group(1))
    return items


def smallest_uint_type(max_value):
    for bits, name in ((8, "UInt8"), (16, "UInt16"), (32, "UInt32"), (64, "UInt64")):
        if max_value <= (1 << bits) - 1:
            return name
    raise ValueError(f"value {max_value} exceeds UInt64 range")


def gen_bytes_and_offsets(items, bytes_name, offsets_name):
    all_bytes = []
    offsets = [0]
    for s in items:
        b = s.encode("utf-8")
        all_bytes.extend(b)
        offsets.append(len(all_bytes))
    total = len(all_bytes)
    n = len(offsets)  # len(items) + 1 cumulative boundaries
    offset_type = smallest_uint_type(total)

    lines = []
    lines.append(f"private let {bytes_name}: InlineArray<{total}, UInt8> = [")
    for i in range(0, total, 20):
        chunk = all_bytes[i:i + 20]
        lines.append("    " + ", ".join(str(b) for b in chunk) + ",")
    lines.append("]")
    lines.append(f"private let {offsets_name}: InlineArray<{n}, {offset_type}> = [")
    for i in range(0, n, 10):
        chunk = offsets[i:i + 10]
        lines.append("    " + ", ".join(str(o) for o in chunk) + ",")
    lines.append("]")
    return "\n".join(lines)


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(1)

    input_path, output_path = sys.argv[1], sys.argv[2]
    with open(input_path, "r", encoding="utf-8") as f:
        text = f.read()

    patterns = extract_array("patterns", text)
    locales = extract_array("locales", text)

    pattern_block = gen_bytes_and_offsets(patterns, "patternBytes", "patternOffsets")
    locale_block = gen_bytes_and_offsets(locales, "localeBytes", "localeOffsets")

    output = f"""{pattern_block}
{locale_block}

@_lifetime(immortal)
package func searchPattern(_ index: Int) -> Span<UInt8> {{
    let start = Int(patternOffsets[index])
    let end = Int(patternOffsets[index + 1])
    let span = patternBytes.span.extracting(start..<end)
    return unsafe _overrideLifetime(span, copying: ())
}}

@_lifetime(immortal)
package func searchLocale(_ index: Int) -> Span<UInt8> {{
    let start = Int(localeOffsets[index])
    let end = Int(localeOffsets[index + 1])
    let span = localeBytes.span.extracting(start..<end)
    return unsafe _overrideLifetime(span, copying: ())
}}
"""

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(output)

    print(f"patterns: {len(patterns)} strings, {sum(len(s.encode('utf-8')) for s in patterns)} bytes")
    print(f"locales: {len(locales)} strings, {sum(len(s.encode('utf-8')) for s in locales)} bytes")


if __name__ == "__main__":
    main()
