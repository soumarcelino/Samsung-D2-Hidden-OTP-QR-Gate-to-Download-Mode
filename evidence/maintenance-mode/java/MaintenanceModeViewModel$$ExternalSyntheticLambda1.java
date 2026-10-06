package com.samsung.android.settings.maintenancemode;

import android.os.SystemClock;
import android.os.SystemProperties;
import android.view.View;
import android.view.WindowManager;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;
import com.sec.ims.configuration.DATA;
import java.lang.invoke.VarHandle;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public final /* synthetic */ class MaintenanceModeViewModel$$ExternalSyntheticLambda1 implements Runnable {
    public final /* synthetic */ int $r8$classId;
    public /* synthetic */ MaintenanceModeViewModel f$0;
    public /* synthetic */ boolean f$1;

    public /* synthetic */ MaintenanceModeViewModel$$ExternalSyntheticLambda1(int i) {
        this.$r8$classId = i;
    }

    @Override // java.lang.Runnable
    public final void run() {
        switch (this.$r8$classId) {
            case 0:
                MaintenanceModeViewModel maintenanceModeViewModel = this.f$0;
                boolean z = this.f$1;
                maintenanceModeViewModel.mIsPrimaryButtonClickable.postValue(Boolean.FALSE);
                maintenanceModeViewModel.setWaitingViewRotation();
                MaintenanceModeUtils.setUserConsentAboutCreatingLog(!z);
                WindowManager windowManager = maintenanceModeViewModel.mWm;
                int i = 1;
                if (z) {
                    windowManager.addView(maintenanceModeViewModel.mEntryWaitingView, maintenanceModeViewModel.mViewWindowParams);
                    View view = maintenanceModeViewModel.mEntryWaitingView;
                    MaintenanceModeViewModel$$ExternalSyntheticLambda6 maintenanceModeViewModel$$ExternalSyntheticLambda6 = new MaintenanceModeViewModel$$ExternalSyntheticLambda6(1);
                    maintenanceModeViewModel$$ExternalSyntheticLambda6.f$0 = maintenanceModeViewModel;
                    maintenanceModeViewModel$$ExternalSyntheticLambda6.f$1 = view;
                    VarHandle.storeStoreFence();
                    new Thread(maintenanceModeViewModel$$ExternalSyntheticLambda6).start();
                } else {
                    windowManager.addView(maintenanceModeViewModel.mDumpWaitingView, maintenanceModeViewModel.mViewWindowParams);
                    SystemProperties.set("bugreport.mode", "light_mode");
                    SystemProperties.set("ctl.start", "bugreportm");
                    maintenanceModeViewModel.mDumpDeadline = SystemClock.elapsedRealtime() + 300000;
                    ScheduledExecutorService scheduledExecutorService = maintenanceModeViewModel.mScheduler;
                    MaintenanceModeViewModel$$ExternalSyntheticLambda2 maintenanceModeViewModel$$ExternalSyntheticLambda2 = new MaintenanceModeViewModel$$ExternalSyntheticLambda2(3);
                    maintenanceModeViewModel$$ExternalSyntheticLambda2.f$0 = maintenanceModeViewModel;
                    VarHandle.storeStoreFence();
                    scheduledExecutorService.schedule(maintenanceModeViewModel$$ExternalSyntheticLambda2, 10000L, TimeUnit.MILLISECONDS);
                }
                ExecutorService executorService = maintenanceModeViewModel.mLoggingExecutor;
                MaintenanceModeViewModel$$ExternalSyntheticLambda1 maintenanceModeViewModel$$ExternalSyntheticLambda1 = new MaintenanceModeViewModel$$ExternalSyntheticLambda1(i);
                maintenanceModeViewModel$$ExternalSyntheticLambda1.f$0 = maintenanceModeViewModel;
                maintenanceModeViewModel$$ExternalSyntheticLambda1.f$1 = z;
                VarHandle.storeStoreFence();
                executorService.submit(maintenanceModeViewModel$$ExternalSyntheticLambda1);
                ExecutorService executorService2 = maintenanceModeViewModel.mLoggingExecutor;
                MaintenanceModeViewModel$$ExternalSyntheticLambda2 maintenanceModeViewModel$$ExternalSyntheticLambda3 = new MaintenanceModeViewModel$$ExternalSyntheticLambda2(1);
                maintenanceModeViewModel$$ExternalSyntheticLambda3.f$0 = maintenanceModeViewModel;
                VarHandle.storeStoreFence();
                executorService2.submit(maintenanceModeViewModel$$ExternalSyntheticLambda3);
                break;
            default:
                MaintenanceModeUtils.sendLoggingDataToSA(this.f$0.mApp, "7070", this.f$1 ? "1" : DATA.DM_FIELD_INDEX.PCSCF_DOMAIN);
                break;
        }
    }
}
