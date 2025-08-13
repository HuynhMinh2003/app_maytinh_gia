package com.example.app_giau;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.util.Log;
import android.database.Cursor;
import android.provider.OpenableColumns;
import android.content.ContentUris;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.media.MediaScannerConnection;
import android.os.Environment;  // cho Environment

import androidx.annotation.Nullable;

import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.io.FileInputStream;

import io.flutter.plugin.common.MethodChannel;

public class FolderManager {
    // Khai báo biến giữ uri đợi xóa
    private Uri uriPendingDelete = null;

    // Khai báo mã request dùng trong startIntentSenderForResult
    public static final int REQUEST_DELETE_PERMISSION = 2001;
    private Context context;
    private File baseFolder;

    // Biến giữ kết quả chờ callback cho pick file
    private MethodChannel.Result pendingPickFileResult;
    private String pendingPickFileFolderId;

    public static final int PICK_FILE_REQUEST_CODE = 1001;

    public FolderManager(Context context) {
        this.context = context;
        baseFolder = new File(context.getFilesDir(), "MyFolders");
        if (!baseFolder.exists()) {
            baseFolder.mkdirs();
        }
        // Tạo file .nomedia trong thư mục gốc để ẩn toàn bộ thư mục
        File nomedia = new File(baseFolder, ".nomedia");
        if (!nomedia.exists()) {
            try {
                nomedia.createNewFile();

            } catch (Exception e) {

            }
        }
    }

    public File getBaseFolder() {
        return baseFolder;
    }

    public boolean createFolder(String folderName) {
        if (folderName == null || folderName.trim().isEmpty()) {

            return false;
        }
        File folder = new File(baseFolder, folderName);
        if (folder.exists()) {

            return false;
        }
        boolean created = folder.mkdir();
        if (created) {
            // Tạo file .nomedia trong thư mục con
            File nomedia = new File(folder, ".nomedia");
            if (!nomedia.exists()) {
                try {
                    nomedia.createNewFile();

                } catch (Exception e) {

                }
            }
        } else {

        }
        return created;
    }

    public List<String> getFoldersJson() {
        List<String> jsonList = new ArrayList<>();
        File[] folders = baseFolder.listFiles(File::isDirectory);
        if (folders != null) {
            for (File folder : folders) {
                try {
                    JSONObject obj = new JSONObject();
                    obj.put("id", folder.getName());
                    obj.put("name", folder.getName());
                    obj.put("path", folder.getAbsolutePath()); // ✅ Thêm dòng này
                    jsonList.add(obj.toString());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return jsonList;
    }

    public List<String> getFilesInFolder(String folderId) {
        List<String> files = new ArrayList<>();
        File folder = new File(baseFolder, folderId);
        if (folder.exists() && folder.isDirectory()) {
            File[] fileList = folder.listFiles();
            if (fileList != null) {
                for (File file : fileList) {
                    if (file.isFile()) {
                        String name = file.getName();
                        if (!name.startsWith(".") && !name.equals(".nomedia")) {
                            files.add(file.getAbsolutePath());
                        }
                    }
                }
            }
        }
        return files;
    }

    public boolean hideFileToFolder(Uri uri, String folderId, Context context) {
        FileOutputStream out = null;
        InputStream in = null;
        try {
            File folder = new File(baseFolder, folderId);
            if (!folder.exists()) folder.mkdirs();

            ContentResolver resolver = context.getContentResolver();
            in = resolver.openInputStream(uri);
            if (in == null) return false;

            String originalFileName = getFileName(resolver, uri);
            String extension = "";
            if (originalFileName != null && originalFileName.contains(".")) {
                extension = originalFileName.substring(originalFileName.lastIndexOf("."));
            }

            String filename = "file_" + System.currentTimeMillis() + extension;
            File outFile = new File(folder, filename);

            out = new FileOutputStream(outFile);
            byte[] buffer = new byte[8192];
            int len;
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
            out.flush();

            if (outFile.length() == 0) {

                outFile.delete();
                return false;
            }

            // **Thêm dòng này để quét lại file vừa copy**
            MediaScannerConnection.scanFile(context, new String[]{ outFile.getAbsolutePath() }, null, null);

            return true;
        } catch (Exception e) {

            return false;
        } finally {
            try {
                if (in != null) in.close();
                if (out != null) out.close();
            } catch (Exception e) {

            }
        }
    }

    public boolean deleteFile(String path) {
        File file = new File(path);

        if (!file.exists()) {

            return false;
        }
        if (!file.canWrite()) {

            // Cố gắng bật quyền ghi
            boolean writable = file.setWritable(true);

        }
        boolean deleted = file.delete();

        if (!deleted) {
            // Thử xóa lại bằng cách gọi deleteOnExit để debug
            boolean deleteOnExitResult = false;
            try {
                file.deleteOnExit();
                deleteOnExitResult = true;
            } catch (Exception e) {

            }

        }
        return deleted;
    }

    private String getFileName(ContentResolver resolver, Uri uri) {
        String result = null;
        Cursor cursor = resolver.query(uri, null, null, null, null);
        try {
            if (cursor != null && cursor.moveToFirst()) {
                int nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME);
                if (nameIndex != -1) {
                    result = cursor.getString(nameIndex);
                }
            }
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        return result;
    }

    // ----------- MỚI: Hàm gọi pick file giữ pendingResult --------------

    public void pickFile(Activity activity, String folderId, MethodChannel.Result result) {
        this.pendingPickFileResult = result;
        this.pendingPickFileFolderId = folderId;

        // Mở picker ảnh + video
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("*/*"); // phải để */* mới dùng EXTRA_MIME_TYPES được
        intent.putExtra(Intent.EXTRA_MIME_TYPES, new String[]{"image/*", "video/*"}); // chỉ lấy ảnh và video

        activity.startActivityForResult(intent, PICK_FILE_REQUEST_CODE);
    }


    public boolean deleteOriginalFileFromMediaStore(Uri uri) {
        try {
            ContentResolver resolver = context.getContentResolver();
            int deletedRows = resolver.delete(uri, null, null);
            return deletedRows > 0;
        } catch (SecurityException e) {

            return false;
        } catch (Exception e) {

            return false;
        }
    }

    private Uri getMediaStoreUriFromDocumentUri(Uri documentUri) {
        if ("com.android.providers.media.documents".equals(documentUri.getAuthority())) {
            String docId = DocumentsContract.getDocumentId(documentUri);
            String[] parts = docId.split(":");
            if (parts.length == 2) {
                String type = parts[0];
                String id = parts[1];
                Uri mediaUri = null;
                if ("image".equals(type)) {
                    mediaUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                } else if ("video".equals(type)) {
                    mediaUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                } else if ("audio".equals(type)) {
                    mediaUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                }
                if (mediaUri != null) {
                    try {
                        long parsedId = Long.parseLong(id);
                        return ContentUris.withAppendedId(mediaUri, parsedId);
                    } catch (NumberFormatException e) {

                        return documentUri; // fallback
                    }
                }
            }
        }
        // Trường hợp khác trả về nguyên bản
        return documentUri;
    }

    public void requestDeletePermission(Activity activity, Uri documentUri) {
        Uri mediaStoreUri = getMediaStoreUriFromDocumentUri(documentUri);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            try {
                ArrayList<Uri> uriList = new ArrayList<>();
                uriList.add(mediaStoreUri);

                PendingIntent pi = MediaStore.createDeleteRequest(context.getContentResolver(), uriList);
                uriPendingDelete = mediaStoreUri;

                activity.startIntentSenderForResult(
                        pi.getIntentSender(),
                        REQUEST_DELETE_PERMISSION,
                        null,
                        0,
                        0,
                        0
                );
            } catch (Exception e) {

            }
        } else {
            try {
                int deleted = context.getContentResolver().delete(mediaStoreUri, null, null);

            } catch (Exception e) {

            }
        }
    }

    public void handleActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == PICK_FILE_REQUEST_CODE) {
            Uri uri = (data != null) ? data.getData() : null;
            boolean success = false;
            if (resultCode == Activity.RESULT_OK && uri != null) {
                success = hideFileToFolder(uri, pendingPickFileFolderId, context);
                if (success) {
                    // Thay vì xóa trực tiếp, gọi request delete permission:
                    requestDeletePermission((Activity) context, uri);
                }
            }
            if (pendingPickFileResult != null) {
                pendingPickFileResult.success(success);
                pendingPickFileResult = null;
            }
            pendingPickFileFolderId = null;
        } else if (requestCode == REQUEST_DELETE_PERMISSION) {
            if (resultCode == Activity.RESULT_OK && uriPendingDelete != null) {

                // File đã được hệ thống xóa, không cần làm gì thêm
            } else {

            }
            uriPendingDelete = null;
        }
    }

    public boolean restoreFile(String appFilePath) {
        try {
            File sourceFile = new File(appFilePath);
            String fileName = sourceFile.getName();

            File publicDir;
            if (fileName.endsWith(".mp4") || fileName.endsWith(".mov")) {
                publicDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES);
            } else {
                publicDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
            }
            if (!publicDir.exists()) {
                publicDir.mkdirs();
            }

            File destFile = new File(publicDir, fileName);

            try (InputStream in = new FileInputStream(sourceFile);
                 FileOutputStream out = new FileOutputStream(destFile)) {
                byte[] buffer = new byte[8192];
                int len;
                while ((len = in.read(buffer)) > 0) {
                    out.write(buffer, 0, len);
                }
            }

            MediaScannerConnection.scanFile(context, new String[]{destFile.getAbsolutePath()}, null, null);
            return true;
        } catch (Exception e) {

            return false;
        }
    }

    public boolean moveImageToFolder(String imagePath, String folderId) {
        File sourceFile = new File(imagePath);
        File destFolder = new File(baseFolder, folderId);
        if (!destFolder.exists()) {
            destFolder.mkdirs();
        }
        File destFile = new File(destFolder, sourceFile.getName());
        return sourceFile.renameTo(destFile);
    }

    public boolean moveVideoToFolder(String videoPath, String folderId) {
        File sourceFile = new File(videoPath);
        File destFolder = new File(baseFolder, folderId);
        if (!destFolder.exists()) {
            destFolder.mkdirs();
        }
        File destFile = new File(destFolder, sourceFile.getName());
        return sourceFile.renameTo(destFile);
    }

    // Đổi tên folder
    public boolean renameFolder(String folderId, String newName) {
        if (newName == null || newName.trim().isEmpty()) {

            return false;
        }
        File folder = new File(baseFolder, folderId);
        if (!folder.exists() || !folder.isDirectory()) {

            return false;
        }
        File newFolder = new File(baseFolder, newName);
        if (newFolder.exists()) {

            return false;
        }
        boolean renamed = folder.renameTo(newFolder);

        return renamed;
    }

    public boolean deleteFolder(String folderId) {
        File folder = new File(baseFolder, folderId);
        if (!folder.exists() || !folder.isDirectory()) {
            return false;
        }
        File[] files = folder.listFiles();
        if (files != null) {
            for (File file : files) {
                if (!file.delete()) {
                    return false;
                }
            }
        }
        return folder.delete();
    }

    public boolean restoreFolder(String folderId) {
        File folder = new File(baseFolder, folderId);
        if (!folder.exists() || !folder.isDirectory()) {
            return false;
        }
        File[] files = folder.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isFile() && !file.getName().startsWith(".")) {
                    boolean restored = restoreFile(file.getAbsolutePath());
                    if (!restored) {
                        return false;
                    }
                }
            }
        }
        return true;
    }


}
