.class public final synthetic Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field public synthetic f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;


# virtual methods
.method public final onClick(Landroid/view/View;)V
    .locals 1

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$$ExternalSyntheticLambda0;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;

    new-instance p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$OutroDialogFragment;

    invoke-direct {p1}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$OutroDialogFragment;-><init>()V

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getChildFragmentManager()Landroidx/fragment/app/FragmentManager;

    move-result-object p0

    const-string v0, "MaintenanceMode"

    invoke-virtual {p1, p0, v0}, Landroidx/fragment/app/DialogFragment;->show(Landroidx/fragment/app/FragmentManager;Ljava/lang/String;)V

    return-void
.end method
