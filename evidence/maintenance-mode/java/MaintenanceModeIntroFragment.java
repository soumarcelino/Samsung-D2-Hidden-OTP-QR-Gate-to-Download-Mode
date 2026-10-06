package com.samsung.android.settings.maintenancemode;

import android.app.Dialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.widget.SeslCheckedTextView;
import androidx.fragment.app.DialogFragment;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModelProvider;
import androidx.preference.Preference;
import com.android.settings.R;
import com.android.settings.SettingsPreferenceFragment;
import com.android.settings.applications.AppInfoBase$1$$ExternalSyntheticOutline0;
import com.android.settingslib.widget.LayoutPreference;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;
import com.samsung.android.knox.p045zt.config.securelog.SignalSeverity;
import com.samsung.android.sdk.moneta.memory.entity.bundlewrapper.content.KeywordInfoBundleWrapper;
import com.samsung.android.settings.widget.SecFloatingBottomLayout;
import java.lang.invoke.VarHandle;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import kotlin.jvm.internal.Reflection;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public class MaintenanceModeIntroFragment extends SettingsPreferenceFragment {
    public static final /* synthetic */ int $r8$clinit = 0;
    public FragmentActivity mActivity;
    public Preference mCloudBackupPreference;
    public C51621 mCloudStatusTimerTask;
    public Resources mResources;
    public Button mTurnOnButton;
    public MaintenanceModeViewModel mViewModel;
    public boolean mIsCloudBackupSupported = false;
    public String mCloudBackupStatus = "NONE";
    public final ExecutorService mButtonExecutor = Executors.newSingleThreadExecutor();
    public final ExecutorService mCloudStatusExecutor = Executors.newSingleThreadExecutor();
    public final CloudBackupReceiver mCloudBackupReceiver = new CloudBackupReceiver();
    public final Timer mCloudStatusTimer = new Timer();

    /* JADX INFO: renamed from: com.samsung.android.settings.maintenancemode.MaintenanceModeIntroFragment$1 */
    /* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
    public final class C51621 extends TimerTask {
        public C51621() {
        }

        @Override // java.util.TimerTask, java.lang.Runnable
        public final void run() {
            MaintenanceModeIntroFragment maintenanceModeIntroFragment = MaintenanceModeIntroFragment.this;
            if (maintenanceModeIntroFragment.mIsCloudBackupSupported) {
                try {
                    ExecutorService executorService = maintenanceModeIntroFragment.mCloudStatusExecutor;
                    MaintenanceModeIntroFragment$$ExternalSyntheticLambda4 maintenanceModeIntroFragment$$ExternalSyntheticLambda4 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda4(6);
                    maintenanceModeIntroFragment$$ExternalSyntheticLambda4.f$0 = this;
                    VarHandle.storeStoreFence();
                    executorService.submit(maintenanceModeIntroFragment$$ExternalSyntheticLambda4);
                } catch (Exception unused) {
                }
            }
        }
    }

    /* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
    public final class CloudBackupReceiver extends BroadcastReceiver {
        public CloudBackupReceiver() {
        }

        @Override // android.content.BroadcastReceiver
        public final void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action != null) {
                try {
                    ExecutorService executorService = MaintenanceModeIntroFragment.this.mCloudStatusExecutor;
                    MaintenanceModeIntroFragment$$ExternalSyntheticLambda18 maintenanceModeIntroFragment$$ExternalSyntheticLambda18 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda18(1);
                    maintenanceModeIntroFragment$$ExternalSyntheticLambda18.f$0 = this;
                    maintenanceModeIntroFragment$$ExternalSyntheticLambda18.f$1 = action;
                    VarHandle.storeStoreFence();
                    executorService.submit(maintenanceModeIntroFragment$$ExternalSyntheticLambda18);
                } catch (Exception unused) {
                }
            }
            AppInfoBase$1$$ExternalSyntheticOutline0.m153m("onReceive: ", action, "MaintenanceMode");
        }
    }

    /* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
    public static class IntroDialogFragment extends DialogFragment {
        public int mDialogType = 0;
        public String mExtra = SignalSeverity.NONE;

        @Override // androidx.fragment.app.DialogFragment, androidx.fragment.app.Fragment
        public final void onCreate(Bundle bundle) {
            super.onCreate(bundle);
            if (bundle != null) {
                this.mDialogType = bundle.getInt("type", 0);
                this.mExtra = bundle.getString(KeywordInfoBundleWrapper.BUNDLE_KEY_EXTRA, SignalSeverity.NONE);
            }
        }

        /* JADX WARN: Code duplicated, block: B:47:0x0110  */
        @Override // androidx.fragment.app.DialogFragment
        public final Dialog onCreateDialog(Bundle bundle) {
            int i;
            Fragment parentFragment = getParentFragment();
            if (parentFragment == null || !(parentFragment instanceof MaintenanceModeIntroFragment)) {
                return super.onCreateDialog(bundle);
            }
            MaintenanceModeIntroFragment maintenanceModeIntroFragment = (MaintenanceModeIntroFragment) parentFragment;
            int i2 = this.mDialogType;
            int i3 = 2;
            boolean z = true;
            z = true;
            z = true;
            if (i2 == 1) {
                AlertDialog.Builder builder = new AlertDialog.Builder(maintenanceModeIntroFragment.mActivity);
                builder.setMessage(R.string.intro_dialog_message_set_screen_lock_first);
                MaintenanceModeIntroFragment$$ExternalSyntheticLambda8 maintenanceModeIntroFragment$$ExternalSyntheticLambda8 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda8(i3);
                maintenanceModeIntroFragment$$ExternalSyntheticLambda8.f$0 = maintenanceModeIntroFragment;
                VarHandle.storeStoreFence();
                builder.setPositiveButton(R.string.intro_dialog_button_set_screen_lock, maintenanceModeIntroFragment$$ExternalSyntheticLambda8);
                builder.setNegativeButton(R.string.dialog_button_cancel, new MaintenanceModeIntroFragment$$ExternalSyntheticLambda15());
                AlertDialog alertDialogCreate = builder.create();
                alertDialogCreate.getWindow().setGravity(80);
                return alertDialogCreate;
            }
            if (i2 == 2) {
                Log.i("MaintenanceMode", "Device is low on storage");
                AlertDialog.Builder builder2 = new AlertDialog.Builder(maintenanceModeIntroFragment.mActivity);
                builder2.setTitle(R.string.intro_dialog_title_low_on_storage);
                builder2.setMessage(maintenanceModeIntroFragment.mViewModel.mIsTablet ? R.string.intro_dialog_message_storage_almost_full_tablet : R.string.intro_dialog_message_storage_almost_full_phone);
                MaintenanceModeIntroFragment$$ExternalSyntheticLambda8 maintenanceModeIntroFragment$$ExternalSyntheticLambda9 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda8(z ? 1 : 0);
                maintenanceModeIntroFragment$$ExternalSyntheticLambda9.f$0 = maintenanceModeIntroFragment;
                VarHandle.storeStoreFence();
                builder2.setPositiveButton(R.string.intro_dialog_button_analyze_storage, maintenanceModeIntroFragment$$ExternalSyntheticLambda9);
                AlertDialog alertDialogCreate2 = builder2.create();
                alertDialogCreate2.getWindow().setGravity(80);
                return alertDialogCreate2;
            }
            int i4 = 0;
            if (i2 != 3) {
                if (i2 != 4) {
                    return super.onCreateDialog(bundle);
                }
                View viewInflate = LayoutInflater.from(maintenanceModeIntroFragment.mActivity).inflate(R.layout.dialog_intro, (ViewGroup) null);
                SeslCheckedTextView seslCheckedTextView = (SeslCheckedTextView) viewInflate.findViewById(R.id.dialog_checked_text_view);
                MaintenanceModeIntroFragment$$ExternalSyntheticLambda2 maintenanceModeIntroFragment$$ExternalSyntheticLambda2 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda2(z ? 1 : 0);
                maintenanceModeIntroFragment$$ExternalSyntheticLambda2.f$0 = seslCheckedTextView;
                VarHandle.storeStoreFence();
                seslCheckedTextView.setOnClickListener(maintenanceModeIntroFragment$$ExternalSyntheticLambda2);
                seslCheckedTextView.setTextSize(0, MaintenanceModeUtils.getFontSize(maintenanceModeIntroFragment.mActivity, R.dimen.dialog_checkbox_text_size, 1.1f));
                TextView textView = (TextView) viewInflate.findViewById(R.id.dialog_text_view);
                StringBuilder sb = new StringBuilder();
                sb.append(maintenanceModeIntroFragment.mResources.getString(maintenanceModeIntroFragment.mViewModel.mIsTablet ? R.string.intro_dialog_message_need_to_restart_tablet : R.string.intro_dialog_message_need_to_restart_phone));
                sb.append("\n\n");
                sb.append(maintenanceModeIntroFragment.mResources.getString(maintenanceModeIntroFragment.mViewModel.mIsTablet ? R.string.intro_dialog_message_recommend_creating_log_tablet : R.string.intro_dialog_message_recommend_creating_log_phone));
                textView.setText(sb.toString());
                textView.setTextSize(0, MaintenanceModeUtils.getFontSize(maintenanceModeIntroFragment.mActivity, R.dimen.common_text_size));
                AlertDialog.Builder builder3 = new AlertDialog.Builder(maintenanceModeIntroFragment.mActivity);
                builder3.setView(viewInflate);
                MaintenanceModeIntroFragment$$ExternalSyntheticLambda6 maintenanceModeIntroFragment$$ExternalSyntheticLambda6 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda6();
                maintenanceModeIntroFragment$$ExternalSyntheticLambda6.f$0 = maintenanceModeIntroFragment;
                maintenanceModeIntroFragment$$ExternalSyntheticLambda6.f$1 = seslCheckedTextView;
                VarHandle.storeStoreFence();
                builder3.setPositiveButton(R.string.dialog_button_restart, maintenanceModeIntroFragment$$ExternalSyntheticLambda6);
                AlertDialog alertDialogCreate3 = builder3.create();
                alertDialogCreate3.getWindow().setGravity(80);
                return alertDialogCreate3;
            }
            String str = this.mExtra;
            if (str != null) {
                switch (str.hashCode()) {
                    case -1070966578:
                        i3 = !str.equals("RESTORE_RUNNING") ? -1 : 0;
                        break;
                    case -739684063:
                        i3 = !str.equals("BACKUP_NON_FINISHED") ? -1 : 1;
                        break;
                    case -226439134:
                        if (!str.equals("BACKUP_RUNNING")) {
                            i3 = -1;
                        }
                        break;
                    default:
                        i3 = -1;
                        break;
                }
                switch (i3) {
                    case 0:
                        i = R.string.backup_dialog_cloud_message_need_to_stop_restoring_backup;
                        break;
                    case 1:
                        i = R.string.backup_dialog_cloud_message_need_to_handle_incomplete_backup;
                        break;
                    case 2:
                        i = R.string.backup_dialog_cloud_message_need_to_stop_ongoing_backup;
                        break;
                    default:
                        i = R.string.backup_dialog_message_need_to_stop_backing_up;
                        z = false;
                        break;
                }
            } else {
                i = R.string.backup_dialog_message_need_to_stop_backing_up;
                z = false;
            }
            AlertDialog.Builder builder4 = new AlertDialog.Builder(maintenanceModeIntroFragment.mActivity);
            builder4.setMessage(i);
            MaintenanceModeIntroFragment$$ExternalSyntheticLambda7 maintenanceModeIntroFragment$$ExternalSyntheticLambda7 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda7();
            maintenanceModeIntroFragment$$ExternalSyntheticLambda7.f$0 = z;
            maintenanceModeIntroFragment$$ExternalSyntheticLambda7.f$1 = maintenanceModeIntroFragment;
            VarHandle.storeStoreFence();
            builder4.setPositiveButton(R.string.dialog_button_ok, maintenanceModeIntroFragment$$ExternalSyntheticLambda7);
            MaintenanceModeIntroFragment$$ExternalSyntheticLambda8 maintenanceModeIntroFragment$$ExternalSyntheticLambda10 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda8(i4);
            maintenanceModeIntroFragment$$ExternalSyntheticLambda10.f$0 = maintenanceModeIntroFragment;
            VarHandle.storeStoreFence();
            builder4.setNegativeButton(R.string.dialog_button_cancel, maintenanceModeIntroFragment$$ExternalSyntheticLambda10);
            MaintenanceModeIntroFragment$$ExternalSyntheticLambda9 maintenanceModeIntroFragment$$ExternalSyntheticLambda11 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda9();
            maintenanceModeIntroFragment$$ExternalSyntheticLambda11.f$0 = maintenanceModeIntroFragment;
            VarHandle.storeStoreFence();
            builder4.f0P.mOnCancelListener = maintenanceModeIntroFragment$$ExternalSyntheticLambda11;
            AlertDialog alertDialogCreate4 = builder4.create();
            alertDialogCreate4.getWindow().setGravity(80);
            return alertDialogCreate4;
        }

        @Override // androidx.fragment.app.DialogFragment, androidx.fragment.app.Fragment
        public final void onSaveInstanceState(Bundle bundle) {
            super.onSaveInstanceState(bundle);
            bundle.putInt("type", this.mDialogType);
            bundle.putString(KeywordInfoBundleWrapper.BUNDLE_KEY_EXTRA, this.mExtra);
        }
    }

    @Override // com.android.settingslib.core.instrumentation.Instrumentable
    public final int getMetricsCategory() {
        return 0;
    }

    @Override // com.android.settings.core.InstrumentedPreferenceFragment
    public final int getPreferenceScreenResId() {
        return R.xml.preference_screen_intro;
    }

    @Override // com.android.settings.SettingsPreferenceFragment, com.android.settings.core.InstrumentedPreferenceFragment, com.android.settings.core.ObservablePreferenceFragment, com.android.settingslib.preference.PreferenceFragment, androidx.preference.PreferenceFragmentCompat, androidx.fragment.app.Fragment
    public final void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        FragmentActivity activity = getActivity();
        this.mActivity = activity;
        this.mResources = activity.getResources();
        if (MaintenanceModeUtils.checkRequiredConditions(this.mActivity, true) != 0) {
            finish();
        } else {
            this.mViewModel = (MaintenanceModeViewModel) new ViewModelProvider(this).get(Reflection.factory.getOrCreateKotlinClass(MaintenanceModeViewModel.class));
        }
    }

    @Override // com.android.settings.SettingsPreferenceFragment, com.android.settings.core.ObservablePreferenceFragment, com.android.settingslib.preference.PreferenceFragment, androidx.fragment.app.Fragment
    public final void onDestroy() {
        try {
            this.mActivity.unregisterReceiver(this.mCloudBackupReceiver);
        } catch (Exception unused) {
        }
        this.mCloudStatusTimer.cancel();
        this.mCloudStatusExecutor.shutdownNow();
        this.mButtonExecutor.shutdownNow();
        super.onDestroy();
    }

    @Override // com.android.settings.core.InstrumentedPreferenceFragment, com.android.settings.core.ObservablePreferenceFragment, com.android.settingslib.preference.PreferenceFragment, androidx.fragment.app.Fragment
    public final void onPause() {
        C51621 c51621 = this.mCloudStatusTimerTask;
        if (c51621 != null) {
            c51621.cancel();
        }
        super.onPause();
    }

    @Override // com.android.settings.SettingsPreferenceFragment, com.android.settings.core.InstrumentedPreferenceFragment, com.android.settings.core.ObservablePreferenceFragment, com.android.settingslib.preference.PreferenceFragment, androidx.fragment.app.Fragment
    public final void onResume() {
        boolean z;
        int i = 0;
        if (MaintenanceModeUtils.checkRequiredConditions(this.mActivity, false) != 0) {
            finish();
            z = true;
        } else {
            z = false;
        }
        super.onResume();
        if (z) {
            return;
        }
        ExecutorService executorService = this.mCloudStatusExecutor;
        MaintenanceModeIntroFragment$$ExternalSyntheticLambda4 maintenanceModeIntroFragment$$ExternalSyntheticLambda4 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda4(i);
        maintenanceModeIntroFragment$$ExternalSyntheticLambda4.f$0 = this;
        VarHandle.storeStoreFence();
        executorService.submit(maintenanceModeIntroFragment$$ExternalSyntheticLambda4);
        C51621 c51621 = new C51621();
        this.mCloudStatusTimerTask = c51621;
        this.mCloudStatusTimer.schedule(c51621, 30000L, 30000L);
    }

    @Override // com.android.settings.SettingsPreferenceFragment, com.android.settingslib.widget.SettingsBasePreferenceFragment, androidx.preference.PreferenceFragmentCompat, androidx.fragment.app.Fragment
    public final void onViewCreated(View view, Bundle bundle) {
        super.onViewCreated(view, bundle);
        if (this.mViewModel.mIsTablet) {
            LayoutPreference layoutPreference = (LayoutPreference) findPreference("fragment_intro");
            ((TextView) layoutPreference.mRootView.findViewById(R.id.summary_text_view)).setText(this.mResources.getString(R.string.intro_summary_tablet));
            ((TextView) layoutPreference.mRootView.findViewById(R.id.detail_need_to_unlock_text_view)).setText(this.mResources.getString(R.string.intro_detail_need_to_unlock_tablet));
            ((TextView) layoutPreference.mRootView.findViewById(R.id.recommend_backup_text_view)).setText(this.mResources.getString(R.string.intro_recommend_backup_tablet));
        }
        Preference preferenceFindPreference = findPreference("backup_menu_cloud");
        this.mCloudBackupPreference = preferenceFindPreference;
        int i = 0;
        MaintenanceModeIntroFragment$$ExternalSyntheticLambda0 maintenanceModeIntroFragment$$ExternalSyntheticLambda0 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda0(i);
        maintenanceModeIntroFragment$$ExternalSyntheticLambda0.f$0 = this;
        VarHandle.storeStoreFence();
        preferenceFindPreference.setOnPreferenceClickListener(maintenanceModeIntroFragment$$ExternalSyntheticLambda0);
        Preference preferenceFindPreference2 = findPreference("backup_menu_smart_switch");
        MaintenanceModeIntroFragment$$ExternalSyntheticLambda0 maintenanceModeIntroFragment$$ExternalSyntheticLambda1 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda0(1);
        maintenanceModeIntroFragment$$ExternalSyntheticLambda1.f$0 = this;
        VarHandle.storeStoreFence();
        preferenceFindPreference2.setOnPreferenceClickListener(maintenanceModeIntroFragment$$ExternalSyntheticLambda1);
        SecFloatingBottomLayout secFloatingBottomLayout = (SecFloatingBottomLayout) this.mActivity.findViewById(R.id.floating_bottom_container);
        if (secFloatingBottomLayout != null) {
            secFloatingBottomLayout.removeAllViews();
            View viewInflate = LayoutInflater.from(this.mActivity).inflate(R.layout.button_bottom, (ViewGroup) null);
            Button button = (Button) viewInflate.findViewById(R.id.button);
            this.mTurnOnButton = button;
            button.setText(this.mResources.getString(R.string.intro_button_turn_on));
            if (this.mViewModel.mIsTablet) {
                this.mTurnOnButton.setWidth(this.mResources.getDimensionPixelSize(R.dimen.button_width_tablet));
            }
            Button button2 = this.mTurnOnButton;
            MaintenanceModeIntroFragment$$ExternalSyntheticLambda2 maintenanceModeIntroFragment$$ExternalSyntheticLambda2 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda2(i);
            maintenanceModeIntroFragment$$ExternalSyntheticLambda2.f$0 = this;
            VarHandle.storeStoreFence();
            button2.setOnClickListener(maintenanceModeIntroFragment$$ExternalSyntheticLambda2);
            MutableLiveData mutableLiveData = this.mViewModel.mIsPrimaryButtonClickable;
            LifecycleOwner viewLifecycleOwner = getViewLifecycleOwner();
            MaintenanceModeIntroFragment$$ExternalSyntheticLambda3 maintenanceModeIntroFragment$$ExternalSyntheticLambda3 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda3();
            maintenanceModeIntroFragment$$ExternalSyntheticLambda3.f$0 = this;
            VarHandle.storeStoreFence();
            mutableLiveData.observe(viewLifecycleOwner, maintenanceModeIntroFragment$$ExternalSyntheticLambda3);
            secFloatingBottomLayout.addView(viewInflate);
            secFloatingBottomLayout.setVisibility(0);
            secFloatingBottomLayout.setFloatingAware(null);
        }
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_STARTED");
        intentFilter.addAction("com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_COMPLETED");
        intentFilter.addAction("com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_NOT_FINISHED");
        intentFilter.addAction("com.samsung.android.scloud.temporarybackup.NOTIFY_BACKUP_CANCELED");
        this.mActivity.registerReceiver(this.mCloudBackupReceiver, intentFilter, "com.samsung.android.permission.ACCESS_MAINTENANCE_MODE", null, 2);
        ExecutorService executorService = this.mCloudStatusExecutor;
        MaintenanceModeIntroFragment$$ExternalSyntheticLambda4 maintenanceModeIntroFragment$$ExternalSyntheticLambda4 = new MaintenanceModeIntroFragment$$ExternalSyntheticLambda4(i);
        maintenanceModeIntroFragment$$ExternalSyntheticLambda4.f$0 = this;
        VarHandle.storeStoreFence();
        executorService.submit(maintenanceModeIntroFragment$$ExternalSyntheticLambda4);
    }

    public final void updateCloudBackupMenuSummary() {
        if (this.mCloudBackupPreference == null) {
        }
        String str = this.mCloudBackupStatus;
        str.getClass();
        switch (str) {
            case "BACKUP_NON_FINISHED":
                this.mCloudBackupPreference.setSummary(this.mResources.getString(R.string.backup_menu_cloud_summary_backed_up_failed));
                break;
            case "BACKUP_RUNNING":
                this.mCloudBackupPreference.setSummary(this.mResources.getString(R.string.backup_menu_cloud_summary_backing_up));
                break;
            case "BACKUP_COMPLETED":
                this.mCloudBackupPreference.setSummary(this.mResources.getString(R.string.backup_menu_cloud_summary_backed_up_succeeded));
                break;
            default:
                this.mCloudBackupPreference.setSummary("");
                break;
        }
    }
}
