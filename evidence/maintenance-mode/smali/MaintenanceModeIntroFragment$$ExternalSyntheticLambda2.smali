.class public final synthetic Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field public final synthetic $r8$classId:I

.field public synthetic f$0:Ljava/lang/Object;


# direct methods
.method public synthetic constructor <init>(I)V
    .locals 0

    iput p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda2;->$r8$classId:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/view/View;)V
    .locals 3

    iget p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda2;->$r8$classId:I

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda2;->f$0:Ljava/lang/Object;

    packed-switch p1, :pswitch_data_0

    check-cast p0, Landroidx/appcompat/widget/SeslCheckedTextView;

    invoke-virtual {p0}, Landroidx/appcompat/widget/SeslCheckedTextView;->toggle()V

    return-void

    :pswitch_0
    check-cast p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    iget-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-static {p1}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->isSecureLockSet(Landroid/content/Context;)Z

    move-result p1

    const/4 v0, 0x1

    const-string v1, "MaintenanceMode"

    const-string v2, "none"

    if-nez p1, :cond_0

    new-instance p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;

    invoke-direct {p1}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;-><init>()V

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getChildFragmentManager()Landroidx/fragment/app/FragmentManager;

    move-result-object p0

    iput v0, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mDialogType:I

    iput-object v2, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mExtra:Ljava/lang/String;

    invoke-virtual {p1, p0, v1}, Landroidx/fragment/app/DialogFragment;->show(Landroidx/fragment/app/FragmentManager;Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    iget-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-static {p1}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->isLowOnStorage(Landroid/content/Context;)Z

    move-result p1

    if-eqz p1, :cond_1

    new-instance p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;

    invoke-direct {p1}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;-><init>()V

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getChildFragmentManager()Landroidx/fragment/app/FragmentManager;

    move-result-object p0

    const/4 v0, 0x2

    iput v0, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mDialogType:I

    iput-object v2, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mExtra:Ljava/lang/String;

    invoke-virtual {p1, p0, v1}, Landroidx/fragment/app/DialogFragment;->show(Landroidx/fragment/app/FragmentManager;Ljava/lang/String;)V

    goto :goto_0

    :cond_1
    iget-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mTurnOnButton:Landroid/widget/Button;

    const/4 v1, 0x0

    invoke-virtual {p1, v1}, Landroid/widget/Button;->setClickable(Z)V

    iget-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mButtonExecutor:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;

    invoke-direct {v1, v0}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;-><init>(I)V

    iput-object p0, v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda4;->f$0:Ljava/lang/Object;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-interface {p1, v1}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/lang/Runnable;)Ljava/util/concurrent/Future;

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    const-string p1, "7066"

    invoke-virtual {p0, p1}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->sendLoggingData(Ljava/lang/String;)V

    :goto_0
    return-void

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
