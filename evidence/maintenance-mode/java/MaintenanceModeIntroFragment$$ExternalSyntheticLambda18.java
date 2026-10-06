package com.samsung.android.settings.maintenancemode;

import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import com.samsung.android.knox.p045zt.config.securelog.SignalSeverity;
import java.lang.invoke.VarHandle;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeIntroFragment$$ExternalSyntheticLambda18 implements Runnable {
    public final /* synthetic */ int $r8$classId;
    public /* synthetic */ Object f$0;
    public /* synthetic */ String f$1;

    public /* synthetic */ MaintenanceModeIntroFragment$$ExternalSyntheticLambda18(int i) {
        this.$r8$classId = i;
    }

    /* JADX WARN: Can't fix incorrect switch cases order, some code will duplicate */
    /* JADX WARN: Code duplicated, block: B:17:0x003c  */
    @Override // java.lang.Runnable
    public final void run() {
        String str;
        int i = 4;
        switch (this.$r8$classId) {
            case 0:
                MaintenanceModeIntroFragment maintenanceModeIntroFragment = (MaintenanceModeIntroFragment) this.f$0;
                String str2 = this.f$1;
                if ("NOT_IN_PROGRESS".equals(str2)) {
                    MaintenanceModeIntroFragment.IntroDialogFragment introDialogFragment = new MaintenanceModeIntroFragment.IntroDialogFragment();
                    FragmentManager childFragmentManager = maintenanceModeIntroFragment.getChildFragmentManager();
                    introDialogFragment.mDialogType = 4;
                    introDialogFragment.mExtra = SignalSeverity.NONE;
                    introDialogFragment.show(childFragmentManager, "MaintenanceMode");
                } else {
                    MaintenanceModeIntroFragment.IntroDialogFragment introDialogFragment2 = new MaintenanceModeIntroFragment.IntroDialogFragment();
                    FragmentManager childFragmentManager2 = maintenanceModeIntroFragment.getChildFragmentManager();
                    introDialogFragment2.mDialogType = 3;
                    introDialogFragment2.mExtra = str2;
                    introDialogFragment2.show(childFragmentManager2, "MaintenanceMode");
                }
                maintenanceModeIntroFragment.mTurnOnButton.setClickable(true);
                break;
            default:
                MaintenanceModeIntroFragment.CloudBackupReceiver cloudBackupReceiver = (MaintenanceModeIntroFragment.CloudBackupReceiver) this.f$0;
                String str3 = this.f$1;
                MaintenanceModeIntroFragment maintenanceModeIntroFragment2 = MaintenanceModeIntroFragment.this;
                switch (str3.hashCode()) {
                    case 365973607:
                        str3.equals("com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_CANCELED");
                        str = "NONE";
                        break;
                    case 750993107:
                        if (!str3.equals("com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_STARTED")) {
                            str = "NONE";
                        } else {
                            str = "BACKUP_RUNNING";
                        }
                        break;
                    case 875734045:
                        if (!str3.equals("com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_COMPLETED")) {
                            str = "NONE";
                        } else {
                            str = "BACKUP_COMPLETED";
                        }
                        break;
                    case 1579405644:
                        if (!str3.equals("com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_NOT_FINISHED")) {
                            str = "NONE";
                        } else {
                            str = "BACKUP_NON_FINISHED";
                        }
                        break;
                    default:
                        str = "NONE";
                        break;
                }
                maintenanceModeIntroFragment2.mCloudBackupStatus = str;
                FragmentActivity fragmentActivity = maintenanceModeIntroFragment2.mActivity;
                MaintenanceModeIntroFragment$$ExternalSyntheticLambda4 maintenanceModeIntroFragment$$ExternalSyntheticLambda4 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda4(i);
                maintenanceModeIntroFragment$$ExternalSyntheticLambda4.f$0 = maintenanceModeIntroFragment2;
                VarHandle.storeStoreFence();
                fragmentActivity.runOnUiThread(maintenanceModeIntroFragment$$ExternalSyntheticLambda4);
                break;
        }
    }
}
