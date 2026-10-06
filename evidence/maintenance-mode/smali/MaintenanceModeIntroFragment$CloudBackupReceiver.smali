.class public final Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$CloudBackupReceiver;
.super Landroid/content/BroadcastReceiver;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"


# instance fields
.field public final synthetic this$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;


# direct methods
.method public constructor <init>(Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;)V
    .locals 0

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$CloudBackupReceiver;->this$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public final onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 2

    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_0

    :try_start_0
    iget-object p2, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$CloudBackupReceiver;->this$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    iget-object p2, p2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudStatusExecutor:Ljava/util/concurrent/ExecutorService;

    new-instance v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda18;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda18;-><init>(I)V

    iput-object p0, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda18;->f$0:Ljava/lang/Object;

    iput-object p1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda18;->f$1:Ljava/lang/String;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-interface {p2, v0}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_0
    const-string p0, "MaintenanceMode"

    const-string p2, "onReceive: "

    invoke-static {p2, p1, p0}, Lcom/android/settings/applications/AppInfoBase$1$$ExternalSyntheticOutline0;->m(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
