package com.samsung.android.settings.maintenancemode;

import android.app.Application;
import android.content.res.Resources;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.TextView;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.MutableLiveData;
import com.android.settings.R;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;
import java.lang.invoke.VarHandle;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public class MaintenanceModeViewModel extends AndroidViewModel {
    public final Application mApp;
    public long mDumpDeadline;
    public final View mDumpWaitingView;
    public final View mEntryWaitingView;
    public final View mExitWaitingView;
    public final MutableLiveData mIsPrimaryButtonClickable;
    public final boolean mIsTablet;
    public final ExecutorService mLoggingExecutor;
    public final Resources mResources;
    public final ScheduledExecutorService mScheduler;
    public final WindowManager.LayoutParams mViewWindowParams;
    public final WindowManager mWm;

    public MaintenanceModeViewModel(Application application) {
        super(application);
        MutableLiveData mutableLiveData = new MutableLiveData();
        this.mIsPrimaryButtonClickable = mutableLiveData;
        Application application2 = this.application;
        application2.getClass();
        this.mApp = application2;
        Resources resources = application2.getResources();
        this.mResources = resources;
        boolean zIsTablet = MaintenanceModeUtils.isTablet();
        this.mIsTablet = zIsTablet;
        mutableLiveData.setValue(Boolean.TRUE);
        this.mWm = (WindowManager) application2.getSystemService("window");
        this.mLoggingExecutor = Executors.newSingleThreadExecutor();
        this.mScheduler = Executors.newSingleThreadScheduledExecutor();
        WindowManager.LayoutParams layoutParams = new WindowManager.LayoutParams(-1, -1, 0, 0, 2024, 131328, -3);
        this.mViewWindowParams = layoutParams;
        layoutParams.gravity = 17;
        layoutParams.privateFlags |= 16;
        layoutParams.layoutInDisplayCutoutMode = 1;
        layoutParams.setFitInsetsSides(0);
        View viewInflate = LayoutInflater.from(application2).inflate(R.layout.view_waiting, (ViewGroup) null);
        this.mEntryWaitingView = viewInflate;
        viewInflate.findViewById(R.id.progress_bar_container).setVisibility(8);
        TextView textView = (TextView) this.mEntryWaitingView.findViewById(R.id.description_text_view);
        textView.setText(resources.getString(zIsTablet ? R.string.intro_view_waiting_entry_message_tablet : R.string.intro_view_waiting_entry_message_phone));
        textView.setTextSize(0, MaintenanceModeUtils.getFontSize(application2, R.dimen.view_text_size));
        View viewInflate2 = LayoutInflater.from(application2).inflate(R.layout.view_waiting, (ViewGroup) null);
        this.mDumpWaitingView = viewInflate2;
        TextView textView2 = (TextView) viewInflate2.findViewById(R.id.description_text_view);
        StringBuilder sb = new StringBuilder();
        sb.append(resources.getString(R.string.intro_view_waiting_dump_message_creating_log));
        sb.append("\n\n");
        sb.append(resources.getString(zIsTablet ? R.string.intro_view_waiting_dump_message_required_time_tablet : R.string.intro_view_waiting_dump_message_required_time_phone));
        textView2.setText(sb.toString());
        textView2.setTextSize(0, MaintenanceModeUtils.getFontSize(application2, R.dimen.view_text_size));
        View viewInflate3 = LayoutInflater.from(application2).inflate(R.layout.view_waiting, (ViewGroup) null);
        this.mExitWaitingView = viewInflate3;
        viewInflate3.findViewById(R.id.description_container).setVisibility(8);
        if (zIsTablet) {
            int dimensionPixelSize = resources.getDimensionPixelSize(R.dimen.view_body_padding);
            this.mEntryWaitingView.findViewById(R.id.description_container).setPadding(dimensionPixelSize, 0, dimensionPixelSize, 0);
            this.mDumpWaitingView.findViewById(R.id.description_container).setPadding(dimensionPixelSize, 0, dimensionPixelSize, 0);
        }
    }

    @Override // androidx.lifecycle.ViewModel
    public final void onCleared() {
        this.mLoggingExecutor.shutdown();
        this.mScheduler.shutdown();
    }

    public final void sendLoggingData(String str) {
        ExecutorService executorService = this.mLoggingExecutor;
        MaintenanceModeViewModel$$ExternalSyntheticLambda6 maintenanceModeViewModel$$ExternalSyntheticLambda6 = new MaintenanceModeViewModel$$ExternalSyntheticLambda6(2);
        maintenanceModeViewModel$$ExternalSyntheticLambda6.f$0 = this;
        maintenanceModeViewModel$$ExternalSyntheticLambda6.f$1 = str;
        VarHandle.storeStoreFence();
        executorService.submit(maintenanceModeViewModel$$ExternalSyntheticLambda6);
    }

    public final void setWaitingViewRotation() {
        Display display = this.mApp.getDisplay();
        if (display != null) {
            int rotation = display.getRotation();
            if (rotation == 0) {
                this.mViewWindowParams.screenOrientation = 1;
                return;
            }
            if (rotation == 1) {
                this.mViewWindowParams.screenOrientation = 0;
            } else if (rotation == 2) {
                this.mViewWindowParams.screenOrientation = 9;
            } else {
                if (rotation != 3) {
                    return;
                }
                this.mViewWindowParams.screenOrientation = 8;
            }
        }
    }
}
