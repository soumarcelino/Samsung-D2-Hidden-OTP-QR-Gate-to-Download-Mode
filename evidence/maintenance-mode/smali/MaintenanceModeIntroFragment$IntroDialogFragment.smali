.class public Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;
.super Landroidx/fragment/app/DialogFragment;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "IntroDialogFragment"
.end annotation


# instance fields
.field public mDialogType:I

.field public mExtra:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Landroidx/fragment/app/DialogFragment;-><init>()V

    const/4 v0, 0x0

    iput v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mDialogType:I

    const-string v0, "none"

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mExtra:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final onCreate(Landroid/os/Bundle;)V
    .locals 2

    invoke-super {p0, p1}, Landroidx/fragment/app/DialogFragment;->onCreate(Landroid/os/Bundle;)V

    if-eqz p1, :cond_0

    const-string v0, "type"

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mDialogType:I

    const-string v0, "extra"

    const-string v1, "none"

    invoke-virtual {p1, v0, v1}, Landroid/os/Bundle;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mExtra:Ljava/lang/String;

    :cond_0
    return-void
.end method

.method public final onCreateDialog(Landroid/os/Bundle;)Landroid/app/Dialog;
    .locals 8

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getParentFragment()Landroidx/fragment/app/Fragment;

    move-result-object v0

    if-eqz v0, :cond_c

    instance-of v1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    if-nez v1, :cond_0

    goto/16 :goto_7

    :cond_0
    check-cast v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    iget v1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mDialogType:I

    const/4 v2, 0x2

    const v3, 0x7f150fdd

    const/4 v4, 0x1

    const/16 v5, 0x50

    if-eq v1, v4, :cond_b

    if-eq v1, v2, :cond_9

    const/4 v6, 0x3

    const/4 v7, 0x0

    if-eq v1, v6, :cond_4

    const/4 v2, 0x4

    if-eq v1, v2, :cond_1

    invoke-super {p0, p1}, Landroidx/fragment/app/DialogFragment;->onCreateDialog(Landroid/os/Bundle;)Landroid/app/Dialog;

    move-result-object p0

    return-object p0

    :cond_1
    iget-object p0, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p0

    const p1, 0x7f0e020a

    const/4 v1, 0x0

    invoke-virtual {p0, p1, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p0

    const p1, 0x7f0b0596

    invoke-virtual {p0, p1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroidx/appcompat/widget/SeslCheckedTextView;

    new-instance v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda2;

    invoke-direct {v1, v4}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda2;-><init>(I)V

    iput-object p1, v1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda2;->f$0:Ljava/lang/Object;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-virtual {p1, v1}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    const v2, 0x7f07029f

    const v3, 0x3f8ccccd    # 1.1f

    invoke-static {v1, v2, v3}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->getFontSize(Landroid/content/Context;IF)F

    move-result v1

    invoke-virtual {p1, v7, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    const v1, 0x7f0b05af

    invoke-virtual {p0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mResources:Landroid/content/res/Resources;

    iget-object v4, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iget-boolean v4, v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsTablet:Z

    if-eqz v4, :cond_2

    const v4, 0x7f1516cb

    goto :goto_0

    :cond_2
    const v4, 0x7f1516ca

    :goto_0
    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\n\n"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mResources:Landroid/content/res/Resources;

    iget-object v4, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iget-boolean v4, v4, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsTablet:Z

    if-eqz v4, :cond_3

    const v4, 0x7f1516cd

    goto :goto_1

    :cond_3
    const v4, 0x7f1516cc

    :goto_1
    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v2, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    const v3, 0x7f0701ac

    invoke-static {v2, v3}, Lcom/samsung/android/core/pm/mm/MaintenanceModeUtils;->getFontSize(Landroid/content/Context;I)F

    move-result v2

    invoke-virtual {v1, v7, v2}, Landroid/widget/TextView;->setTextSize(IF)V

    new-instance v1, Landroidx/appcompat/app/AlertDialog$Builder;

    iget-object v2, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-direct {v1, v2}, Landroidx/appcompat/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    invoke-virtual {v1, p0}, Landroidx/appcompat/app/AlertDialog$Builder;->setView(Landroid/view/View;)V

    new-instance p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda6;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda6;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda6;->f$1:Landroidx/appcompat/widget/SeslCheckedTextView;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    const p1, 0x7f150fdf

    invoke-virtual {v1, p1, p0}, Landroidx/appcompat/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)V

    invoke-virtual {v1}, Landroidx/appcompat/app/AlertDialog$Builder;->create()Landroidx/appcompat/app/AlertDialog;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    invoke-virtual {p1, v5}, Landroid/view/Window;->setGravity(I)V

    return-object p0

    :cond_4
    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mExtra:Ljava/lang/String;

    if-eqz p0, :cond_8

    invoke-virtual {p0}, Ljava/lang/String;->hashCode()I

    move-result p1

    const/4 v1, -0x1

    sparse-switch p1, :sswitch_data_0

    :goto_2
    move v2, v1

    goto :goto_3

    :sswitch_0
    const-string p1, "BACKUP_RUNNING"

    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_7

    goto :goto_2

    :sswitch_1
    const-string p1, "BACKUP_NON_FINISHED"

    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_5

    goto :goto_2

    :cond_5
    move v2, v4

    goto :goto_3

    :sswitch_2
    const-string p1, "RESTORE_RUNNING"

    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_6

    goto :goto_2

    :cond_6
    move v2, v7

    :cond_7
    :goto_3
    packed-switch v2, :pswitch_data_0

    goto :goto_4

    :pswitch_0
    const p0, 0x7f1506e0

    goto :goto_5

    :pswitch_1
    const p0, 0x7f1506df

    goto :goto_5

    :pswitch_2
    const p0, 0x7f1506e1

    goto :goto_5

    :cond_8
    :goto_4
    const p0, 0x7f1506e2

    move v4, v7

    :goto_5
    new-instance p1, Landroidx/appcompat/app/AlertDialog$Builder;

    iget-object v1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-direct {p1, v1}, Landroidx/appcompat/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    invoke-virtual {p1, p0}, Landroidx/appcompat/app/AlertDialog$Builder;->setMessage(I)V

    new-instance p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda7;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-boolean v4, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda7;->f$0:Z

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda7;->f$1:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    const v1, 0x7f150fde

    invoke-virtual {p1, v1, p0}, Landroidx/appcompat/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)V

    new-instance p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;

    invoke-direct {p0, v7}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;-><init>(I)V

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-virtual {p1, v3, p0}, Landroidx/appcompat/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)V

    new-instance p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda9;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda9;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    iget-object v0, p1, Landroidx/appcompat/app/AlertDialog$Builder;->P:Landroidx/appcompat/app/AlertController$AlertParams;

    iput-object p0, v0, Landroidx/appcompat/app/AlertController$AlertParams;->mOnCancelListener:Landroid/content/DialogInterface$OnCancelListener;

    invoke-virtual {p1}, Landroidx/appcompat/app/AlertDialog$Builder;->create()Landroidx/appcompat/app/AlertDialog;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    invoke-virtual {p1, v5}, Landroid/view/Window;->setGravity(I)V

    return-object p0

    :cond_9
    const-string p0, "MaintenanceMode"

    const-string p1, "Device is low on storage"

    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    new-instance p0, Landroidx/appcompat/app/AlertDialog$Builder;

    iget-object p1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-direct {p0, p1}, Landroidx/appcompat/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const p1, 0x7f1516d1

    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AlertDialog$Builder;->setTitle(I)V

    iget-object p1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iget-boolean p1, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsTablet:Z

    if-eqz p1, :cond_a

    const p1, 0x7f1516d0

    goto :goto_6

    :cond_a
    const p1, 0x7f1516cf

    :goto_6
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AlertDialog$Builder;->setMessage(I)V

    new-instance p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;

    invoke-direct {p1, v4}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;-><init>(I)V

    iput-object v0, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    const v0, 0x7f1516c7

    invoke-virtual {p0, v0, p1}, Landroidx/appcompat/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)V

    invoke-virtual {p0}, Landroidx/appcompat/app/AlertDialog$Builder;->create()Landroidx/appcompat/app/AlertDialog;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    invoke-virtual {p1, v5}, Landroid/view/Window;->setGravity(I)V

    return-object p0

    :cond_b
    new-instance p0, Landroidx/appcompat/app/AlertDialog$Builder;

    iget-object p1, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-direct {p0, p1}, Landroidx/appcompat/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const p1, 0x7f1516ce

    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AlertDialog$Builder;->setMessage(I)V

    new-instance p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;

    invoke-direct {p1, v2}, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;-><init>(I)V

    iput-object v0, p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda8;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    const v0, 0x7f1516c8

    invoke-virtual {p0, v0, p1}, Landroidx/appcompat/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)V

    new-instance p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$$ExternalSyntheticLambda15;

    invoke-direct {p1}, Ljava/lang/Object;-><init>()V

    invoke-virtual {p0, v3, p1}, Landroidx/appcompat/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)V

    invoke-virtual {p0}, Landroidx/appcompat/app/AlertDialog$Builder;->create()Landroidx/appcompat/app/AlertDialog;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    invoke-virtual {p1, v5}, Landroid/view/Window;->setGravity(I)V

    return-object p0

    :cond_c
    :goto_7
    invoke-super {p0, p1}, Landroidx/fragment/app/DialogFragment;->onCreateDialog(Landroid/os/Bundle;)Landroid/app/Dialog;

    move-result-object p0

    return-object p0

    nop

    :sswitch_data_0
    .sparse-switch
        -0x3fd5a732 -> :sswitch_2
        -0x2c16aedf -> :sswitch_1
        -0xd7f2fde -> :sswitch_0
    .end sparse-switch

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public final onSaveInstanceState(Landroid/os/Bundle;)V
    .locals 2

    invoke-super {p0, p1}, Landroidx/fragment/app/DialogFragment;->onSaveInstanceState(Landroid/os/Bundle;)V

    const-string v0, "type"

    iget v1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mDialogType:I

    invoke-virtual {p1, v0, v1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    const-string v0, "extra"

    iget-object p0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeIntroFragment$IntroDialogFragment;->mExtra:Ljava/lang/String;

    invoke-virtual {p1, v0, p0}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
