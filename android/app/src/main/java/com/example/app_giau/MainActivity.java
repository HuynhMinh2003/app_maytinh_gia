package com.example.app_giau;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import java.util.Set;
import java.util.ArrayList;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.vault/channel";
    private static final int REQUEST_CODE_READ_MEDIA_IMAGES = 101;
    private static final int REQUEST_CODE_READ_MEDIA_VIDEO = 105;
    private static final int REQUEST_DELETE_PERMISSION = 102;
    private static final int REQUEST_DELETE_VIDEO_PERMISSION = 104;
    private static final int PICK_IMAGE_REQUEST = 103;
    private static final int PICK_VIDEO_REQUEST = 106;

    private NhapPin pinLogic;
    private TinhToan tinhToan;
    private ChonAnh chonAnh;
    private ChonVideo chonVideo;
    private VideoYeuThich favoriteManager;
    private AnhYeuThich favoriteManager1;
    private RateApp rateApp;
    private AppInfo appInfo;

    // Biến lưu MethodChannel.Result để trả về cho Flutter sau khi chọn ảnh/video
    private MethodChannel.Result pendingPickImageResult;
    private MethodChannel.Result pendingPickVideoResult;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Yêu cầu quyền đọc ảnh
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                ContextCompat.checkSelfPermission(this, Manifest.permission.READ_MEDIA_IMAGES)
                        != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(
                    this,
                    new String[]{Manifest.permission.READ_MEDIA_IMAGES},
                    REQUEST_CODE_READ_MEDIA_IMAGES
            );
        }

        // Yêu cầu quyền đọc video
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                ContextCompat.checkSelfPermission(this, Manifest.permission.READ_MEDIA_VIDEO)
                        != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(
                    this,
                    new String[]{Manifest.permission.READ_MEDIA_VIDEO},
                    REQUEST_CODE_READ_MEDIA_VIDEO
            );
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        pinLogic = new NhapPin(this);
        tinhToan = new TinhToan();
        chonAnh = new ChonAnh(this);
        chonVideo = new ChonVideo(this);
        favoriteManager = new VideoYeuThich(this);
        favoriteManager1 = new AnhYeuThich(this);
        rateApp = new RateApp(this); // ✅ Thêm
        appInfo = new AppInfo(this);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        // PIN/CALC
                        case "savePin":
                            String pin = call.argument("pin");
                            pinLogic.savePin(pin);
                            result.success(true);
                            break;
                        case "getPin":
                            result.success(pinLogic.getPin());
                            break;
                        case "validatePin":
                            String inputPin = call.argument("pin");
                            result.success(pinLogic.validatePin(inputPin));
                            break;
                        case "evaluate":
                            String expr = call.argument("expression");
                            try {
                                double res = tinhToan.evaluate(expr);
                                result.success(res);
                            } catch (Exception e) {
                                result.error("EVAL_ERROR", "Invalid expression", null);
                            }
                            break;
                        case "changePin":
                            String oldPin = call.argument("oldPin");
                            String newPin = call.argument("newPin");
                            if (pinLogic.validatePin(oldPin)) {
                                pinLogic.savePin(newPin);
                                result.success(true);
                            } else {
                                result.success(false);
                            }
                            break;

                        // IMAGE
                        case "getHiddenImages":
                            result.success(chonAnh.getHiddenImages());
                            break;
                        case "hideImage":
                            String uriString = call.argument("uri");
                            Uri imageUri = Uri.parse(uriString);
                            boolean success = chonAnh.hideImage(imageUri);
                            result.success(success);
                            break;
                        case "restoreImage":
                            String path = call.argument("path");
                            boolean restored = chonAnh.restoreImage(path);
                            result.success(restored);
                            break;
                        case "pickImageUri":
                            pendingPickImageResult = result;
                            Intent intentImg = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                            intentImg.setType("image/*");
                            startActivityForResult(intentImg, PICK_IMAGE_REQUEST);
                            break;

                        // VIDEO
                        case "getHiddenVideos":
                            result.success(chonVideo.getHiddenVideos());
                            break;
                        case "hideVideo":
                            String uriVideoString = call.argument("uri");
                            Uri videoUri = Uri.parse(uriVideoString);
                            boolean videoSuccess = chonVideo.hideVideo(videoUri);
                            result.success(videoSuccess);
                            break;
                        case "restoreVideo":
                            String videoPath = call.argument("path");
                            boolean videoRestored = chonVideo.restoreVideo(videoPath);
                            result.success(videoRestored);
                            break;
                        case "pickVideoUri":
                            pendingPickVideoResult = result;
                            Intent intentVid = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Video.Media.EXTERNAL_CONTENT_URI);
                            intentVid.setType("video/*");
                            startActivityForResult(intentVid, PICK_VIDEO_REQUEST);
                            break;
                        case "checkFavorite":
                            String checkPath = call.argument("videoPath");
                            boolean isFav = favoriteManager.isFavorite(checkPath);
                            result.success(isFav);
                            break;
                        case "toggleFavorite":
                            String togglePath = call.argument("videoPath");
                            boolean newStatus = favoriteManager.toggleFavorite(togglePath);
                            result.success(newStatus);
                            break;
                        case "getFavoriteVideos":
                            Set<String> favoriteSet = favoriteManager.getFavoriteVideos();
                            result.success(new ArrayList<>(favoriteSet));
                            break;
                        case "checkFavorite1":
                            String checkPath1 = call.argument("imagePath");
                            boolean isFav1 = favoriteManager1.isFavorite(checkPath1);
                            result.success(isFav1);
                            break;
                        case "toggleFavorite1":
                            String togglePath1 = call.argument("imagePath");
                            boolean newStatus1 = favoriteManager1.toggleFavorite1(togglePath1);
                            result.success(newStatus1);
                            break;
                        case "getFavoriteImages":
                            Set<String> favoriteSet1 = favoriteManager1.getFavoriteImages();
                            result.success(new ArrayList<>(favoriteSet1));
                            break;
                        // ✅ Lưu rating
                        case "saveRating":
                            Number ratingNumber = call.argument("rating");
                            if (ratingNumber != null) {
                                rateApp.saveRating(ratingNumber.floatValue());
                                result.success(true);
                            } else {
                                result.error("INVALID", "Rating is null", null);
                            }
                            break;

                        // ✅ Lấy rating
                        case "getRating":
                            result.success((int) rateApp.getRating());
                            break;

                        case "getAppVersion":
                            result.success(appInfo.getVersionName());
                            break;

                        case "getAppVersionCode":
                            result.success(appInfo.getVersionCode());
                            break;

                        case "saveLanguage":
                            String langCode = call.argument("langCode");
                            if (langCode != null) {
                                LanguageManage.saveLanguage(this, langCode);
                                result.success(true);
                            } else {
                                result.error("INVALID", "Language code is null", null);
                            }
                            break;

                        case "getLanguage":
                            String savedLang = LanguageManage.loadLanguage(this);
                            result.success(savedLang);
                            break;

                        default:
                            result.notImplemented();
                            break;
                    }
                });
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_CODE_READ_MEDIA_IMAGES) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Log.d("VaultApp", "✅ Đã cấp quyền READ_MEDIA_IMAGES");
            } else {
                Log.w("VaultApp", "⚠️ Người dùng từ chối quyền READ_MEDIA_IMAGES");
            }
        }
        if (requestCode == REQUEST_CODE_READ_MEDIA_VIDEO) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Log.d("VaultApp", "✅ Đã cấp quyền READ_MEDIA_VIDEO");
            } else {
                Log.w("VaultApp", "⚠️ Người dùng từ chối quyền READ_MEDIA_VIDEO");
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_DELETE_PERMISSION) {
            ChonAnh.handleDeletePermissionResult(this, resultCode);
        }
        if (requestCode == REQUEST_DELETE_VIDEO_PERMISSION) {
            ChonVideo.handleDeletePermissionResult(this, resultCode);
        }
        if (requestCode == PICK_IMAGE_REQUEST && resultCode == RESULT_OK && data != null && pendingPickImageResult != null) {
            Uri imageUri = data.getData();
            pendingPickImageResult.success(imageUri != null ? imageUri.toString() : null);
            pendingPickImageResult = null;
        }
        if (requestCode == PICK_VIDEO_REQUEST && resultCode == RESULT_OK && data != null && pendingPickVideoResult != null) {
            Uri videoUri = data.getData();
            pendingPickVideoResult.success(videoUri != null ? videoUri.toString() : null);
            pendingPickVideoResult = null;
        }
    }
}