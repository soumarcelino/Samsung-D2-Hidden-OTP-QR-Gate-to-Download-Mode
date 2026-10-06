.class public final synthetic Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda7;
.super Ljava/lang/Object;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# instance fields
.field public synthetic f$0:Z

.field public synthetic f$1:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;


# virtual methods
.method public final onClick(Landroid/content/DialogInterface;I)V
    .locals 1

    iget-boolean p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda7;->f$0:Z

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda7;->f$1:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    if-eqz p1, :cond_0

    iget-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mButtonExecutor:Ljava/util/concurrent/ExecutorService;

    new-instance p2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;

    const/4 v0, 0x5

    invoke-direct {p2, v0}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;-><init>(I)V

    iput-object p0, p2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;->f$0:Ljava/lang/Object;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-interface {p1, p2}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    goto :goto_0

    :cond_0
    new-instance p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;

    invoke-direct {p1}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;-><init>()V

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getChildFragmentManager()Landroidx/fragment/app/FragmentManager;

    move-result-object p2

    const/4 v0, 0x4

    iput v0, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mDialogType:I

    const-string v0, "none"

    iput-object v0, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mExtra:Ljava/lang/String;

    const-string v0, "MaintenanceMode"

    invoke-virtual {p1, p2, v0}, Landroidx/fragment/app/DialogFragment;->show(Landroidx/fragment/app/FragmentManager;Ljava/lang/String;)V

    :goto_0
    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    const-string p1, "7068"

    invoke-virtual {p0, p1}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->sendLoggingData(Ljava/lang/String;)V

    return-void
.end method
