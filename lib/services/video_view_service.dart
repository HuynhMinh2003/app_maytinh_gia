import 'package:flutter/services.dart';

class VideoViewService {
  static const _platform = MethodChannel('com.example.vault/channel');

  /// Lấy trạng thái yêu thích
  static Future<bool> checkFavorite(String videoPath) async {
    try {
      return await _platform.invokeMethod('checkFavorite', {
        'videoPath': videoPath,
      });
    } on PlatformException catch (e) {

      return false;
    }
  }

  /// Đổi trạng thái yêu thích
  static Future<bool> toggleFavorite(String videoPath) async {
    try {
      return await _platform.invokeMethod('toggleFavorite', {
        'videoPath': videoPath,
      });
    } on PlatformException catch (e) {

      return false;
    }
  }
}
