package com.samsung.android.settings.maintenancemode;

import android.content.DialogInterface;
import androidx.fragment.app.FragmentManager;
import com.samsung.android.knox.p045zt.config.securelog.SignalSeverity;
import java.lang.invoke.VarHandle;
import java.util.concurrent.ExecutorService;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeIntroFragment$$ExternalSyntheticLambda7 implements DialogInterface.OnClickListener {
    public /* synthetic */ boolean f$0;
    public /* synthetic */ MaintenanceModeIntroFragment f$1;

    @Override // android.content.DialogInterface.OnClickListener
    public final void onClick(DialogInterface dialogInterface, int i) {
        boolean z = this.f$0;
        MaintenanceModeIntroFragment maintenanceModeIntroFragment = this.f$1;
        if (z) {
            ExecutorService executorService = maintenanceModeIntroFragment.mButtonExecutor;
            MaintenanceModeIntroFragment$$ExternalSyntheticLambda4 maintenanceModeIntroFragment$$ExternalSyntheticLambda4 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda4(5);
            maintenanceModeIntroFragment$$ExternalSyntheticLambda4.f$0 = maintenanceModeIntroFragment;
            VarHandle.storeStoreFence();
            executorService.submit(maintenanceModeIntroFragment$$ExternalSyntheticLambda4);
        } else {
            MaintenanceModeIntroFragment.IntroDialogFragment introDialogFragment = new MaintenanceModeIntroFragment.IntroDialogFragment();
            FragmentManager childFragmentManager = maintenanceModeIntroFragment.getChildFragmentManager();
            introDialogFragment.mDialogType = 4;
            introDialogFragment.mExtra = SignalSeverity.NONE;
            introDialogFragment.show(childFragmentManager, "MaintenanceMode");
        }
        maintenanceModeIntroFragment.mViewModel.sendLoggingData("7068");
    }
}
