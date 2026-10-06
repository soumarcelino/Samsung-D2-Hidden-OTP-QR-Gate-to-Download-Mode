.class public Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$OutroDialogFragment;
.super Landroidx/fragment/app/DialogFragment;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "OutroDialogFragment"
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Landroidx/fragment/app/DialogFragment;-><init>()V

    return-void
.end method


# virtual methods
.method public final onCreateDialog(Landroid/os/Bundle;)Landroid/app/Dialog;
    .locals 2

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getParentFragment()Landroidx/fragment/app/Fragment;

    move-result-object v0

    if-eqz v0, :cond_2

    instance-of v1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;

    if-nez v1, :cond_0

    goto :goto_1

    :cond_0
    check-cast v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;

    new-instance p0, Landroid/app/AlertDialog$Builder;

    iget-object p1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-direct {p0, p1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    iget-object p1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iget-boolean p1, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsTablet:Z

    if-eqz p1, :cond_1

    const p1, 0x7f1521a3

    goto :goto_0

    :cond_1
    const p1, 0x7f1521a2

    :goto_0
    invoke-virtual {p0, p1}, Landroid/app/AlertDialog$Builder;->setMessage(I)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    new-instance p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$$ExternalSyntheticLambda2;

    invoke-direct {p1}, Ljava/lang/Object;-><init>()V

    iput-object v0, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$$ExternalSyntheticLambda2;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    const v0, 0x7f150fdf

    invoke-virtual {p0, v0, p1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    new-instance p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$$ExternalSyntheticLambda3;

    invoke-direct {p1}, Ljava/lang/Object;-><init>()V

    const v0, 0x7f150fdd

    invoke-virtual {p0, v0, p1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    const/16 v0, 0x50

    invoke-virtual {p1, v0}, Landroid/view/Window;->setGravity(I)V

    return-object p0

    :cond_2
    :goto_1
    invoke-super {p0, p1}, Landroidx/fragment/app/DialogFragment;->onCreateDialog(Landroid/os/Bundle;)Landroid/app/Dialog;

    move-result-object p0

    return-object p0
.end method
