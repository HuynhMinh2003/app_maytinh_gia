import 'package:flutter/services.dart';

class ImageService {
  static const MethodChannel _channel = MethodChannel('com.example.vault/channel');

  VoidCallback? _onDeletePermissionFinished;

  // Hàm để đặt listener callback khi delete permission xử lý xong
  void setDeletePermissionListener(VoidCallback callback) {
    _onDeletePermissionFinished = callback;
  }

  ImageService() {
    // Lắng nghe method call từ native
    _channel.setMethodCallHandler((call) async {
      if (call.method == "deletePermissionResult") {
        // Khi nhận được callback, gọi callback đã đăng ký (nếu có)
        if (_onDeletePermissionFinished != null) {
          _onDeletePermissionFinished!();
        }
      }
    });
  }

  Future<List<String>> getHiddenImages() async {
    final List<dynamic> paths = await _channel.invokeMethod('getHiddenImages');
    return paths.cast<String>();
  }

  Future<bool> pickImageAndHide() async {
    final uriString = await _channel.invokeMethod('pickImageUri');
    if (uriString != null) {
      final result = await _channel.invokeMethod('hideImage', {'uri': uriString});
      return result == true;
    }
    return false;
  }

  // Future<bool> restoreImage(String path) async {
  //   final result = await _channel.invokeMethod('restoreImage', {'path': path});
  //   return result == true;
  // }

  Future<bool> deleteImageInApp(String path) async {
    try {
      final bool result = await _channel.invokeMethod('deleteImageInApp', {'path': path});
      return result;
    } catch (e) {
      print('Error deleteImageInApp: $e');
      return false;
    }
  }

  Future<bool> copyImageToGallery(String path) async {
    try {
      final bool result = await _channel.invokeMethod('copyImageToGallery', {'path': path});
      return result;
    } catch (e) {
      print('Error copyImageToGallery: $e');
      return false;
    }
  }

  Future<bool> moveImageToFolder(String imagePath, String folderId) async {
    try {
      final bool result = await _channel.invokeMethod('moveImageToFolder', {
        'imagePath': imagePath,
        'folderId': folderId,
      });
      return result;
    } catch (e) {
      return false;
    }
  }
}
