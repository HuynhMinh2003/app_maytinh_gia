import 'package:flutter/services.dart';

class ImageViewService {
  static const _platform = MethodChannel('com.example.vault/channel');

  Future<bool> checkFavorite(String imagePath) async {
    try {
      return await _platform.invokeMethod('checkFavorite1', {
        'imagePath': imagePath,
      });
    } on PlatformException {
      return false;
    }
  }

  Future<bool> toggleFavorite(String imagePath) async {
    try {
      return await _platform.invokeMethod('toggleFavorite1', {
        'imagePath': imagePath,
      });
    } on PlatformException {
      return false;
    }
  }
}
