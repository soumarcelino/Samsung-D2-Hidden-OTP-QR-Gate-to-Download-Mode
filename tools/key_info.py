#!/usr/bin/env python3
"""Report RSA public key metadata and a canonical SPKI fingerprint."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa

FIRMWARE_KEY_SHA256 = 'd66e3eda6f1b6e15172cc4e55958e710aa7708d75b66ba1e75ef293fae51f640'


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('key', type=Path, help='Public key in PEM or DER form')
    args = parser.parse_args()
    try:
        raw = args.key.read_bytes()
        loader = serialization.load_pem_public_key if raw.lstrip().startswith(b'-----BEGIN') else serialization.load_der_public_key
        key = loader(raw)
        if not isinstance(key, rsa.RSAPublicKey):
            raise ValueError('Expected an RSA public key')
        der = key.public_bytes(serialization.Encoding.DER, serialization.PublicFormat.SubjectPublicKeyInfo)
        fingerprint = hashlib.sha256(der).hexdigest()
        result = {'file': str(args.key), 'type': 'RSA public key', 'bits': key.key_size,
                  'exponent': key.public_numbers().e, 'spki_der_bytes': len(der),
                  'spki_der_sha256': fingerprint,
                  'matches_documented_zzi8_public_key': fingerprint == FIRMWARE_KEY_SHA256}
    except (OSError, ValueError) as exc:
        parser.exit(2, f'Error: {exc}\n')
    print(json.dumps(result, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
