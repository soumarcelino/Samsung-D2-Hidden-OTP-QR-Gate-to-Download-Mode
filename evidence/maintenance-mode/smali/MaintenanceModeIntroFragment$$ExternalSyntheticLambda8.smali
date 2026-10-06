.class public final synthetic Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;
.super Ljava/lang/Object;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# instance fields
.field public final synthetic $r8$classId:I

.field public synthetic f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;


# direct methods
.method public synthetic constructor <init>(I)V
    .locals 0

    iput p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;->$r8$classId:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/content/DialogInterface;I)V
    .locals 0

    iget p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;->$r8$classId:I

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    packed-switch p1, :pswitch_data_0

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-static {p0}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->startSecureLockSettingsActivity(Landroid/content/Context;)V

    return-void

    :pswitch_0
    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-static {p0}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->startMyFilesActivity(Landroid/app/Activity;)V

    return-void

    :pswitch_1
    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    const-string p1, "7069"

    invoke-virtual {p0, p1}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->sendLoggingData(Ljava/lang/String;)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
