package com.samsung.android.settings.maintenancemode;

import android.content.DialogInterface;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeIntroFragment$$ExternalSyntheticLambda9 implements DialogInterface.OnCancelListener {
    public /* synthetic */ MaintenanceModeIntroFragment f$0;

    @Override // android.content.DialogInterface.OnCancelListener
    public final void onCancel(DialogInterface dialogInterface) {
        this.f$0.mViewModel.sendLoggingData("7069");
    }
}
