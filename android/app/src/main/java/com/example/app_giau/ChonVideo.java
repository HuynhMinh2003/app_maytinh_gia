package com.example.app_giau;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Context;
import android.database.Cursor;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;

import java.io.*;
import java.util.*;

public class ChonVideo {
    public static final int REQUEST_DELETE_PERMISSION = 104;
    public static Uri uriPendingDelete = null;

    private final Context context;

    private static final List<String> SUPPORTED_VIDEO_EXTENSIONS = Arrays.asList(".mp4", ".avi", ".mov", ".mkv", ".wmv", ".flv", ".webm", ".3gp");

    public ChonVideo(Context context) {
        this.context = context;
    }

    public ArrayList<String> getHiddenVideos() {
        File vaultDir = new File(context.getFilesDir(), ".Vault/Videos");
        ArrayList<String> filePaths = new ArrayList<>();

        if (vaultDir.exists()) {
            File[] files = vaultDir.listFiles();
            if (files != null) {
                Arrays.sort(files, (f1, f2) -> Long.compare(f2.lastModified(), f1.lastModified()));
                for (File file : files) {
                    String name = file.getName().toLowerCase(Locale.ROOT);
                    if (!file.isHidden() && file.length() > 0 && isSupportedVideo(name)) {
                        filePaths.add(file.getAbsolutePath());
                    }
                }
            }
        }
        return filePaths;
    }

    private boolean isSupportedVideo(String fileName) {
        for (String ext : SUPPORTED_VIDEO_EXTENSIONS) {
            if (fileName.endsWith(ext)) return true;
        }
        return false;
    }

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
                Log.e("VaultApp", "❌ Không thể mở InputStream từ uri: " + uri);
                return false;
            }

            out = new FileOutputStream(outFile);

            byte[] buffer = new byte[4096];
            int len;
            while ((len = in.read(buffer)) > 0) {
                out.write(buffer, 0, len);
            }

            out.flush();

            Uri mediaStoreUri = getMediaStoreVideoUriFromInput(uri);

            if (mediaStoreUri != null) {
                requestDeletePermission(mediaStoreUri);
            } else {
                File file = new File(uri.getPath());
                if (file.exists()) {
                    boolean deleted = file.delete();
                    Log.d("VaultApp", "🗑️ Xóa file riêng app: " + deleted);
                } else {
                    Log.e("VaultApp", "❌ File không tồn tại: " + file.getAbsolutePath());
                }
            }

            MediaScannerConnection.scanFile(context,
                    new String[]{outFile.getAbsolutePath()},
                    null,
                    (path, uri1) -> Log.d("VaultApp", "🎬 Đã scan thư mục ẩn: " + path));

            return true;

        } catch (Exception e) {
            Log.e("VaultApp", "❌ Lỗi khi ẩn video: " + e.getMessage(), e);
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

    public boolean restoreVideo(String hiddenFilePath) {
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

            hiddenFile.delete();

            MediaScannerConnection.scanFile(context, new String[]{restoredFile.getAbsolutePath()}, null, null);

            return true;

        } catch (Exception e) {
            Log.e("VaultApp", "❌ Lỗi khi khôi phục video: " + e.getMessage(), e);
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
                Log.e("VaultApp", "❌ mediaStoreUri null khi yêu cầu xóa video");
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
            Log.e("VaultApp", "❌ Lỗi khi gửi yêu cầu xoá qua MediaStore: " + e.getMessage(), e);
        }
    }

    public static void handleDeletePermissionResult(Context context, int resultCode) {
        if (resultCode == Activity.RESULT_OK && uriPendingDelete != null) {
            Log.d("VaultApp", "✅ Người dùng cho phép xoá video");
        } else {
            Log.w("VaultApp", "❌ Người dùng từ chối quyền xóa video hoặc uri null");
        }
        uriPendingDelete = null;
    }
}