package com.samsung.android.settings.maintenancemode;

import android.app.ActivityManager;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import androidx.fragment.app.DialogFragment;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModelProvider;
import com.android.settings.R;
import com.android.settings.SettingsPreferenceFragment;
import com.samsung.android.settings.widget.SecFloatingBottomLayout;
import java.lang.invoke.VarHandle;
import kotlin.jvm.internal.Reflection;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public class MaintenanceModeOutroFragment extends SettingsPreferenceFragment {
    public static final /* synthetic */ int $r8$clinit = 0;
    public FragmentActivity mActivity;
    public Button mExitButton;
    public Resources mResources;
    public MaintenanceModeViewModel mViewModel;

    /* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
    public static class OutroDialogFragment extends DialogFragment {
        @Override // androidx.fragment.app.DialogFragment
        public final Dialog onCreateDialog(Bundle bundle) {
            Fragment parentFragment = getParentFragment();
            if (parentFragment == null || !(parentFragment instanceof MaintenanceModeOutroFragment)) {
                return super.onCreateDialog(bundle);
            }
            MaintenanceModeOutroFragment maintenanceModeOutroFragment = (MaintenanceModeOutroFragment) parentFragment;
            AlertDialog.Builder message = new AlertDialog.Builder(maintenanceModeOutroFragment.mActivity).setMessage(maintenanceModeOutroFragment.mViewModel.mIsTablet ? R.string.outro_dialog_message_need_to_restart_tablet : R.string.outro_dialog_message_need_to_restart_phone);
            MaintenanceModeOutroFragment$$ExternalSyntheticLambda2 maintenanceModeOutroFragment$$ExternalSyntheticLambda2 = new MaintenanceModeOutroFragment$$ExternalSyntheticLambda2();
            maintenanceModeOutroFragment$$ExternalSyntheticLambda2.f$0 = maintenanceModeOutroFragment;
            VarHandle.storeStoreFence();
            AlertDialog alertDialogCreate = message.setPositiveButton(R.string.dialog_button_restart, maintenanceModeOutroFragment$$ExternalSyntheticLambda2).setNegativeButton(R.string.dialog_button_cancel, new MaintenanceModeOutroFragment$$ExternalSyntheticLambda3()).create();
            alertDialogCreate.getWindow().setGravity(80);
            return alertDialogCreate;
        }
    }

    @Override // com.android.settingslib.core.instrumentation.Instrumentable
    public final int getMetricsCategory() {
        return 0;
    }

    @Override // com.android.settings.core.InstrumentedPreferenceFragment
    public final int getPreferenceScreenResId() {
        return R.xml.preference_screen_outro;
    }

    @Override // com.android.settings.SettingsPreferenceFragment, com.android.settings.core.InstrumentedPreferenceFragment, com.android.settings.core.ObservablePreferenceFragment, com.android.settingslib.preference.PreferenceFragment, androidx.preference.PreferenceFragmentCompat, androidx.fragment.app.Fragment
    public final void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        if (ActivityManager.getCurrentUser() != 77) {
            finish();
            return;
        }
        FragmentActivity activity = getActivity();
        this.mActivity = activity;
        this.mResources = activity.getResources();
        this.mViewModel = (MaintenanceModeViewModel) new ViewModelProvider(this).get(Reflection.factory.getOrCreateKotlinClass(MaintenanceModeViewModel.class));
    }

    @Override // com.android.settings.SettingsPreferenceFragment, com.android.settingslib.widget.SettingsBasePreferenceFragment, androidx.preference.PreferenceFragmentCompat, androidx.fragment.app.Fragment
    public final void onViewCreated(View view, Bundle bundle) {
        super.onViewCreated(view, bundle);
        SecFloatingBottomLayout secFloatingBottomLayout = (SecFloatingBottomLayout) this.mActivity.findViewById(R.id.floating_bottom_container);
        if (secFloatingBottomLayout != null) {
            secFloatingBottomLayout.removeAllViews();
            View viewInflate = LayoutInflater.from(this.mActivity).inflate(R.layout.button_bottom, (ViewGroup) null);
            Button button = (Button) viewInflate.findViewById(R.id.button);
            this.mExitButton = button;
            button.setText(this.mResources.getString(R.string.outro_button_exit));
            if (this.mViewModel.mIsTablet) {
                this.mExitButton.setWidth(this.mResources.getDimensionPixelSize(R.dimen.button_width_tablet));
            }
            Button button2 = this.mExitButton;
            MaintenanceModeOutroFragment$$ExternalSyntheticLambda0 maintenanceModeOutroFragment$$ExternalSyntheticLambda0 = new MaintenanceModeOutroFragment$$ExternalSyntheticLambda0();
            maintenanceModeOutroFragment$$ExternalSyntheticLambda0.f$0 = this;
            VarHandle.storeStoreFence();
            button2.setOnClickListener(maintenanceModeOutroFragment$$ExternalSyntheticLambda0);
            MutableLiveData mutableLiveData = this.mViewModel.mIsPrimaryButtonClickable;
            LifecycleOwner viewLifecycleOwner = getViewLifecycleOwner();
            MaintenanceModeOutroFragment$$ExternalSyntheticLambda1 maintenanceModeOutroFragment$$ExternalSyntheticLambda1 = new MaintenanceModeOutroFragment$$ExternalSyntheticLambda1();
            maintenanceModeOutroFragment$$ExternalSyntheticLambda1.f$0 = this;
            VarHandle.storeStoreFence();
            mutableLiveData.observe(viewLifecycleOwner, maintenanceModeOutroFragment$$ExternalSyntheticLambda1);
            secFloatingBottomLayout.addView(viewInflate);
            secFloatingBottomLayout.setVisibility(0);
            secFloatingBottomLayout.setFloatingAware(null);
        }
    }
}
