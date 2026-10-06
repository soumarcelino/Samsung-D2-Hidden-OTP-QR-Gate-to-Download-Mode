.class public final synthetic Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda6;
.super Ljava/lang/Object;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# instance fields
.field public synthetic f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

.field public synthetic f$1:Landroidx/appcompat/widget/SeslCheckedTextView;


# virtual methods
.method public final onClick(Landroid/content/DialogInterface;I)V
    .locals 1

    iget-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda6;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda6;->f$1:Landroidx/appcompat/widget/SeslCheckedTextView;

    iget-object p2, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-static {p2}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->isSecureLockSet(Landroid/content/Context;)Z

    move-result p2

    const/4 v0, 0x1

    if-nez p2, :cond_0

    new-instance p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;

    invoke-direct {p0}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;-><init>()V

    invoke-virtual {p1}, Landroidx/fragment/app/Fragment;->getChildFragmentManager()Landroidx/fragment/app/FragmentManager;

    move-result-object p1

    iput v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mDialogType:I

    const-string p2, "none"

    iput-object p2, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mExtra:Ljava/lang/String;

    const-string p2, "MaintenanceMode"

    invoke-virtual {p0, p1, p2}, Landroidx/fragment/app/DialogFragment;->show(Landroidx/fragment/app/FragmentManager;Ljava/lang/String;)V

    return-void

    :cond_0
    iget-boolean p0, p0, Landroidx/appcompat/widget/SeslCheckedTextView;->mChecked:Z

    xor-int/2addr p0, v0

    iget-object p1, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    new-instance p2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;

    const/4 v0, 0x0

    invoke-direct {p2, v0}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;-><init>(I)V

    iput-object p1, p2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iput-boolean p0, p2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda1;->f$1:Z

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    iget-object p0, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mApp:Landroid/app/Application;

    invoke-static {p0, p2}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->confirmSecureLock(Landroid/content/Context;Ljava/lang/Runnable;)V

    return-void
.end method
