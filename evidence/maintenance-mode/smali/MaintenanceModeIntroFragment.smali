.class public Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;
.super Lcom/android/settings/SettingsPreferenceFragment;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;
    }
.end annotation


# static fields
.field public static final synthetic $r8$clinit:I


# instance fields
.field public mActivity:Landroidx/fragment/app/FragmentActivity;

.field public final mButtonExecutor:Ljava/util/concurrent/ExecutorService;

.field public mCloudBackupPreference:Landroidx/preference/Preference;

.field public final mCloudBackupReceiver:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$CloudBackupReceiver;

.field public mCloudBackupStatus:Ljava/lang/String;

.field public final mCloudStatusExecutor:Ljava/util/concurrent/ExecutorService;

.field public final mCloudStatusTimer:Ljava/util/Timer;

.field public mCloudStatusTimerTask:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$1;

.field public mIsCloudBackupSupported:Z

.field public mResources:Landroid/content/res/Resources;

.field public mTurnOnButton:Landroid/widget/Button;

.field public mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Lcom/android/settings/SettingsPreferenceFragment;-><init>()V

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mIsCloudBackupSupported:Z

    const-string v0, "NONE"

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudBackupStatus:Ljava/lang/String;

    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mButtonExecutor:Ljava/util/concurrent/ExecutorService;

    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudStatusExecutor:Ljava/util/concurrent/ExecutorService;

    new-instance v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$CloudBackupReceiver;

    invoke-direct {v0, p0}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$CloudBackupReceiver;-><init>(Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;)V

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudBackupReceiver:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$CloudBackupReceiver;

    new-instance v0, Ljava/util/Timer;

    invoke-direct {v0}, Ljava/util/Timer;-><init>()V

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudStatusTimer:Ljava/util/Timer;

    return-void
.end method


# virtual methods
.method public final getMetricsCategory()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public final getPreferenceScreenResId()I
    .locals 0

    const p0, 0x7f180149

    return p0
.end method

.method public final onCreate(Landroid/os/Bundle;)V
    .locals 2

    invoke-super {p0, p1}, Lcom/android/settings/SettingsPreferenceFragment;->onCreate(Landroid/os/Bundle;)V

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-virtual {p1}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mResources:Landroid/content/res/Resources;

    iget-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    const/4 v0, 0x1

    invoke-static {p1, v0}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->checkRequiredConditions(Landroid/content/Context;Z)I

    move-result p1

    if-eqz p1, :cond_0

    invoke-virtual {p0}, Lcom/android/settings/SettingsPreferenceFragment;->finish()V

    return-void

    :cond_0
    new-instance p1, Landroidx/lifecycle/ViewModelProvider;

    invoke-direct {p1, p0}, Landroidx/lifecycle/ViewModelProvider;-><init>(Landroidx/lifecycle/ViewModelStoreOwner;)V

    const-class v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    sget-object v1, Lkotlin/jvm/internal/Reflection;->factory:Lkotlin/jvm/internal/ReflectionFactory;

    invoke-virtual {v1, v0}, Lkotlin/jvm/internal/ReflectionFactory;->getOrCreateKotlinClass(Ljava/lang/Class;)Lkotlin/reflect/KClass;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroidx/lifecycle/ViewModelProvider;->get(Lkotlin/reflect/KClass;)Landroidx/lifecycle/ViewModel;

    move-result-object p1

    check-cast p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    return-void
.end method

.method public final onDestroy()V
    .locals 2

    :try_start_0
    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    iget-object v1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudBackupReceiver:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$CloudBackupReceiver;

    invoke-virtual {v0, v1}, Landroid/app/Activity;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudStatusTimer:Ljava/util/Timer;

    invoke-virtual {v0}, Ljava/util/Timer;->cancel()V

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudStatusExecutor:Ljava/util/concurrent/ExecutorService;

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mButtonExecutor:Ljava/util/concurrent/ExecutorService;

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    invoke-super {p0}, Lcom/android/settings/SettingsPreferenceFragment;->onDestroy()V

    return-void
.end method

.method public final onPause()V
    .locals 1

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudStatusTimerTask:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$1;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/util/TimerTask;->cancel()Z

    :cond_0
    invoke-super {p0}, Lcom/android/settings/core/InstrumentedPreferenceFragment;->onPause()V

    return-void
.end method

.method public final onResume()V
    .locals 9

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->checkRequiredConditions(Landroid/content/Context;Z)I

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lcom/android/settings/SettingsPreferenceFragment;->finish()V

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    move v0, v1

    :goto_0
    invoke-super {p0}, Lcom/android/settings/SettingsPreferenceFragment;->onResume()V

    if-eqz v0, :cond_1

    return-void

    :cond_1
    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudStatusExecutor:Ljava/util/concurrent/ExecutorService;

    new-instance v2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;

    invoke-direct {v2, v1}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;-><init>(I)V

    iput-object p0, v2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;->f$0:Ljava/lang/Object;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-interface {v0, v2}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    new-instance v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$1;

    invoke-direct {v4, p0}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$1;-><init>(Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;)V

    iput-object v4, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudStatusTimerTask:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$1;

    iget-object v3, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudStatusTimer:Ljava/util/Timer;

    const-wide/16 v5, 0x7530

    const-wide/16 v7, 0x7530

    invoke-virtual/range {v3 .. v8}, Ljava/util/Timer;->schedule(Ljava/util/TimerTask;JJ)V

    return-void
.end method

.method public final onViewCreated(Landroid/view/View;Landroid/os/Bundle;)V
    .locals 11

    invoke-super {p0, p1, p2}, Lcom/android/settings/SettingsPreferenceFragment;->onViewCreated(Landroid/view/View;Landroid/os/Bundle;)V

    iget-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iget-boolean p1, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsTablet:Z

    if-eqz p1, :cond_0

    const-string p1, "fragment_intro"

    invoke-virtual {p0, p1}, Lcom/android/settings/core/InstrumentedPreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object p1

    check-cast p1, Lcom/android/settingslib/widget/LayoutPreference;

    const p2, 0x7f0b139a

    iget-object v0, p1, Lcom/android/settingslib/widget/LayoutPreference;->mRootView:Landroid/view/View;

    invoke-virtual {v0, p2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p2

    check-cast p2, Landroid/widget/TextView;

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mResources:Landroid/content/res/Resources;

    const v1, 0x7f1516d7

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const p2, 0x7f0b0565

    iget-object v0, p1, Lcom/android/settingslib/widget/LayoutPreference;->mRootView:Landroid/view/View;

    invoke-virtual {v0, p2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p2

    check-cast p2, Landroid/widget/TextView;

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mResources:Landroid/content/res/Resources;

    const v1, 0x7f1516c5

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const p2, 0x7f0b0fcd

    iget-object p1, p1, Lcom/android/settingslib/widget/LayoutPreference;->mRootView:Landroid/view/View;

    invoke-virtual {p1, p2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iget-object p2, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mResources:Landroid/content/res/Resources;

    const v0, 0x7f1516d3

    invoke-virtual {p2, v0}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_0
    const-string p1, "backup_menu_cloud"

    invoke-virtual {p0, p1}, Lcom/android/settings/core/InstrumentedPreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudBackupPreference:Landroidx/preference/Preference;

    new-instance p2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda0;

    const/4 v0, 0x0

    invoke-direct {p2, v0}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda0;-><init>(I)V

    iput-object p0, p2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda0;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-virtual {p1, p2}, Landroidx/preference/Preference;->setOnPreferenceClickListener(Landroidx/preference/Preference$OnPreferenceClickListener;)V

    const-string p1, "backup_menu_smart_switch"

    invoke-virtual {p0, p1}, Lcom/android/settings/core/InstrumentedPreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object p1

    new-instance p2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda0;

    const/4 v1, 0x1

    invoke-direct {p2, v1}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda0;-><init>(I)V

    iput-object p0, p2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda0;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-virtual {p1, p2}, Landroidx/preference/Preference;->setOnPreferenceClickListener(Landroidx/preference/Preference$OnPreferenceClickListener;)V

    iget-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    const p2, 0x7f0b0714

    invoke-virtual {p1, p2}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Lcom/samsung/android/settings/widget/SecFloatingBottomLayout;

    if-eqz p1, :cond_2

    invoke-virtual {p1}, Landroid/widget/FrameLayout;->removeAllViews()V

    iget-object p2, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-static {p2}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p2

    const v1, 0x7f0e0154

    const/4 v2, 0x0

    invoke-virtual {p2, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p2

    const v1, 0x7f0b02ec

    invoke-virtual {p2, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Button;

    iput-object v1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mTurnOnButton:Landroid/widget/Button;

    iget-object v3, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mResources:Landroid/content/res/Resources;

    const v4, 0x7f1516c1

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    iget-object v1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iget-boolean v1, v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsTablet:Z

    if-eqz v1, :cond_1

    iget-object v1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mTurnOnButton:Landroid/widget/Button;

    iget-object v3, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mResources:Landroid/content/res/Resources;

    const v4, 0x7f070168

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v3

    invoke-virtual {v1, v3}, Landroid/widget/Button;->setWidth(I)V

    :cond_1
    iget-object v1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mTurnOnButton:Landroid/widget/Button;

    new-instance v3, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda2;

    invoke-direct {v3, v0}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda2;-><init>(I)V

    iput-object p0, v3, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda2;->f$0:Ljava/lang/Object;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-virtual {v1, v3}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iget-object v1, v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsPrimaryButtonClickable:Landroidx/lifecycle/MutableLiveData;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getViewLifecycleOwner()Landroidx/lifecycle/LifecycleOwner;

    move-result-object v3

    new-instance v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda3;

    invoke-direct {v4}, Ljava/lang/Object;-><init>()V

    iput-object p0, v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda3;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-virtual {v1, v3, v4}, Landroidx/lifecycle/LiveData;->observe(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Observer;)V

    invoke-virtual {p1, p2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;)V

    invoke-virtual {p1, v0}, Landroid/widget/FrameLayout;->setVisibility(I)V

    invoke-virtual {p1, v2}, Lcom/google/android/material/oneui/floatingactioncontainer/FloatingGroupLayout;->setFloatingAware(Lcom/google/android/material/oneui/floatingactioncontainer/FloatingGroupLayout$FloatingGroupAware;)V

    :cond_2
    new-instance v7, Landroid/content/IntentFilter;

    invoke-direct {v7}, Landroid/content/IntentFilter;-><init>()V

    const-string p1, "com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_STARTED"

    invoke-virtual {v7, p1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string p1, "com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_COMPLETED"

    invoke-virtual {v7, p1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string p1, "com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_NOT_FINISHED"

    invoke-virtual {v7, p1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string p1, "com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_CANCELED"

    invoke-virtual {v7, p1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    iget-object v5, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    iget-object v6, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudBackupReceiver:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$CloudBackupReceiver;

    const/4 v9, 0x0

    const/4 v10, 0x2

    const-string v8, "com.samsung.android.permission.ACCESS_MAINTENANCE_MODE"

    invoke-virtual/range {v5 .. v10}, Landroid/app/Activity;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;I)Landroid/content/Intent;

    iget-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudStatusExecutor:Ljava/util/concurrent/ExecutorService;

    new-instance p2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;

    invoke-direct {p2, v0}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;-><init>(I)V

    iput-object p0, p2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;->f$0:Ljava/lang/Object;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-interface {p1, p2}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    return-void
.end method

.method public final updateCloudBackupMenuSummary()V
    .locals 3

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudBackupPreference:Landroidx/preference/Preference;

    if-nez v0, :cond_0

    return-void

    :cond_0
    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudBackupStatus:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    move-result v1

    const/4 v2, -0x1

    sparse-switch v1, :sswitch_data_0

    goto :goto_0

    :sswitch_0
    const-string v1, "BACKUP_COMPLETED"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    goto :goto_0

    :cond_1
    const/4 v2, 0x2

    goto :goto_0

    :sswitch_1
    const-string v1, "BACKUP_RUNNING"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    goto :goto_0

    :cond_2
    const/4 v2, 0x1

    goto :goto_0

    :sswitch_2
    const-string v1, "BACKUP_NON_FINISHED"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_3

    goto :goto_0

    :cond_3
    const/4 v2, 0x0

    :goto_0
    packed-switch v2, :pswitch_data_0

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudBackupPreference:Landroidx/preference/Preference;

    const-string v0, ""

    invoke-virtual {p0, v0}, Landroidx/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    return-void

    :pswitch_0
    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudBackupPreference:Landroidx/preference/Preference;

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mResources:Landroid/content/res/Resources;

    const v1, 0x7f1506e8

    invoke-virtual {p0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroidx/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    return-void

    :pswitch_1
    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudBackupPreference:Landroidx/preference/Preference;

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mResources:Landroid/content/res/Resources;

    const v1, 0x7f1506e9

    invoke-virtual {p0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroidx/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    return-void

    :pswitch_2
    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mCloudBackupPreference:Landroidx/preference/Preference;

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mResources:Landroid/content/res/Resources;

    const v1, 0x7f1506e7

    invoke-virtual {p0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroidx/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    return-void

    nop

    :sswitch_data_0
    .sparse-switch
        -0x2c16aedf -> :sswitch_2
        -0xd7f2fde -> :sswitch_1
        0x4ed9fee -> :sswitch_0
    .end sparse-switch

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
