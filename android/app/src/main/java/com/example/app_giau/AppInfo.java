package com.example.app_giau;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

public class AppInfo {
    private final Context context;

    public AppInfo(Context context) {
        this.context = context;
    }

    // Lấy phiên bản app (versionName)
    public String getVersionName() {
        try {
            PackageManager pm = context.getPackageManager();
            PackageInfo pInfo = pm.getPackageInfo(context.getPackageName(), 0);
            return pInfo.versionName; // ví dụ: "1.0.3"
        } catch (PackageManager.NameNotFoundException e) {
            return "Unknown";
        }
    }

    // Lấy version code (số build)
    public long getVersionCode() {
        try {
            PackageManager pm = context.getPackageManager();
            PackageInfo pInfo = pm.getPackageInfo(context.getPackageName(), 0);
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
                return pInfo.getLongVersionCode();
            } else {
                return pInfo.versionCode;
            }
        } catch (PackageManager.NameNotFoundException e) {
            return -1;
        }
    }
}
