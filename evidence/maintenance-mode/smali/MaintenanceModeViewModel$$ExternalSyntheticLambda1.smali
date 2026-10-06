.class public final synthetic Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic $r8$classId:I

.field public synthetic f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

.field public synthetic f$1:Z


# direct methods
.method public synthetic constructor <init>(I)V
    .locals 0

    iput p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;->$r8$classId:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 7

    iget v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;->$r8$classId:I

    packed-switch v0, :pswitch_data_0

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iget-boolean p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;->f$1:Z

    iget-object v0, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mApp:Landroid/app/Application;

    if-eqz p0, :cond_0

    const-string p0, "1"

    goto :goto_0

    :cond_0
    const-string p0, "0"

    :goto_0
    const-string v1, "7070"

    invoke-static {v0, v1, p0}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->sendLoggingDataToSA(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :pswitch_0
    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iget-boolean p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;->f$1:Z

    iget-object v1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsPrimaryButtonClickable:Landroidx/lifecycle/MutableLiveData;

    sget-object v2, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-virtual {v1, v2}, Landroidx/lifecycle/LiveData;->postValue(Ljava/lang/Object;)V

    invoke-virtual {v0}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->setWaitingViewRotation()V

    xor-int/lit8 v1, p0, 0x1

    invoke-static {v1}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->setUserConsentAboutCreatingLog(Z)V

    iget-object v1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mWm:Landroid/view/WindowManager;

    const/4 v2, 0x1

    if-eqz p0, :cond_1

    iget-object v3, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mEntryWaitingView:Landroid/view/View;

    iget-object v4, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mViewWindowParams:Landroid/view/WindowManager$LayoutParams;

    invoke-interface {v1, v3, v4}, Landroid/view/WindowManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iget-object v1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mEntryWaitingView:Landroid/view/View;

    new-instance v3, Ljava/lang/Thread;

    new-instance v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;

    invoke-direct {v4, v2}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;-><init>(I)V

    iput-object v0, v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iput-object v1, v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;->f$1:Ljava/lang/Object;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-direct {v3, v4}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v3}, Ljava/lang/Thread;->start()V

    goto :goto_1

    :cond_1
    iget-object v3, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mDumpWaitingView:Landroid/view/View;

    iget-object v4, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mViewWindowParams:Landroid/view/WindowManager$LayoutParams;

    invoke-interface {v1, v3, v4}, Landroid/view/WindowManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const-string v1, "bugreport.mode"

    const-string v3, "light_mode"

    invoke-static {v1, v3}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "ctl.start"

    const-string v3, "bugreportm"

    invoke-static {v1, v3}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v3

    const-wide/32 v5, 0x493e0

    add-long/2addr v3, v5

    iput-wide v3, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mDumpDeadline:J

    iget-object v1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mScheduler:Ljava/util/concurrent/ScheduledExecutorService;

    new-instance v3, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;

    const/4 v4, 0x3

    invoke-direct {v3, v4}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;-><init>(I)V

    iput-object v0, v3, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    const-wide/16 v4, 0x2710

    sget-object v6, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-interface {v1, v3, v4, v5, v6}, Ljava/util/concurrent/ScheduledExecutorService;->schedule(Ljava/lang/Runnable;JLjava/util/concurrent/TimeUnit;)Ljava/util/concurrent/ScheduledFuture;

    :goto_1
    iget-object v1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mLoggingExecutor:Ljava/util/concurrent/ExecutorService;

    new-instance v3, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;

    invoke-direct {v3, v2}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;-><init>(I)V

    iput-object v0, v3, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iput-boolean p0, v3, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;->f$1:Z

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-interface {v1, v3}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    iget-object p0, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mLoggingExecutor:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;

    invoke-direct {v1, v2}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;-><init>(I)V

    iput-object v0, v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-interface {p0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    return-void

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
