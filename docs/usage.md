# Using the hidden screen

> **Related articles:** [Overview](../README.md) · [Complete flow](../flowchart.md)

Opening the screen, obtaining a session response, entering digits and understanding the result.

## Contents

1. [Opening the screen](#opening-screen)
2. [QR and code entry](#qr-and-code)

<a name="opening-screen"></a>

## Opening the screen

The key sequence opens the hidden authorization screen from D2.

<a name="opening-screen-procedure"></a>

### Procedure

Keep **Power held** throughout the following steps:

| Step | Action |
| --- | --- |
| 1 | Tap Volume Up 8 times |
| 2 | Tap Volume Down 5 times |
| 3 | Tap Volume Up 9 times |

Release Volume after each tap while keeping Power held.

<a name="opening-screen-troubleshooting"></a>

### Troubleshooting

Holding Volume does not count as multiple taps. A wrong key or releasing Power
cancels the sequence. Start again from the first step.

<a name="opening-screen-result"></a>

### Result

After all 22 taps, the QR and code entry screen opens.

> **Note:** Opening the screen does not authorize Download Mode. A valid eight
> digit code is still required. See [QR Code and OTP](#qr-and-code).

<a name="qr-and-code"></a>

## QR and code entry

The hidden screen contains a QR Code for the current authorization session,
an **INPUT** field and a menu for entering an eight digit code, also called an OTP.

<a name="qr-and-code-session-qr"></a>

### Session QR

<p align="center">
  <img src="../images/otp-screen.jpg" alt="Hidden authorization screen with QR, input field and menu" width="540">
</p>

An authorized operator uses the QR to provide the code for this session.
Scanning the QR with an ordinary reader does not reveal the answer.

<a name="qr-and-code-menu"></a>

### Menu

Volume Up/Down moves the selection. Power activates the selected item.

| Item | Action |
| --- | --- |
| **0 to 9** | Add a digit to INPUT. Include leading zeros. |
| **BACK SPACE** | Delete the last digit. |
| **DONE** | Submit the code for verification. |
| **POWER OFF** | Cancel; the analyzed firmware restarts the device. |

<a name="qr-and-code-verification"></a>

### Verification

| Outcome | Result |
| --- | --- |
| Correct code | Continue to Download Mode confirmation for this session |
| First or second incorrect submission | Clear the input and try again |
| Third incorrect submission | End the session and restart |

> **Warning:** There are three submissions in total. The expected code remains
> the same while this session is open.

<a name="qr-and-code-new-session"></a>

### New session

Reopening the hidden screen creates a new session. Request a code for the new QR.

> **Note:** Successful authorization does not permanently remove the stored
> restriction. See [Complete flow](../flowchart.md) for the documented behavior.

<a name="qr-and-code-reconstruction-and-response-requirements"></a>

### Reconstruction and response requirements

[OTP reconstruction](protocol.md#otp-reconstruction) maps the local evidence and explains what is needed to obtain a valid response. The authorized service application and matching private key were not recovered by this research.
