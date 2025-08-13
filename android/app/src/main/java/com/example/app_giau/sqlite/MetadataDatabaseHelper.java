package com.example.app_giau.sqlite;

import com.example.app_giau.modules.ImageMetadata;
import com.example.app_giau.modules.VideoMetadata;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.content.ContentValues;

public class MetadataDatabaseHelper extends SQLiteOpenHelper {
    private static final String DB_NAME = "vault.db";
    private static final int DB_VERSION = 2; // tăng version để tạo bảng video
    private static final String TABLE_IMAGE_METADATA = "image_metadata";
    private static final String TABLE_VIDEO_METADATA = "video_metadata";

    public MetadataDatabaseHelper(Context context) {
        super(context, DB_NAME, null, DB_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        // Bảng ảnh
        String createImageTable = "CREATE TABLE " + TABLE_IMAGE_METADATA + " (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "file_path TEXT NOT NULL, " +
                "file_name TEXT NOT NULL, " +
                "created_at INTEGER, " +
                "tags TEXT, " +
                "is_hidden INTEGER DEFAULT 1, " +
                "size INTEGER" +
                ")";
        db.execSQL(createImageTable);

        // Bảng video
        String createVideoTable = "CREATE TABLE " + TABLE_VIDEO_METADATA + " (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "file_path TEXT NOT NULL, " +
                "file_name TEXT NOT NULL, " +
                "created_at INTEGER, " +
                "tags TEXT, " +
                "is_hidden INTEGER DEFAULT 1, " +
                "size INTEGER, " +
                "duration INTEGER" + // thời lượng video (ms)
                ")";
        db.execSQL(createVideoTable);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        if (oldVersion < 2) {
            // Tạo bảng video nếu chưa có
            String createVideoTable = "CREATE TABLE IF NOT EXISTS " + TABLE_VIDEO_METADATA + " (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "file_path TEXT NOT NULL, " +
                    "file_name TEXT NOT NULL, " +
                    "created_at INTEGER, " +
                    "tags TEXT, " +
                    "is_hidden INTEGER DEFAULT 1, " +
                    "size INTEGER, " +
                    "duration INTEGER" +
                    ")";
            db.execSQL(createVideoTable);
        }

        // Nếu sau này lên version 3, 4... thì thêm các điều kiện nâng cấp tiếp ở đây
        // if (oldVersion < 3) { ... }
    }

    // ================== IMAGE ==================
    public long insertImageMetadata(ImageMetadata metadata) {
        SQLiteDatabase db = getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put("file_path", metadata.filePath);
        values.put("file_name", metadata.fileName);
        values.put("created_at", metadata.createdAt);
        values.put("tags", metadata.tags);
        values.put("is_hidden", metadata.isHidden ? 1 : 0);
        values.put("size", metadata.size);

        long id = db.insert(TABLE_IMAGE_METADATA, null, values);
        db.close();
        return id;
    }

    // ================== VIDEO ==================
    public long insertVideoMetadata(VideoMetadata metadata) {
        SQLiteDatabase db = getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put("file_path", metadata.filePath);
        values.put("file_name", metadata.fileName);
        values.put("created_at", metadata.createdAt);
        values.put("tags", metadata.tags);
        values.put("is_hidden", metadata.isHidden ? 1 : 0);
        values.put("size", metadata.size);
        values.put("duration", metadata.duration);

        long id = db.insert(TABLE_VIDEO_METADATA, null, values);
        db.close();
        return id;
    }

    public int updateVideoHiddenStatus(String filePath, boolean isHidden) {
        SQLiteDatabase db = getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put("is_hidden", isHidden ? 1 : 0);
        int rows = db.update(TABLE_VIDEO_METADATA, values, "file_path = ?", new String[]{filePath});
        db.close();
        return rows;
    }

}
