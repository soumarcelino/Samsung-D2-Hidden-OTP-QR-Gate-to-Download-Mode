package com.samsung.android.settings.maintenancemode;

import androidx.lifecycle.Observer;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeIntroFragment$$ExternalSyntheticLambda3 implements Observer {
    public /* synthetic */ MaintenanceModeIntroFragment f$0;

    @Override // androidx.lifecycle.Observer
    public final void onChanged(Object obj) {
        MaintenanceModeIntroFragment maintenanceModeIntroFragment = this.f$0;
        Boolean bool = (Boolean) obj;
        if (bool != null) {
            maintenanceModeIntroFragment.mTurnOnButton.setClickable(bool.booleanValue());
        }
    }
}
