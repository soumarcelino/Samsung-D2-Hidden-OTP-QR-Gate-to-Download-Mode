package com.samsung.android.settings.maintenancemode;

import androidx.fragment.app.FragmentActivity;
import androidx.preference.Preference;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;
import java.lang.invoke.VarHandle;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeIntroFragment$$ExternalSyntheticLambda4 implements Runnable {
    public final /* synthetic */ int $r8$classId;
    public /* synthetic */ Object f$0;

    public /* synthetic */ MaintenanceModeIntroFragment$$ExternalSyntheticLambda4(int i) {
        this.$r8$classId = i;
    }

    @Override // java.lang.Runnable
    public final void run() {
        int i = this.$r8$classId;
        int i2 = 4;
        Object obj = this.f$0;
        switch (i) {
            case 0:
                MaintenanceModeIntroFragment maintenanceModeIntroFragment = (MaintenanceModeIntroFragment) obj;
                maintenanceModeIntroFragment.mCloudBackupStatus = MaintenanceModeUtils.getCloudBackupStatus(maintenanceModeIntroFragment.mActivity);
                FragmentActivity fragmentActivity = maintenanceModeIntroFragment.mActivity;
                MaintenanceModeIntroFragment$$ExternalSyntheticLambda4 maintenanceModeIntroFragment$$ExternalSyntheticLambda4 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda4(i2);
                maintenanceModeIntroFragment$$ExternalSyntheticLambda4.f$0 = maintenanceModeIntroFragment;
                VarHandle.storeStoreFence();
                fragmentActivity.runOnUiThread(maintenanceModeIntroFragment$$ExternalSyntheticLambda4);
                maintenanceModeIntroFragment.mIsCloudBackupSupported = MaintenanceModeUtils.checkCloudBackupSupport(maintenanceModeIntroFragment.mActivity).isSupported;
                FragmentActivity fragmentActivity2 = maintenanceModeIntroFragment.mActivity;
                MaintenanceModeIntroFragment$$ExternalSyntheticLambda4 maintenanceModeIntroFragment$$ExternalSyntheticLambda5 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda4(2);
                maintenanceModeIntroFragment$$ExternalSyntheticLambda5.f$0 = maintenanceModeIntroFragment;
                VarHandle.storeStoreFence();
                fragmentActivity2.runOnUiThread(maintenanceModeIntroFragment$$ExternalSyntheticLambda5);
                break;
            case 1:
                MaintenanceModeIntroFragment maintenanceModeIntroFragment2 = (MaintenanceModeIntroFragment) obj;
                String statusOfBackupInProgress = MaintenanceModeUtils.getStatusOfBackupInProgress(maintenanceModeIntroFragment2.mActivity);
                FragmentActivity fragmentActivity3 = maintenanceModeIntroFragment2.mActivity;
                MaintenanceModeIntroFragment$$ExternalSyntheticLambda18 maintenanceModeIntroFragment$$ExternalSyntheticLambda18 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda18(0);
                maintenanceModeIntroFragment$$ExternalSyntheticLambda18.f$0 = maintenanceModeIntroFragment2;
                maintenanceModeIntroFragment$$ExternalSyntheticLambda18.f$1 = statusOfBackupInProgress;
                VarHandle.storeStoreFence();
                fragmentActivity3.runOnUiThread(maintenanceModeIntroFragment$$ExternalSyntheticLambda18);
                break;
            case 2:
                MaintenanceModeIntroFragment maintenanceModeIntroFragment3 = (MaintenanceModeIntroFragment) obj;
                maintenanceModeIntroFragment3.updateCloudBackupMenuSummary();
                Preference preference = maintenanceModeIntroFragment3.mCloudBackupPreference;
                if (preference != null) {
                    preference.setVisible(maintenanceModeIntroFragment3.mIsCloudBackupSupported);
                    break;
                }
                break;
            case 3:
                MaintenanceModeUtils.startCloudActivity(((MaintenanceModeIntroFragment) obj).mActivity);
                break;
            case 4:
                ((MaintenanceModeIntroFragment) obj).updateCloudBackupMenuSummary();
                break;
            case 5:
                MaintenanceModeUtils.startCloudActivity(((MaintenanceModeIntroFragment) obj).mActivity);
                break;
            default:
                MaintenanceModeIntroFragment maintenanceModeIntroFragment4 = MaintenanceModeIntroFragment.this;
                maintenanceModeIntroFragment4.mCloudBackupStatus = MaintenanceModeUtils.getCloudBackupStatus(maintenanceModeIntroFragment4.mActivity);
                FragmentActivity fragmentActivity4 = maintenanceModeIntroFragment4.mActivity;
                MaintenanceModeIntroFragment$$ExternalSyntheticLambda4 maintenanceModeIntroFragment$$ExternalSyntheticLambda6 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda4(i2);
                maintenanceModeIntroFragment$$ExternalSyntheticLambda6.f$0 = maintenanceModeIntroFragment4;
                VarHandle.storeStoreFence();
                fragmentActivity4.runOnUiThread(maintenanceModeIntroFragment$$ExternalSyntheticLambda6);
                break;
        }
    }
}
