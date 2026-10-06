# 1. Escopo e dispositivo

## Objetivo

Verificar tecnicamente as afirmações do documento `D2_Error.md` do projeto DFReroot:

- existência de `com.android.server.DmcService`;
- existência do vault lógico `DMC`;
- formato e atualização dos flags;
- participação do VaultKeeper/TEE;
- consumo desses dados pelo bootloader Qualcomm (`abl`);
- nível de acesso possível via ADB e root.

## Dispositivo analisado

| Campo | Valor observado |
|---|---|
| Modelo | Samsung Galaxy S23 Ultra (`SM-S918B`, `dm3q`) |
| Firmware | `CP2A.260605.016.S918BXXUAZZI8` |
| Bootloader | `S918BXXUAZZI8` |
| Android | 17 |
| Patch | `2026-08-05` |
| Verified Boot | `green` |
| Estado do bootloader | `locked` |
| Transporte | ADB USB |
| Root posterior | KernelSU, UID 0, domínio `u:r:ksu:s0` |

A data registrada durante a análise foi 2026-10-01, conforme o ambiente e o relógio do dispositivo.

## Regras adotadas

- análise inicialmente read-only;
- nenhuma chamada Binder de escrita;
- nenhuma alteração de flags;
- dumps temporários removidos do aparelho ao término;
- binários Samsung não incluídos no repositório;
- diferenciação explícita entre fato observado e inferência.
