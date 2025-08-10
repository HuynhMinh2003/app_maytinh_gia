package com.example.app_giau;

import android.content.Context;
import android.content.SharedPreferences;

public class NhapPin {

    private final SharedPreferences prefs;

    public NhapPin(Context context) {
        prefs = context.getSharedPreferences("VaultPrefs", Context.MODE_PRIVATE);
    }

    public void savePin(String pin) {
        prefs.edit().putString("pin_code", pin).apply();
    }

    public String getPin() {
        return prefs.getString("pin_code", "");
    }

    public boolean validatePin(String inputPin) {
        return inputPin.equals(getPin());
    }

}
