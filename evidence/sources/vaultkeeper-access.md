# 4. VaultKeeper, permissões e TEE

## Interface Binder

Transações observadas na AIDL de `IVaultKeeperService`:

| Código | Método |
|---:|---|
| 1 | `isInitialized` |
| 2 | `initialize` |
| 3 | `destroy` |
| 4 | `read` |
| 5 | `write` |
| 6 | `sensitiveBox` |
| 7 | `encryptMessage` |
| 8 | `migrationStorage` |
| 9 | `verifyCertificate` |
| 10 | `checkDataWritable` |
| 11 | `generateHotpCode` |

## Testes de autorização

ADB shell (`uid=2000`) foi rejeitado:

```text
Permission denied. Check your UID (2000)
```

Root (`uid=0`) também foi rejeitado:

```text
NOT Allowed : 0 isn't signed with platform key.
```

A execução externa como UID 1000 não bastou:

```text
Invalid package name
```

## Política reconstruída

`VaultKeeperService.getPackageName()` concede acesso quando:

- o processo chamador é realmente `system_server` e o UID efetivo corresponde a system; ou
- o UID pertence a pacote assinado com a chave platform e o PID aparece entre os processos Android reconhecidos.

Isso explica por que root tradicional não concede automaticamente acesso à API de alto nível.

## Partição `vk`

```text
/dev/block/by-name/vk -> /dev/block/sde29
Tamanho observado: 2 MiB
Formato: ELF 64-bit ARM AArch64 shared object
```

A leitura exigiu entrar no mount namespace do PID 1. O conteúdo identifica a partição como código do TA, não como armazenamento plano dos flags.
