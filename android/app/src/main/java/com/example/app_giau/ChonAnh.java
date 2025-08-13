package com.example.app_giau;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.content.ContentValues;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;

import com.example.app_giau.sqlite.MetadataDatabaseHelper;
import com.example.app_giau.modules.ImageMetadata;

import java.io.*;
import java.util.*;


public class ChonAnh {
    public static final int REQUEST_DELETE_PERMISSION = 102;
    public static Uri uriPendingDelete = null;

    private final Context context;

    private static final List<String> SUPPORTED_IMAGE_EXTENSIONS = Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp");

    public ChonAnh(Context context) {
        this.context = context;
    }

    public ArrayList<String> getHiddenImages() {
        ArrayList<String> filePaths = new ArrayList<>();
        SQLiteDatabase db = null;
        Cursor cursor = null;

        try {
            MetadataDatabaseHelper dbHelper = new MetadataDatabaseHelper(context);
            db = dbHelper.getReadableDatabase();

            // Lấy tất cả ảnh đang ẩn, sắp xếp theo ngày tạo mới nhất
            cursor = db.query(
                    "image_metadata",
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

                    // Chỉ thêm nếu file vẫn tồn tại
                    if (file.exists() && file.length() > 0 && isSupportedImage(file.getName())) {
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

    private boolean isSupportedImage(String fileName) {
        for (String ext : SUPPORTED_IMAGE_EXTENSIONS) {
            if (fileName.endsWith(ext)) return true;
        }
        return false;
    }

    public boolean hideImage(Uri uri) {
        InputStream in = null;
        FileOutputStream out = null;

        try {
            File vaultDir = new File(context.getFilesDir(), ".Vault/Images");
            if (!vaultDir.exists()) vaultDir.mkdirs();

            File noMedia = new File(vaultDir, ".nomedia");
            if (!noMedia.exists()) noMedia.createNewFile();

            String filename = "img_" + System.currentTimeMillis() + ".jpg";
            File outFile = new File(vaultDir, filename);

            in = context.getContentResolver().openInputStream(uri);
            if (in == null) {

                return false;
            }

            out = new FileOutputStream(outFile);
            byte[] buffer = new byte[1024];
            int len;
            while ((len = in.read(buffer)) > 0) {
                out.write(buffer, 0, len);
            }
            out.flush();

            // 🔹 Lưu metadata vào SQLite
            MetadataDatabaseHelper dbHelper = new MetadataDatabaseHelper(context);
            ImageMetadata meta = new ImageMetadata(
                    outFile.getAbsolutePath(),
                    filename,
                    System.currentTimeMillis(),
                    "", // tag mặc định rỗng
                    true, // đang ẩn
                    outFile.length()
            );
            dbHelper.insertImageMetadata(meta);

            Uri mediaStoreUri = getMediaStoreImageUriFromInput(uri);
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
                    (path, uri1) -> Log.d("VaultApp", "📷 Đã scan thư mục ẩn: " + path));

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

    // Xóa ảnh trong app (xóa file trong thư mục ẩn)
    public boolean deleteImageInApp(String filePath) {
        try {
            File file = new File(filePath);
            if (file.exists()) {
                return file.delete();
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Copy ảnh sang thư viện nhưng không xóa ảnh gốc
    public boolean copyImageToGallery(String hiddenFilePath) {
        FileInputStream in = null;
        FileOutputStream out = null;
        try {
            File hiddenFile = new File(hiddenFilePath);
            File picturesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
            File restoredFile = new File(picturesDir, hiddenFile.getName());

            in = new FileInputStream(hiddenFile);
            out = new FileOutputStream(restoredFile);

            byte[] buffer = new byte[1024];
            int len;
            while ((len = in.read(buffer)) > 0) {
                out.write(buffer, 0, len);
            }
            out.flush();

            // Không xóa file gốc

            // Cập nhật media store để ảnh hiện trong thư viện
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

    private void deleteOriginalImage(Uri uri) {
        try {
            String scheme = uri.getScheme();
            Log.d("VaultApp", "🗑️ Đang cố gắng xoá ảnh với URI = " + uri + ", scheme = " + scheme);

            if ("content".equals(scheme)) {
                int deleted = context.getContentResolver().delete(uri, null, null);

                if (deleted == 0) {

                }
            } else {
                File file = new File(uri.getPath());
                if (file.exists()) {
                    boolean result = file.delete();

                } else {

                }
            }

        } catch (Exception e) {

        }
    }

    private Uri getMediaStoreImageUriFromInput(Uri inputUri) {
        String scheme = inputUri.getScheme();
        if ("content".equals(scheme)) {
            // Nếu là content://media/external/images/media/<id> thì trả về luôn
            if (inputUri.toString().startsWith(MediaStore.Images.Media.EXTERNAL_CONTENT_URI.toString())) {
                return inputUri;
            }
            // Nếu là content nhưng không phải media/external, thì thử lấy _ID qua truy vấn
            Cursor cursor = context.getContentResolver().query(
                    inputUri,
                    new String[]{MediaStore.Images.Media._ID},
                    null,
                    null,
                    null
            );
            if (cursor != null) {
                if (cursor.moveToFirst()) {
                    int idIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media._ID);
                    long id = cursor.getLong(idIndex);
                    cursor.close();
                    return Uri.withAppendedPath(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, String.valueOf(id));
                }
                cursor.close();
            }
        } else if ("file".equals(scheme)) {
            // Nếu là file:// thì lấy đường dẫn, rồi truy vấn lấy _ID
            String filePath = inputUri.getPath();
            return getMediaStoreUriFromFilePath(filePath);
        }
        return null;
    }

    private Uri getMediaStoreUriFromFilePath(String filePath) {
        Uri externalUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
        Cursor cursor = context.getContentResolver().query(
                externalUri,
                new String[]{MediaStore.Images.Media._ID},
                MediaStore.Images.Media.DATA + "=?",
                new String[]{filePath},
                null
        );
        if (cursor != null) {
            if (cursor.moveToFirst()) {
                int id = cursor.getInt(cursor.getColumnIndexOrThrow(MediaStore.Images.Media._ID));
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

            // KHÔNG cần gọi lại deleteOriginalImage(uriPendingDelete) nữa! Ảnh đã được hệ thống xóa.
        } else {

        }
        uriPendingDelete = null;
    }

    private Uri getMediaStoreContentUriFromFilePath(String filePath) {
        // ⚠️ Lưu ý: MediaStore.Images.Media.DATA đã bị deprecated và không hoạt động tốt từ Android 10+
        Uri externalUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;

        Cursor cursor = context.getContentResolver().query(
                externalUri,
                new String[]{MediaStore.Images.Media._ID},
                MediaStore.Images.Media.DATA + "=?",
                new String[]{filePath},
                null
        );

        if (cursor != null) {
            if (cursor.moveToFirst()) {
                int id = cursor.getInt(cursor.getColumnIndexOrThrow(MediaStore.Images.Media._ID));
                cursor.close();
                return Uri.withAppendedPath(externalUri, String.valueOf(id));
            }
            cursor.close();
        }
        return null;
    }

    private Uri getMediaStoreUriFromFile(Uri fileUri) {
        if (fileUri == null) return null;
        String path = fileUri.getPath();
        if (path == null) return null;

        Uri externalUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
        Cursor cursor = context.getContentResolver().query(
                externalUri,
                new String[]{MediaStore.Images.Media._ID},
                MediaStore.Images.Media.DATA + "=?",
                new String[]{path},
                null
        );

        if (cursor != null && cursor.moveToFirst()) {
            int id = cursor.getInt(cursor.getColumnIndexOrThrow(MediaStore.Images.Media._ID));
            cursor.close();
            return Uri.withAppendedPath(externalUri, String.valueOf(id));
        }

        if (cursor != null) cursor.close();
        return null;
    }

    public static String getRealPathFromUri(Context context, Uri uri) {
        String[] projection = {MediaStore.Images.Media.DATA};
        Cursor cursor = context.getContentResolver().query(uri, projection, null, null, null);

        if (cursor != null) {
            int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            if (cursor.moveToFirst()) {
                String path = cursor.getString(column_index);
                cursor.close();
                return path;
            }
            cursor.close();
        }
        return null;
    }


}
