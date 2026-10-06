package com.samsung.android.settings.maintenancemode;

import android.os.SystemClock;
import android.os.SystemProperties;
import android.os.UserManager;
import android.util.Log;
import android.view.View;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;
import java.lang.invoke.VarHandle;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeViewModel$$ExternalSyntheticLambda2 implements Runnable {
    public final /* synthetic */ int $r8$classId;
    public /* synthetic */ MaintenanceModeViewModel f$0;

    public /* synthetic */ MaintenanceModeViewModel$$ExternalSyntheticLambda2(int i) {
        this.$r8$classId = i;
    }

    @Override // java.lang.Runnable
    public final void run() {
        int i = this.$r8$classId;
        TimeUnit timeUnit = TimeUnit.MILLISECONDS;
        MaintenanceModeViewModel maintenanceModeViewModel = this.f$0;
        switch (i) {
            case 0:
                maintenanceModeViewModel.mIsPrimaryButtonClickable.postValue(Boolean.FALSE);
                maintenanceModeViewModel.setWaitingViewRotation();
                maintenanceModeViewModel.mWm.addView(maintenanceModeViewModel.mExitWaitingView, maintenanceModeViewModel.mViewWindowParams);
                View view = maintenanceModeViewModel.mExitWaitingView;
                MaintenanceModeViewModel$$ExternalSyntheticLambda2 maintenanceModeViewModel$$ExternalSyntheticLambda2 = new MaintenanceModeViewModel$$ExternalSyntheticLambda2(2);
                maintenanceModeViewModel$$ExternalSyntheticLambda2.f$0 = maintenanceModeViewModel;
                VarHandle.storeStoreFence();
                new Thread(maintenanceModeViewModel$$ExternalSyntheticLambda2).start();
                ScheduledExecutorService scheduledExecutorService = maintenanceModeViewModel.mScheduler;
                MaintenanceModeViewModel$$ExternalSyntheticLambda6 maintenanceModeViewModel$$ExternalSyntheticLambda6 = new MaintenanceModeViewModel$$ExternalSyntheticLambda6(0);
                maintenanceModeViewModel$$ExternalSyntheticLambda6.f$0 = maintenanceModeViewModel;
                maintenanceModeViewModel$$ExternalSyntheticLambda6.f$1 = view;
                VarHandle.storeStoreFence();
                scheduledExecutorService.schedule(maintenanceModeViewModel$$ExternalSyntheticLambda6, 180000L, timeUnit);
                break;
            case 1:
                MaintenanceModeUtils.sendLoggingDataToSA(maintenanceModeViewModel.mApp, "7071", (String) null);
                break;
            case 2:
                maintenanceModeViewModel.getClass();
                try {
                    ((UserManager) maintenanceModeViewModel.mApp.getSystemService("user")).removeUser(77);
                } catch (Exception e) {
                    Log.i("MaintenanceMode", "Exception", e);
                    return;
                }
                break;
            default:
                maintenanceModeViewModel.getClass();
                if (SystemProperties.getInt("dumpstate.is_running", 0) != 0) {
                    if (maintenanceModeViewModel.mDumpDeadline - SystemClock.elapsedRealtime() > 0) {
                        ScheduledExecutorService scheduledExecutorService2 = maintenanceModeViewModel.mScheduler;
                        MaintenanceModeViewModel$$ExternalSyntheticLambda2 maintenanceModeViewModel$$ExternalSyntheticLambda3 = new MaintenanceModeViewModel$$ExternalSyntheticLambda2(3);
                        maintenanceModeViewModel$$ExternalSyntheticLambda3.f$0 = maintenanceModeViewModel;
                        VarHandle.storeStoreFence();
                        scheduledExecutorService2.schedule(maintenanceModeViewModel$$ExternalSyntheticLambda3, 2000L, timeUnit);
                    } else {
                        Log.i("MaintenanceMode", "Waiting for dumpstate timed out");
                    }
                }
                View view2 = maintenanceModeViewModel.mDumpWaitingView;
                MaintenanceModeViewModel$$ExternalSyntheticLambda6 maintenanceModeViewModel$$ExternalSyntheticLambda7 = new MaintenanceModeViewModel$$ExternalSyntheticLambda6(1);
                maintenanceModeViewModel$$ExternalSyntheticLambda7.f$0 = maintenanceModeViewModel;
                maintenanceModeViewModel$$ExternalSyntheticLambda7.f$1 = view2;
                VarHandle.storeStoreFence();
                new Thread(maintenanceModeViewModel$$ExternalSyntheticLambda7).start();
                break;
        }
    }
}
