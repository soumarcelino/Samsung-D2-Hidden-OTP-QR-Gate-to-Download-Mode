.class public final Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$1;
.super Ljava/util/TimerTask;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"


# instance fields
.field public final synthetic this$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;


# direct methods
.method public constructor <init>(Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;)V
    .locals 0

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$1;->this$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    invoke-direct {p0}, Ljava/util/TimerTask;-><init>()V

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 3

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$1;->this$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    iget-boolean v1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mIsCloudBackupSupported:Z

    if-eqz v1, :cond_0

    :try_start_0
    iget-object v0, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudStatusExecutor:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;

    const/4 v2, 0x6

    invoke-direct {v1, v2}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;-><init>(I)V

    iput-object p0, v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;->f$0:Ljava/lang/Object;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_0
    return-void
.end method
