# Relatório de Engenharia Reversa — Tela azul do bootloader, erro **D2** e fluxo **QR Code + OTP**

> **Errata de endereços e entrada (revisão de 2026-10-04).** Uma segunda
> passagem com Ghidra isolou a máquina de estados completa no próprio SAFZI1:
> a tela D2 e a sequência ficam em `FUN_000d6700`, e a tabela de 22 palavras em
> `0x1ac6d0` contém literalmente `0x81 × 8`, `0x82 × 5`, `0x81 × 9`.
> Portanto, a descrição antiga abaixo que atribuía a contagem a uma camada
> anterior está superada. O mapa revisado de teclas e rotas USB/serial está em
> [`docs/17-rotas-alternativas-teclas-usb-serial.md`](../../docs/17-rotas-alternativas-teclas-usb-serial.md).

**Dispositivo:** Samsung Galaxy S23 Ultra — `SM-S918B` (EUX)
**Firmware analisado:** `S918BXXSAFZI1` (binário), build `MQB114515121`, OS16
**Pacote:** `SAMFW.COM_SM-S918B_EUX_S918BXXSAFZI1_fac.zip`
**Data da análise:** 2026-10-04
**SoC:** Qualcomm Snapdragon 8 Gen 2 (bootloader ABL/aboot UEFI AArch64, QSEE/QTEE)
**Projeto de referência:** `/home/matias/Projects/D2Vault-Research/` (fluxo DMC/D2 já documentado)

> **Escopo e autorização.** Análise estática de firmware obtido publicamente, em hardware próprio, para fins de pesquisa e documentação defensiva. O objetivo é **entender e documentar** como o bootloader monta a tela de QR Code + OTP (One-Time Password) acessível pela combinação de teclas, incluindo a origem dos dados, o formato do QR e o algoritmo de verificação da OTP. Nenhum segredo, chave privada ou token proprietário é reproduzido aqui; onde a chave/segredo reside em TEE/fuse, isso é descrito sem extraí-lo.

---

## 0. Sumário executivo

A tela azul do bootloader com o código **D2** é a **tela de lockdown do mecanismo DMC/VaultKeeper** (já documentada no projeto `D2Vault-Research`): quando o vault `DMC` devolve a política `[lock=1, maintenance=0, at=0]`, o `LinuxLoader` bloqueia o Odin/Download Mode e mostra `"[Reboot Device - D2]"`.

A combinação de teclas descrita (**8× Volume Up, 5× Volume Down, 9× Volume Up, sempre segurando Power**) leva a um **modo de manutenção/autorização** cujo coração é a função que chamei de **`check_otp_input`** no `LinuxLoader.efi`. Essa função:

1. Monta um **blob de identidade do aparelho** (`make_si` — *make System Information*) com campos `sw_version`, `pid`, `UN`, `model name`, `DID`, `IMEI` e, crucialmente, um **NONCE de 32 bytes** obtido do Trusted App `vk` (vaultkeeper) via protocolo UEFI (`GET_NONCE`, persistido em RPMB como `dmc_nonce`).
2. **Serializa** esse blob e o **codifica como QR Code** (biblioteca estilo *qrcodegen*, nível de correção de erro alto), renderizando-o na tela azul via `draw_qrcode`.
3. Mostra um **menu de entrada** (`display_otp_mode`) com os itens `DONE`, `BACK SPACE`, `POWER OFF`, `0`…`9`, navegável por **Volume Up/Down** e confirmado por **Power**, onde o operador digita uma **OTP de 8 dígitos**.
4. **Verifica a OTP** recomputando um **HOTP (HMAC-based One-Time Password, RFC 4226) de 8 dígitos** sobre o desafio (nonce + identidade), comparando com a entrada. Em caso de erro mostra `"Invalid input!!! Retry count (%d/%d)"`. O segredo compartilhado reside no TEE (`vk`, comando `GENERATE_HOTP_CODE`); há **fuse OTP anti-replay** ("blow OTP fuse") e contador de tentativas.

Em uma frase: **o QR Code é um "desafio" (challenge) que empacota a identidade do aparelho + um nonce gerado no TEE; o servidor da Samsung, que detém o segredo compartilhado, calcula o HOTP de 8 dígitos correspondente; o operador digita essa OTP; o bootloader recomputa o mesmo HOTP localmente (via TEE) e autoriza a operação de manutenção se baterem.** É um protocolo clássico de **challenge–response offline**.

---

## 1. Como o firmware foi aberto (cadeia de extração)

```
SAMFW...zip
└── BL_S918BXXSAFZI1_...tar.md5            (tarball de bootloaders, componentes .lz4)
    ├── abl.elf.lz4         → abl.elf        (ELF32 ARM, load 0x9FA00000)
    ├── uefi.elf.lz4        → uefi.elf
    ├── vaultkeeper.mbn.lz4 → vaultkeeper.mbn (ELF64 AArch64 — Trusted App "vk")
    └── tz.mbn.lz4, keymint.mbn.lz4, imagefv.elf.lz4 ...
```

### 1.1 ABL → Firmware Volume → módulos PE/COFF

O `abl.elf` contém um **payload LZMA** no offset `0x1078` (cabeçalho `5D 00 00 00 01`, formato `LZMA_ALONE`):

```
abl.elf @0x1078  (LZMA)  →  abl_payload.bin  (3 916 232 bytes)
abl_payload.bin @0x04     →  Firmware Volume UEFI (assinatura "_FVH" em +0x28)
```

O FV é **custom da Samsung** (tipos de arquivo não-FFS padrão), então os módulos foram recortados diretamente pelos cabeçalhos **PE32+ (`MZ`/`PE\0\0`, machine `0xAA64` = AArch64)**. Foram encontrados 5 módulos; os dois relevantes:

| Módulo recortado | Base no FV | ImageBase | `.text` | Identidade (por strings) |
|---|---:|---:|---:|---|
| `mod_000000a8.pe` | `0x000a8` | 0 | `0xCE000` | **OdinApp.efi** (`OdinMain`, `EM_CMD_*`, Odin/Download) |
| `mod_001230e4.pe` | `0x1230e4` | 0 | `0x141000` | **LinuxLoader.efi** (`draw_qrcode`, `display_otp_mode`, `BarCodeInitData`, `fastboot`, `EM_CMD_*`) |

> Como `ImageBase = 0`, **RVA = VA** nestes módulos, o que torna triviais as referências `adrp`/`add`. Todos os endereços neste relatório são RVAs dentro do respectivo módulo.

### 1.2 Hashes dos artefatos (SHA-256)

```
abl.elf                 b6d718a09b742b00d64c92978037a9db72cd0e0355a23c59f1eccd14baa1e485
abl_payload.bin         720aa8c1128e66044304df74705ff85e3a9c2d4334692b8d6765e1e6256ac25a
LinuxLoader (mod_1230e4) 8bb0f540a84da661dade1b273f9d307c265dd57f5563c88ae4d8c11686412174
OdinApp     (mod_000a8)  f188d58dc0a0763ffecf8f68b9f2916d20e018e90cd41d7d98cbed2b1ed6fadd
vaultkeeper.mbn (TA vk)  72b7c0e5b525c782cee8e241d8a71de87c61dfbed3e1040acedf3ce41f13d165
```

### 1.3 Metodologia de análise

- Desmontagem AArch64 com **Capstone**, com *resync* de 4 bytes sobre gaps de dados embutidos no `.text` (essencial: a desmontagem linear ingênua parava no primeiro byte de string e perdia todo o código seguinte).
- **Auto-nomeação de funções** explorando o padrão do *logger* interno `FUN_0x162c(nível, fmt, nome_da_função, ...)`: o 3º argumento é sempre o nome da função que emite o log. Isso recuperou **280 nomes** de função automaticamente (ex.: `make_si`, `display_otp_mode`, `em_token_get_status`, `GetUnlockCount`).
- Lista de funções construída a partir de **todos os alvos de `bl`** (3647 funções) + detecção de prólogos.
- As ferramentas estão em `analysis/tools/pe.py`; os dumps brutos das funções-chave em `analysis/evidence/*.asm`.

---

## 2. Onde o código do QR/OTP vive

Todas as strings do subsistema estão no **LinuxLoader.efi** (`mod_001230e4.pe`). O cluster de funções fica em `~0xD4CE0 – 0xD7xxx`:

| RVA | Nome (recuperado/atribuído) | Papel |
|---:|---|---|
| `0x70650` | *download/maintenance handler* | Entrada do modo; chama `BLInitToken`, o gate OTP e segue para o Odin |
| `0xd6700` | `otp_gate` (wrapper) | Gate de autorização antes de `check_otp_input` |
| `0xd5f28` | **`check_otp_input`** | **Orquestrador**: monta SI, codifica QR, laço de teclas, verifica OTP |
| `0xd4ce0` | **`make_si`** | Coleta identidade do aparelho + **NONCE** → blob "System Information" |
| `0xd5950` | **`draw_qrcode`** | Renderiza a matriz QR já calculada no framebuffer |
| `0xd5d40` | **`display_otp_mode`** | Desenha o menu de entrada e a string digitada |
| `0xd8460` | `get_did` | Monta o Device-ID a partir de fuses |
| `0xa5f20` | `hmac` | HMAC (init md, key, update, final) — base do HOTP |
| `0xf7f38`→`0xf6d54` | `qrcode_encode` | Codificador QR (estilo *qrcodegen*) |
| `0x5cd50` | `BarCodeInitData` | Monta o código de barras de serial (DeviceID) — caminho correlato |

Call graph observado:

```
main dispatch (0x8a98)
  └── download/maintenance handler (0x70650)
        ├── BLInitToken (0xd8b50)
        ├── otp_gate (0xd6700) ──► check_otp_input (0xd5f28/0xd5f10)
        │        ├── make_si (0xd4ce0)
        │        │     ├── <coleta sw_version/pid/UN/model/DID/IMEI>
        │        │     └── LocateProtocol(vk/EM GUID)->GetNonce()  [NONCE 32B]
        │        ├── qrcode_encode (0xf7f38 → 0xf6d54)
        │        ├── draw_qrcode (0xd5950)            [loop de refresh]
        │        ├── display_otp_mode (0xd5d40)       [menu + input]
        │        ├── ReadKeyStroke (0x32060)          [Vol Up/Down/Power]
        │        └── hmac (0xa5f20) → truncação → %08d → compara
        └── <segue para OdinApp / ação de manutenção>
```

---

## 3. A combinação de teclas e a entrada no modo

### 3.1 Semântica das teclas no laço

Dentro de `check_otp_input` (RVA `0xd6240`+) o laço lê teclas com `ReadKeyStroke` (`0x32060`), comparando o status com `EFI_NOT_READY` (`0x8000000000000006`). O valor da tecla (`[sp+0x1b8]`) é mapeado:

```
0xd63c0:  w20 == 1  → "VOL_UP"     (0x110bec)   → mover seleção p/ cima / +1
0xd63c8:  w20 == 2  → "VOL_DN"     (0x10cffc)   → mover seleção p/ baixo / -1
          outro     → Power/Select → confirma o item do menu
```

Log de diagnóstico: `"%a: Press %a (%d)"` (`0x100cf7`) com o nome da tecla.

### 3.2 A sequência 8–5–9 + Power

O gatilho de **8× Volume Up, 5× Volume Down, 9× Volume Up (com Power pressionado)** está dentro de `FUN_000d6700`, a mesma função que desenha a tela D2. A tabela em `DAT_001ac6d0` possui exatamente 22 palavras: oito `0x81`, cinco `0x82` e nove `0x81`. `0x81` é Power + Volume Up; `0x82` é Power + Volume Down. Depois de cada combinação, a máscara precisa voltar a `0x80` (Power sozinho) para incrementar o índice. Uma transição errada reinicia a tentativa.

Assim, a contagem é um fato extraído byte a byte do SAFZI1. Ela não é consumida antes de `0x70650`: o handler de Download chama `FUN_000d6700`, e esta aguarda a sequência antes de chamar `check_otp_input`.

---

## 4. `make_si` — a montagem do conteúdo do QR Code (o "desafio")

`make_si` (`0xd4ce0`) constrói um **dicionário de pares chave→valor** em pilha (uma tabela de ponteiros em `sp+0xA0…0xD8`, cada entrada apontando para um buffer de valor). É o núcleo do que vira o QR. Campos observados, com as strings de log que os identificam:

| Campo | Constante/Fonte no binário | Como é obtido |
|---|---|---|
| **model name** | `"SM-S918B"` (`0x114c18`) | constante; validado por tamanho (9–?) |
| **binary version** | `"S918BXXSAFZI1"` (`0x1136e6`) | constante do build |
| **code** | `"10004"` (`0x116ad9`) | constante (tipo/categoria do SI) |
| **sw_version** | log `"%a: get sw_version"` (`0xfbfd7`) | consulta runtime |
| **pid** | log `"%a: get pid"` (`0xf98e0`) | consulta runtime |
| **UN** (unique number/serial) | log `"%a: get UN"` (`0xf98ed`) | consulta runtime |
| **DID** (Device-ID) | log `"%a: get DID"` (`0xffb58`); `get_did` `0xd8460` | fuses (ver §4.1) |
| **IMEI** | log `"%a: get IMEI"` (`0x1032b1`) | consulta runtime |
| **NONCE** (32 bytes) | log `"%a: get NONCE"` (`0x10f6fd`) | **protocolo UEFI → TA vk** (ver §4.2) |

Cada valor é copiado com um helper de cópia segura (`0x5a80`, tipo `AsciiStrnCpyS`/`strlcpy`), e cada chave é resolvida por um `si_get`/lookup (`0x4f90`) contra um *handle* de container (`0x119417`). Há verificação de **MAX LENGTH ERROR** (`0xf98f9`) e de buffers *all-zero* (ex.: "get IMEI" não deve ser nulo).

### 4.1 `get_did` (`0xd8460`) — o Device-ID vem de fuses

```c
// pseudocódigo
char* get_did(void) {
    char* did = global_DID_buf;           // 0x1dffc0 (16 bytes)
    if (var_lookup("DID", did, 16) == OK)  // 0x12ebc
        return did;
    // senão, monta a partir de fuses do SoC:
    uint ek   = get_ek_fuse();            // 0xc5ac0
    uint a    = read_chip_value_1();      // 0x16d90
    uint b    = read_chip_value_2();      // 0x174a0
    sprintf(did, "%02x%04x%08x%01x%01x",  // 0xd8510
            ek & 0xff, a, b, ek&1, ...);
    return did;
}
```

Ou seja, o **DID é um identificador único derivado de eFuses** do chip (não é o IMEI nem o serial comercial). Isso garante que o desafio é **específico do aparelho** — o HOTP calculado pelo servidor só vale para aquele SoC.

### 4.2 O NONCE de 32 bytes vem do TEE (vaultkeeper `vk`)

Em `make_si` (`0xd5338`):

```asm
adrp x8, 0x1ad000 ; ldr x8,[x8,#0x758]   ; tabela de protocolos
ldr  x8,[x8,#0x140]                       ; método "LocateProtocol"
mov  x0, &GUID(0x141ba0)                   ; GUID = 3152bca5-eade-433d-862e-c01cdc291f44
blr  x8                                     ; localiza o protocolo EM/VaultKeeper
...
ldr  x0,[sp,#0x78]                          ; interface
mov  x1, &GUID(0x141aa0)                    ; e43176d7-b6e8-4827-b784-7ffdc4b68561
mov  w2, #0x20                              ; 32 bytes
add  x3, sp, #0x240                         ; buffer destino
ldr  x8,[x0,#8] ; blr x8                     ; iface->GetNonce(sub-GUID, 32, buf)
```

O nonce de **32 bytes** é lido e verificado contra *all-zero*. Essa é a materialização, no bootloader, do comando **`[CMD:GET_NONCE]`** do TA `vk`, que mantém nonces nomeados por domínio (`dmc_nonce`, `drk_nonce`, `aasa_nonce`, …) **persistidos em RPMB** (`vkqsee_read_nonce`/`vkqsee_write_nonce`). O nonce impede replay: muda a cada sessão de desafio.

GUIDs relevantes (em `.data` do LinuxLoader):
```
0x141ba0 = 3152bca5-eade-433d-862e-c01cdc291f44   (protocolo EM/VaultKeeper)
0x141aa0 = e43176d7-b6e8-4827-b784-7ffdc4b68561   (seletor/serviço de nonce)
```

### 4.3 Serialização e codificação do QR

Depois de `make_si` retornar o handle do SI, `check_otp_input` (`0xd5fe0`+) faz:

```c
si = make_si(...);                      // handle do dicionário
len = si_length(si);                    // 0xb6be4
memset(buf, 0, 0x1000);                 // 0x3a18
si_serialize(buf, si, ...);             // 0xa486c  → texto (campos concatenados)
append(global_a, buf, 0x1d);            // 0x5a80 → buffers globais 0x1df709 / 0x1df926
build_final(global_qr, global_a, 0x21d);// 0xd6e8c → string final do QR
...
qr = malloc(...);                       // 0x7018
qrcode_encode(&qr_struct, data, 0x1e, 3); // 0xf7f38 → 0xf6d54
```

- `qrcode_encode` (`0xf7f38`) calcula `len = strlen(data)` (`0x4ec0`) e chama o encoder real `0xf6d54` com **nível de correção de erro = 3** (ECC **H**, o mais alto) — coerente com uma tela de serviço que precisa ser lida por câmera em condições ruins.
- A struct resultante (`sp+0x38`) guarda o tamanho do lado da matriz no byte `+1` (lido por `draw_qrcode`).
- Diagnóstico: `"%a : qrcode.size : %d"` (`0xfd308`) imprime o tamanho da matriz.

**Conteúdo do QR (reconstruído):** um blob textual contendo os campos `{code=10004, model=SM-S918B, binary=S918BXXSAFZI1, sw_version, pid, UN, DID, IMEI, NONCE(32B)}`. Isto é o **challenge**: tudo que o servidor da Samsung precisa para (a) identificar unicamente o aparelho e (b) calcular a OTP correta para aquele nonce.

> Nota: os buffers `0x1df509/0x1df709/0x1df926` são **globais BSS** (zerados no arquivo, preenchidos em runtime). Por isso o texto exato só existe em execução; a **estrutura** acima foi reconstruída a partir do fluxo de dados, não de strings estáticas.

---

## 5. `draw_qrcode` (`0xd5950`) — renderização na tela azul

`draw_qrcode(qr_struct, x, y)`:

```c
int side = qr_struct->size;              // ldrb w8,[x25,#1]!
void* bmp = malloc(side*side * 100);     // 0x7018 ; 100 = bloco 10x10 px por módulo
for (int my = 0; my < side; my++)
  for (int mx = 0; mx < side; mx++) {
     int bit = qrcodegen_getModule(qr, mx, my);   // 0xf7fb0
     uint8_t c = bit ? 0x00 : 0xFF;               // preto se módulo setado, branco senão
     // escreve o bloco de pixels (stride 0x14) nas posições do framebuffer
     fill_cell(bmp, mx, my, c);
  }
```

Cada módulo QR vira um bloco de pixels (escala ~5–10×), com `csetm` escolhendo preto (`0x00`) para módulo setado e branco (`0xFF`) para vazio. O bitmap é então enviado ao display. A função é **puramente de desenho** — não decide conteúdo.

---

## 6. `display_otp_mode` (`0xd5d40`) — o menu de entrada da OTP

Desenha, via `GlibDisplayMessage` (`0x5f610`), a UI que acompanha o QR:

```
SM-S918B                                      (modelo + hash DID)
 ====================================
   Move/Scroll : Volume Up/Down key
   Select      : Power key
   Done        : Select DONE menu
 ====================================
 INPUT : <string digitada até agora>          (cor magenta 0xFF00FF)
 <lista de itens do menu, item selecionado em branco 0xFF, demais 0xFFFFFF>
```

A **tabela de itens** do menu está em `.data` no RVA `0x1ac668` (array de ponteiros):

```
[0] DONE      [1] BACK SPACE   [2] POWER OFF
[3] 0  [4] 1  [5] 2  [6] 3  [7] 4  [8] 5  [9] 6  [10] 7  [11] 8  [12] 9
```

O cursor (`w20`/`w26`) percorre esses itens; `Power` confirma. `DONE` finaliza a entrada, `BACK SPACE` apaga o último dígito, `POWER OFF` desliga. Assim o operador digita **8 dígitos** (0–9) para formar a OTP.

---

## 7. Verificação da OTP — **HOTP (RFC 4226) de 8 dígitos**

Esta é a parte criptográfica central, em `check_otp_input` (`0xd655c`–`0xd6604`):

```c
char* input = si_or_challenge_buf;         // sp+0x78 (desafio: nonce+identidade)
int   ilen  = AsciiStrLen(input);          // 0x4ec0 ; validado em faixa (~0x11d..)

// 1) HMAC do desafio com a chave de 32 bytes
uint8_t mac[32];
hmac(/*key*/ key32 /*sp+0x50*/, /*keylen*/ 0x20,
     /*msg*/ input /*sp+0x78*/, /*msglen*/ ilen,
     /*out*/ mac   /*sp+0x1b8*/);           // 0xa5f20

// 2) Truncação dinâmica (RFC 4226 §5.3)
int off = mac[last] & 0x0F;                 // 0xd6594: ldrb ... and #0xf
uint32_t bin = ((mac[off]   & 0x7F) << 24)  // bfi #0x18,#7  → zera o bit de sinal
             | ( mac[off+1]        << 16)
             | ( mac[off+2]        << 8 )
             |   mac[off+3];

// 3) Reduz a 8 dígitos decimais
uint32_t otp = bin % 100000000;             // 0x5F5E100 via mult. recíproca (magic 0x55E63B89, shift 57)
char expected[9];
sprintf(expected, "%08d", otp);             // "%08d" @0x114067

// 4) Compara com o que o usuário digitou
if (AsciiStrCmp(user_input /*sp+0x1a8*/, expected) == 0)   // 0x4f90
     → AUTORIZADO
else
     mostra "Invalid input!!! Retry count (%d/%d)"          // "Invalid input" @0x112e54
```

Evidências decisivas:
- **`and w, w, #0xf`** sobre o último byte do MAC = *offset* da truncação dinâmica (assinatura inequívoca de HOTP).
- **`& 0x7F` no byte alto** = mascaramento do bit de sinal (31 bits), exatamente como RFC 4226.
- **Módulo 10⁸** (`w10 = 0x05F5E100 = 100 000 000`) implementado por multiplicação recíproca (`0x55E63B89`, `lsr #57`) + `msub` → **8 dígitos**.
- **`"%08d"`** formata o resultado com zeros à esquerda.
- **`hmac` (`0xa5f20`)**: inicializa contexto (`0xa5cbc`, *md* padrão em `0x1d3780`), define chave (`0xa5990`, chave padrão `0x138900` se nula), `update` (`0xa5bc4`) e `final` — estrutura canônica de HMAC.

### 7.1 Onde está o segredo e o papel do TEE

O HMAC acima usa uma **chave de 32 bytes** (`key32`). O segredo compartilhado real **não está em claro no bootloader**: o TA `vk` expõe **`[CMD:GENERATE_HOTP_CODE]`** e usa `sha256`/`HMAC_SHA512` internamente, com material de chave protegido em TEE/RPMB. O modelo de segurança é:

- O **servidor da Samsung** detém o segredo mestre e, a partir do QR (identidade + nonce), calcula o HOTP de 8 dígitos e o entrega ao operador como OTP.
- O **aparelho** recomputa o mesmo HOTP — localmente no ABL com a chave derivada e/ou delegando ao TA `vk` (`GENERATE_HOTP_CODE`) — e compara.
- **Anti-replay:** o TA pode **queimar um fuse OTP** (`"blow OTP fuse"`, `"check OTP value(%d/%d)"`) e/ou girar o `dmc_nonce` em RPMB, de modo que cada OTP só vale uma vez. Há ainda o **contador de tentativas** ("Retry count").

### 7.2 O gate de autorização (`0xd6700`)

Antes de rodar a verificação, `otp_gate` (`0xd6700`) confere condições (`0xd3a30`, `0xd87f0(0x16)` e o formatador de DID `0xd8510`) e zera um flag global (`0x1ac438`). Só então o corpo de `check_otp_input` executa. É o ponto que decide se a tela OTP é oferecida.

---

## 8. Relação com a tela **D2** e com o lockdown DMC

Do projeto `D2Vault-Research` (confirmado e consistente com este firmware):

- O Android grava no vault **DMC** três sinais `[lock, maintenance, at]`.
- No boot de Download/Odin, o `LinuxLoader` chama `DmcCheckLockdown` → envia `{0xC0DE0003, 0xBC06}` ao TA `vk` → lê `payload[32]` → testa `payload[0..2] == [1,0,0]`.
- Se verdadeiro, grava em `DevAuthInfo+0x168` e `FUN_000d6700` desenha **`"[Reboot Device - D2]"`** com `"Volume Down + Power key for 7 seconds"`, bloqueando o Odin num laço. O endereço `0xd70a0` era uma identificação incorreta para este build.

**Como o QR/OTP se encaixa:** a tela D2 é o *bloqueio*; o fluxo QR+OTP é o **caminho de autorização/manutenção** paralelo. Ambos vivem no mesmo módulo (`LinuxLoader.efi`), compartilham o mesmo TA `vk` (nonce em RPMB, EM tokens) e o mesmo `DevAuthInfo`. A OTP válida é o mecanismo pelo qual um técnico autorizado **prova posse do segredo do servidor** para destravar/operar o aparelho sem derrubar as proteções — um challenge-response offline em vez de desbloqueio por senha local.

---

## 9. O subsistema **EM** (tokens/licenças de engenharia) — contexto de apoio

Tanto o `OdinApp.efi` quanto o `LinuxLoader.efi` embarcam o subsistema **EM** (centenas de strings `[EM]...`), que é a infraestrutura de **tokens assinados de engenharia/manutenção** da Samsung, com PKI completa:

- **PKI:** `root CA pubkey`, `Dev CA pubkey`, `server pubkey`, `server cert` — verificação de cadeia (`X509_verify`, RSA-OAEP, EVP GCM/CTR, HMAC, SHA).
- **Comandos:** `EM_CMD_INIT`, `EM_CMD_INSTALL_TOKEN`, `EM_CMD_GET_MODES(_BIT)`, `EM_CMD_GET_STATUS`, `EM_CMD_REQ_TOKEN_ESS_V1`, `EM_CMD_RECOVERY_ESS_V1`, `EM_CMD_GET_TUC`, etc.
- **Estruturas:** `ESI` (Encrypted Secure Info), `ESS`, `TUC` (Token Usage Count), `tokens` com expiração, `did`, `modes`, `nonce`, `otp`.
- **Persistência:** RPMB (`vkqsee_*_rpmb`, blocos DMC `0xB0/0xB2`), fuses.

A OTP de 8 dígitos (HOTP) é o fator "humano/offline" leve desse ecossistema; o EM/token é o fator "criptográfico/assinado" pesado (certificados + tokens com contador de uso). Os dois coexistem: a OTP autoriza ações rápidas de manutenção; os tokens EM autorizam modos persistentes (ESS/ESI).

---

## 10. Fluxo de ponta a ponta (consolidado)

```
┌─ Operador: 8× Vol+, 5× Vol−, 9× Vol+  (segurando Power) ──────────────────┐
│                                                                            │
│  SBL/ABL varredura de teclado (0x56350/0x627c0) → seleciona MODO MANUTENÇÃO│
│                                                                            │
├─ LinuxLoader: handler 0x70650 → BLInitToken → otp_gate (0xd6700) ──────────┤
│                                                                            │
│  check_otp_input (0xd5f28):                                                │
│   1. make_si (0xd4ce0):                                                     │
│        coleta sw_version, pid, UN, model=SM-S918B, DID(fuses), IMEI         │
│        GET_NONCE (32B) via protocolo → TA vk → RPMB (dmc_nonce)             │
│        → SI = "code=10004;model=SM-S918B;binary=S918BXXSAFZI1;...;NONCE"    │
│   2. qrcode_encode(SI, ECC=H) (0xf7f38→0xf6d54)                             │
│   3. draw_qrcode (0xd5950)  ── pinta o QR na tela azul                      │
│   4. display_otp_mode (0xd5d40) ── menu: DONE/BACKSPACE/POWEROFF/0..9       │
└────────────────────────────────────────────────────────────────────────────┘
                 │  QR (challenge)                       ▲  OTP (8 dígitos)
                 ▼                                       │
        ┌─────────────────────────┐          Operador digita via Vol/Power
        │  Servidor Samsung        │          (Vol+/− move, Power seleciona)
        │  detém segredo mestre    │
        │  OTP = truncate(HMAC(    │
        │     segredo, nonce+id))  │
        │        ) mod 10^8        │
        └─────────────────────────┘
                 │ OTP
                 ▼
   check_otp_input verifica:
     mac = HMAC(key32, challenge)           (0xa5f20)
     off = mac[last] & 0xF
     otp = ((mac[off]&0x7F)<<24|...) % 1e8  → "%08d"
     se otp == entrada → AUTORIZADO
        (TA: GENERATE_HOTP_CODE / blow OTP fuse / gira nonce RPMB)
     senão → "Invalid input!!! Retry count (%d/%d)"
```

---

## 11. Matriz de confiança das conclusões

| Afirmação | Estado | Evidência |
|---|---|---|
| Código do QR/OTP está no `LinuxLoader.efi` | **Confirmado** | strings + xrefs em `mod_001230e4.pe` |
| `make_si` monta identidade {sw_version, pid, UN, model, DID, IMEI, NONCE} | **Confirmado** | disassembly `0xd4ce0`; strings `%a: get …` |
| NONCE de 32 bytes vem do TA `vk` (GET_NONCE, RPMB) | **Confirmado** | protocolo `0xd5338`; strings TA `[CMD:GET_NONCE]`, `dmc_nonce` |
| DID derivado de eFuses | **Confirmado** | `get_did 0xd8460` + `%02x%04x%08x%01x%01x` |
| QR é renderizado por `draw_qrcode` a partir de matriz qrcodegen, ECC alto | **Confirmado** | `0xd5950`, `0xf7f38→0xf6d54`, `qrcode.size` |
| Menu de entrada = DONE/BACKSPACE/POWEROFF/0–9, Vol move, Power seleciona | **Confirmado** | tabela `0x1ac668`; strings de UI; laço de teclas |
| OTP é HOTP (RFC 4226) de **8 dígitos** | **Confirmado** | truncação `&0xf`/`&0x7f`, `% 1e8`, `"%08d"`, `hmac 0xa5f20` |
| Segredo reside no TEE; anti-replay por fuse/nonce | **Confirmado (TA)** | `[CMD:GENERATE_HOTP_CODE]`, `blow OTP fuse`, `check OTP value` |
| Relação com lockdown D2/DMC | **Confirmado** | consistente com `D2Vault-Research` (DevAuthInfo, `vk`) |
| Contagem exata 8/5/9 do combo | **Confirmado** | tabela de 22 palavras em `0x1ac6d0`: `0x81×8`, `0x82×5`, `0x81×9` |
| Chave HMAC = nonce vs. segredo derivado (ordem exata dos args) | **Plausível** | estrutura HOTP certa; mapeamento fino de args parcial |

---

## 12. Perguntas em aberto / próximos passos sugeridos

1. **Concluído:** a sequência 8/5/9 foi isolada em `FUN_000d6700`, tabela `0x1ac6d0`.
2. **Mapear argumentos exatos de `hmac` (`0xa5f20`)** e a origem precisa de `key32` (`sp+0x50`): confirmar se é o nonce, um segredo derivado de fuse, ou retorno de `GENERATE_HOTP_CODE`.
3. **Reconstruir `GENERATE_HOTP_CODE` no TA `vk`** (vaultkeeper.mbn): confirmar algoritmo (SHA-256 vs SHA-512), moving factor/counter e a semântica do fuse OTP.
4. **Serialização do SI (`0xa486c`)**: capturar em runtime o texto exato do QR (campos/delimitadores) — exige execução/emulação autorizada.
5. **Diferença de versões**: comparar com firmware anterior/posterior para datar a introdução do fluxo HOTP.

---

## 13. Artefatos deste relatório

```
analysis/
├── RELATORIO_D2_QRCODE_OTP.md        (este documento)
├── tools/pe.py                        (harness Capstone: PE loader, disasm resync, auto-naming, xrefs)
├── extracted/
│   ├── abl.elf, abl_payload.bin, abl_fv.bin
│   ├── mods/mod_000000a8.pe   (OdinApp.efi)
│   ├── mods/mod_001230e4.pe   (LinuxLoader.efi)
│   └── vaultkeeper.mbn, tz.mbn, uefi.elf, imagefv.elf, keymint.mbn
└── evidence/                          (dumps anotados das funções-chave)
    ├── make_si_0xd4ce0.asm
    ├── check_otp_input_0xd5f28.asm
    ├── display_otp_mode_0xd5d40.asm
    ├── draw_qrcode_0xd5950.asm
    ├── get_did_0xd8460.asm
    ├── hmac_0xa5f20.asm
    ├── otp_wrapper_0xd6700.asm
    └── dlmode_handler_0x70650.asm
```

---

*Relatório produzido por análise estática (Capstone/AArch64) do firmware `S918BXXSAFZI1`. Endereços são RVAs nos módulos PE indicados. Material proprietário (chaves, tokens, segredos de TEE) não é reproduzido.*
