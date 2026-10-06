package com.samsung.android.settings.maintenancemode;

import androidx.preference.Preference;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;
import java.lang.invoke.VarHandle;
import java.util.concurrent.ExecutorService;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeIntroFragment$$ExternalSyntheticLambda0 implements Preference.OnPreferenceClickListener {
    public final /* synthetic */ int $r8$classId;
    public /* synthetic */ MaintenanceModeIntroFragment f$0;

    public /* synthetic */ MaintenanceModeIntroFragment$$ExternalSyntheticLambda0(int i) {
        this.$r8$classId = i;
    }

    @Override // androidx.preference.Preference.OnPreferenceClickListener
    public final boolean onPreferenceClick(Preference preference) {
        int i = this.$r8$classId;
        MaintenanceModeIntroFragment maintenanceModeIntroFragment = this.f$0;
        switch (i) {
            case 0:
                ExecutorService executorService = maintenanceModeIntroFragment.mButtonExecutor;
                MaintenanceModeIntroFragment$$ExternalSyntheticLambda4 maintenanceModeIntroFragment$$ExternalSyntheticLambda4 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda4(3);
                maintenanceModeIntroFragment$$ExternalSyntheticLambda4.f$0 = maintenanceModeIntroFragment;
                VarHandle.storeStoreFence();
                executorService.submit(maintenanceModeIntroFragment$$ExternalSyntheticLambda4);
                maintenanceModeIntroFragment.mViewModel.sendLoggingData("7083");
                break;
            default:
                MaintenanceModeUtils.startSmartSwitchActivity(maintenanceModeIntroFragment.mActivity);
                maintenanceModeIntroFragment.mViewModel.sendLoggingData("7074");
                break;
        }
        return true;
    }
}
