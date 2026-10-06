# Manifesto dos artefatos D2

Este diretório reúne o material utilizado na análise D2/QR/OTP. Ele foi movido
de `/home/matias/Downloads/firmware_extract/` para manter a pesquisa completa
dentro do projeto `D2Vault-Research`.

## Entradas principais

| Artefato | SHA-256 | Observação |
|---|---|---|
| `analysis/extracted/abl.elf` | `0993103dd7528e258d22ca7076fe8a9a517912e2f47edf63ddeee486301fb839` | ABL da combination de 2023 |
| `analysis/current/source_abl.img` | `73f583e0f6bef3263999f4a77b23a852447e3047443a16b3ab12eaaf5c3f419d` | ABL mais novo com fluxo D2/QR/OTP |
| `analysis/current/pe/001250e8_LinuxLoader.efi` | `993016ab7a70454950b55c9030db67828ca53ce99af1462e8262deebed4d5757` | módulo principal analisado |
| `analysis/current/vaultkeeper.mbn` | `72b7c0e5b525c782cee8e241d8a71de87c61dfbed3e1040acedf3ce41f13d165` | TA VaultKeeper da geração mais nova |
| `analysis/current/d2_otp_public_key.der` | `d66e3eda6f1b6e15172cc4e55958e710aa7708d75b66ba1e75ef293fae51f640` | chave pública RSA-4096 do envelope OTP |

## Documentação e evidências

- `RELATORIO_D2_QR_OTP.md`: relatório técnico consolidado.
- `analysis/TOOLS_INSTALLED.md`: ferramentas e configuração de ambiente.
- `analysis/DumpTargets.java`: script Ghidra usado para extrair as rotinas.
- `analysis/current-targets-final.txt`: decompilação final das funções-alvo.
- `analysis/current-otp-decomp.txt`: evidências específicas de SI/OTP.
- `analysis/current-linux-targets.txt`: referências do LinuxLoader.
- `analysis/ghidra-project/`: projeto Ghidra completo, mantido localmente.
- `analysis/toolenv/`: ambiente Python, reconstruído no novo caminho.

## Análise SAFZI1 (Capstone) — fluxo QR/OTP

Segunda análise independente, feita com harness Capstone próprio sobre o firmware
`S918BXXSAFZI1` (pacote `SAMFW.COM_SM-S918B_EUX_S918BXXSAFZI1_fac`), focada na tela
QR Code + OTP. Reside em `analysis/safzi1-capstone/`.

| Artefato | SHA-256 | Observação |
|---|---|---|
| `analysis/safzi1-capstone/extracted/mods/mod_000000a8.pe` | `f188d58dc0a0763ffecf8f68b9f2916d20e018e90cd41d7d98cbed2b1ed6fadd` | OdinApp.efi (SAFZI1) |
| `analysis/safzi1-capstone/extracted/mods/mod_001230e4.pe` | `8bb0f540a84da661dade1b273f9d307c265dd57f5563c88ae4d8c11686412174` | LinuxLoader.efi (SAFZI1) — módulo do QR/OTP |
| `analysis/safzi1-capstone/extracted/vaultkeeper.mbn` | `72b7c0e5b525c782cee8e241d8a71de87c61dfbed3e1040acedf3ce41f13d165` | TA VaultKeeper (SAFZI1) |

- `RELATORIO_D2_QRCODE_OTP_SAFZI1.md`: relatório técnico completo desta análise.
- `analysis/safzi1-capstone/tools/pe.py`: harness Capstone (loader PE, disasm com resync, auto-naming, xrefs).
- `analysis/safzi1-capstone/evidence/*.asm`: dumps anotados das funções-chave
  (`make_si 0xd4ce0`, `check_otp_input 0xd5f28`, `display_otp_mode 0xd5d40`,
  `draw_qrcode 0xd5950`, `get_did 0xd8460`, `hmac 0xa5f20`,
  `otp_wrapper 0xd6700`, `dlmode_handler 0x70650`).
- `analysis/safzi1-capstone/extracted/`: ABL/FV/payload, OdinApp, LinuxLoader, TA vk, tz, uefi.

> Firmware-fonte completo (inclui AP de ~17 GB) permanece em
> `/home/matias/Downloads/SAMFW.COM_SM-S918B_EUX_S918BXXSAFZI1_fac/`. Não foi
> duplicado para o repo por volume; apenas as partições de bootloader/TEE
> relevantes foram centralizadas aqui.

## Observação sobre Git

Imagens integrais, dados sensíveis configurados, projeto Ghidra e ambiente
Python permanecem disponíveis localmente e são ignorados pelo Git. Relatórios,
scripts, manifestos, dumps textuais e artefatos extraídos selecionados podem ser
versionados para reprodução da pesquisa.
