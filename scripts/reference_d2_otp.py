#!/usr/bin/env python3
"""Implementação de referência do protocolo D2 SI/OTP reconstruído do ABL.

Use somente dados sintéticos ou identificadores cuja análise foi autorizada.
Por padrão, o programa exibe uma demonstração de laboratório sintética.
"""

from __future__ import annotations

import argparse
import base64
import hashlib
import hmac
from dataclasses import dataclass
from pathlib import Path


PROTOCOL = "D2"
PROTOCOL_VERSION = "01"
PID = "10004"
PUBLIC_HEADER_SIZE = 0x1D
RSA_CIPHERTEXT_SIZE = 0x200
ENVELOPE_SIZE = PUBLIC_HEADER_SIZE + RSA_CIPHERTEXT_SIZE


@dataclass(frozen=True)
class DeviceFields:
    model: str
    sw_version: str
    did: str
    un: str
    serial: str
    imei: str
    pid: str = PID


def build_body(fields: DeviceFields, nonce: bytes) -> bytes:
    if len(nonce) != 32:
        raise ValueError("o nonce deve ter exatamente 32 bytes")
    if not any(nonce):
        raise ValueError("o firmware rejeita nonce inteiramente zerado")

    nonce_b64 = base64.b64encode(nonce).decode("ascii")
    parts = (
        fields.pid,
        fields.model,
        fields.sw_version,
        fields.did,
        fields.un,
        fields.serial,
        fields.imei,
        nonce_b64,
    )
    if any(":" in value for value in parts):
        raise ValueError("um campo contém o separador de campos")
    body = ":".join(parts).encode("ascii")
    if len(body) > 0x100:
        raise ValueError("BODY excede o limite de 0x100 bytes do firmware")
    return body


def build_si(fields: DeviceFields, nonce: bytes) -> bytes:
    body = build_body(fields, nonce)
    header = (
        f"{PROTOCOL}{PROTOCOL_VERSION}{fields.pid}{fields.sw_version}"
        f"{PROTOCOL}:{len(body)}:"
    ).encode("ascii")
    if len(header) != PUBLIC_HEADER_SIZE:
        raise ValueError(
            f"header tem {len(header)} bytes; firmware espera {PUBLIC_HEADER_SIZE}. "
            "Verifique PID, SW_VERSION e comprimento de três algarismos."
        )
    return header + body


def calculate_otp(si: bytes, nonce: bytes) -> tuple[str, bytes, int, int]:
    if len(nonce) != 32:
        raise ValueError("a chave HMAC deve ser o nonce binário de 32 bytes")
    digest = hmac.new(nonce, si, hashlib.sha256).digest()
    offset = digest[-1] & 0x0F
    binary = int.from_bytes(digest[offset : offset + 4], "big") & 0x7FFFFFFF
    otp = f"{binary % 100_000_000:08d}"
    return otp, digest, offset, binary


def build_envelope(si: bytes, public_key_der: Path) -> bytes:
    if len(si) <= PUBLIC_HEADER_SIZE:
        raise ValueError("SI não contém BODY")
    try:
        from cryptography.hazmat.primitives import hashes, serialization
        from cryptography.hazmat.primitives.asymmetric import padding
    except ImportError as exc:
        raise RuntimeError("instale 'cryptography' para executar RSA-OAEP") from exc

    public_key = serialization.load_der_public_key(public_key_der.read_bytes())
    ciphertext = public_key.encrypt(
        si[PUBLIC_HEADER_SIZE:],
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA1()),
            algorithm=hashes.SHA1(),
            label=None,
        ),
    )
    if len(ciphertext) != RSA_CIPHERTEXT_SIZE:
        raise ValueError("a chave fornecida não produziu ciphertext RSA-4096")
    envelope = si[:PUBLIC_HEADER_SIZE] + ciphertext
    if len(envelope) != ENVELOPE_SIZE:
        raise AssertionError("tamanho interno inesperado")
    return envelope


def parse_public_header(envelope: bytes) -> dict[str, str | int]:
    if len(envelope) != ENVELOPE_SIZE:
        raise ValueError(f"envelope deve ter {ENVELOPE_SIZE} bytes")
    header = envelope[:PUBLIC_HEADER_SIZE].decode("ascii")
    if not header.startswith("D20110004"):
        raise ValueError("assinatura D2/versão/PID inesperada")
    marker = header.rfind("D2:")
    if marker < 0 or not header.endswith(":"):
        raise ValueError("marcador/comprimento D2 ausente")
    return {
        "raw": header,
        "protocol": header[0:2],
        "version": header[2:4],
        "pid": header[4:9],
        "sw_version": header[9:marker],
        "body_length": int(header[marker + 3 : -1]),
    }


def synthetic_demo(make_envelope: bool, public_key: Path) -> None:
    fields = DeviceFields(
        model="D2-LAB",
        sw_version="LAB0000000001",
        did="LAB_DEVICE_000000001",
        un="LAB_UN",
        serial="LAB_SERIAL",
        imei="000000000000000",
    )
    nonce = bytes(range(1, 33))
    si = build_si(fields, nonce)
    otp, digest, offset, binary = calculate_otp(si, nonce)

    print(f"BODY length: {len(si) - PUBLIC_HEADER_SIZE}")
    print(f"Public header ({PUBLIC_HEADER_SIZE} bytes): {si[:PUBLIC_HEADER_SIZE]!r}")
    print(f"SI ({len(si)} bytes): {si.decode('ascii')}")
    print(f"Nonce hex: {nonce.hex()}")
    print(f"Nonce Base64: {base64.b64encode(nonce).decode('ascii')}")
    print(f"HMAC-SHA-256: {digest.hex()}")
    print(f"Dynamic offset: {offset}")
    print(f"31-bit value: {binary}")
    print(f"OTP: {otp}")

    if make_envelope:
        envelope = build_envelope(si, public_key)
        qr_text = base64.b64encode(envelope).decode("ascii")
        print(f"Envelope length: {len(envelope)}")
        print(f"QR text length: {len(qr_text)}")
        print(f"Parsed header: {parse_public_header(envelope)}")
        print(f"QR text: {qr_text}")


def main() -> None:
    default_key = (
        Path(__file__).resolve().parents[1]
        / "keys/lab-public.der"
    )
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--make-envelope",
        action="store_true",
        help="também cifra o BODY e imprime o texto que seria enviado ao QR",
    )
    parser.add_argument(
        "--public-key",
        type=Path,
        default=default_key,
        help="chave pública SPKI DER extraída do ABL",
    )
    args = parser.parse_args()
    synthetic_demo(args.make_envelope, args.public_key)


if __name__ == "__main__":
    main()
