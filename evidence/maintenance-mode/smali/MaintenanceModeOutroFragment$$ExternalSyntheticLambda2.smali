.class public final synthetic Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# instance fields
.field public synthetic f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;


# virtual methods
.method public final onClick(Landroid/content/DialogInterface;I)V
    .locals 0

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$$ExternalSyntheticLambda2;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    new-instance p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;

    const/4 p2, 0x0

    invoke-direct {p1, p2}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;-><init>(I)V

    iput-object p0, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel$$ExternalSyntheticLambda2;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mApp:Landroid/app/Application;

    invoke-static {p0, p1}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->confirmSecureLock(Landroid/content/Context;Ljava/lang/Runnable;)V

    return-void
.end method
