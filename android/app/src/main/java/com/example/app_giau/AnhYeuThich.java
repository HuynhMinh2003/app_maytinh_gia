package com.example.app_giau;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import java.util.HashSet;
import java.util.Set;

public class AnhYeuThich {
    private final SharedPreferences prefs1;

    public AnhYeuThich(Context context) {
        prefs1 = PreferenceManager.getDefaultSharedPreferences(context);
    }

    public boolean isFavorite(String anhPath) {
        Set<String> favorites = prefs1.getStringSet("favorite_images", new HashSet<>());
        return favorites.contains(anhPath);
    }

    public Set<String> getFavoriteImages() {
        return prefs1.getStringSet("favorite_images", new HashSet<>());
    }

    public boolean toggleFavorite1(String anhPath) {
        Set<String> favorites = new HashSet<>(prefs1.getStringSet("favorite_images", new HashSet<>()));
        boolean isNowFavorite;
        if (favorites.contains(anhPath)) {
            favorites.remove(anhPath);
            isNowFavorite = false;
        } else {
            favorites.add(anhPath);
            isNowFavorite = true;
        }
        prefs1.edit().putStringSet("favorite_images", favorites).apply();
        return isNowFavorite;
    }
}
