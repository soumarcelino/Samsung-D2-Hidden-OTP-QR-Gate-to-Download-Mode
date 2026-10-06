# Tools and protocol laboratory

> **Related articles:** [Overview](../README.md) · [Complete flow](../flowchart.md)

The complete tool catalog, encoding and decoding workflow, inspection, extraction scripts, Ghidra collectors and examples.

## Contents

1. [Protocol laboratory](#laboratory)
2. [Inspection utilities](#inspection)
3. [Extraction and Ghidra scripts](#analysis-scripts)
4. [Synthetic examples](#examples)

<a name="laboratory"></a>

## Protocol laboratory

The original research includes a challenge encoder, a decoder and a compact
reference implementation. This project provides local adaptations, key utilities,
PNG rendering and static analysis helpers for a complete laboratory workflow.

<a name="laboratory-programs"></a>

### Programs

| Program | Responsibility |
| --- | --- |
| [generate_lab_keys.py](../tools/generate_lab_keys.py) | Create an independent RSA4096 laboratory key pair |
| [d2_otp_simulator.py](../tools/d2_otp_simulator.py) | Assemble synthetic SI, encrypt the body, encode the envelope and derive the response |
| [d2_qr_decode.py](../tools/d2_qr_decode.py) | Decode an envelope with its matching private key and validate recovered fields |
| [reference_d2_otp.py](../scripts/reference_d2_otp.py) | Compact reference for SI, HMAC and envelope construction |
| [render_qr.py](../tools/render_qr.py) | Export the envelope as a version 30 QR PNG |
| [key_info.py](../tools/key_info.py) | Describe an RSA public key and its canonical fingerprint |
| [extract_public_key.py](../tools/extract_public_key.py) | Extract the documented public DER region from a supplied ZZI8 LinuxLoader |
| [inspect_qr.py](../tools/inspect_qr.py) | Inspect the public envelope structure without decryption |
| [inspect_artifact.py](../tools/inspect_artifact.py) | Identify file bytes and initial executable metadata |

<a name="laboratory-dependencies"></a>

### Dependencies

Run from the repository root:

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r tools/requirements.txt -r scripts/requirements.txt
mkdir -p outputs
```

The two inspection tools use only the standard library. Protocol and key tools
require `cryptography`. PNG rendering uses `qrcode` and Pillow. PE extraction uses
`pefile`. Ghidra utilities run inside Ghidra rather than this Python environment.

<a name="laboratory-laboratory-workflow"></a>

### Laboratory workflow

<a name="laboratory-create-a-laboratory-key-pair"></a>

#### Create a laboratory key pair

```sh
.venv/bin/python tools/generate_lab_keys.py
.venv/bin/python tools/key_info.py keys/lab-public.der
```

The generator creates `keys/lab-private.pem` and `keys/lab-public.der`. The
private file is created with mode 0600 on systems supporting POSIX permissions.
It is unencrypted PKCS8. Existing key files are not replaced.

These keys belong to the local laboratory. They are independent of the firmware
key documented in the research. The `keys` directory is ignored by Git.

<a name="laboratory-encode-a-synthetic-session"></a>

#### Encode a synthetic session

```sh
.venv/bin/python tools/d2_otp_simulator.py --demo --json > outputs/simulation.json
```

The demo uses model `D2-LAB`, software field `LAB0000000001`, synthetic identifiers
and a fixed nonce for repeatable response derivation. The generated JSON contains
parameters, nonce, BODY, SI, key fingerprint, ciphertext, envelope, QR text and
intermediate response values.

RSA OAEP is randomized. Repeating with identical SI and nonce can produce a
different ciphertext and QR, while the derived eight digit response remains the
same. The demo is a laboratory encoding profile, not a reproduced device session.

<a name="laboratory-export-qr-text-and-image"></a>

#### Export QR text and image

```sh
.venv/bin/python -c 'import json; from pathlib import Path; data=json.loads(Path("outputs/simulation.json").read_text()); Path("outputs/lab-qr.txt").write_text(data["qr_content"]+"\n")'
.venv/bin/python tools/inspect_qr.py outputs/lab-qr.txt
.venv/bin/python tools/render_qr.py --simulation outputs/simulation.json --output outputs/lab-qr.png
```

The renderer uses QR version 30, HIGH error correction and a four module quiet
zone. At scale 5 the complete PNG is 725 × 725 pixels. The firmware's 685 × 685
value describes the module matrix without this added quiet zone.

<a name="laboratory-decode-the-laboratory-challenge"></a>

#### Decode the laboratory challenge

```sh
.venv/bin/python tools/d2_qr_decode.py --qr-file outputs/lab-qr.txt --private-key keys/lab-private.pem
```

The decoder reads the Base64 envelope, parses the supported public header,
decrypts with the corresponding RSA private key, validates the body and recovers
its nonce. It derives the same response from that laboratory SI.

For an encrypted private key, `--ask-password` requests the password without
terminal echo. `--password-file` is another supported input. Human output hides
identity fields by default; `--show-sensitive` displays them. JSON output includes
the complete recovered body and session data.

<a name="laboratory-inspect-the-compact-implementation"></a>

#### Inspect the compact implementation

```sh
.venv/bin/python scripts/reference_d2_otp.py
.venv/bin/python scripts/reference_d2_otp.py --make-envelope --public-key keys/lab-public.der
```

The reference uses the same synthetic profile. Its output makes the SI and local
response derivation explicit without the full simulator result structure.

<a name="laboratory-public-key-inspection"></a>

### Public key inspection

The extracted ZZI8 key is included in reusable formats:

| File | Format | Intended use |
| --- | --- | --- |
| [zzi8-d2-otp-public.der](../public-keys/zzi8-d2-otp-public.der) | DER SubjectPublicKeyInfo | Binary input for the simulator and cryptographic tools |
| [zzi8-d2-otp-public.pem](../public-keys/zzi8-d2-otp-public.pem) | PEM SubjectPublicKeyInfo | Text transport and OpenSSL compatible input |
| [zzi8-d2-otp-public.json](../public-keys/zzi8-d2-otp-public.json) | JSON metadata | Build, source offset, size, hashes and key parameters |
| [SHA256SUMS](../public-keys/SHA256SUMS) | SHA256 list | Direct integrity verification after download |

Both encoded key files represent the same RSA4096 public key. The canonical
identity is the SHA256 of its DER SubjectPublicKeyInfo:
`d66e3eda6f1b6e15172cc4e55958e710aa7708d75b66ba1e75ef293fae51f640`.

Inspect the included key directly:

```sh
.venv/bin/python tools/key_info.py public-keys/zzi8-d2-otp-public.der
openssl pkey -pubin -in public-keys/zzi8-d2-otp-public.pem -text -noout
sha256sum -c public-keys/SHA256SUMS
```

Create a synthetic envelope with the actual ZZI8 public key:

```sh
.venv/bin/python tools/d2_otp_simulator.py --demo --public-key public-keys/zzi8-d2-otp-public.der --json
```

The simulator already knows the synthetic SI and nonce, so it can show the
derived response. The resulting ciphertext cannot be decoded without the
matching private key.

For a supplied extracted ZZI8 `LinuxLoader.efi`:

```sh
.venv/bin/python tools/extract_public_key.py captures/LinuxLoader.efi keys/firmware-public.der
.venv/bin/python tools/key_info.py keys/firmware-public.der
```

The extractor reads `0x226` bytes at file offset `0x1ad48c`, parses the public
RSA key and requires the documented DER SHA256 fingerprint before writing it.
It refuses an existing output. Those coordinates refer to the extracted PE,
not an outer ABL image or an unrelated build.

The included public key is sufficient to encrypt a laboratory body compatible
with this key profile. It does not supply private key decryption capability.
Key generation produces a new independent pair; it cannot derive the firmware's
private key.

<a name="laboratory-decode-requirements"></a>

### Decode requirements

A decoder needs the private key corresponding to the public key used for that
challenge. The original research did not recover or distribute that private key.
The repository supplies programs, not a manufacturer private key.

Supported validation includes envelope lengths, protocol prefix, decimal body
length, RSA4096 OAEP decryption, eight body fields, consistency of PID/software
fields and a 32 byte nonzero nonce. A missing, mismatched or incompatible key
fails before a response can be derived from the recovered session.

<a name="laboratory-header-interpretation"></a>

### Header interpretation

The original encoder asserted a 29 byte public header and a 13 character software
field, while its default device version had 12 characters. This made its demo
inconsistent. The adapted demo uses an explicit 13 character laboratory field.

The decoder locates the header marker instead of asserting offset 22. This
removes one hardcoded width assumption, but does not prove compatibility with
every physical device header. Actual header padding and formatting still require
comparison with the firmware and captures for the relevant build.

Simulator fields are ASCII and colon separated. The laboratory encoder requires
a body length with three decimal digits to fit its 29 byte header profile.
The tools are not presented as universal firmware implementations.

<a name="laboratory-provenance"></a>

### Provenance

Original programs are preserved locally as
[simulator source](../evidence/sources/d2_otp_simulator.py),
[decoder source](../evidence/sources/d2_qr_decode.py) and
[reference source](../evidence/sources/reference_d2_otp.py).
Their identities and the executable adaptations are recorded in the
[import manifest](../evidence/import-manifest.json).

These programs have not been executed as a complete round trip in this update.
The protocol reconstruction and software adaptation are separate from validation
against a live device.

<a name="inspection"></a>

## Inspection utilities

The toolkit includes protocol encoders, decoders, key utilities, QR rendering
and file inspection. The two inspection tools use Python 3.10 or later and the
standard library. The [laboratory guide](#laboratory) lists additional
dependencies for the other programs.

<a name="inspection-qr-envelope-inspector"></a>

### QR envelope inspector

Program: [inspect_qr.py](../tools/inspect_qr.py).

Supply the text returned by a QR reader, not an image:

```sh
python3 tools/inspect_qr.py examples/qr-envelope.txt
```

For a local capture supplied through standard input:

```sh
python3 tools/inspect_qr.py < captures/session-qr.txt
```

The inspector checks canonical Base64, the 724 character text length, the
541 byte envelope, the `D2` marker and protocol version `01`. It reports the
opaque 29 byte header, the 512 byte protected body and SHA256 fingerprints.
Whitespace from line wrapping is removed before validation. Input is limited
to 64 KiB. Malformed or unsupported input exits with status 2.

The uncertain textual header widths are not inferred. The protected body is
not decrypted. The fixture demonstrates a valid envelope layout; it does not
prove that the payload is a usable RSA ciphertext or authorization challenge.

<a name="inspection-artifact-inspector"></a>

### Artifact inspector

Program: [inspect_artifact.py](../tools/inspect_artifact.py).

```sh
python3 tools/inspect_artifact.py evidence/zzi8/d2-screen.txt
python3 tools/inspect_artifact.py path/to/LinuxLoader.efi
```

The tool hashes the file in chunks and reports its size. An ELF signature adds
class, byte order and machine metadata. A valid located PE signature adds its
header offset, machine and section count. Other files remain unclassified.

<a name="inspection-scope-of-the-output"></a>

### Scope of the output

| Tool | Establishes | Does not establish |
| --- | --- | --- |
| QR inspector | Supported envelope layout and byte identity | Private body contents, valid padding or accepted OTP |
| Artifact inspector | Byte identity and initial format metadata | Complete executable validity or firmware compatibility |

The QR constants come from the local [QR envelope article](protocol.md#qr-envelope)
and [ZZI8 source report](../evidence/sources/zzi8-report.md).

<a name="analysis-scripts"></a>

## Extraction and Ghidra scripts

The extraction and Ghidra scripts are imported from the original research
revision recorded in the [import manifest](../evidence/import-manifest.json).
The reference protocol implementation is a local adaptation; its original
source bytes are preserved separately.
They read supplied artifacts or an open analysis project and write extracted
outputs to paths selected by the operator.

<a name="analysis-scripts-pe-module-extraction"></a>

### PE module extraction

Program: [extract_odinapp.py](../scripts/extract_odinapp.py).

```sh
.venv/bin/python scripts/extract_odinapp.py path/to/volume.bin outputs/OdinApp.efi 0xac
```

The input must already be decompressed. The third argument is the module offset,
interpreted as a Python integer such as hexadecimal `0xac`. The script parses
PE section bounds and copies the module through the largest raw section end.
It reports extraction offset, size and machine identifier.

The historical default offset `0xac` is specific to its source artifact.
It is not a universal position in ABL images. The script also assumes positional
arguments, an existing output parent directory and an appropriate PE input.
The chosen destination file is overwritten if it already exists.

<a name="analysis-scripts-image-extraction"></a>

### Image extraction

Program: [carve_jpegs.py](../scripts/carve_jpegs.py).

```sh
.venv/bin/python scripts/carve_jpegs.py path/to/blob.bin outputs/images
```

The script searches JPEG start and end markers, decodes candidates with Pillow
and saves accepted images as PNG. Names include a counter, source offset and
pixel dimensions. The output directory is created automatically.

The marker search is an inspection aid rather than a complete binary format
parser. It can miss unusual JPEG arrangements and does not prove that an image
belongs to the D2 interface without supporting references in the firmware.

<a name="analysis-scripts-ghidra-string-and-caller-export"></a>

### Ghidra string and caller export

Program: [DumpDmcXrefs.java](../scripts/ghidra/DumpDmcXrefs.java).

1. Open and analyze the relevant firmware module in Ghidra.
2. Add `scripts/ghidra` to the Script Manager directories.
3. Run `DumpDmcXrefs.java`.
4. Supply an output path as its first script argument when supported by the runner.

Its default output is `/tmp/dmc-xrefs.txt`. It finds defined strings containing
DMC or the recorded `QseecomStartApp (vk` text, lists their references and exports
the decompiled containing functions. Each function has a 120 second decompiler
timeout. String definition and function analysis affect coverage.

<a name="analysis-scripts-protocol-reference"></a>

### Protocol reference

[reference_d2_otp.py](../scripts/reference_d2_otp.py) is the compact implementation imported
from the research and adapted to the synthetic laboratory header profile.
It displays identity serialization, response derivation and optional envelope
construction. [Protocol laboratory](#laboratory) documents its use.

<a name="analysis-scripts-additional-ghidra-collectors"></a>

### Additional Ghidra collectors

| Script | Behavior | Address scope |
| --- | --- | --- |
| [DumpBootRoutes.java](../scripts/ghidra/DumpBootRoutes.java) | Dump selected functions and direct callers | Historical SAFZI1 target list |
| [DumpRouteStateMachines.java](../scripts/ghidra/DumpRouteStateMachines.java) | Dump boot and key state functions | Historical research target list |

Both collectors print decompiled evidence to the Ghidra console. Configure
`scripts/ghidra` as a Script Manager path and open the corresponding module.
The arrays are build specific. Verify the module and targets with the
[function map](research.md#function-map) before applying them to another build.

DumpBootRoutes uses an image base plus each supplied RVA and a 180 second
function timeout. DumpRouteStateMachines uses a 240 second function timeout.
Missing functions and decompiler failures are included in the output; they
are not silently treated as successful recovery.

<a name="analysis-scripts-limits"></a>

### Limits

| Utility | Main limitation |
| --- | --- |
| PE extractor | Offset and decompressed input must already be known |
| Image carver | Marker based JPEG search is incomplete |
| Ghidra exporter | Depends on recovered strings, references and function boundaries |

These utilities were copied from the research, not newly validated against a
firmware corpus in this update. Adapted usage notes are local to this project.

<a name="examples"></a>

## Synthetic examples

<a name="examples-qr-envelope-layout"></a>

### QR envelope layout

[qr-envelope.txt](../examples/qr-envelope.txt) is a synthetic Base64 envelope containing:

| Region | Bytes |
| --- | --- |
| Header | ASCII `D201` followed by 25 ASCII zero characters |
| Protected body placeholder | 512 zero bytes |
| Envelope | 541 bytes before Base64 |

The file is intended for structural inspection with
[inspect_qr.py](../tools/inspect_qr.py). It is not a capture, encrypted challenge,
valid SI or response code. Its header does not claim the exact firmware field widths.

```sh
python3 tools/inspect_qr.py examples/qr-envelope.txt
```
