#!/usr/bin/env python3
"""Extract and identify the documented ZZI8 public key from a LinuxLoader PE file."""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa

KEY_OFFSET = 0x1ad48c
KEY_BYTES = 0x226
EXPECTED_SHA256 = 'd66e3eda6f1b6e15172cc4e55958e710aa7708d75b66ba1e75ef293fae51f640'


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('linuxloader', type=Path, help='Extracted ZZI8 LinuxLoader.efi, not outer ABL')
    parser.add_argument('output', type=Path, help='New DER destination; existing files are not replaced')
    args = parser.parse_args()
    try:
        with args.linuxloader.open('rb') as stream:
            stream.seek(KEY_OFFSET)
            der = stream.read(KEY_BYTES)
        if len(der) != KEY_BYTES:
            raise ValueError('Input is too short for the documented ZZI8 key region')
        fingerprint = hashlib.sha256(der).hexdigest()
        if fingerprint != EXPECTED_SHA256:
            raise ValueError('Key fingerprint differs from the documented ZZI8 artifact')
        key = serialization.load_der_public_key(der)
        if not isinstance(key, rsa.RSAPublicKey) or key.key_size != 4096:
            raise ValueError('Expected an RSA4096 public key')
        args.output.parent.mkdir(parents=True, exist_ok=True)
        with args.output.open('xb') as stream:
            stream.write(der)
    except (OSError, ValueError) as exc:
        parser.exit(2, f'Error: {exc}\n')
    print(f'Public key: {args.output}')
    print(f'SPKI SHA256: {fingerprint}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
