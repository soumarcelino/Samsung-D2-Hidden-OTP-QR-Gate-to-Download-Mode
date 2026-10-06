.class public Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;
.super Landroidx/lifecycle/AndroidViewModel;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"


# instance fields
.field public final mApp:Landroid/app/Application;

.field public mDumpDeadline:J

.field public final mDumpWaitingView:Landroid/view/View;

.field public final mEntryWaitingView:Landroid/view/View;

.field public final mExitWaitingView:Landroid/view/View;

.field public final mIsPrimaryButtonClickable:Landroidx/lifecycle/MutableLiveData;

.field public final mIsTablet:Z

.field public final mLoggingExecutor:Ljava/util/concurrent/ExecutorService;

.field public final mResources:Landroid/content/res/Resources;

.field public final mScheduler:Ljava/util/concurrent/ScheduledExecutorService;

.field public final mViewWindowParams:Landroid/view/WindowManager$LayoutParams;

.field public final mWm:Landroid/view/WindowManager;


# direct methods
.method public constructor <init>(Landroid/app/Application;)V
    .locals 11

    invoke-direct {p0, p1}, Landroidx/lifecycle/AndroidViewModel;-><init>(Landroid/app/Application;)V

    new-instance p1, Landroidx/lifecycle/MutableLiveData;

    invoke-direct {p1}, Landroidx/lifecycle/LiveData;-><init>()V

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsPrimaryButtonClickable:Landroidx/lifecycle/MutableLiveData;

    iget-object v0, p0, Landroidx/lifecycle/AndroidViewModel;->application:Landroid/app/Application;

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mApp:Landroid/app/Application;

    invoke-virtual {v0}, Landroid/app/Application;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    iput-object v1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mResources:Landroid/content/res/Resources;

    invoke-static {}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->isTablet()Z

    move-result v2

    iput-boolean v2, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsTablet:Z

    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p1, v3}, Landroidx/lifecycle/LiveData;->setValue(Ljava/lang/Object;)V

    const-string p1, "window"

    invoke-virtual {v0, p1}, Landroid/app/Application;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/view/WindowManager;

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mWm:Landroid/view/WindowManager;

    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mLoggingExecutor:Ljava/util/concurrent/ExecutorService;

    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadScheduledExecutor()Ljava/util/concurrent/ScheduledExecutorService;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mScheduler:Ljava/util/concurrent/ScheduledExecutorService;

    new-instance v3, Landroid/view/WindowManager$LayoutParams;

    const v9, 0x20100

    const/4 v10, -0x3

    const/4 v4, -0x1

    const/4 v5, -0x1

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/16 v8, 0x7e8

    invoke-direct/range {v3 .. v10}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIIIII)V

    iput-object v3, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mViewWindowParams:Landroid/view/WindowManager$LayoutParams;

    const/16 p1, 0x11

    iput p1, v3, Landroid/view/WindowManager$LayoutParams;->gravity:I

    iget p1, v3, Landroid/view/WindowManager$LayoutParams;->privateFlags:I

    or-int/lit8 p1, p1, 0x10

    iput p1, v3, Landroid/view/WindowManager$LayoutParams;->privateFlags:I

    const/4 p1, 0x1

    iput p1, v3, Landroid/view/WindowManager$LayoutParams;->layoutInDisplayCutoutMode:I

    const/4 p1, 0x0

    invoke-virtual {v3, p1}, Landroid/view/WindowManager$LayoutParams;->setFitInsetsSides(I)V

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v3

    const v4, 0x7f0e0cc4

    const/4 v5, 0x0

    invoke-virtual {v3, v4, v5}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v3

    iput-object v3, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mEntryWaitingView:Landroid/view/View;

    const v6, 0x7f0b0f45

    invoke-virtual {v3, v6}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v3

    const/16 v6, 0x8

    invoke-virtual {v3, v6}, Landroid/view/View;->setVisibility(I)V

    iget-object v3, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mEntryWaitingView:Landroid/view/View;

    const v7, 0x7f0b0558

    invoke-virtual {v3, v7}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    if-eqz v2, :cond_0

    const v8, 0x7f1516dc

    goto :goto_0

    :cond_0
    const v8, 0x7f1516db

    :goto_0
    invoke-virtual {v1, v8}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v3, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v8, 0x7f071673

    invoke-static {v0, v8}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->getFontSize(Landroid/content/Context;I)F

    move-result v9

    invoke-virtual {v3, p1, v9}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v3

    invoke-virtual {v3, v4, v5}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v3

    iput-object v3, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mDumpWaitingView:Landroid/view/View;

    invoke-virtual {v3, v7}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const v9, 0x7f1516d8

    invoke-virtual {v1, v9}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, "\n\n"

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v2, :cond_1

    const v9, 0x7f1516da

    goto :goto_1

    :cond_1
    const v9, 0x7f1516d9

    :goto_1
    invoke-virtual {v1, v9}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v3, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0, v8}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->getFontSize(Landroid/content/Context;I)F

    move-result v7

    invoke-virtual {v3, p1, v7}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    invoke-virtual {v0, v4, v5}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mExitWaitingView:Landroid/view/View;

    const v3, 0x7f0b054c

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v6}, Landroid/view/View;->setVisibility(I)V

    if-eqz v2, :cond_2

    const v0, 0x7f071671

    invoke-virtual {v1, v0}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v0

    iget-object v1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mEntryWaitingView:Landroid/view/View;

    invoke-virtual {v1, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v1, v0, p1, v0, p1}, Landroid/view/View;->setPadding(IIII)V

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mDumpWaitingView:Landroid/view/View;

    invoke-virtual {p0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    invoke-virtual {p0, v0, p1, v0, p1}, Landroid/view/View;->setPadding(IIII)V

    :cond_2
    return-void
.end method


# virtual methods
.method public final onCleared()V
    .locals 1

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mLoggingExecutor:Ljava/util/concurrent/ExecutorService;

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdown()V

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mScheduler:Ljava/util/concurrent/ScheduledExecutorService;

    invoke-interface {p0}, Ljava/util/concurrent/ScheduledExecutorService;->shutdown()V

    return-void
.end method

.method public final sendLoggingData(Ljava/lang/String;)V
    .locals 3

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mLoggingExecutor:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;

    const/4 v2, 0x2

    invoke-direct {v1, v2}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;-><init>(I)V

    iput-object p0, v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iput-object p1, v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda6;->f$1:Ljava/lang/Object;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    return-void
.end method

.method public final setWaitingViewRotation()V
    .locals 2

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mApp:Landroid/app/Application;

    invoke-virtual {v0}, Landroid/app/Application;->getDisplay()Landroid/view/Display;

    move-result-object v0

    if-eqz v0, :cond_4

    invoke-virtual {v0}, Landroid/view/Display;->getRotation()I

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_3

    if-eq v0, v1, :cond_2

    const/4 v1, 0x2

    if-eq v0, v1, :cond_1

    const/4 v1, 0x3

    if-eq v0, v1, :cond_0

    goto :goto_0

    :cond_0
    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mViewWindowParams:Landroid/view/WindowManager$LayoutParams;

    const/16 v0, 0x8

    iput v0, p0, Landroid/view/WindowManager$LayoutParams;->screenOrientation:I

    return-void

    :cond_1
    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mViewWindowParams:Landroid/view/WindowManager$LayoutParams;

    const/16 v0, 0x9

    iput v0, p0, Landroid/view/WindowManager$LayoutParams;->screenOrientation:I

    return-void

    :cond_2
    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mViewWindowParams:Landroid/view/WindowManager$LayoutParams;

    const/4 v0, 0x0

    iput v0, p0, Landroid/view/WindowManager$LayoutParams;->screenOrientation:I

    return-void

    :cond_3
    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mViewWindowParams:Landroid/view/WindowManager$LayoutParams;

    iput v1, p0, Landroid/view/WindowManager$LayoutParams;->screenOrientation:I

    :cond_4
    :goto_0
    return-void
.end method
