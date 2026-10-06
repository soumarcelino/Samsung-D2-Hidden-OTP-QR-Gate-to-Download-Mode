#!/usr/bin/env python3
"""Decodifica o conteúdo textual de um QR D2 e calcula o OTP correspondente.

Fluxo implementado:

    qr_content (Base64, 724 chars)
        -> envelope binário (541 bytes)
        -> header público (29 bytes) + ciphertext RSA (512 bytes)
        -> RSA-4096 OAEP SHA-1/MGF1-SHA-1 com a CHAVE PRIVADA
        -> BODY = PID:model:SW:DID:UN:SN:IMEI:Base64(nonce)
        -> SI = header || BODY
        -> HMAC-SHA-256(key=nonce binário, message=SI)
        -> truncamento dinâmico
        -> OTP decimal de oito dígitos

Importante: a chave pública extraída do ABL não decifra um QR real. É necessária
a chave privada correspondente. O programa nunca imprime ou grava a chave.
"""

from __future__ import annotations

import argparse
import base64
import binascii
import getpass
import hashlib
import hmac
import json
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any

try:
    from cryptography.exceptions import InvalidKey
    from cryptography.hazmat.primitives import hashes, serialization
    from cryptography.hazmat.primitives.asymmetric import padding, rsa
except ImportError as exc:
    raise SystemExit(
        "Dependência ausente: cryptography. Ative o toolenv do projeto ou "
        "execute: python -m pip install cryptography"
    ) from exc


# Constantes observadas no LinuxLoader.efi.
PUBLIC_HEADER_SIZE = 0x1D
RSA_CIPHERTEXT_SIZE = 0x200
ENVELOPE_SIZE = 0x21D
QR_CONTENT_SIZE = 724
NONCE_SIZE = 0x20
EXPECTED_PREFIX = b"D201"
EXPECTED_PID = "10004"
EXPECTED_MODEL = "SM-S918B"


@dataclass(frozen=True)
class PublicHeader:
    raw: str
    protocol: str
    protocol_version: str
    pid: str
    sw_version: str
    marker: str
    declared_body_length: int


@dataclass(frozen=True)
class BodyFields:
    pid: str
    model: str
    sw_version: str
    did: str
    un: str
    serial: str
    imei: str
    nonce_base64: str


@dataclass(frozen=True)
class DecodeResult:
    qr_content_length: int
    envelope_length: int
    envelope_sha256: str
    public_header: PublicHeader
    ciphertext_length: int
    ciphertext_sha256: str
    body: str
    body_length: int
    body_fields: BodyFields
    nonce_hex: str
    nonce_length: int
    si: str
    si_length: int
    hmac_sha256_hex: str
    dynamic_offset: int
    selected_digest_bytes_hex: str
    truncated_31bit_value: int
    otp_modulus: int
    otp: str


def read_qr_content(args: argparse.Namespace) -> str:
    """Lê o texto diretamente, de arquivo, ou de stdin."""

    if args.qr_text is not None:
        text = args.qr_text
    elif args.qr_file is not None:
        text = args.qr_file.read_text(encoding="ascii")
    else:
        text = sys.stdin.read()

    # Aceita newline final de arquivo/clipboard, mas não altera o conteúdo
    # Base64 interno.
    text = text.strip()
    if not text:
        raise ValueError("conteúdo do QR está vazio")
    try:
        text.encode("ascii")
    except UnicodeEncodeError as exc:
        raise ValueError("conteúdo do QR deve ser ASCII/Base64") from exc
    return text


def decode_envelope(qr_content: str) -> bytes:
    """Converte os 724 caracteres Base64 no envelope de 541 bytes."""

    if len(qr_content) != QR_CONTENT_SIZE:
        raise ValueError(
            f"conteúdo QR tem {len(qr_content)} caracteres; esperado: "
            f"{QR_CONTENT_SIZE}"
        )
    try:
        envelope = base64.b64decode(qr_content, validate=True)
    except (binascii.Error, ValueError) as exc:
        raise ValueError("conteúdo QR não é Base64 canônico válido") from exc
    if len(envelope) != ENVELOPE_SIZE:
        raise ValueError(
            f"envelope tem {len(envelope)} bytes; esperado: {ENVELOPE_SIZE}"
        )
    return envelope


def parse_public_header(header_bytes: bytes) -> PublicHeader:
    """Interpreta D2|01|PID|SW|D2:|NNN: nos primeiros 29 bytes."""

    if len(header_bytes) != PUBLIC_HEADER_SIZE:
        raise ValueError("header público deve ter exatamente 29 bytes")
    try:
        raw = header_bytes.decode("ascii")
    except UnicodeDecodeError as exc:
        raise ValueError("header público não é ASCII") from exc

    if not header_bytes.startswith(EXPECTED_PREFIX):
        raise ValueError("header não começa com a assinatura D2/01")

    protocol = raw[0:2]
    protocol_version = raw[2:4]
    pid = raw[4:9]

    # A build analisada possui SW de 13 bytes, seguido de D2: no offset 22.
    marker_offset = raw.find("D2:", 9)
    if marker_offset != 22:
        raise ValueError(
            f"marcador D2: encontrado no offset {marker_offset}; esperado: 22"
        )
    sw_version = raw[9:marker_offset]
    length_text = raw[marker_offset + 3 : -1]
    if not raw.endswith(":") or len(length_text) != 3 or not length_text.isdigit():
        raise ValueError("comprimento BODY no header não possui formato NNN:")

    return PublicHeader(
        raw=raw,
        protocol=protocol,
        protocol_version=protocol_version,
        pid=pid,
        sw_version=sw_version,
        marker="D2:",
        declared_body_length=int(length_text),
    )


def read_private_key_password(args: argparse.Namespace) -> bytes | None:
    if args.password_file is not None:
        # Remove apenas a quebra final comum de arquivos de segredo.
        return args.password_file.read_bytes().rstrip(b"\r\n")
    if args.ask_password:
        return getpass.getpass("Senha da chave privada: ").encode("utf-8")
    return None


def load_private_key(path: Path, password: bytes | None) -> rsa.RSAPrivateKey:
    """Carrega PKCS#8/PKCS#1 em PEM ou DER e exige RSA-4096."""

    encoded = path.read_bytes()
    loaders = (
        serialization.load_pem_private_key,
        serialization.load_der_private_key,
    )
    last_error: Exception | None = None
    key: Any = None
    for loader in loaders:
        try:
            key = loader(encoded, password=password)
            break
        except (ValueError, TypeError, InvalidKey) as exc:
            last_error = exc
    if key is None:
        raise ValueError(
            "não foi possível abrir a chave privada como PEM ou DER; "
            "formato/senha incorretos"
        ) from last_error
    if not isinstance(key, rsa.RSAPrivateKey):
        raise ValueError("a chave privada não é RSA")
    if key.key_size != 4096:
        raise ValueError(f"esperada RSA-4096; encontrada RSA-{key.key_size}")
    return key


def decrypt_body(
    private_key: rsa.RSAPrivateKey,
    ciphertext: bytes,
) -> bytes:
    """Reverte RSA_public_encrypt(..., RSA_PKCS1_OAEP_PADDING)."""

    if len(ciphertext) != RSA_CIPHERTEXT_SIZE:
        raise ValueError("ciphertext deve ter exatamente 512 bytes")
    try:
        return private_key.decrypt(
            ciphertext,
            padding.OAEP(
                mgf=padding.MGF1(algorithm=hashes.SHA1()),
                algorithm=hashes.SHA1(),
                label=None,
            ),
        )
    except ValueError as exc:
        raise ValueError(
            "falha RSA-OAEP: chave privada não corresponde ao QR, ou o "
            "ciphertext foi alterado"
        ) from exc


def parse_body(body: bytes, header: PublicHeader) -> tuple[BodyFields, bytes]:
    """Valida os oito campos e recupera o nonce binário."""

    if len(body) != header.declared_body_length:
        raise ValueError(
            f"header declara BODY={header.declared_body_length}, mas RSA "
            f"produziu {len(body)} bytes"
        )
    try:
        body_text = body.decode("ascii")
    except UnicodeDecodeError as exc:
        raise ValueError("BODY decifrado não é ASCII") from exc

    parts = body_text.split(":")
    if len(parts) != 8:
        raise ValueError(f"BODY possui {len(parts)} campos; esperado: 8")
    fields = BodyFields(*parts)

    if fields.pid != header.pid:
        raise ValueError("PID do BODY não coincide com o PID do header")
    if fields.sw_version != header.sw_version:
        raise ValueError("SW_VERSION do BODY não coincide com o header")

    try:
        nonce = base64.b64decode(fields.nonce_base64, validate=True)
    except (binascii.Error, ValueError) as exc:
        raise ValueError("campo nonce não é Base64 válido") from exc
    if len(nonce) != NONCE_SIZE:
        raise ValueError(f"nonce decodificado tem {len(nonce)} bytes; esperado: 32")
    if not any(nonce):
        raise ValueError("nonce inteiramente zerado seria rejeitado pelo ABL")
    return fields, nonce


def calculate_otp(si: bytes, nonce: bytes) -> dict[str, Any]:
    """HMAC-SHA-256 + truncamento dinâmico + módulo 10^8 + %08d."""

    digest = hmac.new(nonce, si, hashlib.sha256).digest()
    offset = digest[31] & 0x0F
    selected = digest[offset : offset + 4]
    binary_31bit = int.from_bytes(selected, "big") & 0x7FFFFFFF
    modulus = 100_000_000
    otp = f"{binary_31bit % modulus:08d}"
    return {
        "digest": digest,
        "offset": offset,
        "selected": selected,
        "binary_31bit": binary_31bit,
        "modulus": modulus,
        "otp": otp,
    }


def decode_qr(
    qr_content: str,
    private_key: rsa.RSAPrivateKey,
) -> DecodeResult:
    envelope = decode_envelope(qr_content)
    header_bytes = envelope[:PUBLIC_HEADER_SIZE]
    ciphertext = envelope[PUBLIC_HEADER_SIZE:]

    header = parse_public_header(header_bytes)
    body = decrypt_body(private_key, ciphertext)
    fields, nonce = parse_body(body, header)

    # A mensagem autenticada no telefone é a SI original, não o envelope e nem
    # o texto Base64 do QR.
    si = header_bytes + body
    otp_data = calculate_otp(si, nonce)

    return DecodeResult(
        qr_content_length=len(qr_content),
        envelope_length=len(envelope),
        envelope_sha256=hashlib.sha256(envelope).hexdigest(),
        public_header=header,
        ciphertext_length=len(ciphertext),
        ciphertext_sha256=hashlib.sha256(ciphertext).hexdigest(),
        body=body.decode("ascii"),
        body_length=len(body),
        body_fields=fields,
        nonce_hex=nonce.hex(),
        nonce_length=len(nonce),
        si=si.decode("ascii"),
        si_length=len(si),
        hmac_sha256_hex=otp_data["digest"].hex(),
        dynamic_offset=otp_data["offset"],
        selected_digest_bytes_hex=otp_data["selected"].hex(),
        truncated_31bit_value=otp_data["binary_31bit"],
        otp_modulus=otp_data["modulus"],
        otp=otp_data["otp"],
    )


def print_human(result: DecodeResult, show_sensitive: bool) -> None:
    print("=" * 78)
    print("D2 QR DECODE — QR → RSA-OAEP → SI/NONCE → OTP")
    print("=" * 78)

    print("\n[1] QR E ENVELOPE")
    print(f"  QR content     = {result.qr_content_length} caracteres")
    print(f"  envelope       = {result.envelope_length} bytes")
    print(f"  envelope SHA   = {result.envelope_sha256}")
    print(f"  ciphertext     = {result.ciphertext_length} bytes")
    print(f"  ciphertext SHA = {result.ciphertext_sha256}")

    print("\n[2] HEADER PÚBLICO")
    for name, value in asdict(result.public_header).items():
        print(f"  {name:20} = {value}")

    print("\n[3] BODY DECIFRADO E VALIDADO")
    print(f"  comprimento         = {result.body_length} bytes")
    if show_sensitive:
        for name, value in asdict(result.body_fields).items():
            print(f"  {name:19} = {value}")
        print(f"  nonce hexadecimal   = {result.nonce_hex}")
        print(f"  SI completa         = {result.si}")
    else:
        print("  campos sensíveis    = ocultos; use --show-sensitive para exibir")
        print(f"  modelo              = {result.body_fields.model}")
        print(f"  versão              = {result.body_fields.sw_version}")
        print(f"  nonce               = {result.nonce_length} bytes, validado")
        print(f"  SI length           = {result.si_length} bytes")

    print("\n[4] CÁLCULO DO OTP")
    print(f"  HMAC-SHA-256    = {result.hmac_sha256_hex}")
    print(f"  offset          = {result.dynamic_offset}")
    print(f"  quatro bytes    = {result.selected_digest_bytes_hex}")
    print(f"  valor 31-bit    = {result.truncated_31bit_value}")
    print(f"  módulo          = {result.otp_modulus}")
    print("  formato         = %08d")
    print(f"  OTP FINAL       = {result.otp}")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=__doc__,
        epilog=f"""
Exemplos:

  # Ler o texto QR de um arquivo:
  {Path(sys.argv[0]).name} --qr-file qr.txt --private-key private.pem

  # Ler o texto QR de stdin:
  printf '%s' "$QR_TEXT" | {Path(sys.argv[0]).name} --private-key private.pem

  # Chave privada cifrada, senha solicitada sem eco:
  {Path(sys.argv[0]).name} --qr-file qr.txt --private-key private.pem \\
      --ask-password --json
""",
    )
    qr_group = parser.add_mutually_exclusive_group()
    qr_group.add_argument("--qr-text", help="conteúdo Base64 copiado do QR")
    qr_group.add_argument("--qr-file", type=Path, help="arquivo com o conteúdo QR")
    parser.add_argument(
        "--private-key",
        type=Path,
        required=True,
        help="chave RSA-4096 privada correspondente, PEM ou DER",
    )
    password_group = parser.add_mutually_exclusive_group()
    password_group.add_argument(
        "--ask-password",
        action="store_true",
        help="solicita a senha da chave sem eco no terminal",
    )
    password_group.add_argument(
        "--password-file",
        type=Path,
        help="lê a senha da chave de um arquivo",
    )
    parser.add_argument("--json", action="store_true", help="saída JSON completa")
    parser.add_argument(
        "--show-sensitive",
        action="store_true",
        help="exibe DID, UN, serial, IMEI, nonce e SI",
    )
    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    try:
        qr_content = read_qr_content(args)
        password = read_private_key_password(args)
        private_key = load_private_key(args.private_key, password)
        result = decode_qr(qr_content, private_key)
    except (OSError, ValueError) as exc:
        parser.error(str(exc))

    if args.json:
        print(json.dumps(asdict(result), indent=2, ensure_ascii=False))
    else:
        print_human(result, args.show_sensitive)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
