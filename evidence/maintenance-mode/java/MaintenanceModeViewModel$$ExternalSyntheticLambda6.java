package com.samsung.android.settings.maintenancemode;

import android.content.pm.UserInfo;
import android.os.UserManager;
import android.util.Log;
import android.view.View;
import com.android.settings.R;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeViewModel$$ExternalSyntheticLambda6 implements Runnable {
    public final /* synthetic */ int $r8$classId;
    public /* synthetic */ MaintenanceModeViewModel f$0;
    public /* synthetic */ Object f$1;

    @Override // java.lang.Runnable
    public final void run() {
        UserInfo userInfoCreateUser = null;
        switch (this.$r8$classId) {
            case 0:
                MaintenanceModeViewModel maintenanceModeViewModel = this.f$0;
                maintenanceModeViewModel.mWm.removeView((View) this.f$1);
                maintenanceModeViewModel.mIsPrimaryButtonClickable.postValue(Boolean.TRUE);
                break;
            case 1:
                MaintenanceModeViewModel maintenanceModeViewModel2 = this.f$0;
                View view = (View) this.f$1;
                if (MaintenanceModeUtils.isSecureLockSet(maintenanceModeViewModel2.mApp) && MaintenanceModeUtils.checkRequiredConditions(maintenanceModeViewModel2.mApp, true) == 0) {
                    try {
                        userInfoCreateUser = ((UserManager) maintenanceModeViewModel2.mApp.getSystemService("user")).createUser(maintenanceModeViewModel2.mResources.getString(R.string.maintenance_mode), "com.samsung.android.os.usertype.full.MAINTENANCE_MODE", 1024);
                    } catch (Exception e) {
                        Log.i("MaintenanceMode", "Exception", e);
                    }
                }
                if (userInfoCreateUser == null) {
                    maintenanceModeViewModel2.mWm.removeView(view);
                    maintenanceModeViewModel2.mIsPrimaryButtonClickable.postValue(Boolean.TRUE);
                }
                break;
            default:
                MaintenanceModeViewModel maintenanceModeViewModel3 = this.f$0;
                MaintenanceModeUtils.sendLoggingDataToSA(maintenanceModeViewModel3.mApp, (String) this.f$1, (String) null);
                break;
        }
    }
}
