import 'package:flutter/services.dart';

class ImageService {
  static const MethodChannel _channel = MethodChannel('com.example.vault/channel');

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

  Future<bool> restoreImage(String path) async {
    final result = await _channel.invokeMethod('restoreImage', {'path': path});
    return result == true;
  }
}
