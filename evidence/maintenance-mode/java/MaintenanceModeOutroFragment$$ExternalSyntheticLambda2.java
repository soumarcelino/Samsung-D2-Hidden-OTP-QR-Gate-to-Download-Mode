package com.samsung.android.settings.maintenancemode;

import android.content.DialogInterface;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;
import java.lang.invoke.VarHandle;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeOutroFragment$$ExternalSyntheticLambda2 implements DialogInterface.OnClickListener {
    public /* synthetic */ MaintenanceModeOutroFragment f$0;

    @Override // android.content.DialogInterface.OnClickListener
    public final void onClick(DialogInterface dialogInterface, int i) {
        MaintenanceModeViewModel maintenanceModeViewModel = this.f$0.mViewModel;
        maintenanceModeViewModel.getClass();
        MaintenanceModeViewModel$$ExternalSyntheticLambda2 maintenanceModeViewModel$$ExternalSyntheticLambda2 = new MaintenanceModeViewModel$$ExternalSyntheticLambda2(0);
        maintenanceModeViewModel$$ExternalSyntheticLambda2.f$0 = maintenanceModeViewModel;
        VarHandle.storeStoreFence();
        MaintenanceModeUtils.confirmSecureLock(maintenanceModeViewModel.mApp, maintenanceModeViewModel$$ExternalSyntheticLambda2);
    }
}
