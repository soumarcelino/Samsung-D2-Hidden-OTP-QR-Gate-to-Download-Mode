package com.samsung.android.settings.maintenancemode;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.KeyguardManager;
import android.app.PendingIntent;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;
import com.android.settings.R;
import com.android.settings.Settings;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public class MaintenanceModeProxyActivity extends Activity {
    public Context mContext;
    public Resources mResources;
    public boolean mIsTablet = false;
    public boolean mIsFlip = false;

    @Override // android.app.Activity
    public final void onCreate(Bundle bundle) {
        String string;
        super.onCreate(bundle);
        Context applicationContext = getApplicationContext();
        this.mContext = applicationContext;
        this.mResources = applicationContext.getResources();
        this.mIsTablet = MaintenanceModeUtils.isTablet();
        this.mIsFlip = MaintenanceModeUtils.isFlip();
        int iCheckRequiredConditions = MaintenanceModeUtils.checkRequiredConditions(this.mContext, false);
        if (iCheckRequiredConditions != 0) {
            if (iCheckRequiredConditions == 1) {
                string = this.mResources.getString(this.mIsTablet ? R.string.proxy_toast_message_not_supported_tablet : R.string.proxy_toast_message_not_supported_phone);
            } else if (iCheckRequiredConditions == 2) {
                Resources resources = this.mResources;
                string = resources.getString(R.string.proxy_toast_message_only_be_used_by_owner, resources.getString(R.string.maintenance_mode));
            } else if (iCheckRequiredConditions == 3) {
                Resources resources2 = this.mResources;
                string = resources2.getString(R.string.proxy_toast_message_cannot_be_used_while, resources2.getString(R.string.proxy_toast_text_device_admin));
            } else if (iCheckRequiredConditions != 4) {
                string = iCheckRequiredConditions != 5 ? "" : this.mResources.getString(R.string.proxy_toast_message_cannot_use_while_mpsm_is_on);
            } else {
                Resources resources3 = this.mResources;
                string = resources3.getString(R.string.proxy_toast_message_cannot_be_used_while, resources3.getString(R.string.proxy_toast_text_samsung_dex));
            }
            if (!TextUtils.isEmpty(string)) {
                Toast.makeText(this, string, 1).show();
            }
            finish();
            return;
        }
        Class cls = ActivityManager.getCurrentUser() == 77 ? Settings.MaintenanceModeOutroActivity.class : Settings.MaintenanceModeIntroActivity.class;
        if (this.mIsFlip) {
            try {
                KeyguardManager keyguardManager = (KeyguardManager) this.mContext.getSystemService("keyguard");
                PendingIntent activity = PendingIntent.getActivity(this.mContext, 0, new Intent(this, (Class<?>) cls), 201326592, null);
                Intent intent = new Intent();
                intent.putExtra("runOnCover", true);
                intent.putExtra("ignoreKeyguardState", true);
                intent.putExtra("showCoverToast", true);
                keyguardManager.semSetPendingIntentAfterUnlock(activity, intent);
            } catch (Exception e) {
                Log.i("MaintenanceMode", "Failed to set PendingIntent: " + e.toString());
            }
        } else {
            try {
                startActivity(new Intent(this, (Class<?>) cls));
            } catch (ActivityNotFoundException e2) {
                Log.i("MaintenanceMode", "Failed to start targetActivity: " + e2.toString());
            }
        }
        finish();
    }
}
