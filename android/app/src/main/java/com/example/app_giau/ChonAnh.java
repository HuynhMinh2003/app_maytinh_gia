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

public class ChonAnh {
    public static final int REQUEST_DELETE_PERMISSION = 102;
    public static Uri uriPendingDelete = null;

    private final Context context;

    private static final List<String> SUPPORTED_IMAGE_EXTENSIONS = Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp");

    public ChonAnh(Context context) {
        this.context = context;
    }

    public ArrayList<String> getHiddenImages() {
        File vaultDir = new File(context.getFilesDir(), ".Vault/Images");
        ArrayList<String> filePaths = new ArrayList<>();

        if (vaultDir.exists()) {
            File[] files = vaultDir.listFiles();
            if (files != null) {
                Arrays.sort(files, (f1, f2) -> Long.compare(f2.lastModified(), f1.lastModified()));
                for (File file : files) {
                    String name = file.getName().toLowerCase(Locale.ROOT);
                    if (!file.isHidden() && file.length() > 0 && isSupportedImage(name)) {
                        filePaths.add(file.getAbsolutePath());
                    }
                }
            }
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
                Log.e("VaultApp", "❌ Không thể mở InputStream từ uri: " + uri);
                return false;
            }

            out = new FileOutputStream(outFile);

            byte[] buffer = new byte[1024];
            int len;
            while ((len = in.read(buffer)) > 0) {
                out.write(buffer, 0, len);
            }

            out.flush();

            Uri mediaStoreUri = getMediaStoreImageUriFromInput(uri);

            if (mediaStoreUri != null) {
                requestDeletePermission(mediaStoreUri);
            } else {
                // THÊM ĐOẠN NÀY
                // Nếu không phải ảnh MediaStore, xóa vật lý file
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
                    (path, uri1) -> Log.d("VaultApp", "📷 Đã scan thư mục ẩn: " + path));

            return true;

        } catch (Exception e) {
            Log.e("VaultApp", "❌ Lỗi khi ẩn ảnh: " + e.getMessage(), e);
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

    public boolean restoreImage(String hiddenFilePath) {
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

            hiddenFile.delete();

            MediaScannerConnection.scanFile(context, new String[]{restoredFile.getAbsolutePath()}, null, null);

            return true;

        } catch (Exception e) {
            Log.e("VaultApp", "❌ Lỗi khi khôi phục ảnh: " + e.getMessage(), e);
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
                Log.d("VaultApp", "🗑️ Xoá ảnh qua MediaStore, deleted = " + deleted);
                if (deleted == 0) {
                    Log.e("VaultApp", "❌ Không xoá được ảnh qua MediaStore");
                }
            } else {
                File file = new File(uri.getPath());
                if (file.exists()) {
                    boolean result = file.delete();
                    Log.d("VaultApp", "🗑️ Xoá ảnh vật lý: " + result);
                } else {
                    Log.e("VaultApp", "❌ File không tồn tại: " + file.getAbsolutePath());
                }
            }

        } catch (Exception e) {
            Log.e("VaultApp", "❌ Lỗi khi xoá ảnh: " + e.getMessage(), e);
        }
    }

    /**
     * ĐÂY LÀ HÀM QUAN TRỌNG: Tìm đúng MediaStore URI từ input (uri lấy từ Intent, hoặc từ file)
     */
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
                Log.e("VaultApp", "❌ mediaStoreUri null khi yêu cầu xóa");
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
            Log.d("VaultApp", "✅ Người dùng cho phép xoá ảnh");
            // KHÔNG cần gọi lại deleteOriginalImage(uriPendingDelete) nữa! Ảnh đã được hệ thống xóa.
        } else {
            Log.w("VaultApp", "❌ Người dùng từ chối quyền xóa ảnh hoặc uri null");
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
