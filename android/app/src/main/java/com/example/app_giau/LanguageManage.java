package com.example.app_giau;

import android.content.Context;
import android.content.SharedPreferences;

public class LanguageManage {
    private static final String PREFS_NAME = "app_language_prefs";
    private static final String KEY_LANGUAGE = "selected_language";

    public static void saveLanguage(Context context, String langCode) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        prefs.edit().putString(KEY_LANGUAGE, langCode).apply();
    }

    public static String loadLanguage(Context context) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return prefs.getString(KEY_LANGUAGE, "en"); // mặc định English
    }
}
