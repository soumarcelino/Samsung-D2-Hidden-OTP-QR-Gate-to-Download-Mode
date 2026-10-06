package com.samsung.android.settings.maintenancemode;

import android.view.View;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeOutroFragment$$ExternalSyntheticLambda0 implements View.OnClickListener {
    public /* synthetic */ MaintenanceModeOutroFragment f$0;

    @Override // android.view.View.OnClickListener
    public final void onClick(View view) {
        new MaintenanceModeOutroFragment.OutroDialogFragment().show(this.f$0.getChildFragmentManager(), "MaintenanceMode");
    }
}
