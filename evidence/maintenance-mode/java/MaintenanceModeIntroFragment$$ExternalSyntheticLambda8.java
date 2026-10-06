package com.samsung.android.settings.maintenancemode;

import android.content.DialogInterface;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeIntroFragment$$ExternalSyntheticLambda8 implements DialogInterface.OnClickListener {
    public final /* synthetic */ int $r8$classId;
    public /* synthetic */ MaintenanceModeIntroFragment f$0;

    public /* synthetic */ MaintenanceModeIntroFragment$$ExternalSyntheticLambda8(int i) {
        this.$r8$classId = i;
    }

    @Override // android.content.DialogInterface.OnClickListener
    public final void onClick(DialogInterface dialogInterface, int i) {
        int i2 = this.$r8$classId;
        MaintenanceModeIntroFragment maintenanceModeIntroFragment = this.f$0;
        switch (i2) {
            case 0:
                maintenanceModeIntroFragment.mViewModel.sendLoggingData("7069");
                break;
            case 1:
                MaintenanceModeUtils.startMyFilesActivity(maintenanceModeIntroFragment.mActivity);
                break;
            default:
                MaintenanceModeUtils.startSecureLockSettingsActivity(maintenanceModeIntroFragment.mActivity);
                break;
        }
    }
}
