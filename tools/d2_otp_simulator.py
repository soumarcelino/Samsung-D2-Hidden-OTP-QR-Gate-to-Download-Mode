#!/usr/bin/env python3
"""Simulador completo do protocolo D2 QR/OTP reconstruído do Samsung ABL.

O programa reproduz, na mesma ordem do bootloader:

  1. coleta/recebe os campos do aparelho;
  2. gera ou recebe um nonce binário de 32 bytes;
  3. converte o nonce para Base64;
  4. monta BODY e SI conforme o perfil de laboratório documentado;
  5. carrega a chave RSA-4096 pública (DER ou diretamente do LinuxLoader.efi);
  6. cifra BODY com RSA-OAEP SHA-1/MGF1-SHA-1;
  7. monta o envelope público de 541 bytes;
  8. gera o conteúdo Base64 de 724 caracteres usado pelo QR Code;
  9. calcula HMAC-SHA-256(nonce, SI);
 10. aplica truncamento dinâmico e gera o OTP decimal de oito dígitos.

O programa NÃO desenha a imagem do QR. ``qr_content`` é exatamente a string
que o firmware entrega ao encoder QR versão 30 / ECC HIGH.

Use apenas em aparelhos e dados cuja análise foi autorizada.
"""

from __future__ import annotations

import argparse
import base64
import hashlib
import hmac
import json
import secrets
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any

try:
    from cryptography.hazmat.primitives import hashes, serialization
    from cryptography.hazmat.primitives.asymmetric import padding, rsa
except ImportError as exc:  # mensagem melhor que um traceback de importação
    raise SystemExit(
        "Dependência ausente: cryptography. Ative o toolenv do projeto ou "
        "execute: python -m pip install cryptography"
    ) from exc


# ---------------------------------------------------------------------------
# Constantes confirmadas no LinuxLoader.efi
# ---------------------------------------------------------------------------

PROTOCOL = "D2"
PROTOCOL_VERSION = "01"
DEFAULT_PID = "10004"

NONCE_SIZE = 0x20                 # 32 bytes
PUBLIC_HEADER_SIZE = 0x1D         # 29 bytes
RSA_CIPHERTEXT_SIZE = 0x200       # 512 bytes = RSA-4096
ENVELOPE_SIZE = 0x21D             # 29 + 512 = 541 bytes
BODY_MAX_SIZE = 0x100             # limite observado no ABL

QR_VERSION = 30
QR_ECC = "HIGH"
QR_MODULES = 4 * QR_VERSION + 17  # 137 × 137 módulos
QR_PIXEL_SCALE = 5
QR_RENDERED_PIXELS = QR_MODULES * QR_PIXEL_SCALE  # 685 × 685

# Chave SPKI DER embutida no LinuxLoader analisado.
LINUXLOADER_PUBLIC_KEY_OFFSET = 0x1AD48C
LINUXLOADER_PUBLIC_KEY_SIZE = 0x226
EXPECTED_PUBLIC_KEY_SHA256 = (
    "d66e3eda6f1b6e15172cc4e55958e710"
    "aa7708d75b66ba1e75ef293fae51f640"
)

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_PUBLIC_KEY = PROJECT_ROOT / "keys/lab-public.der"
DEFAULT_LINUXLOADER = PROJECT_ROOT / "captures/LinuxLoader.efi"


@dataclass(frozen=True)
class DeviceParameters:
    """Campos que o firmware concatena, na ordem exata da SI."""

    model: str
    sw_version: str
    did: str
    un: str
    serial: str
    imei: str
    pid: str = DEFAULT_PID


@dataclass(frozen=True)
class SimulationResult:
    """Todos os resultados intermediários úteis para auditoria."""

    parameters: DeviceParameters
    nonce_hex: str
    nonce_base64: str
    body: str
    body_length: int
    public_header: str
    public_header_hex: str
    si: str
    si_length: int
    public_key_source: str
    public_key_sha256: str
    public_key_bits: int
    rsa_padding: str
    ciphertext_hex: str
    ciphertext_length: int
    envelope_hex: str
    envelope_length: int
    qr_content: str
    qr_content_length: int
    qr_version: int
    qr_ecc: str
    qr_modules: int
    qr_rendered_pixels: int
    hmac_sha256_hex: str
    dynamic_offset: int
    selected_digest_bytes_hex: str
    truncated_31bit_value: int
    otp_modulus: int
    otp: str


# ---------------------------------------------------------------------------
# Validação e montagem da SI
# ---------------------------------------------------------------------------

def ascii_bytes(label: str, value: str) -> bytes:
    """Codifica como ASCII, pois o firmware usa AsciiStr/AsciiSPrint."""

    try:
        return value.encode("ascii")
    except UnicodeEncodeError as exc:
        raise ValueError(f"{label} deve conter somente caracteres ASCII") from exc


def validate_nonce(nonce: bytes) -> None:
    if len(nonce) != NONCE_SIZE:
        raise ValueError(
            f"nonce deve ter {NONCE_SIZE} bytes; recebido: {len(nonce)}"
        )
    if not any(nonce):
        # A make_si original rejeita o resultado inteiramente zerado.
        raise ValueError("nonce de 32 bytes zerados é rejeitado pelo firmware")


def build_body(parameters: DeviceParameters, nonce: bytes) -> tuple[bytes, str]:
    """Monta PID:model:SW:DID:UN:SN:IMEI:Base64(nonce), sem ':' final."""

    validate_nonce(nonce)
    nonce_b64 = base64.b64encode(nonce).decode("ascii")

    fields = (
        parameters.pid,
        parameters.model,
        parameters.sw_version,
        parameters.did,
        parameters.un,
        parameters.serial,
        parameters.imei,
        nonce_b64,
    )
    for index, value in enumerate(fields):
        ascii_bytes(f"campo {index}", value)
        if ":" in value:
            raise ValueError(f"campo {index} contém o separador de campos")

    body = ":".join(fields).encode("ascii")
    if len(body) > BODY_MAX_SIZE:
        raise ValueError(
            f"BODY tem {len(body)} bytes e excede o limite de {BODY_MAX_SIZE}"
        )
    return body, nonce_b64


def build_si(parameters: DeviceParameters, nonce: bytes) -> tuple[bytes, bytes, str]:
    """Monta o cabeçalho de 29 bytes e anexa BODY sem terminador NUL."""

    body, nonce_b64 = build_body(parameters, nonce)

    # Equivalente às chamadas AsciiSPrint encontradas no ABL:
    #   "%a%a%a" → "D2", "01", PID
    #   cópia de SW_VERSION no offset 9
    #   "%a:"    → "D2:"
    #   "%u:"    → comprimento decimal do BODY + ':'
    header_text = (
        f"{PROTOCOL}{PROTOCOL_VERSION}{parameters.pid}"
        f"{parameters.sw_version}{PROTOCOL}:{len(body)}:"
    )
    header = ascii_bytes("cabeçalho", header_text)

    # O RSA começa invariavelmente em SI+0x1d. Se o header não der 29 bytes, os
    # dados não representariam o layout observado nessa build do firmware.
    if len(header) != PUBLIC_HEADER_SIZE:
        raise ValueError(
            f"cabeçalho resultou em {len(header)} bytes, mas o firmware espera "
            f"{PUBLIC_HEADER_SIZE}. SW_VERSION deve ter 13 caracteres e BODY "
            "deve possuir comprimento decimal de três algarismos."
        )

    return header + body, body, nonce_b64


# ---------------------------------------------------------------------------
# Chave pública e RSA-OAEP
# ---------------------------------------------------------------------------

def extract_public_key_from_linuxloader(path: Path) -> bytes:
    """Extrai os 0x226 bytes SPKI DER no offset confirmado do PE analisado."""

    image = path.read_bytes()
    end = LINUXLOADER_PUBLIC_KEY_OFFSET + LINUXLOADER_PUBLIC_KEY_SIZE
    if len(image) < end:
        raise ValueError(
            f"{path} é pequeno demais para conter a chave no offset esperado"
        )
    der = image[LINUXLOADER_PUBLIC_KEY_OFFSET:end]
    # A validação criptográfica completa será feita por load_der_public_key.
    return der


def load_public_key(
    public_key_path: Path | None,
    linuxloader_path: Path | None,
) -> tuple[rsa.RSAPublicKey, bytes, str]:
    """Carrega DER ou extrai a chave diretamente do LinuxLoader."""

    if linuxloader_path is not None:
        der = extract_public_key_from_linuxloader(linuxloader_path)
        source = f"LinuxLoader:{linuxloader_path}@0x{LINUXLOADER_PUBLIC_KEY_OFFSET:x}"
    else:
        key_path = public_key_path or DEFAULT_PUBLIC_KEY
        der = key_path.read_bytes()
        source = f"DER:{key_path}"

    key_hash = hashlib.sha256(der).hexdigest()
    key = serialization.load_der_public_key(der)
    if not isinstance(key, rsa.RSAPublicKey):
        raise ValueError("a chave carregada não é RSA")
    if key.key_size != 4096:
        raise ValueError(f"esperada RSA-4096; encontrada RSA-{key.key_size}")

    return key, der, source


def rsa_encrypt_body(public_key: rsa.RSAPublicKey, body: bytes) -> bytes:
    """Equivalente ao RSA_public_encrypt(..., padding=4) do firmware."""

    ciphertext = public_key.encrypt(
        body,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA1()),
            algorithm=hashes.SHA1(),
            label=None,
        ),
    )
    if len(ciphertext) != RSA_CIPHERTEXT_SIZE:
        raise AssertionError(
            f"RSA-4096 deveria gerar 512 bytes; gerou {len(ciphertext)}"
        )
    return ciphertext


# ---------------------------------------------------------------------------
# HMAC, truncamento dinâmico e OTP
# ---------------------------------------------------------------------------

def calculate_otp(si: bytes, nonce: bytes) -> dict[str, Any]:
    """Reproduz o HMAC e o truncamento encontrados em check_otp_input."""

    validate_nonce(nonce)

    # O nonce BINÁRIO é a chave. A mensagem é a SI ASCII completa.
    digest = hmac.new(nonce, si, hashlib.sha256).digest()

    # Truncamento dinâmico no estilo HOTP.
    offset = digest[31] & 0x0F
    selected = digest[offset : offset + 4]
    binary_31bit = int.from_bytes(selected, "big") & 0x7FFFFFFF

    # A string "%08d" preserva zeros à esquerda.
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


# ---------------------------------------------------------------------------
# Simulação completa
# ---------------------------------------------------------------------------

def simulate(
    parameters: DeviceParameters,
    nonce: bytes,
    public_key_path: Path | None = None,
    linuxloader_path: Path | None = None,
) -> SimulationResult:
    """Executa o pipeline completo e retorna todos os intermediários."""

    si, body, nonce_b64 = build_si(parameters, nonce)
    header = si[:PUBLIC_HEADER_SIZE]

    public_key, public_key_der, key_source = load_public_key(
        public_key_path, linuxloader_path
    )
    ciphertext = rsa_encrypt_body(public_key, body)

    # Estrutura exata copiada para DAT_001e0799 antes do Base64.
    envelope = header + ciphertext
    if len(envelope) != ENVELOPE_SIZE:
        raise AssertionError("envelope deveria possuir 0x21d/541 bytes")

    # Esta é a string efetivamente entregue a qrcode_initText.
    qr_content = base64.b64encode(envelope).decode("ascii")
    if len(qr_content) != 724:
        raise AssertionError("Base64 do envelope deveria possuir 724 caracteres")

    otp_data = calculate_otp(si, nonce)
    return SimulationResult(
        parameters=parameters,
        nonce_hex=nonce.hex(),
        nonce_base64=nonce_b64,
        body=body.decode("ascii"),
        body_length=len(body),
        public_header=header.decode("ascii"),
        public_header_hex=header.hex(),
        si=si.decode("ascii"),
        si_length=len(si),
        public_key_source=key_source,
        public_key_sha256=hashlib.sha256(public_key_der).hexdigest(),
        public_key_bits=public_key.key_size,
        rsa_padding="RSAES-OAEP SHA-1 / MGF1-SHA-1 / empty label",
        ciphertext_hex=ciphertext.hex(),
        ciphertext_length=len(ciphertext),
        envelope_hex=envelope.hex(),
        envelope_length=len(envelope),
        qr_content=qr_content,
        qr_content_length=len(qr_content),
        qr_version=QR_VERSION,
        qr_ecc=QR_ECC,
        qr_modules=QR_MODULES,
        qr_rendered_pixels=QR_RENDERED_PIXELS,
        hmac_sha256_hex=otp_data["digest"].hex(),
        dynamic_offset=otp_data["offset"],
        selected_digest_bytes_hex=otp_data["selected"].hex(),
        truncated_31bit_value=otp_data["binary_31bit"],
        otp_modulus=otp_data["modulus"],
        otp=otp_data["otp"],
    )


# ---------------------------------------------------------------------------
# Apresentação
# ---------------------------------------------------------------------------

def print_human(result: SimulationResult, show_ciphertext: bool) -> None:
    """Saída explicativa, em etapas, adequada para estudo manual."""

    print("=" * 78)
    print("SIMULADOR D2 QR/OTP: LABORATÓRIO")
    print("=" * 78)

    print("\n[1] PARÂMETROS COLETADOS")
    for name, value in asdict(result.parameters).items():
        print(f"  {name:12} = {value}")

    print("\n[2] NONCE DA SESSÃO")
    print(f"  binário/hex   = {result.nonce_hex}")
    print(f"  Base64 na SI  = {result.nonce_base64}")

    print("\n[3] BODY")
    print(f"  comprimento   = {result.body_length} bytes")
    print(f"  conteúdo      = {result.body}")

    print("\n[4] SI COMPLETA")
    print(f"  header[0:29]  = {result.public_header}")
    print(f"  header hex    = {result.public_header_hex}")
    print(f"  SI length     = {result.si_length} bytes")
    print(f"  SI            = {result.si}")

    print("\n[5] CHAVE E RSA-OAEP")
    print(f"  fonte         = {result.public_key_source}")
    print(f"  SHA-256 DER   = {result.public_key_sha256}")
    print(f"  tamanho       = RSA-{result.public_key_bits}")
    print(f"  padding       = {result.rsa_padding}")
    print(f"  ciphertext    = {result.ciphertext_length} bytes")
    if show_ciphertext:
        print(f"  ciphertexthex = {result.ciphertext_hex}")

    print("\n[6] ENVELOPE DO QR")
    print("  fórmula       = SI[0:29] || RSA-OAEP(BODY)")
    print(f"  binário       = {result.envelope_length} bytes")
    print(f"  Base64        = {result.qr_content_length} caracteres")
    print(f"  QR version    = {result.qr_version}")
    print(f"  QR ECC        = {result.qr_ecc}")
    print(f"  matriz        = {result.qr_modules} x {result.qr_modules} módulos")
    print(
        f"  render ABL    = {result.qr_rendered_pixels} x "
        f"{result.qr_rendered_pixels} pixels"
    )
    print("\n  CONTEÚDO EXATO ENTREGUE AO ENCODER QR:")
    print(result.qr_content)

    print("\n[7] HMAC E OTP")
    print("  fórmula HMAC  = HMAC-SHA-256(key=nonce binário, message=SI)")
    print(f"  digest        = {result.hmac_sha256_hex}")
    print(f"  offset        = digest[31] & 0x0f = {result.dynamic_offset}")
    print(f"  quatro bytes  = {result.selected_digest_bytes_hex}")
    print(f"  valor 31-bit  = {result.truncated_31bit_value}")
    print(f"  módulo        = {result.otp_modulus}")
    print(f"  formato       = %08d")
    print(f"  OTP FINAL     = {result.otp}")

    print("\nObservação: OAEP usa aleatoriedade; repetir com os mesmos parâmetros pode")
    print("produzir outro conteúdo QR, mas o OTP permanece igual enquanto SI e nonce")
    print("forem idênticos.")


def result_as_json(result: SimulationResult) -> str:
    data = asdict(result)
    return json.dumps(data, indent=2, ensure_ascii=False)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def parse_nonce(args: argparse.Namespace) -> tuple[bytes, str]:
    if args.nonce_hex:
        try:
            nonce = bytes.fromhex(args.nonce_hex)
        except ValueError as exc:
            raise ValueError("--nonce-hex não é hexadecimal válido") from exc
        source = "fornecido por --nonce-hex"
    elif args.demo_nonce:
        # Determinístico para documentação/testes; não use como nonce real.
        nonce = bytes(range(1, 33))
        source = "demo determinístico 01..20"
    else:
        nonce = secrets.token_bytes(NONCE_SIZE)
        source = "gerado por CSPRNG do sistema"
    validate_nonce(nonce)
    return nonce, source


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=__doc__,
        epilog=f"""
Exemplos:

  # Demonstração reproduzível com valores sintéticos:
  {Path(sys.argv[0]).name} --demo

  # Extrair a chave diretamente do LinuxLoader e gerar nonce novo:
  {Path(sys.argv[0]).name} --linuxloader {DEFAULT_LINUXLOADER} \\
      --model SM-S918B --sw-version LAB0000000001 \\
      --did DID_EXEMPLO --un UN_EXEMPLO --serial SN_EXEMPLO \\
      --imei 000000000000000

  # Reproduzir uma sessão com nonce conhecido e gerar JSON:
  {Path(sys.argv[0]).name} --nonce-hex <64_hex_chars> --json \\
      --model SM-S918B --sw-version LAB0000000001 \\
      --did DID_EXEMPLO --un UN_EXEMPLO --serial SN_EXEMPLO \\
      --imei 000000000000000
""",
    )
    parser.add_argument(
        "--demo",
        action="store_true",
        help="usa parâmetros sintéticos e nonce determinístico",
    )
    parser.add_argument("--model", help="modelo, por exemplo SM-S918B")
    parser.add_argument("--sw-version", help="versão do perfil de laboratório, 13 caracteres")
    parser.add_argument("--did", help="Device ID")
    parser.add_argument("--un", help="UN")
    parser.add_argument("--serial", help="número serial")
    parser.add_argument("--imei", help="IMEI")
    parser.add_argument("--pid", default=DEFAULT_PID, help="PID (padrão: 10004)")
    parser.add_argument(
        "--nonce-hex",
        help="nonce existente: exatamente 64 caracteres hex/32 bytes",
    )
    parser.add_argument(
        "--demo-nonce",
        action="store_true",
        help=argparse.SUPPRESS,
    )
    key_group = parser.add_mutually_exclusive_group()
    key_group.add_argument(
        "--public-key",
        type=Path,
        default=DEFAULT_PUBLIC_KEY,
        help=f"SPKI DER público (padrão: {DEFAULT_PUBLIC_KEY})",
    )
    key_group.add_argument(
        "--linuxloader",
        type=Path,
        help="extrai a chave diretamente do LinuxLoader.efi",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="emite todos os resultados como JSON",
    )
    parser.add_argument(
        "--show-ciphertext",
        action="store_true",
        help="inclui ciphertext RSA em hex na saída humana",
    )
    return parser


def parameters_from_args(args: argparse.Namespace) -> DeviceParameters:
    if args.demo:
        args.demo_nonce = True
        return DeviceParameters(
            model="D2-LAB",
            sw_version="LAB0000000001",
            did="LAB_DEVICE_000000001",
            un="LAB_UN",
            serial="LAB_SERIAL",
            imei="000000000000000",
            pid=DEFAULT_PID,
        )

    required = {
        "model": args.model,
        "sw-version": args.sw_version,
        "did": args.did,
        "un": args.un,
        "serial": args.serial,
        "imei": args.imei,
    }
    missing = [f"--{name}" for name, value in required.items() if value is None]
    if missing:
        raise ValueError("parâmetros obrigatórios ausentes: " + ", ".join(missing))

    return DeviceParameters(
        model=args.model,
        sw_version=args.sw_version,
        did=args.did,
        un=args.un,
        serial=args.serial,
        imei=args.imei,
        pid=args.pid,
    )


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    try:
        parameters = parameters_from_args(args)
        nonce, nonce_source = parse_nonce(args)
        result = simulate(
            parameters=parameters,
            nonce=nonce,
            public_key_path=None if args.linuxloader else args.public_key,
            linuxloader_path=args.linuxloader,
        )
    except (OSError, ValueError) as exc:
        parser.error(str(exc))

    if args.json:
        data = asdict(result)
        data["nonce_source"] = nonce_source
        print(json.dumps(data, indent=2, ensure_ascii=False))
    else:
        print_human(result, args.show_ciphertext)
        print(f"\nFonte do nonce: {nonce_source}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

