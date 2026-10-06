.class public final Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService$1;
.super Landroid/content/BroadcastReceiver;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"


# instance fields
.field public final synthetic this$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService;


# direct methods
.method public constructor <init>(Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService;)V
    .locals 0

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService$1;->this$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public final onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 1

    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string p2, "MaintenanceMode"

    const-string v0, "onReceive: "

    invoke-static {v0, p1, p2}, Lcom/android/settings/applications/AppInfoBase$1$$ExternalSyntheticOutline0;->m(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-eqz p1, :cond_2

    const-string p2, "com.samsung.android.intent.action.HIDE_MAINTENANCE_MODE_MARK"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_1

    const-string p2, "com.samsung.android.intent.action.SHOW_MAINTENANCE_MODE_MARK"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_0

    goto :goto_0

    :cond_0
    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService$1;->this$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService;

    sget-object p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService;->COMPONENT_OUTRO:Landroid/content/ComponentName;

    const/4 p1, 0x1

    invoke-virtual {p0, p1}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService;->setOverlayVisibility(Z)V

    return-void

    :cond_1
    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService$1;->this$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService;

    sget-object p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService;->COMPONENT_OUTRO:Landroid/content/ComponentName;

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeNotificationService;->setOverlayVisibility(Z)V

    :cond_2
    :goto_0
    return-void
.end method
