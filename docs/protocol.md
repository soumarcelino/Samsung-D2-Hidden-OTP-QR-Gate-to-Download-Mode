# QR protocol and screen state

> **Related articles:** [Overview](../README.md) · [Complete flow](../flowchart.md)

Session data origins, challenge encoding, screen state, verification and the evidence required to reconstruct an accepted response.

## Contents

1. [Session information and QR envelope](#qr-envelope)
2. [Interface and session state](#interface-state)
3. [Reconstruction and response requirements](#otp-reconstruction)

<a name="qr-envelope"></a>

## Session information and QR envelope

<a name="qr-envelope-identity-builder"></a>

### Identity builder

`make_si` gathers product and device fields and obtains 32 random bytes through
the UEFI RNG protocol. The original binary nonce is retained for verification;
its Base64 form is included in the textual body.

| Body order | Field | Source |
| --- | --- | --- |
| 1 | PID | Product constant, `10004` |
| 2 | Model | Build constant, `SM-S918B` |
| 3 | Software version | Build constant, `S918BXXUAZZI8` |
| 4 | DID | Platform device identity |
| 5 | UN | Platform unique identifier |
| 6 | SN | Serial returned by the platform |
| 7 | IMEI | Cellular identifier returned by the platform |
| 8 | Nonce | UEFI RNG, represented as Base64 |

The body uses colon separators and has a reported maximum of 256 bytes.
Failure to access the RNG, failed generation and an all zero nonce are rejected.

<a name="qr-envelope-envelope-layout"></a>

### Envelope layout

| Byte region | Length | Meaning |
| --- | --- | --- |
| 0 through 28 | 29 bytes | Public header copied from SI |
| 29 through 540 | 512 bytes | RSA encrypted body |
| Complete envelope | 541 bytes | Header and protected body |
| Base64 representation | 724 characters | Text passed to the QR encoder |

The firmware protects the body with RSA4096 OAEP. The current reconstruction
identifies SHA1 and MGF1 SHA1 for padding. The public key is embedded in the
phone; the matching private key is not present in the analyzed artifacts.

> **Note:** The 29 byte copying boundary is stronger evidence than an inferred
> fixed width for every textual header field. The decompiler recovered the
> formatting call imperfectly. Treat the header as an opaque 29 byte prefix
> when inspecting its layout rather than asserting a 13 character software field.

<a name="qr-envelope-qr-encoding-and-drawing"></a>

### QR encoding and drawing

| Property | Observed value in ZZI8 |
| --- | --- |
| Version | 30 |
| Error correction | HIGH |
| Matrix | 137 × 137 modules |
| Module scale | 5 × 5 pixels |
| Rendered module area | 685 × 685 pixels |

The renderer paints black and white modules into a graphics buffer and positions
them using the display dimensions. It does not derive the OTP from pixels.

<a name="qr-envelope-session-relationship"></a>

### Session relationship

The local verifier derives its expected eight digit response using the binary
nonce and full SI. The QR is the protected transport of the same session data.
A reader can inspect the envelope shape without recovering the protected body.

<a name="qr-envelope-inspection"></a>

### Inspection

[QR inspector](protocol-lab.md#inspection-qr-envelope-inspector) validates the Base64,
lengths and public prefix without interpreting uncertain field widths.
The [example envelope](protocol-lab.md#examples) is a layout fixture with zero
ciphertext bytes, not a real device challenge.

<a name="qr-envelope-evidence"></a>

### Evidence

[ZZI8 technical report](../evidence/sources/zzi8-report.md), sections 6 through 8,
provides the current protocol reconstruction. Local primary excerpts include the
[identity builder](../evidence/zzi8/identity-builder.txt),
[handler](../evidence/zzi8/otp-handler.txt) and
[renderer](../evidence/zzi8/qr-renderer.txt).

<a name="interface-state"></a>

## Interface and session state

<a name="interface-state-display-responsibilities"></a>

### Display responsibilities

The display routine shows model identification, control hints, the QR, the
`INPUT` field and a menu. The handler owns the input buffer, selected menu index,
attempt counter, SI and nonce. Redrawing the interface does not itself start a
new authorization session.

| State | Updated by | Lifetime |
| --- | --- | --- |
| SI and binary nonce | Identity builder | One opening of the hidden screen |
| QR matrix | Encoder | Same session as SI |
| Menu selection | Volume buttons | Interactive input loop |
| Entered digits | Numeric selections and BACK SPACE | Cleared after rejected submission |
| Attempt counter | Failed DONE submission | Three submissions per opening |
| Runtime gate flag | Caller on successful return | Current Download path |
| Persistent DMC record | Trusted storage policy path | Survives screen interaction |

<a name="interface-state-menu-processing"></a>

### Menu processing

The 13 entries are `DONE`, `BACK SPACE`, `POWER OFF`, followed by digits zero
through nine. Volume Up decrements the selection, Volume Down increments it,
and the index wraps modulo 13. Power activates the selected entry.

The input buffer accepts up to 10 characters. Verification expects an exact
match to the formatted eight digit string. This explains why extra digits,
missing digits and missing leading zeros fail.

<a name="interface-state-submission-and-retry"></a>

### Submission and retry

1. DONE triggers derivation of the expected response.
2. The handler compares the entered and expected strings.
3. Success returns zero to the D2 caller.
4. Failure displays an invalid input message with the retry count.
5. The code waits for a new key transition acknowledging the message.
6. The entered buffer is cleared.
7. If another submission remains, the same QR and menu are redrawn.
8. After the third error, the handler exits with failure.

<a name="interface-state-cancellation-and-preparation-failure"></a>

### Cancellation and preparation failure

POWER OFF enters a cancellation path. The observed handler and caller use
firmware cleanup/reset services; the label does not establish identical
power behavior on every build. Preparation errors can occur before the menu,
including unavailable RNG, failed identity construction, key loading,
encryption, Base64 conversion and allocation failures.

> **Note:** A wrong key during the opening sequence resets sequence progress.
> It is separate from submitting a wrong OTP with DONE.

<a name="interface-state-evidence"></a>

### Evidence

[Handler excerpt](../evidence/zzi8/otp-handler.txt),
[display excerpt](../evidence/zzi8/otp-menu.txt) and
[D2 caller excerpt](../evidence/zzi8/d2-screen.txt) preserve these responsibilities.
[Complete flow](../flowchart.md) diagrams the same stages.

<a name="otp-reconstruction"></a>

## Reconstruction and response requirements

The hidden screen displays a challenge for one session and accepts an eight digit response from an authorized operator. An ordinary QR reader recovers the challenge text, not the response. The research reconstructed the phone side behavior but did not identify the remote application or recover the matching private key.

<a name="otp-reconstruction-what-the-reconstruction-establishes"></a>

### What the reconstruction establishes

| Stage | Recovered behavior | Local evidence |
| --- | --- | --- |
| Persistent policy | Android and trusted storage supply the policy consumed by D2 | [Android policy](system.md#android-policy), [VaultKeeper](system.md#vaultkeeper) |
| Hidden screen entry | D2 recognizes its key sequence and calls the session handler | [D2 screen excerpt](../evidence/zzi8/d2-screen.txt), [function map](research.md#function-map) |
| Session creation | LinuxLoader collects identity fields and generates fresh random session data | [Identity builder](../evidence/zzi8/identity-builder.txt) |
| Challenge display | A public header and RSA protected body are encoded into the QR | [QR envelope](#qr-envelope), [renderer excerpt](../evidence/zzi8/qr-renderer.txt) |
| Input and verification | The handler maintains input and retries and compares the submitted response locally | [Handler excerpt](../evidence/zzi8/otp-handler.txt), [interface state](#interface-state) |
| Successful return | The caller clears the runtime gate for the current Download path | [D2 screen excerpt](../evidence/zzi8/d2-screen.txt) |

Maintenance Mode belongs to the first row. Its Android credential and profile lifecycle do not produce the hidden screen's OTP.

<a name="otp-reconstruction-what-is-needed-to-obtain-the-code"></a>

### What is needed to obtain the code

For a real device session, the documented route is to provide the current QR to an authorized service operator capable of processing that challenge. The repository does not identify the service application, endpoint, account requirements or a publicly available code provider. It therefore cannot supply a working manufacturer service URL or guarantee access to that service.

The body is protected with the firmware's public RSA key. Recovering that public key or reading the public header does not reveal the private body. The matching private key was not found in the analyzed artifacts. A newly generated laboratory key pair is independent and cannot open a challenge created with the firmware's key.

A synthetic laboratory reproduction can check the research model using data and keys controlled by the researcher. That establishes consistency of the reproduction; it does not demonstrate authorization of a physical device or compatibility with every firmware header. See [laboratory scope and limits](protocol-lab.md#laboratory).

<a name="otp-reconstruction-questions-that-still-need-evidence"></a>

### Questions that still need evidence

| Question | Current status | Evidence needed to resolve it |
| --- | --- | --- |
| Which authorized application processes this QR? | Not identified | Manufacturer/service documentation or an authorized service workflow |
| Does the reconstruction match an authorized real response? | Not established by a synthetic round trip | A consented, version labelled service validation record |
| Are all textual header widths correct? | Qualified by imperfect decompilation | Exact formatting evidence and a redacted capture for the same build |
| Does the verifier enforce a local time expiry? | No counter identified in the analyzed verifier | Build specific control flow evidence; absence here does not establish remote policy |
| Does the same behavior apply to another model/build? | Not established | Separate artifact identities and corresponding source evidence |

Keep real captures, device identifiers and service credentials out of published examples. Use synthetic or redacted fixtures when recording validation results.

<a name="otp-reconstruction-how-to-read-the-reconstruction"></a>

### How to read the reconstruction

Start with the [complete flow](../flowchart.md) for the session lifecycle, then use the [function map](research.md#function-map) to identify the build and module for each excerpt. Check caller relationships and data boundaries against the preserved evidence. A string or similarly named TA method alone does not establish participation in the screen path.

The [version notes](research.md#version-notes) separate current ZZI8 conclusions from historical interpretations that attributed the nonce or screen response to TA/RPMB operations. Android runtime observations can establish policy behavior; they do not establish how a bootloader only screen calculates its response.

For each new research claim, record build, artifact hash, source range, whether the result is static or observed on-device, and what remains untested. Preserve the original evidence separately from the explanation.
