#!/usr/bin/env python3
"""Inspect a textual D2 QR envelope without decrypting its protected body."""
from __future__ import annotations

import argparse
import base64
import binascii
import hashlib
import json
from pathlib import Path
import sys

HEADER_BYTES = 29
CIPHERTEXT_BYTES = 512
ENVELOPE_BYTES = HEADER_BYTES + CIPHERTEXT_BYTES
BASE64_CHARACTERS = 724
MAX_INPUT_BYTES = 65536


def inspect(text: str) -> dict:
    compact = ''.join(text.split())
    if len(compact) != BASE64_CHARACTERS:
        raise ValueError(f'Expected {BASE64_CHARACTERS} Base64 characters; got {len(compact)}')
    try:
        envelope = base64.b64decode(compact, validate=True)
    except (binascii.Error, ValueError) as exc:
        raise ValueError('Input is not ASCII Base64') from exc
    if base64.b64encode(envelope).decode('ascii') != compact:
        raise ValueError('Base64 is not canonical')
    if len(envelope) != ENVELOPE_BYTES:
        raise ValueError(f'Expected {ENVELOPE_BYTES} envelope bytes; got {len(envelope)}')
    header = envelope[:HEADER_BYTES]
    if header[:4] != b'D201':
        raise ValueError('Expected D2 marker and protocol version 01')
    ciphertext = envelope[HEADER_BYTES:]
    return {
        'layout_matches_zzi8_envelope': True,
        'base64_characters': len(compact),
        'envelope_bytes': len(envelope),
        'public_header_bytes': len(header),
        'public_header_hex': header.hex(),
        'public_header_text': header.decode('ascii', errors='backslashreplace'),
        'protected_body_bytes': len(ciphertext),
        'protected_body_sha256': hashlib.sha256(ciphertext).hexdigest(),
        'envelope_sha256': hashlib.sha256(envelope).hexdigest(),
        'cryptographic_validity': 'not evaluated',
        'header_field_widths': 'not inferred',
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input', nargs='?', type=Path, help='Text file; omit to read standard input')
    args = parser.parse_args()
    try:
        if args.input is None:
            raw = sys.stdin.buffer.read(MAX_INPUT_BYTES + 1)
        else:
            with args.input.open('rb') as stream:
                raw = stream.read(MAX_INPUT_BYTES + 1)
        if len(raw) > MAX_INPUT_BYTES:
            raise ValueError('Input exceeds 64 KiB')
        result = inspect(raw.decode('ascii'))
    except (OSError, ValueError) as exc:
        parser.exit(2, f'Error: {exc}\n')
    print(json.dumps(result, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
