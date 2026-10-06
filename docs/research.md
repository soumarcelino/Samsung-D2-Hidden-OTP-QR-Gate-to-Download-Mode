# Research reference and evidence

> **Related articles:** [Overview](../README.md) · [Complete flow](../flowchart.md)

Static analysis workflow, function coordinates, version differences, artifact identity and terminology in one reference.

## Contents

1. [Static analysis workflow](#research-method)
2. [Function map](#function-map)
3. [Versions and interpretation limits](#version-notes)
4. [Evidence and artifact identity](#evidence-guide)
5. [Glossary](#glossary)

<a name="research-method"></a>

## Static analysis workflow

<a name="research-method-identify-the-artifact"></a>

### Identify the artifact

Record the source artifact name and SHA256 before extraction. Distinguish the
outer ABL image, decompressed firmware volume, extracted PE module and TA ELF.
Keep outputs in a separate working directory so the source bytes remain intact.

[Artifact inspector](protocol-lab.md#inspection-artifact-inspector) reports the hash,
size and basic ELF or PE signature using Python standard library functions.
Signature recognition is a preliminary classification, not a full parser.

<a name="research-method-extract-the-relevant-module"></a>

### Extract the relevant module

The imported [PE extraction script](protocol-lab.md#analysis-scripts-pe-module-extraction)
extracts a PE from a supplied offset in an already decompressed volume. Its
historical default `0xac` refers to one artifact. Determine the offset for your
own image before using it; the script does not scan, decompress or locate modules.

Use the extracted LinuxLoader for the secret screen path and retain OdinApp as
a separate analysis target. Identical routine names across modules do not imply
identical addresses or behavior.

<a name="research-method-follow-evidence-in-order"></a>

### Follow evidence in order

1. Identify DMC and UI strings.
2. Find references to those strings.
3. Locate the surrounding functions and their callers.
4. Follow request and response buffer sizes.
5. Trace the policy result into the runtime field.
6. Trace the screen input loop into session construction and comparison.
7. Inspect key tables and menu tables as data, not only as decompiler labels.
8. Compare recovered formatting calls against buffer copying boundaries.

[DumpDmcXrefs](protocol-lab.md#analysis-scripts-ghidra-string-and-caller-export) collects DMC
strings, references and containing decompiled functions from an open Ghidra
program. It depends on Ghidra analysis and already defined string data.

<a name="research-method-read-decompilation-critically"></a>

### Read decompilation critically

The recovered C can lose types, variadic arguments and function boundaries.
Compare important claims with instructions, data bytes and call relationships.
In particular, do not infer exact field widths from a degraded format call or
identify a hash from a truncation mask alone.

<a name="research-method-publish-evidence"></a>

### Publish evidence

Record source revision, module identity, coordinate type and original line ranges.
Preserve verbatim excerpts separately from adapted documentation. This project
uses [an import manifest](../evidence/import-manifest.json) for that distinction.

<a name="research-method-evidence"></a>

### Evidence

This workflow is adapted from the [bootloader analysis](../evidence/sources/bootloader-analysis.md)
and [ZZI8 report](../evidence/sources/zzi8-report.md), especially its evidence and
reproducibility sections. Tools are documented in [Scripts](protocol-lab.md#analysis-scripts)
and [Tools](protocol-lab.md#inspection).

<a name="function-map"></a>

## Function map

<a name="function-map-address-conventions"></a>

### Address conventions

RVA is relative to a PE image base. A file offset is a location in its serialized
bytes. A VA depends on the mapped image base. Firmware volume offsets refer to
another enclosing object. Record the build, module and coordinate type together.
Researcher assigned names below describe behavior; they are not exported symbols.

<a name="function-map-zzi8-linuxloader"></a>

### ZZI8 LinuxLoader

| RVA | Functional label | Local evidence |
| --- | --- | --- |
| `0xd5680` | `make_si` | [Identity builder](../evidence/zzi8/identity-builder.txt) |
| `0xd62f0` | `draw_qrcode` | [Renderer](../evidence/zzi8/qr-renderer.txt) |
| `0xd66e0` | `display_otp_mode` | [Menu drawing](../evidence/zzi8/otp-menu.txt) |
| `0xd68b0` | `check_otp_input` | [Session handler](../evidence/zzi8/otp-handler.txt) |
| `0xd70a0` | D2 screen | [Screen and caller](../evidence/zzi8/d2-screen.txt) |
| `0xd782c` | Base64 wrapper | ZZI8 report, function map |
| `0xa6860` | HMAC wrapper | ZZI8 report, local verifier |
| `0xf8848` | QR encoder | ZZI8 report, QR construction |

<a name="function-map-zzi8-data-references"></a>

### ZZI8 data references

| RVA | Meaning |
| --- | --- |
| `0x1ad720` | 22 entry key sequence table |
| `0x1ad6b8` | 13 entry menu table |
| `0x114b56` | Eight digit format string |
| `0x119ab1` | D2 label |
| `0x1e0799` | Envelope buffer |
| `0x1e09b6` | Base64 QR text buffer |

<a name="function-map-safzi1-comparison"></a>

### SAFZI1 comparison

| Role | SAFZI1 reference | ZZI8 reference |
| --- | --- | --- |
| D2 screen | `0xd6700` | `0xd70a0` |
| Identity builder | `0xd4ce0` | `0xd5680` |
| QR drawing | `0xd5950` | `0xd62f0` |
| Menu drawing | `0xd5d40` | `0xd66e0` |
| Key table | `0x1ac6d0` | `0x1ad720` |

The earlier report uses both `0xd5f28` and `0xd5f10` when naming the handler.
Retain that uncertainty instead of presenting one address as universally valid.
Algorithm claims in that report are historical and require separate confirmation.

<a name="function-map-evidence"></a>

### Evidence

[Current ZZI8 report](../evidence/sources/zzi8-report.md) and
[historical SAFZI1 report](../evidence/sources/safzi1-historical-report.md)
provide the mappings. [Version notes](#version-notes) explain conflicting claims.

<a name="version-notes"></a>

## Versions and interpretation limits

<a name="version-notes-current-reference"></a>

### Current reference

The primary reference is the ZZI8 ABL image and its extracted LinuxLoader module.
The device record describes a Galaxy S23 Ultra, model `SM-S918B`, device name
`dm3q`, software `CP2A.260605.016.S918BXXUAZZI8` and locked bootloader state.
These values are the research observations, not compatibility guarantees.

<a name="version-notes-sources-that-must-remain-distinct"></a>

### Sources that must remain distinct

| Source | Role in this project |
| --- | --- |
| ZZI8 consolidated report | Current hidden screen reconstruction |
| ZZI8 decompilation excerpts | Primary code evidence for screen behavior |
| Android and TA analyses | Policy field origins and persistent storage |
| SAFZI1 report | Historical comparison of another build |
| Combination AWF1 image | Earlier artifact described in the research |

The combination image of 2023 uses an earlier FMM vault path. Searching it alone
is not evidence that the newer hidden screen is absent from all firmware.

<a name="version-notes-corrected-interpretations"></a>

### Corrected interpretations

Older reports attributed the screen nonce to TA/RPMB state, described SHA1 and
associated the UI with token or fuse operations. The current ZZI8 reconstruction
identifies local UEFI random generation and HMAC SHA256 in the screen verifier.
These claims are not combined into a single implementation.

A four bit truncation offset alone does not identify the HMAC hash. Algorithm
identification requires the actual digest descriptor and its caller, not only
a recognizable arithmetic pattern.

<a name="version-notes-remaining-limits"></a>

### Remaining limits

| Question | What the local sources establish |
| --- | --- |
| Exact remote application or endpoint | Not identified |
| Service account and network requirements | Not recovered from the phone |
| Local time expiry counter | Not identified in the screen verifier |
| All public header text widths | Formatting recovery remains qualified |
| Full RPMB crypto and key derivation | Not completely reconstructed |
| Cross model compatibility | Not established |
| Permanent unlock through OTP | Not established; runtime authorization is observed |

<a name="version-notes-evidence"></a>

### Evidence

[Device scope](../evidence/sources/scope.md),
[ZZI8 report](../evidence/sources/zzi8-report.md),
[historical report](../evidence/sources/safzi1-historical-report.md) and
[artifact manifest](../evidence/sources/artifact-manifest.md) are local snapshots.

<a name="evidence-guide"></a>

## Evidence and artifact identity

<a name="evidence-guide-local-sources"></a>

### Local sources

This project carries local source snapshots and selected decompilation excerpts.
The [evidence index](../evidence/README.md) identifies each file and its original
location. The [import manifest](../evidence/import-manifest.json) records the
source revision, SHA256 hashes and excerpt line ranges.

The preserved source snapshots are in Portuguese. Wiki pages are English
adaptations. Original source files remain separate so revised wording can be
compared with the underlying research.

<a name="evidence-guide-artifact-identity"></a>

### Artifact identity

| Artifact in the research | SHA256 |
| --- | --- |
| ZZI8 source ABL | `73f583e0f6bef3263999f4a77b23a852447e3047443a16b3ab12eaaf5c3f419d` |
| ZZI8 LinuxLoader | `993016ab7a70454950b55c9030db67828ca53ce99af1462e8262deebed4d5757` |
| TA listed in the extraction manifest | `72b7c0e5b525c782cee8e241d8a71de87c61dfbed3e1040acedf3ce41f13d165` |
| Public RSA key listed in the manifest | `d66e3eda6f1b6e15172cc4e55958e710aa7708d75b66ba1e75ef293fae51f640` |
| SAFZI1 LinuxLoader | `8bb0f540a84da661dade1b273f9d307c265dd57f5563c88ae4d8c11686412174` |

These are identities recorded by the research, not hashes of firmware shipped
in this repository. Full firmware artifacts are external inputs to the analysis
scripts. The local evidence import hashes identify the included text files.

<a name="evidence-guide-confidence-levels"></a>

### Confidence levels

| Evidence | Supports | Does not establish alone |
| --- | --- | --- |
| Screenshot | Visible layout and menu labels | Policy record or server protocol |
| String | Presence of diagnostic/UI text | Reachability or a complete branch |
| Cross reference | Code/data relationship | Correct types and semantics |
| Decompilation | Recovered control and data flow | Exact variadic formatting or every instruction |
| Disassembly and tables | Specific branch and data behavior | Cross build compatibility |
| Static protocol reconstruction | Expected endpoint capabilities | Actual remote app deployment |

<a name="evidence-guide-version-discipline"></a>

### Version discipline

Preserve artifact identity and build labels with every address. If two reports
conflict, cite the specific version and evidence supporting the current claim.
Historical sources retain their original limitations and should not silently
replace the ZZI8 reconstruction.

<a name="evidence-guide-evidence"></a>

### Evidence

[Original artifact manifest](../evidence/sources/artifact-manifest.md) records
firmware identity. [Version notes](#version-notes) explain how the reports are
used. [Research method](#research-method) describes the analysis workflow.

<a name="glossary"></a>

## Glossary

<a name="glossary-terms"></a>

### Terms

| Term | Meaning in this documentation |
| --- | --- |
| ABL | Android bootloader implementation hosting the analyzed UEFI modules |
| Base64 | Text representation of binary data; not encryption |
| Binder | Android interprocess communication interface |
| DID | Platform device identifier distinct from a serial or IMEI |
| DMC | Logical policy vault and related device service |
| D2 | Restriction screen in the Download path |
| ELF | Executable container format used by some analyzed artifacts |
| HAL | Hardware abstraction layer bridging framework and vendor implementation |
| HMAC | Message authentication construction using a key and message |
| IMEI | Cellular equipment identifier |
| Nonce | Fresh random data distinguishing an authorization session |
| OAEP | RSA encryption padding scheme used by the protected challenge |
| OdinApp | Firmware application for the Download/Odin path |
| OTP | Eight digit session response entered through the hidden menu |
| PE/COFF | Executable module format inside the examined firmware volume |
| QSEECom | Qualcomm interface to trusted applications |
| QR | Optical transport of the encoded challenge |
| RPMB | Authenticated persistent storage used by the vault implementation |
| RSA public key | Key used by the phone to protect the outgoing body |
| RVA | Address relative to a PE image base |
| SI | Session information assembled for the QR and local verification |
| SN | Serial identifier gathered from the platform |
| TA | Trusted application, such as VaultKeeper `vk` |
| TEE | Trusted execution environment |
| UN | Platform unique identifier named in the identity builder |
| VA | Virtual address in the analyzed mapping |
| VaultKeeper | Samsung service and trusted environment vault infrastructure |

<a name="glossary-easily-confused-concepts"></a>

### Easily confused concepts

Base64 is readable encoding, whereas the RSA body is encrypted. The QR carries
a challenge, whereas the OTP is the response. A session nonce is not the persistent
DMC record. A runtime gate flag is not permanent bootloader unlock state.

<a name="glossary-evidence"></a>

### Evidence

Terms are adapted from the [original glossary](../evidence/sources/glossary.md) and the
[ZZI8 report](../evidence/sources/zzi8-report.md), with meanings narrowed to the
screen path documented in this project.
