.class public Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;
.super Lcom/android/settings/SettingsPreferenceFragment;
.source "qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$OutroDialogFragment;
    }
.end annotation


# static fields
.field public static final synthetic $r8$clinit:I


# instance fields
.field public mActivity:Landroidx/fragment/app/FragmentActivity;

.field public mExitButton:Landroid/widget/Button;

.field public mResources:Landroid/content/res/Resources;

.field public mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Lcom/android/settings/SettingsPreferenceFragment;-><init>()V

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

    const p0, 0x7f18014a

    return p0
.end method

.method public final onCreate(Landroid/os/Bundle;)V
    .locals 2

    invoke-super {p0, p1}, Lcom/android/settings/SettingsPreferenceFragment;->onCreate(Landroid/os/Bundle;)V

    invoke-static {}, Landroid/app/ActivityManager;->getCurrentUser()I

    move-result p1

    const/16 v0, 0x4d

    if-eq p1, v0, :cond_0

    invoke-virtual {p0}, Lcom/android/settings/SettingsPreferenceFragment;->finish()V

    return-void

    :cond_0
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-virtual {p1}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mResources:Landroid/content/res/Resources;

    new-instance p1, Landroidx/lifecycle/ViewModelProvider;

    invoke-direct {p1, p0}, Landroidx/lifecycle/ViewModelProvider;-><init>(Landroidx/lifecycle/ViewModelStoreOwner;)V

    const-class v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    sget-object v1, Lkotlin/jvm/internal/Reflection;->factory:Lkotlin/jvm/internal/ReflectionFactory;

    invoke-virtual {v1, v0}, Lkotlin/jvm/internal/ReflectionFactory;->getOrCreateKotlinClass(Ljava/lang/Class;)Lkotlin/reflect/KClass;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroidx/lifecycle/ViewModelProvider;->get(Lkotlin/reflect/KClass;)Landroidx/lifecycle/ViewModel;

    move-result-object p1

    check-cast p1, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iput-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    return-void
.end method

.method public final onViewCreated(Landroid/view/View;Landroid/os/Bundle;)V
    .locals 4

    invoke-super {p0, p1, p2}, Lcom/android/settings/SettingsPreferenceFragment;->onViewCreated(Landroid/view/View;Landroid/os/Bundle;)V

    iget-object p1, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    const p2, 0x7f0b0714

    invoke-virtual {p1, p2}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Lcom/samsung/android/settings/widget/SecFloatingBottomLayout;

    if-eqz p1, :cond_1

    invoke-virtual {p1}, Landroid/widget/FrameLayout;->removeAllViews()V

    iget-object p2, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mActivity:Landroidx/fragment/app/FragmentActivity;

    invoke-static {p2}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p2

    const v0, 0x7f0e0154

    const/4 v1, 0x0

    invoke-virtual {p2, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p2

    const v0, 0x7f0b02ec

    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mExitButton:Landroid/widget/Button;

    iget-object v2, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mResources:Landroid/content/res/Resources;

    const v3, 0x7f1521a1

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iget-boolean v0, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsTablet:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mExitButton:Landroid/widget/Button;

    iget-object v2, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mResources:Landroid/content/res/Resources;

    const v3, 0x7f070168

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v2

    invoke-virtual {v0, v2}, Landroid/widget/Button;->setWidth(I)V

    :cond_0
    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mExitButton:Landroid/widget/Button;

    new-instance v2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$$ExternalSyntheticLambda0;

    invoke-direct {v2}, Ljava/lang/Object;-><init>()V

    iput-object p0, v2, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$$ExternalSyntheticLambda0;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-virtual {v0, v2}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    iget-object v0, p0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;->mViewModel:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;

    iget-object v0, v0, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeViewModel;->mIsPrimaryButtonClickable:Landroidx/lifecycle/MutableLiveData;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getViewLifecycleOwner()Landroidx/lifecycle/LifecycleOwner;

    move-result-object v2

    new-instance v3, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$$ExternalSyntheticLambda1;

    invoke-direct {v3}, Ljava/lang/Object;-><init>()V

    iput-object p0, v3, Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment$$ExternalSyntheticLambda1;->f$0:Lcom/samsung/android/settings/maintenancemode/MaintenanceModeOutroFragment;

    invoke-static {}, Ljava/lang/invoke/VarHandle;->storeStoreFence()V

    invoke-virtual {v0, v2, v3}, Landroidx/lifecycle/LiveData;->observe(Landroidx/lifecycle/LifecycleOwner;Landroidx/lifecycle/Observer;)V

    invoke-virtual {p1, p2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;)V

    const/4 p0, 0x0

    invoke-virtual {p1, p0}, Landroid/widget/FrameLayout;->setVisibility(I)V

    invoke-virtual {p1, v1}, Lcom/google/android/material/oneui/floatingactioncontainer/FloatingGroupLayout;->setFloatingAware(Lcom/google/android/material/oneui/floatingactioncontainer/FloatingGroupLayout$FloatingGroupAware;)V

    :cond_1
    return-void
.end method
