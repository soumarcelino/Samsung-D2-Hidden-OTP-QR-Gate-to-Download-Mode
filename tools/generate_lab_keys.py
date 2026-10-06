#!/usr/bin/env python3
"""Generate an RSA4096 key pair for isolated D2 protocol demonstrations."""
from __future__ import annotations

import argparse
import os
from pathlib import Path
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-dir', type=Path, default=Path('keys'))
    args = parser.parse_args()
    private_path = args.output_dir / 'lab-private.pem'
    public_path = args.output_dir / 'lab-public.der'
    created_private = False
    created_public = False
    try:
        args.output_dir.mkdir(parents=True, exist_ok=True)
        if private_path.exists() or public_path.exists():
            raise ValueError('A lab key file already exists; choose another output directory')
        key = rsa.generate_private_key(public_exponent=65537, key_size=4096)
        private_bytes = key.private_bytes(serialization.Encoding.PEM,
            serialization.PrivateFormat.PKCS8, serialization.NoEncryption())
        public_bytes = key.public_key().public_bytes(serialization.Encoding.DER,
            serialization.PublicFormat.SubjectPublicKeyInfo)
        fd = os.open(private_path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
        created_private = True
        with os.fdopen(fd, 'wb') as stream:
            stream.write(private_bytes)
        with public_path.open('xb') as stream:
            created_public = True
            stream.write(public_bytes)
    except (OSError, ValueError) as exc:
        if created_private:
            private_path.unlink(missing_ok=True)
        if created_public:
            public_path.unlink(missing_ok=True)
        parser.exit(2, f'Error: {exc}\n')
    print(f'Private lab key: {private_path}')
    print(f'Public lab key: {public_path}')
    print('These keys belong to this laboratory; they do not match a device key.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
