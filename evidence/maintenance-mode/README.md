# MaintenanceModeIntroActivity

## Encadeamento
- Activity: `com.android.settings.Settings$MaintenanceModeIntroActivity`
- Base: `com.android.settings.SettingsActivity`
- Fragment carregado pelo metadata: `com.samsung.android.settings.maintenancemode.MaintenanceModeIntroFragment`
- Estado/ações assíncronas: `MaintenanceModeViewModel`
- Entrada por deep link/atalho: `MaintenanceModeProxyActivity`
- API de sistema usada: `com.samsung.android.core.pm.mm.MaintenanceModeUtils` (framework externo ao APK)

## Manifest
- Exportada: sim
- Exige permissão: `com.samsung.android.permission.ACCESS_MAINTENANCE_MODE`
- Ação: `com.samsung.android.intent.action.ENABLE_MAINTENANCE_MODE`
- Excluída de recentes: sim

## Interface
- Preference screen: `preference_screen_intro.xml`
- Layout: `fragment_intro.xml`
- Oferece backup temporário em nuvem e backup externo via Smart Switch.

## Fluxo observado
1. A Activity é somente uma classe-alias vazia de `SettingsActivity`.
2. `SettingsActivity` lê `FRAGMENT_CLASS` do manifesto e abre `MaintenanceModeIntroFragment`.
3. O fragment verifica pré-condições por `MaintenanceModeUtils.checkRequiredConditions`.
4. O botão de ativação trata bloqueio seguro, pouco armazenamento e estado do backup.
5. O diálogo oferece criação de log e reinicialização.
6. O ViewModel coordena estado do botão, overlays de espera, logging e entrada no modo.

Consulte `exact-references.txt`, `all-java-references.txt` e `all-smali-references.txt`.
