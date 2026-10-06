#!/usr/bin/env python3
"""Render a D2 envelope as a version 30, HIGH error correction PNG."""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import qrcode
from inspect_qr import inspect


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument('--qr-file', type=Path, help='Textual envelope')
    source.add_argument('--simulation', type=Path, help='Simulator JSON containing qr_content')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--scale', type=int, default=5, help='Pixels per module, from 1 through 32')
    args = parser.parse_args()
    try:
        if not 1 <= args.scale <= 32:
            raise ValueError('Scale must be from 1 through 32')
        if args.simulation:
            payload = json.loads(args.simulation.read_text())
            text = payload['qr_content']
        else:
            text = args.qr_file.read_text(encoding='ascii')
        if not isinstance(text, str):
            raise ValueError('qr_content must be a string')
        text = ''.join(text.split())
        inspect(text)
        qr = qrcode.QRCode(version=30, error_correction=qrcode.constants.ERROR_CORRECT_H,
                           box_size=args.scale, border=4)
        qr.add_data(text, optimize=0)
        qr.make(fit=False)
        args.output.parent.mkdir(parents=True, exist_ok=True)
        with args.output.open('xb') as stream:
            qr.make_image(fill_color='black', back_color='white').save(stream, format='PNG')
    except (OSError, ValueError, KeyError, TypeError, qrcode.exceptions.DataOverflowError) as exc:
        parser.exit(2, f'Error: {exc}\n')
    print(f'QR image: {args.output}')
    print(f'Module matrix: 137 x 137; quiet zone: 4 modules; scale: {args.scale}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
