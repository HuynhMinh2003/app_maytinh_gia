package com.example.app_giau;

import android.content.Context;
import android.content.SharedPreferences;

public class RateApp {
    private static final String PREF_NAME = "rate_app_pref";
    private static final String KEY_RATING = "user_rating";

    private final Context context;

    public RateApp(Context context) {
        this.context = context;
    }

    // Lưu số sao
    public void saveRating(float rating) {
        SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        prefs.edit().putFloat(KEY_RATING, rating).apply();
    }

    // Lấy số sao đã lưu
    public float getRating() {
        SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        return prefs.getFloat(KEY_RATING, 0f);
    }
}
