#!/usr/bin/env python3
"""Report file identity and preliminary ELF or PE metadata without modifying it."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


def inspect(path: Path) -> dict:
    digest = hashlib.sha256()
    size = 0
    with path.open('rb') as stream:
        prefix = stream.read(64)
        stream.seek(0)
        while chunk := stream.read(1024 * 1024):
            digest.update(chunk)
            size += len(chunk)
        result = {'file': str(path), 'bytes': size, 'sha256': digest.hexdigest(),
                  'format': 'unrecognized or outer container'}
        if prefix.startswith(b'\x7fELF'):
            result['format'] = 'ELF signature'
            if len(prefix) >= 20:
                result['elf_class'] = {1: '32 bit', 2: '64 bit'}.get(prefix[4], 'unknown')
                byteorder = {1: 'little', 2: 'big'}.get(prefix[5])
                result['elf_byte_order'] = byteorder or 'unknown'
                if byteorder:
                    result['elf_machine'] = int.from_bytes(prefix[18:20], byteorder)
        elif prefix.startswith(b'MZ') and len(prefix) >= 64:
            pe_offset = int.from_bytes(prefix[60:64], 'little')
            if pe_offset <= size - 24:
                stream.seek(pe_offset)
                coff = stream.read(24)
                if coff[:4] == b'PE\x00\x00':
                    result['format'] = 'PE/COFF signature'
                    result['pe_header_offset'] = pe_offset
                    result['pe_machine'] = int.from_bytes(coff[4:6], 'little')
                    result['pe_sections'] = int.from_bytes(coff[6:8], 'little')
        result['structural_validation'] = 'signature inspection only'
        return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('file', type=Path)
    args = parser.parse_args()
    try:
        result = inspect(args.file)
    except OSError as exc:
        parser.exit(2, f'Error: {exc}\n')
    print(json.dumps(result, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
