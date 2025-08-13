package com.example.app_giau;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;

import com.example.app_giau.sqlite.MetadataDatabaseHelper;
import com.example.app_giau.modules.VideoMetadata;

import java.io.*;
import java.util.*;

public class ChonVideo {
    public static final int REQUEST_DELETE_PERMISSION = 104;
    public static Uri uriPendingDelete = null;

    private final Context context;

    private static final List<String> SUPPORTED_VIDEO_EXTENSIONS = Arrays.asList(
            ".mp4", ".avi", ".mov", ".mkv", ".wmv", ".flv", ".webm", ".3gp"
    );

    public ChonVideo(Context context) {
        this.context = context;
    }

    /** Lấy danh sách video ẩn từ SQLite */
    public ArrayList<String> getHiddenVideos() {
        ArrayList<String> filePaths = new ArrayList<>();
        SQLiteDatabase db = null;
        Cursor cursor = null;

        try {
            MetadataDatabaseHelper dbHelper = new MetadataDatabaseHelper(context);
            db = dbHelper.getReadableDatabase();

            cursor = db.query(
                    "video_metadata",
                    new String[]{"file_path"},
                    "is_hidden = ?",
                    new String[]{"1"},
                    null,
                    null,
                    "created_at DESC"
            );

            if (cursor.moveToFirst()) {
                do {
                    String path = cursor.getString(cursor.getColumnIndexOrThrow("file_path"));
                    File file = new File(path);

                    if (file.exists() && file.length() > 0 && isSupportedVideo(file.getName().toLowerCase(Locale.ROOT))) {
                        filePaths.add(path);
                    }
                } while (cursor.moveToNext());
            }
        } finally {
            if (cursor != null) cursor.close();
            if (db != null) db.close();
        }

        return filePaths;
    }

    private boolean isSupportedVideo(String fileName) {
        for (String ext : SUPPORTED_VIDEO_EXTENSIONS) {
            if (fileName.endsWith(ext)) return true;
        }
        return false;
    }

    /** Ẩn video */
    public boolean hideVideo(Uri uri) {
        InputStream in = null;
        FileOutputStream out = null;

        try {
            File vaultDir = new File(context.getFilesDir(), ".Vault/Videos");
            if (!vaultDir.exists()) vaultDir.mkdirs();

            File noMedia = new File(vaultDir, ".nomedia");
            if (!noMedia.exists()) noMedia.createNewFile();

            String filename = "video_" + System.currentTimeMillis() + ".mp4";
            File outFile = new File(vaultDir, filename);

            in = context.getContentResolver().openInputStream(uri);
            if (in == null) {

                return false;
            }

            out = new FileOutputStream(outFile);
            byte[] buffer = new byte[4096];
            int len;
            while ((len = in.read(buffer)) > 0) {
                out.write(buffer, 0, len);
            }
            out.flush();

            // 🔹 Lưu metadata vào SQLite
            MetadataDatabaseHelper dbHelper = new MetadataDatabaseHelper(context);
            VideoMetadata meta = new VideoMetadata(
                    outFile.getAbsolutePath(),
                    filename,
                    System.currentTimeMillis(),
                    "", // tag mặc định
                    true, // đang ẩn
                    outFile.length()
            );
            dbHelper.insertVideoMetadata(meta);

            Uri mediaStoreUri = getMediaStoreVideoUriFromInput(uri);
            if (mediaStoreUri != null) {
                requestDeletePermission(mediaStoreUri);
            } else {
                File file = new File(uri.getPath());
                if (file.exists()) {
                    boolean deleted = file.delete();

                } else {

                }
            }

            MediaScannerConnection.scanFile(context,
                    new String[]{outFile.getAbsolutePath()},
                    null,
                    (path, uri1) -> Log.d("VaultApp", "🎬 Đã scan thư mục ẩn: " + path));

            return true;

        } catch (Exception e) {

            return false;

        } finally {
            try {
                if (in != null) in.close();
                if (out != null) out.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

//    /** Khôi phục video */
//    public boolean restoreVideo(String hiddenFilePath) {
//        FileInputStream in = null;
//        FileOutputStream out = null;
//
//        try {
//            File hiddenFile = new File(hiddenFilePath);
//            File moviesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES);
//            File restoredFile = new File(moviesDir, hiddenFile.getName());
//
//            in = new FileInputStream(hiddenFile);
//            out = new FileOutputStream(restoredFile);
//
//            byte[] buffer = new byte[4096];
//            int len;
//            while ((len = in.read(buffer)) > 0) {
//                out.write(buffer, 0, len);
//            }
//            out.flush();
//
//            hiddenFile.delete();
//
//            // 🔹 Cập nhật SQLite: đánh dấu là không ẩn
//            MetadataDatabaseHelper dbHelper = new MetadataDatabaseHelper(context);
//            dbHelper.updateVideoHiddenStatus(hiddenFilePath, false);
//
//            MediaScannerConnection.scanFile(context, new String[]{restoredFile.getAbsolutePath()}, null, null);
//
//            return true;
//
//        } catch (Exception e) {
//
//            return false;
//
//        } finally {
//            try {
//                if (in != null) in.close();
//                if (out != null) out.close();
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
//        }
//    }

    public boolean deleteVideoInApp(String path) {
        try {
            // Ví dụ: xoá file ẩn trong app (hoặc đánh dấu hidden = false trong DB)
            MetadataDatabaseHelper dbHelper = new MetadataDatabaseHelper(context);
            boolean updated = dbHelper.updateVideoHiddenStatus(path, true) > 0;

            // Hoặc nếu lưu file riêng thì xoá file ở folder app
            File file = new File(path);
            if (file.exists()) {
                return file.delete();
            }

            return updated;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Tải video về thư viện (copy file từ thư mục ẩn về Movies)
    public boolean copyVideoToGallery(String hiddenFilePath) {
        FileInputStream in = null;
        FileOutputStream out = null;
        try {
            File hiddenFile = new File(hiddenFilePath);
            File moviesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES);
            File restoredFile = new File(moviesDir, hiddenFile.getName());

            in = new FileInputStream(hiddenFile);
            out = new FileOutputStream(restoredFile);

            byte[] buffer = new byte[4096];
            int len;
            while ((len = in.read(buffer)) > 0) {
                out.write(buffer, 0, len);
            }
            out.flush();

            MediaScannerConnection.scanFile(context, new String[]{restoredFile.getAbsolutePath()}, null, null);

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (in != null) in.close();
                if (out != null) out.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private Uri getMediaStoreVideoUriFromInput(Uri inputUri) {
        String scheme = inputUri.getScheme();
        if ("content".equals(scheme)) {
            if (inputUri.toString().startsWith(MediaStore.Video.Media.EXTERNAL_CONTENT_URI.toString())) {
                return inputUri;
            }
            Cursor cursor = context.getContentResolver().query(
                    inputUri,
                    new String[]{MediaStore.Video.Media._ID},
                    null,
                    null,
                    null
            );
            if (cursor != null) {
                if (cursor.moveToFirst()) {
                    int idIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media._ID);
                    long id = cursor.getLong(idIndex);
                    cursor.close();
                    return Uri.withAppendedPath(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, String.valueOf(id));
                }
                cursor.close();
            }
        } else if ("file".equals(scheme)) {
            String filePath = inputUri.getPath();
            return getMediaStoreUriFromFilePath(filePath);
        }
        return null;
    }

    private Uri getMediaStoreUriFromFilePath(String filePath) {
        Uri externalUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
        Cursor cursor = context.getContentResolver().query(
                externalUri,
                new String[]{MediaStore.Video.Media._ID},
                MediaStore.Video.Media.DATA + "=?",
                new String[]{filePath},
                null
        );
        if (cursor != null) {
            if (cursor.moveToFirst()) {
                int id = cursor.getInt(cursor.getColumnIndexOrThrow(MediaStore.Video.Media._ID));
                cursor.close();
                return Uri.withAppendedPath(externalUri, String.valueOf(id));
            }
            cursor.close();
        }
        return null;
    }

    private void requestDeletePermission(Uri mediaStoreUri) {
        try {
            if (mediaStoreUri == null) {

                return;
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                ArrayList<Uri> uriList = new ArrayList<>();
                uriList.add(mediaStoreUri);

                PendingIntent pi = MediaStore.createDeleteRequest(context.getContentResolver(), uriList);
                uriPendingDelete = mediaStoreUri;
                ((Activity) context).startIntentSenderForResult(
                        pi.getIntentSender(),
                        REQUEST_DELETE_PERMISSION,
                        null,
                        0,
                        0,
                        0
                );
            } else {
                context.getContentResolver().delete(mediaStoreUri, null, null);
            }
        } catch (Exception e) {

        }
    }

    public static void handleDeletePermissionResult(Context context, int resultCode) {
        if (resultCode == Activity.RESULT_OK && uriPendingDelete != null) {

        } else {

        }
        uriPendingDelete = null;
    }
}
