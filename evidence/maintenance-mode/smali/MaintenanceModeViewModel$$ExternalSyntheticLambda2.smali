.class public final synthetic Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic $r8$classId:I

.field public synthetic f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;


# direct methods
.method public synthetic constructor <init>(I)V
    .locals 0

    iput p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;->$r8$classId:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 7

    iget v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;->$r8$classId:I

    sget-object v1, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    const-string v2, "MaintenanceMode"

    const/4 v3, 0x0

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    packed-switch v0, :pswitch_data_0

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const-string v0, "dumpstate.is_running"

    invoke-static {v0, v3}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result v0

    if-eqz v0, :cond_1

    iget-wide v3, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mDumpDeadline:J

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v5

    sub-long/2addr v3, v5

    const-wide/16 v5, 0x0

    cmp-long v0, v3, v5

    if-gtz v0, :cond_0

    const-string v0, "Waiting for dumpstate timed out"

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mScheduler:Ljava/util/concurrent/ScheduledExecutorService;

    new-instance v2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;

    const/4 v3, 0x3

    invoke-direct {v2, v3}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;-><init>(I)V

    iput-object p0, v2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    const-wide/16 v3, 0x7d0

    invoke-interface {v0, v2, v3, v4, v1}, Ljava/util/concurrent/ScheduledExecutorService;->schedule(Ljava/lang/Runnable;JLjava/util/concurrent/TimeUnit;)Ljava/util/concurrent/ScheduledFuture;

    goto :goto_1

    :cond_1
    :goto_0
    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mDumpWaitingView:Landroid/view/View;

    new-instance v1, Ljava/lang/Thread;

    new-instance v2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;

    const/4 v3, 0x1

    invoke-direct {v2, v3}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;-><init>(I)V

    iput-object p0, v2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iput-object v0, v2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;->f$1:Ljava/lang/Object;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-direct {v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    :goto_1
    return-void

    :pswitch_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    :try_start_0
    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mApp:Landroid/app/Application;

    const-string v0, "user"

    invoke-virtual {p0, v0}, Landroid/app/Application;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/os/UserManager;

    const/16 v0, 0x4d

    invoke-virtual {p0, v0}, Landroid/os/UserManager;->removeUser(I)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    :catch_0
    move-exception p0

    const-string v0, "Exception"

    invoke-static {v2, v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_2
    return-void

    :pswitch_1
    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mApp:Landroid/app/Application;

    const-string v0, "7071"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->sendLoggingDataToSA(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :pswitch_2
    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsPrimaryButtonClickable:Landroidx/lifecycle/MutableLiveData;

    sget-object v2, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-virtual {v0, v2}, Landroidx/lifecycle/LiveData;->postValue(Ljava/lang/Object;)V

    invoke-virtual {p0}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->setWaitingViewRotation()V

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mWm:Landroid/view/WindowManager;

    iget-object v2, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mExitWaitingView:Landroid/view/View;

    iget-object v4, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mViewWindowParams:Landroid/view/WindowManager$LayoutParams;

    invoke-interface {v0, v2, v4}, Landroid/view/WindowManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mExitWaitingView:Landroid/view/View;

    new-instance v2, Ljava/lang/Thread;

    new-instance v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;

    const/4 v5, 0x2

    invoke-direct {v4, v5}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;-><init>(I)V

    iput-object p0, v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-direct {v2, v4}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v2}, Ljava/lang/Thread;->start()V

    iget-object v2, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mScheduler:Ljava/util/concurrent/ScheduledExecutorService;

    new-instance v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;

    invoke-direct {v4, v3}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;-><init>(I)V

    iput-object p0, v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iput-object v0, v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;->f$1:Ljava/lang/Object;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    const-wide/32 v5, 0x2bf20

    invoke-interface {v2, v4, v5, v6, v1}, Ljava/util/concurrent/ScheduledExecutorService;->schedule(Ljava/lang/Runnable;JLjava/util/concurrent/TimeUnit;)Ljava/util/concurrent/ScheduledFuture;

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
