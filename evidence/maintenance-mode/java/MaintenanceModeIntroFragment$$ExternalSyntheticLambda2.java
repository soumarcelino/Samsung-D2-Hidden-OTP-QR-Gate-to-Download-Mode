package com.samsung.android.settings.maintenancemode;

import android.view.View;
import androidx.appcompat.widget.SeslCheckedTextView;
import androidx.fragment.app.FragmentManager;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;
import com.samsung.android.knox.p045zt.config.securelog.SignalSeverity;
import java.lang.invoke.VarHandle;
import java.util.concurrent.ExecutorService;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeIntroFragment$$ExternalSyntheticLambda2 implements View.OnClickListener {
    public final /* synthetic */ int $r8$classId;
    public /* synthetic */ Object f$0;

    public /* synthetic */ MaintenanceModeIntroFragment$$ExternalSyntheticLambda2(int i) {
        this.$r8$classId = i;
    }

    @Override // android.view.View.OnClickListener
    public final void onClick(View view) {
        int i = this.$r8$classId;
        Object obj = this.f$0;
        switch (i) {
            case 0:
                MaintenanceModeIntroFragment maintenanceModeIntroFragment = (MaintenanceModeIntroFragment) obj;
                int i2 = 1;
                if (!MaintenanceModeUtils.isSecureLockSet(maintenanceModeIntroFragment.mActivity)) {
                    MaintenanceModeIntroFragment.IntroDialogFragment introDialogFragment = new MaintenanceModeIntroFragment.IntroDialogFragment();
                    FragmentManager childFragmentManager = maintenanceModeIntroFragment.getChildFragmentManager();
                    introDialogFragment.mDialogType = 1;
                    introDialogFragment.mExtra = SignalSeverity.NONE;
                    introDialogFragment.show(childFragmentManager, "MaintenanceMode");
                } else if (!MaintenanceModeUtils.isLowOnStorage(maintenanceModeIntroFragment.mActivity)) {
                    maintenanceModeIntroFragment.mTurnOnButton.setClickable(false);
                    ExecutorService executorService = maintenanceModeIntroFragment.mButtonExecutor;
                    MaintenanceModeIntroFragment$$ExternalSyntheticLambda4 maintenanceModeIntroFragment$$ExternalSyntheticLambda4 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda4(i2);
                    maintenanceModeIntroFragment$$ExternalSyntheticLambda4.f$0 = maintenanceModeIntroFragment;
                    VarHandle.storeStoreFence();
                    executorService.submit(maintenanceModeIntroFragment$$ExternalSyntheticLambda4);
                    maintenanceModeIntroFragment.mViewModel.sendLoggingData("7066");
                } else {
                    MaintenanceModeIntroFragment.IntroDialogFragment introDialogFragment2 = new MaintenanceModeIntroFragment.IntroDialogFragment();
                    FragmentManager childFragmentManager2 = maintenanceModeIntroFragment.getChildFragmentManager();
                    introDialogFragment2.mDialogType = 2;
                    introDialogFragment2.mExtra = SignalSeverity.NONE;
                    introDialogFragment2.show(childFragmentManager2, "MaintenanceMode");
                }
                break;
            default:
                ((SeslCheckedTextView) obj).toggle();
                break;
        }
    }
}
