package com.samsung.android.settings.maintenancemode;

import android.content.DialogInterface;
import androidx.appcompat.widget.SeslCheckedTextView;
import androidx.fragment.app.FragmentManager;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;
import com.samsung.android.knox.p045zt.config.securelog.SignalSeverity;
import java.lang.invoke.VarHandle;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeIntroFragment$$ExternalSyntheticLambda6 implements DialogInterface.OnClickListener {
    public /* synthetic */ MaintenanceModeIntroFragment f$0;
    public /* synthetic */ SeslCheckedTextView f$1;

    @Override // android.content.DialogInterface.OnClickListener
    public final void onClick(DialogInterface dialogInterface, int i) {
        MaintenanceModeIntroFragment maintenanceModeIntroFragment = this.f$0;
        SeslCheckedTextView seslCheckedTextView = this.f$1;
        if (!MaintenanceModeUtils.isSecureLockSet(maintenanceModeIntroFragment.mActivity)) {
            MaintenanceModeIntroFragment.IntroDialogFragment introDialogFragment = new MaintenanceModeIntroFragment.IntroDialogFragment();
            FragmentManager childFragmentManager = maintenanceModeIntroFragment.getChildFragmentManager();
            introDialogFragment.mDialogType = 1;
            introDialogFragment.mExtra = SignalSeverity.NONE;
            introDialogFragment.show(childFragmentManager, "MaintenanceMode");
            return;
        }
        boolean z = !seslCheckedTextView.mChecked;
        MaintenanceModeViewModel maintenanceModeViewModel = maintenanceModeIntroFragment.mViewModel;
        maintenanceModeViewModel.getClass();
        MaintenanceModeViewModel$$ExternalSyntheticLambda1 maintenanceModeViewModel$$ExternalSyntheticLambda1 = new MaintenanceModeViewModel$$ExternalSyntheticLambda1(0);
        maintenanceModeViewModel$$ExternalSyntheticLambda1.f$0 = maintenanceModeViewModel;
        maintenanceModeViewModel$$ExternalSyntheticLambda1.f$1 = z;
        VarHandle.storeStoreFence();
        MaintenanceModeUtils.confirmSecureLock(maintenanceModeViewModel.mApp, maintenanceModeViewModel$$ExternalSyntheticLambda1);
    }
}
