# 3. DmcService e os flags

## Descoberta

O `services.jar` do aparelho contém:

- `com.android.server.DmcService`
- `DmcService$LifeCycle`
- `DmcService$DmcLocalServiceImpl`

Na inicialização:

```java
mVkm = VaultKeeperManager.getInstance("DMC");
```

Isso confirma que `DMC` é o nome do vault usado pelo serviço.

## Boot concluído

Em `PHASE_BOOT_COMPLETED`, o serviço:

1. registra receivers;
2. consulta `KeyguardManager.isDeviceSecure()`;
3. consulta `persist.sys.is_in_maintenance_mode`;
4. cria um array iniciado por `{secure, maintenance, 0}`;
5. executa `mVkm.write(1, array)`.

A API trabalha com um registro de 32 bytes. Os três primeiros bytes têm semântica confirmada pelo fluxo do código.

## Atualizações em runtime

Ações registradas:

```text
android.intent.action.MAIN_USER_LOCKSCREEN_KNOWLEDGE_FACTOR_CHANGED
com.samsung.android.intent.action.NOTIFY_PREPROCESSING_MAINTENANCE_MODE
com.samsung.android.intent.action.NOTIFY_POSTPROCESSING_MAINTENANCE_MODE
```

Mapeamento:

- mudança da credencial → offset `0`;
- entrada/saída do Maintenance Mode → offset `1`;
- `setFlagAtCommand()` → offset `2 = 1`.

O terceiro byte volta a zero no próximo boot porque o array inicial contém zero nessa posição.

## Estado observado

Durante a primeira inspeção:

```text
lock_settings get-disabled = true
persist.sys.is_in_maintenance_mode = vazio/desativado
device_provisioned = 1
```

Isso sugere `[0,0,0]` após o boot, mas **não é leitura direta do vault** e não deve ser tratado como evidência definitiva do valor atual.
