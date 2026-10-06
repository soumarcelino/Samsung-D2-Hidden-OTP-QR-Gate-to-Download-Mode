package com.samsung.android.settings.maintenancemode;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.UserHandle;
import android.util.Log;
import android.view.WindowManager;
import android.widget.TextView;
import com.android.settings.R;
import com.android.settings.Settings;
import com.android.settings.applications.AppInfoBase$1$$ExternalSyntheticOutline0;
import com.samsung.android.core.pm.mm.MaintenanceModeUtils;
import com.samsung.android.knox.net.vpn.KnoxVpnPolicyConstants;

/* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
/* JADX INFO: loaded from: classes3.dex */
public class MaintenanceModeNotificationService extends Service {
    public static final ComponentName COMPONENT_OUTRO = new ComponentName(KnoxVpnPolicyConstants.ANDROID_SETTINGS_PKG, Settings.MaintenanceModeOutroActivity.class.getName());
    public Handler mHandler;
    public final C51631 mOverlayReceiver = new BroadcastReceiver() { // from class: com.samsung.android.settings.maintenancemode.MaintenanceModeNotificationService.1
        @Override // android.content.BroadcastReceiver
        public final void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            AppInfoBase$1$$ExternalSyntheticOutline0.m153m("onReceive: ", action, "MaintenanceMode");
            if (action != null) {
                if (action.equals("com.samsung.android.intent.action.HIDE_MAINTENANCE_MODE_MARK")) {
                    MaintenanceModeNotificationService maintenanceModeNotificationService = MaintenanceModeNotificationService.this;
                    ComponentName componentName = MaintenanceModeNotificationService.COMPONENT_OUTRO;
                    maintenanceModeNotificationService.setOverlayVisibility(false);
                } else if (action.equals("com.samsung.android.intent.action.SHOW_MAINTENANCE_MODE_MARK")) {
                    MaintenanceModeNotificationService maintenanceModeNotificationService2 = MaintenanceModeNotificationService.this;
                    ComponentName componentName2 = MaintenanceModeNotificationService.COMPONENT_OUTRO;
                    maintenanceModeNotificationService2.setOverlayVisibility(true);
                }
            }
        }
    };
    public TextView mOverlayView;
    public WindowManager.LayoutParams mOverlayViewParams;
    public WindowManager mWm;

    /* JADX INFO: compiled from: qb/114805780 7f8a3bb39064e0efe2b4827d453759882d43bb5a408476461a63b27d8ff6500a */
    public static class DismissalReceiver extends BroadcastReceiver {
        @Override // android.content.BroadcastReceiver
        public final void onReceive(Context context, Intent intent) {
            Log.i("MaintenanceMode", "Notification has been dismissed!");
            Context contextCreateContextAsUser = context.createContextAsUser(UserHandle.of(77), 0);
            ComponentName componentName = MaintenanceModeNotificationService.COMPONENT_OUTRO;
            ((NotificationManager) contextCreateContextAsUser.getSystemService(NotificationManager.class)).createNotificationChannel(new NotificationChannel("maintenance_mode_channel", "maintenance_mode", 3));
            ((NotificationManager) contextCreateContextAsUser.getSystemService(NotificationManager.class)).notify(150707, MaintenanceModeNotificationService.buildNotification(contextCreateContextAsUser));
        }
    }

    public static Notification buildNotification(Context context) {
        PendingIntent activity = PendingIntent.getActivity(context, 0, new Intent().setComponent(COMPONENT_OUTRO), 67108864);
        PendingIntent broadcast = PendingIntent.getBroadcast(context, 0, new Intent(context, (Class<?>) DismissalReceiver.class), 67108864);
        Bundle bundle = new Bundle();
        bundle.putBoolean("android.showSmallIcon", true);
        return new Notification.Builder(context, "maintenance_mode_channel").setSmallIcon(R.drawable.ic_notification).setContentTitle(MaintenanceModeUtils.isTablet() ? context.getResources().getString(R.string.notification_title_tablet) : context.getResources().getString(R.string.notification_title_phone)).setContentText(context.getResources().getString(R.string.notification_message_tap_here_to_exit)).addExtras(bundle).setOngoing(true).setContentIntent(activity).setDeleteIntent(broadcast).build();
    }

    @Override // android.app.Service
    public final IBinder onBind(Intent intent) {
        throw new UnsupportedOperationException("Unsupported");
    }

    @Override // android.app.Service
    public final void onCreate() {
        super.onCreate();
        ((NotificationManager) getSystemService(NotificationManager.class)).createNotificationChannel(new NotificationChannel("maintenance_mode_channel", "maintenance_mode", 3));
        startForeground(150707, buildNotification(this));
        this.mHandler = new Handler(getMainLooper());
        try {
            Resources resources = getResources();
            this.mOverlayView = new TextView(this);
            int dimensionPixelSize = resources.getDimensionPixelSize(R.dimen.overlay_padding);
            this.mOverlayView.setGravity(17);
            this.mOverlayView.setPadding(dimensionPixelSize, dimensionPixelSize, dimensionPixelSize, dimensionPixelSize);
            this.mOverlayView.setBackgroundColor(getColor(R.color.overlay_background));
            this.mOverlayView.setTextAppearance(R.style.TextAppearance_Common);
            this.mOverlayView.setTextColor(getColor(R.color.overlay_text_color));
            this.mOverlayView.setTextSize(0, resources.getDimensionPixelSize(R.dimen.overlay_text_size));
            this.mOverlayView.setText(R.string.maintenance_mode);
            WindowManager.LayoutParams layoutParams = new WindowManager.LayoutParams();
            this.mOverlayViewParams = layoutParams;
            layoutParams.type = 2038;
            layoutParams.width = -2;
            layoutParams.height = -2;
            layoutParams.gravity = 8388691;
            layoutParams.format = this.mOverlayView.getBackground().getOpacity();
            WindowManager.LayoutParams layoutParams2 = this.mOverlayViewParams;
            layoutParams2.flags = 24;
            layoutParams2.privateFlags |= 536870928;
            this.mWm = (WindowManager) getSystemService("window");
        } catch (Exception e) {
            Log.i("MaintenanceMode", "Failed to make overlay: " + e.toString());
        }
        setOverlayVisibility(true);
        try {
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction("com.samsung.android.intent.action.HIDE_MAINTENANCE_MODE_MARK");
            intentFilter.addAction("com.samsung.android.intent.action.SHOW_MAINTENANCE_MODE_MARK");
            registerReceiverForAllUsers(this.mOverlayReceiver, intentFilter, null, this.mHandler, 2);
        } catch (Exception e2) {
            Log.i("MaintenanceMode", "Failed to register overlay receiver: " + e2.toString());
        }
    }

    public final void setOverlayVisibility(boolean z) {
        WindowManager windowManager = this.mWm;
        TextView textView = this.mOverlayView;
        try {
            if (z) {
                windowManager.addView(textView, this.mOverlayViewParams);
            } else {
                windowManager.removeView(textView);
            }
        } catch (Exception e) {
            Log.i("MaintenanceMode", "Failed to set overlay visibility: " + e.toString());
        }
    }
}
