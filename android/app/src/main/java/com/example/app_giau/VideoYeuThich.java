package com.example.app_giau;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import java.util.HashSet;
import java.util.Set;

public class VideoYeuThich {
    private final SharedPreferences prefs;

    public VideoYeuThich(Context context) {
        prefs = PreferenceManager.getDefaultSharedPreferences(context);
    }

    public boolean isFavorite(String videoPath) {
        Set<String> favorites = prefs.getStringSet("favorite_videos", new HashSet<>());
        return favorites.contains(videoPath);
    }

    public Set<String> getFavoriteVideos() {
        return prefs.getStringSet("favorite_videos", new HashSet<>());
    }

    public boolean toggleFavorite(String videoPath) {
        Set<String> favorites = new HashSet<>(prefs.getStringSet("favorite_videos", new HashSet<>()));
        boolean isNowFavorite;
        if (favorites.contains(videoPath)) {
            favorites.remove(videoPath);
            isNowFavorite = false;
        } else {
            favorites.add(videoPath);
            isNowFavorite = true;
        }
        prefs.edit().putStringSet("favorite_videos", favorites).apply();
        return isNowFavorite;
    }
}
