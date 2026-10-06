# Apps, frameworks e serviços conectados ao Maintenance Mode

## Confirmados pelo código

### Android Settings (`com.android.settings`)
Hospeda `MaintenanceModeIntroActivity`, `MaintenanceModeOutroActivity`, `MaintenanceModeProxyActivity` e `MaintenanceModeNotificationService`.

### Samsung Core Framework
API: `com.samsung.android.core.pm.mm.MaintenanceModeUtils`.
Centraliza pré-condições, bloqueio seguro, pouco armazenamento, backup, logs e abertura de apps externos.

Métodos observados:
- `checkRequiredConditions`
- `checkCloudBackupSupport`
- `getCloudBackupStatus`
- `getStatusOfBackupInProgress`
- `confirmSecureLock`
- `isSecureLockSet`
- `isLowOnStorage`
- `startCloudActivity`
- `startSmartSwitchActivity`
- `startMyFilesActivity`
- `startSecureLockSettingsActivity`
- `setUserConsentAboutCreatingLog`
- `sendLoggingDataToSA`

### Android UserManager / ActivityManager
Cria um usuário Android especial com tipo `com.samsung.android.os.usertype.full.MAINTENANCE_MODE`. O código usa o ID fixo `77` para detectar e operar o perfil de manutenção.

### Samsung Cloud (`com.samsung.android.scloud`)
Integração de backup temporário. Broadcasts observados:
- `com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_STARTED`
- `...NOTIFY_BACKUP_COMPLETED`
- `...NOTIFY_BACKUP_NOT_FINISHED`
- `...NOTIFY_BACKUP_CANCELED`

### Samsung Smart Switch
Aberto por `MaintenanceModeUtils.startSmartSwitchActivity` para backup em armazenamento externo. No aparelho foi encontrado `com.samsung.android.smartswitchassistant`.

### My Files
Aberto por `MaintenanceModeUtils.startMyFilesActivity` quando há pouco espaço ou para gerenciamento de armazenamento.

### Lock Settings / Keyguard
`confirmSecureLock`, `isSecureLockSet` e `startSecureLockSettingsActivity` integram o fluxo com bloqueio seguro. `MaintenanceModeProxyActivity` usa `KeyguardManager.semSetPendingIntentAfterUnlock`.

### Notification service
`MaintenanceModeNotificationService`, processo `:ui`, canal `maintenance_mode_channel`. Abre a Activity de saída e reage a:
- `com.samsung.android.intent.action.HIDE_MAINTENANCE_MODE_MARK`
- `com.samsung.android.intent.action.SHOW_MAINTENANCE_MODE_MARK`

## Entradas externas
- `com.samsung.android.intent.action.ENABLE_MAINTENANCE_MODE`
- `com.samsung.android.intent.action.DISABLE_MAINTENANCE_MODE`
- Deep link `oneui://maintenance-mode`
- URLs Samsung contendo `/support/maintenance-mode`
- Permissão protegida `com.samsung.android.permission.ACCESS_MAINTENANCE_MODE`

## Observação da varredura ADB
Antes da desconexão, o Package Manager confirmou que apenas as Activities de Settings tratavam diretamente os intents ENABLE/DISABLE. O aparelho desconectou durante a análise posterior de APKs/frameworks; portanto referências internas ao framework Samsung ainda devem ser extraídas quando o ADB retornar.
