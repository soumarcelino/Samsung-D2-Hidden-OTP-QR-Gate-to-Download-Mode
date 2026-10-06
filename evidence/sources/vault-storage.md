# 12. Engenharia reversa do Trusted Application `vk`

## Identificação

A partição `/dev/block/by-name/vk` contém um ELF AArch64 do Trusted Application VaultKeeper:

```text
ELF64, AArch64, ET_DYN
segmento RX aproximado: 0xf850c bytes
sem section headers
versão registrada nos logs: 4.4.2
```

## Persistência em RPMB — confirmada

O TA contém e referencia funções/mensagens explícitas:

```text
vkqsee_init_rpmb
vkqsee_read_vault
vkqsee_write_vault
Failed to init RPMB for reading vault
Failed to read data from rpmb
Failed to write data to rpmb
RPMB Key Provisioning not yet
```

Portanto, a hipótese anterior foi elevada a fato: os vaults são persistidos pelo TA usando RPMB. A partição `vk` contém o código do TA; não contém diretamente os valores correntes do DMC.

## Entrada especial do bootloader

A função em VA `0x100318` distingue requisições normais do daemon e requisições compactas do bootloader.

Formato reconstruído:

```c
struct bl_request {
    uint32_t command;     // 0xc0de0003
    uint32_t vault_id;    // 0xbc06 para DMC
};
```

O valor little-endian enviado pelo ABL:

```text
03 00 de c0 06 bc 00 00
```

é interpretado exatamente como:

```text
command  = 0xc0de0003
vault_id = 0x0000bc06
```

## Dispatch de vaults do bootloader

O switch do TA aceita os IDs:

| Vault ID | Parâmetros observados |
|---:|---:|
| `0xbc01` | blocos `0xc8` / `0xdc` |
| `0xbc03` | blocos `0xab` / `0xad` |
| `0xbc04` | blocos `0x1f2` / `0x1f4` |
| `0xbc05` | blocos `0x1f6` / `0x1f8` |
| `0xbc06` | blocos `0xb0` / `0xb2` |

Para `0xbc06`, o TA chama a rotina proposta `BlReadUnsheltered` com:

```text
vault table/index ID = 0x31393
vault ID             = 0xbc06
primary RPMB block   = 0xb0
backup RPMB block    = 0xb2
response size        = 0x24
```

## Registro DMC na tabela

A tabela interna contém um registro explícito:

```text
description: This is the cryptographic contexts for DMC vault
client:      system_server
vault name:  DMC
nonce name:  dmc_nonce
index/id:    0x31393
blocks:      0xb0 / 0xb2
```

Isso conecta o mesmo vault lógico usado por `VaultKeeperManager.getInstance("DMC")` ao caminho de bootloader `0xbc06`.

## Resposta e redundância

Formato da resposta:

```c
struct bl_response {
    int32_t status;
    uint8_t data[32];
}; // 0x24 bytes
```

Comportamento reconstruído:

1. verifica se a chave RPMB está provisionada;
2. lê o bloco primário `0xb0`;
3. se os 32 bytes forem zero, retorna `Allzero`;
4. valida integridade/hash do registro;
5. se a validação primária falhar, tenta o bloco de backup `0xb2`;
6. se o backup for íntegro, retorna seus 32 bytes;
7. se ambos falharem, retorna `Broken`.

O ABL interpreta:

- `Allzero` → sem lockdown;
- `Broken` → sentinela de erro `0xffffffff`;
- conteúdo normal → compara os três primeiros bytes com `[1,0,0]`.

## Comandos normais do VaultKeeper

O TA também implementa o caminho extenso autenticado para `vaultkeeperd`, incluindo:

```text
INITIALIZE
CHECK_INITIALIZED
READ_UNSHELTERED
READ_SHELTERED
WRITE_UNSHELTERED
WRITE_SHELTERED
VERIFY_CERT
MIGRATION
ENCRYPT_MSG
DESTROY
READ_SBOX
GET_NONCE
CHECK_DATA_WRITABLE
GENERATE_HOTP_CODE
```

Isso explica por que Android usa a mesma TA para múltiplos vaults, enquanto o bootloader possui uma interface compacta e read-only para vaults previamente conhecidos.

## Limites

- O algoritmo criptográfico completo e a derivação das chaves não foram reconstruídos.
- Os frames RPMB brutos não foram extraídos nem modificados.
- A interpretação “primário/backup” resulta do fallback entre dois blocos e deve ser entendida como nome funcional.
