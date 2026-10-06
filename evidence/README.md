# Evidence index

> **Related articles:** [Technical wiki](../README.md#pages) · [Evidence guide](../docs/research.md#evidence-guide) · [Complete flow](../flowchart.md)

This directory contains selected source snapshots from the original research
project `D2Vault-Research`, revision
`b8131475fd75f8f5f54b3485c611a00774068620`. The project name identifies provenance;
no remote repository is required to read these files.

## Contents

1. [Source snapshots](#source-snapshots)
2. [ZZI8 code excerpts](#zzi8-code-excerpts)
3. [Provenance](#provenance)
4. [Reading limits](#reading-limits)

## Source snapshots

| Local file | Original source path | Status |
| --- | --- | --- |
| [ZZI8 report](sources/zzi8-report.md) | `evidence/firmware_extract/RELATORIO_D2_QR_OTP.md` | Principal screen reconstruction |
| [Historical SAFZI1 report](sources/safzi1-historical-report.md) | `evidence/firmware_extract/RELATORIO_D2_QRCODE_OTP_SAFZI1.md` | Historical, contains superseded interpretations |
| [Android policy](sources/android-policy.md) | `docs/03-dmcservice-e-flags.md` | Policy origins |
| [VaultKeeper access](sources/vaultkeeper-access.md) | `docs/04-vaultkeeper-e-tee.md` | Caller checks |
| [Bootloader analysis](sources/bootloader-analysis.md) | `docs/11-engenharia-reversa-abl.md` | Runtime gate and policy structures |
| [Trusted storage](sources/vault-storage.md) | `docs/12-engenharia-reversa-ta-vk.md` | TA dispatch and RPMB reconstruction |
| [Artifact manifest](sources/artifact-manifest.md) | `evidence/firmware_extract/MANIFEST.md` | Recorded binary identities |
| [Device scope](sources/scope.md) | `docs/01-escopo-e-dispositivo.md` | Observation context |
| [Glossary](sources/glossary.md) | `docs/10-glossario.md` | Original terminology |

### Extracted public key

The repository includes the D2 OTP public key extracted from the analyzed ZZI8
`LinuxLoader.efi`. The [DER key](../public-keys/zzi8-d2-otp-public.der) preserves
the original extracted bytes. The [PEM key](../public-keys/zzi8-d2-otp-public.pem)
contains the same public key in a text encoding. The
[metadata record](../public-keys/zzi8-d2-otp-public.json) binds both files to the
source build, artifact hash, offset, length and research revision.

This is one distinct public key in two encodings. No matching private key was
found in the analyzed artifacts.

### Original protocol scripts

| Archived original | Adapted executable |
| --- | --- |
| [Simulator](sources/d2_otp_simulator.py) | [d2_otp_simulator.py](../tools/d2_otp_simulator.py) |
| [Decoder](sources/d2_qr_decode.py) | [d2_qr_decode.py](../tools/d2_qr_decode.py) |
| [Reference implementation](sources/reference_d2_otp.py) | [reference_d2_otp.py](../scripts/reference_d2_otp.py) |

The archived source bytes remain unchanged. Executable copies use local paths
and a documented laboratory profile. Differences are described in the
[protocol laboratory](../docs/protocol-lab.md#laboratory).

## ZZI8 code excerpts

All excerpts come from the original
`evidence/firmware_extract/analysis/current-targets-final.txt`. Line numbers below
refer to that original file. Each local excerpt starts at its own line 1.

| Local excerpt | Original lines | Main content |
| --- | --- | --- |
| [OTP handler](zzi8/otp-handler.txt) | 4366 through 4770 | Session construction, menu input and verification |
| [Identity builder](zzi8/identity-builder.txt) | 5276 through 5878 | Device fields and RNG |
| [QR renderer](zzi8/qr-renderer.txt) | 5880 through 6066 | Graphics output |
| [Menu display](zzi8/otp-menu.txt) | 6070 through 6164 | Interface drawing |
| [D2 screen](zzi8/d2-screen.txt) | 6167 through 6295 | Sequence input and handler result |

To translate an original line into a local line, subtract the original excerpt
start and add one. For example, original line 6268 is local line 102 in the
D2 screen excerpt. Source references in the complete flow use these local positions.

## Provenance

[import-manifest.json](import-manifest.json) records each source path, source
revision, source file SHA256, imported byte SHA256 and optional line range.
It includes both the text evidence and the imported analysis scripts.

The source text was copied from the recorded Git revision. English wiki pages
are adaptations rather than verbatim copies. Original line numbers and text
remain reproducible in the local snapshots. Headers, dashes and source paths
inside those archived originals are retained as evidence, not editorial styling.

## Reading limits

The source reports contain earlier conclusions alongside later corrections.
Use [version notes](../docs/research.md#version-notes) to distinguish them. Original
absolute paths describe the research environment and are not required local
installation locations. The excerpts preserve decompiler output, including
recovered types and warnings; they should not be treated as buildable source.

The import manifests identify text snapshots. Recorded firmware hashes identify
the original analyzed binaries, not artifacts distributed by this repository.

## Maintenance Mode import

The [original flow](sources/maintenance-mode-flow.md) and [extracted Settings components](maintenance-mode/README.md) are preserved byte-for-byte from the source revision above. The component directory includes Java, smali, manifest, resources and reference inventories. Their original relative paths describe the research repository. Use the adapted [Maintenance Mode article](../docs/system.md#maintenance-mode) for local navigation and its relationship to [OTP reconstruction](../docs/protocol.md#otp-reconstruction). Each imported file is recorded in the import manifest.
