# 11. Engenharia reversa do ABL

## Resultado principal

A análise estática do `OdinApp.efi` confirmou diretamente a condição descrita na documentação do DFReroot. A função em RVA `0x76dc0`:

1. monta uma requisição DMC de 8 bytes;
2. chama o wrapper QSEECom em `0x76b90`;
3. recebe uma resposta de 36 bytes;
4. exige status de transporte e status da resposta iguais a zero;
5. interpreta os bytes da resposta nos offsets `+4`, `+5` e `+6`;
6. retorna verdadeiro somente quando os bytes são `[1, 0, 0]`.

Pseudocódigo normalizado:

```c
bool dmc_lockdown_condition(void) {
    request8 request = DMC_REQUEST_CONSTANT;
    response36 response = { .status = -1 };

    if (dmc_send_cmd(&request, &response) != 0 || response.status != 0)
        return true; // falha conservadora no binário analisado

    if (memcmp(response.payload, "Allzero", 7) == 0)
        return false;
    if (memcmp(response.payload, "Broken", 6) == 0)
        return ERROR_SENTINEL;

    return response.payload[0] == 1 &&
           response.payload[1] == 0 &&
           response.payload[2] == 0;
}
```

A sequência AArch64 que implementa a comparação usa três `ldrb`, comparações com `1`, `0`, `0`, e combina os resultados com `and` antes de retornar.

## Estruturas reconstruídas

### Request

O wrapper recebe exatamente 8 bytes. O valor imediato construído pela função é:

```text
0x0000bc06c0de0003
```

Em little-endian:

```text
03 00 de c0 06 bc 00 00
```

O significado individual dos campos ainda não foi atribuído. O primeiro valor é candidato a CmdId, mas isso precisa ser validado no TA `vk`.

### Response

O wrapper QSEECom recebe buffer de `0x24` (36) bytes:

```c
struct dmc_response {
    int32_t status;       // offset 0
    uint8_t payload[32];  // offset 4
};
```

O tamanho casa com o registro de 32 bytes utilizado por `VaultKeeperManager.read(1)` no framework. Isso conecta estruturalmente a resposta do TA ao vault Android.

## Funções identificadas

| RVA | Nome proposto | Função |
|---:|---|---|
| `0x76b90` | `DmcSendCmd` | abre QSEECom, inicia `vk`, envia request de 8 bytes e recebe 36 bytes |
| `0x76dc0` | `DmcCheckLockdown` | interpreta a resposta e testa `[1,0,0]` |
| `0x6af50` | `CollectSecurityState` | coleta várias políticas e armazena o resultado DMC no estado global |

O resultado de `DmcCheckLockdown` é armazenado no campo global em `0xdb318`, junto a outras políticas de segurança coletadas pelo OdinApp.

## Xrefs e cadeia observada

```text
CollectSecurityState (0x6af50)
  └── DmcCheckLockdown (0x76dc0)
        └── DmcSendCmd (0x76b90)
              ├── Locate QSEECom protocol
              ├── StartApp("vk")
              ├── SendCmd(request=8, response=0x24)
              └── ShutdownApp
```

Strings de diagnóstico confirmam os papéis:

```text
[Dmc]QseecomStartApp (vk) ...
[Dmc]QseecomSendCmd ... ReqCmd->CmdId ... RspBuff->Status ...
[DMC]Rsp: ALLZERO
[DMC]Rsp: Broken
%d%d%d
```

## Impacto na conclusão

Antes desta etapa, `[1,0,0] → lockdown` era uma alegação ainda não confirmada diretamente. A comparação agora está comprovada no ABL analisado.

Ainda falta seguir o campo global `0xdb318` até a rotina visual/decisão final que mostra a tela D2. A análise de referências diretas encontra apenas a escrita porque o estado é posteriormente acessado por tabela/estrutura, exigindo tipagem manual ou análise de fluxo adicional.

## Fluxo final até a tela D2 — confirmado

A análise do segundo PE/COFF do firmware volume, identificado como `LinuxLoader.efi`, fechou o fluxo que antes estava pendente.

### Coleta em `DevAuthInfo`

A rotina de inicialização de `DevAuthInfo` chama `DmcCheckLockdown` em RVA `0xd75a0` e grava o retorno:

```text
DevAuthInfo base       = 0x1a3010
campo DMC              = base + 0x168
endereço do campo      = 0x1a3178
```

No trecho AArch64:

```text
bl   DmcCheckLockdown
str  w0, [x19, #0x78]
```

Nesse ponto `x19 = 0x1a3100`; portanto `x19 + 0x78 = 0x1a3178`, equivalente a `DevAuthInfo + 0x168`.

### Consumidor

A rotina em RVA `0xd70a0`, nome proposto `ShowD2LockdownScreen`, obtém `DevAuthInfo` e testa exatamente o campo DMC:

```c
DevAuthInfo *info = GetDevAuthInfo();
if (info->dmc_lockdown != 0) {
    // desenha tela de bloqueio e entra no loop de teclas/reboot
}
```

O decompilador representa esse acesso como `info[0x5a]`; `0x5a * sizeof(uint32_t) = 0x168`.

### Texto D2

A tela chama a primitiva de desenho com:

```text
[Reboot Device - %a]
```

O argumento `%a` aponta para a string localizada em RVA `0x119ab1`:

```text
D2
```

Também é desenhada a instrução:

```text
Volume Down + Power key for 7 seconds
```

A função desativa o watchdog, desenha a tela e permanece em um loop de leitura de teclas. Somente uma sequência/reboot aceito sai desse estado.

### Chamada antes do OdinApp

No fluxo principal do LinuxLoader:

```c
if (d2_screen_enabled != 0)
    ShowD2LockdownScreen();

LaunchOdinApp();
```

Como a rotina D2 bloqueia em loop quando `DevAuthInfo.dmc_lockdown != 0`, o `OdinApp` só é lançado se a condição DMC não estiver ativa ou depois que o gate for liberado.

## Cadeia completa confirmada

```text
Pedido de Download/Odin Mode
  → LinuxLoader coleta DevAuthInfo
  → DmcCheckLockdown envia {0xc0de0003, 0xbc06} ao TA vk
  → TA lê o vault DMC
  → resposta payload[32]
  → comparação payload[0..2] == [1,0,0]
  → resultado gravado em DevAuthInfo + 0x168
  → ShowD2LockdownScreen testa o campo
  → exibe "[Reboot Device - D2]"
  → loop de bloqueio impede LaunchOdinApp
```

Com isso, o fluxo `[1,0,0] → D2 → Odin bloqueado` está confirmado de ponta a ponta no firmware analisado.
