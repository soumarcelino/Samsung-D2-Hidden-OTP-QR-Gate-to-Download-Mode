# Engenharia reversa do fluxo D2, QR Code e OTP

## 1. Resumo executivo

Esta análise reconstrói o caminho entre o estado persistente `DMC`, a tela azul
`D2`, a combinação secreta de teclas, a geração do QR Code e a verificação do
OTP no bootloader do Samsung SM-S918B.

O resultado principal é:

1. O Android grava três flags no vault `DMC`: `lock`, `maintenance` e
   `at_command`.
2. O Trusted Application (TA) `vk` persiste o vault em RPMB, usando para o DMC
   os blocos funcionais primário/alternativo `0xb0` e `0xb2`.
3. Durante o boot para Download Mode, o ABL consulta o vault `0xbc06` com o
   comando `0xc0de0003`.
4. O estado exato `[1, 0, 0]` ativa `DevAuthInfo.dmc_lockdown` e impede a entrada
   imediata no OdinApp.
5. A rotina em RVA `0xd70a0` mostra `[Reboot Device - D2]` e entra num loop de
   leitura das teclas.
6. Mantendo Power pressionado, a sequência esperada é exatamente:

   ```text
   8 × Volume Up
   5 × Volume Down
   9 × Volume Up
   ```

7. Concluídos os 22 passos, a rotina em RVA `0xd68b0` cria uma SI (System/Service
   Information) específica daquela sessão, cifra sua parte sensível com uma
   chave pública RSA embutida, codifica o envelope em Base64 e o transforma em
   QR Code.
8. O mesmo nonce aleatório de 32 bytes incluído na SI é usado como chave de
   HMAC-SHA-256 sobre a SI textual. O digest de 32 bytes sofre truncamento
   dinâmico, módulo `100000000`, e formatação `%08d`. Este é o OTP esperado.
9. O operador digita o OTP por um menu controlado por Volume Up/Down e Power.
   Após três respostas inválidas, a interface encerra a tentativa. Um OTP
   correto faz a rotina retornar sucesso ao fluxo D2.

O QR não contém o OTP em claro. Ele transporta uma identificação curta em
claro e um bloco RSA cifrado que permite ao sistema autorizado recuperar a SI,
inclusive seu nonce, e então calcular o mesmo OTP.

## 2. Escopo, imagens e diferença de versões

### 2.1 Firmware entregue inicialmente

Diretório analisado:

```text
/home/matias/Projects/D2Vault-Research/evidence/firmware_extract/
```

A imagem inicial é uma combination/factory build de 2023, identificada como
`COMBINATION_FAC_FAT0_S918BFAU3AWF1`. Ela contém ABL, XBL, UEFI, VaultKeeper,
super image e as demais partições usuais. O ABL desta versão usa o vault FMM
`0xbc04`; ele não contém a implementação mais nova de QR/OTP descrita neste
relatório.

Hash relevante:

```text
abl.elf (combination 2023)
SHA-256 0993103dd7528e258d22ca7076fe8a9a517912e2f47edf63ddeee486301fb839
```

Essa divergência é importante: procurar somente na combination antiga leva à
conclusão incorreta de que o fluxo secreto não existe. A confirmação foi feita
na imagem ABL mais nova já presente no ambiente de pesquisa e compatível com a
documentação do projeto auxiliar:

```text
/home/matias/Projects/SamsungD2BrickProtect/research/partitions/abl.img
SHA-256 73f583e0f6bef3263999f4a77b23a852447e3047443a16b3ab12eaaf5c3f419d
```

Uma cópia dessa imagem foi preservada junto às evidências em
`analysis/current/source_abl.img`, evitando dependência do outro projeto.

O `LinuxLoader.efi` extraído dessa geração tem:

```text
SHA-256 993016ab7a70454950b55c9030db67828ca53ce99af1462e8262deebed4d5757
```

Ele referencia a build `S918BXXUAZZI8` e contém as strings `check_otp_input`,
`display_otp_mode`, `qrcode.size`, `draw_qrcode`, `%08d` e
`Volume Down + Power key for 7 seconds`.

### 2.2 Projeto auxiliar

Foi correlacionado todo o material em:

```text
/home/matias/Projects/D2Vault-Research/
```

Esse projeto fornece a cadeia Android → VaultKeeper → TA `vk` → RPMB → ABL.
A nova análise acrescenta a parte que ainda não estava documentada: o gate de
22 teclas, a SI, o envelope RSA/Base64, o QR Code e o cálculo local do OTP.

## 3. Arquitetura de ponta a ponta

```text
Android / DmcService
  │ grava [lock, maintenance, at_command]
  ▼
VaultKeeperManager("DMC") / vaultkeeperd / HAL
  ▼
Trusted Application vk
  │ armazenamento autenticado
  ▼
RPMB: blocos DMC 0xb0 e 0xb2
  ▲
  │ ABL envia { command=0xc0de0003, vault_id=0xbc06 }
  │ bytes LE: 03 00 de c0 06 bc 00 00
  ▼
DevAuthInfo.dmc_lockdown
  ├── 0: OdinApp/Download Mode pode continuar
  └── 1: tela azul D2
          ▼
      Power + sequência 8/5/9
          ▼
      SI + nonce → RSA → Base64 → QR
          └────── nonce + SI → HMAC-SHA-256 → OTP de 8 dígitos
```

## 4. Como o estado DMC ativa a tela D2

O registro escrito pelo serviço Android começa com três bytes:

| Offset | Campo | Significado funcional |
|---:|---|---|
| `0` | `lock` | bloqueio seguro solicitado |
| `1` | `maintenance` | modo de manutenção |
| `2` | `at_command` | exceção/caminho de comando AT |

No ABL analisado, a combinação que causa lockdown é exclusivamente:

```c
lock == 1 && maintenance == 0 && at_command == 0
```

Assim:

```text
[1,0,0] → lockdown → D2 → Odin bloqueado
[0,0,0] → sem lockdown
```

Estados sentinela como `Allzero` e `Broken` possuem tratamento separado. O
resultado validado é transportado em `DevAuthInfo`, no campo observado em
`+0x168`. A rotina visual em `LinuxLoader.efi`, RVA `0xd70a0`, só entra no loop
D2 quando esse campo é diferente de zero.

## 5. Tela azul e máquina de estados das teclas

### 5.1 Entrada da rotina

A rotina proposta `ShowD2LockdownScreen`, RVA `0xd70a0`, faz:

1. testes de elegibilidade/estado do boot;
2. desabilitação do watchdog para permitir o loop;
3. obtenção de `DevAuthInfo`;
4. teste do campo de lockdown;
5. desenho de `[Reboot Device - D2]` e da instrução de reinicialização;
6. polling contínuo das teclas.

Os códigos são máscaras de bits:

| Valor | Estado |
|---:|---|
| `0x80` | Power sozinho |
| `0x81` | Power + Volume Up |
| `0x82` | Power + Volume Down |

### 5.2 Tabela exata embutida

Em `DAT_001ad720`, a tabela contém 22 palavras de 32 bits:

```text
0x81 × 8
0x82 × 5
0x81 × 9
```

Portanto, Power não é pressionado novamente a cada passo: ele permanece
segurado. Cada toque de volume produz `0x81` ou `0x82`; ao soltar apenas o botão
de volume, o estado volta a `0x80`, e somente então o índice é incrementado.
Isso explica a descrição prática “sempre segurando Power”.

Pseudocódigo fiel à lógica:

```c
expected = [UP x8, DOWN x5, UP x9];
i = 0;

while (power_is_held) {
    wait_until(key_mask == (POWER | expected[i]));
    wait_until(key_mask == POWER);       // soltou o volume, não o Power
    i++;
    if (i == 22) {
        result = check_otp_input();
        break;
    }
}
```

Uma transição incompatível com o próximo item esperado interrompe a progressão
da tentativa. O código também filtra repetição: manter Volume pressionado não
conta como múltiplos toques.

## 6. Construção da SI

A função em RVA `0xd5680` coleta os campos abaixo:

| Ordem no corpo | Campo | Origem/tamanho observado |
|---:|---|---|
| 1 | PID | constante de produto, aqui `10004` |
| 2 | modelo | `SM-S918B` |
| 3 | versão de software | `S918BXXUAZZI8` nesta imagem |
| 4 | DID | identificador do dispositivo, 20 bytes/copied chars |
| 5 | UN | identificador obtido pela plataforma |
| 6 | SN | serial |
| 7 | IMEI | identificador celular |
| 8 | nonce | 32 bytes aleatórios codificados em Base64 |

O nonce é obtido do protocolo RNG de UEFI. A função rejeita falha do protocolo,
falha de geração e o caso degenerado de 32 bytes zerados. Os mesmos 32 bytes
brutos são devolvidos ao chamador para o cálculo do HMAC.

O corpo é a concatenação desses oito itens separados por `:`. Para o último
item é usado o comprimento retornado pelo codificador Base64; para os demais,
`strlen`. O limite do corpo é 256 bytes.

A SI final possui esta forma lógica:

```text
PREFIXO || "D2:" || decimal(body_len) || ":" || BODY

BODY = PID:model:sw_version:DID:UN:SN:IMEI:base64(nonce)
```

O prefixo é iniciado com os identificadores/protocolo `D2`, versão `01`, PID e
versão de software. Na build examinada, os componentes fixos observados são:

```text
D2 + 01 + 10004 + S918BXXUAZZI8
```

O buffer de saída da SI tem capacidade `0x11d` (285 bytes). A rotina sempre
mantém os primeiros `0x1d` (29) bytes como cabeçalho público do envelope do QR.
Por causa da recuperação imperfeita de argumentos variádicos pelo decompilador,
é mais seguro tratar os 29 bytes como `public_header[29]`; a composição e ordem
do corpo acima estão confirmadas diretamente.

## 7. Construção exata do payload do QR Code

### 7.1 Envelope binário

A função `check_otp_input`, RVA `0xd68b0`, executa:

```text
SI, nonce = make_si()
rsa_key  = load_embedded_public_key()
cipher   = RSA4096_OAEP_SHA1(SI[0x1d:] usando rsa_key)

envelope = SI[0:0x1d] || cipher
qr_text  = Base64(envelope[0:0x21d])
```

Os tamanhos são decisivos:

| Componente | Tamanho |
|---|---:|
| Cabeçalho público da SI | `0x1d` = 29 bytes |
| Bloco RSA | `0x200` = 512 bytes |
| Envelope antes de Base64 | `0x21d` = 541 bytes |
| Base64 esperado, sem quebras | 724 caracteres |

O bloco RSA de 512 bytes indica uma chave RSA de 4096 bits. O material público
é carregado a partir de dados embutidos próximos a `DAT_001ad48c`, usando o
comprimento em `DAT_001ad6b4`. A chave privada correspondente não está no ABL;
ela é necessária do lado autorizado que lê o QR.

O ponto essencial é que o firmware não simplesmente coloca a SI em Base64. Ele
mantém o cabeçalho textual de 29 bytes em claro e cifra exatamente o corpo
`SI[0x1d:]` com RSA-4096 OAEP (padding OpenSSL `4`, SHA-1/MGF1-SHA-1) antes de
codificar todo o envelope.

### 7.2 Codificação QR

O texto Base64 é passado à rotina de QR em RVA `0xf8848`:

```c
qr_encode(&qr, work_buffer, 0x1e, 3, base64_envelope);
```

Os parâmetros constantes são versão QR `0x1e = 30` e correção de erro
`3 = HIGH`. Isso produz uma matriz de `137 × 137` módulos. O tamanho efetivo
volta no segundo byte da estrutura `qr`, registrado pelo firmware como
`qrcode.size`.

### 7.3 Renderização

`draw_qrcode`, RVA `0xd62f0`, percorre a matriz módulo por módulo. Cada módulo
vira um quadrado de `5 × 5` pixels, branco ou preto, em um buffer de BLT. A
largura renderizada é:

```text
pixel_width = qr_size × 5
```

O código consulta as dimensões da tela, calcula coordenadas centralizadas e
envia o buffer ao protocolo gráfico UEFI. Assim, o QR exibido é uma
representação direta do texto Base64 do envelope de 541 bytes; não há uma
segunda camada textual, URL ou JSON adicionada pelo renderizador.

## 8. Cálculo exato do OTP

O nonce de 32 bytes produzido por `make_si()` não é só conteúdo do QR. Ele é a
chave do autenticador local:

```c
digest = HMAC_SHA256(
    key     = nonce,       // 32 bytes
    message = SI,          // bytes ASCII até strlen(SI)
);
```

A identificação SHA-256 é confirmada porque o descritor passado por
`FUN_0009f418()` à implementação HMAC tem digest de 32 bytes e corresponde ao
descritor EVP de SHA-256. O wrapper HMAC está em RVA `0xa6860`.

Depois é aplicado o truncamento dinâmico no estilo HOTP, mas com oito dígitos:

```c
offset = digest[31] & 0x0f;

binary = ((digest[offset] & 0x7f) << 24) |
         ( digest[offset+1]        << 16) |
         ( digest[offset+2]        <<  8) |
         ( digest[offset+3]);

otp_number = binary % 100000000;
otp_text   = sprintf("%08d", otp_number);
```

Não existe contador temporal/TOTP no trecho analisado. A unicidade/frescura
vem do nonce RNG de 32 bytes criado toda vez que a tela OTP é aberta. Portanto,
o OTP de uma sessão não deve ser reutilizável em outra sessão que gere novo
nonce.

### 8.1 Relação QR ↔ servidor autorizado ↔ OTP

O fluxo operacional reconstruído é:

```text
Telefone                              Sistema autorizado
--------                              -------------------
gera nonce aleatório
monta SI
cifra SI com RSA pública  ──QR──►     decodifica Base64
                                      separa header/cipher
                                      decifra com RSA privada
                                      recupera SI + nonce
                                      calcula HMAC-SHA-256
                                      devolve OTP de 8 dígitos

computa o mesmo HMAC localmente
compara OTP digitado
```

Essa arquitetura explica simultaneamente por que:

- o aparelho consegue validar offline, pois conhece SI e nonce;
- o leitor comum do QR não vê todos os identificadores sensíveis;
- somente quem possui a chave RSA privada consegue extrair o nonce do bloco
  cifrado e reproduzir o OTP esperado;
- o QR muda entre sessões mesmo no mesmo aparelho.

## 9. Interface de entrada do OTP

O menu tem 13 itens, nesta ordem:

```text
0  DONE
1  BACK SPACE
2  POWER OFF
3  0
4  1
5  2
6  3
7  4
8  5
9  6
10 7
11 8
12 9
```

Controles mostrados e implementados:

```text
Move/Scroll : Volume Up/Down key
Select      : Power key
Done        : Select DONE menu
```

- Volume Up move a seleção para trás, com wrap em 13 itens.
- Volume Down move para frente.
- Power seleciona.
- `BACK SPACE` apaga o último caractere.
- Os itens `0` a `9` acrescentam seu primeiro caractere ao buffer.
- O buffer aceita no máximo 10 caracteres, embora o OTP correto tenha 8.
- `DONE` calcula o HMAC, formata `%08d` e compara as strings.
- `POWER OFF` sai pelo caminho de desligamento.

Em erro, é exibido:

```text
Invalid input!!! Retry count (%d/%d)
```

O contador começa em 1 e o limite mostrado é 3. Após o terceiro erro, a rotina
limpa/encerra a interface. Em acerto, limpa a tela e retorna `0` para o chamador.
Se `check_otp_input()` retorna um resultado de saída/erro ao gate D2, o chamador
aciona o serviço de reset/desligamento conforme o código retornado.

## 10. Propriedades de segurança e implicações

### 10.1 O que protege o fluxo

- O estado DMC fica em RPMB autenticado, não em uma partição de dados comum.
- O ABL consome o vault por uma interface limitada da TA `vk`.
- O QR usa RSA pública no telefone; a chave privada não foi encontrada no
  firmware analisado.
- O segredo de sessão é um nonce RNG de 256 bits.
- O OTP autentica toda a SI, não somente o nonce.
- A resposta tem três tentativas por abertura da interface.

### 10.2 O que a combinação de teclas faz e não faz

A sequência 8/5/9 não remove o DMC, não altera RPMB e não é o OTP. Ela apenas
revela o canal de desafio/resposta. Sem a chave RSA privada do sistema
autorizado, observar o QR e conhecer o algoritmo não basta para recuperar o
nonce cifrado e fabricar o OTP de uma nova sessão.

### 10.3 Dados sensíveis

A SI inclui DID, UN, serial e IMEI. Eles estão dentro do conteúdo protegido,
mas os primeiros 29 bytes são intencionalmente públicos. Nenhum valor real do
aparelho conectado foi incluído neste relatório nem nos exemplos.

### 10.4 Pontos ainda não demonstrados integralmente

1. O nome e protocolo do serviço remoto que possui a chave RSA privada não
   aparecem no ABL.
2. A identificação exata da versão/fork da biblioteca QR não está gravada como
   símbolo, embora sua ABI, versão 30, ECC HIGH e matriz de 137 módulos estejam
   confirmadas.
3. Alguns argumentos variádicos de `AsciiSPrint` ficaram degradados na saída C
   do decompilador; a inspeção AArch64 confirmou o cabeçalho textual completo,
   inclusive `D20110004S918BXXUAZZI8D2:<len>:`.

## 11. Mapa das principais rotinas

| RVA em `LinuxLoader.efi` | Nome proposto | Função |
|---:|---|---|
| `0xd5680` | `make_si` | coleta IDs, gera nonce e monta SI |
| `0xd62f0` | `draw_qrcode` | converte módulos em blocos 5×5 e desenha |
| `0xd66e0` | `display_otp_mode` | desenha instruções, entrada e menu |
| `0xd68b0` | `check_otp_input` | RSA/Base64/QR, entrada e validação OTP |
| `0xd70a0` | `ShowD2LockdownScreen` | tela D2 e gate secreto de 22 passos |
| `0xd782c` | `base64_encode_wrapper` | Base64 usado no nonce e envelope |
| `0xa6860` | `hmac_wrapper` | inicializa, atualiza e finaliza HMAC |
| `0xf8848` | `qr_encode` | constrói matriz QR |

Dados principais:

| Endereço/RVA | Conteúdo |
|---:|---|
| `0x1ad720` | sequência de 22 máscaras `0x81/0x82` |
| `0x1ad6b8` | tabela de 13 ponteiros do menu OTP |
| `0x114b56` | formato `%08d` |
| `0x119ab1` | string `D2` |
| `0x1e0799` | início do envelope QR antes de Base64 |
| `0x1e09b6` | texto Base64 usado pelo encoder QR |

## 12. Pseudocódigo consolidado

```c
void d2_screen(void) {
    DevAuthInfo *info = get_dev_auth_info();
    if (!info || !info->dmc_lockdown)
        return;

    draw("[Reboot Device - D2]");
    draw("Volume Down + Power key for 7 seconds");

    if (!match_while_power_held(UP,8, DOWN,5, UP,9))
        loop_on_d2();

    if (check_otp_input() != 0)
        reset_or_poweroff();
}

int check_otp_input(void) {
    char si[0x11d];
    uint8_t nonce[32], digest[32];
    uint8_t envelope[0x21d];

    make_si(si, nonce);
    cipher = rsa4096_oaep_sha1_encrypt_with_embedded_public_key(si + 0x1d);

    memcpy(envelope, si, 0x1d);
    memcpy(envelope + 0x1d, cipher, 0x200);
    qr_text = base64(envelope, 0x21d);
    qr = qr_encode(qr_text);
    draw_qrcode(qr, scale=5);

    for (attempt = 1; attempt <= 3; attempt++) {
        typed = volume_power_numeric_menu();
        digest = hmac_sha256(key=nonce, msg=si);
        offset = digest[31] & 0x0f;
        n = be31(digest[offset..offset+3]) % 100000000;
        expected = format("%08d", n);
        if (!strcmp(typed, expected))
            return 0;
    }
    return failure;
}
```

## 13. Evidências e reprodutibilidade

Artefatos produzidos durante a análise:

```text
analysis/abl_decompressed.bin
analysis/current/abl_fv.bin
analysis/current/pe/001250e8_LinuxLoader.efi
analysis/current-linux-targets.txt
analysis/current-otp-decomp.txt
analysis/current-targets-extended.txt
analysis/current-targets-final.txt
analysis/DumpTargets.java
analysis/ghidra-project/D2Firmware.gpr
```

Os dumps de decompilação preservam as chamadas, RVAs, strings e referências que
sustentam as conclusões. Eles devem ser usados como evidência primária quando
uma atualização do firmware mudar endereços ou constantes.

## 14. Conclusão

O D2 é um gate de autorização anterior ao OdinApp, derivado de um vault DMC
persistido de forma autenticada. A combinação 8 Up, 5 Down, 9 Up, sempre com
Power mantido, abre um protocolo de suporte offline baseado em desafio/resposta.

O desafio é uma SI com identificadores do dispositivo e nonce aleatório. O QR é
`Base64(public_header[29] || RSA4096_ciphertext[512])`. A resposta é
`%08d(dynamic_truncate(HMAC-SHA-256(nonce, SI)) mod 100000000)`. O telefone
calcula e valida essa resposta localmente; o agente autorizado precisa decifrar
o QR com a chave RSA privada para obter os dados necessários. Esse é o fluxo
completo observável no firmware, desde o bit persistido em RPMB até a decisão
final de aceitar ou rejeitar o OTP.
