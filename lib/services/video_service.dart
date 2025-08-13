import 'package:flutter/services.dart';

class HiddenVideoService {
  static const MethodChannel _platform = MethodChannel('com.example.vault/channel');

  Future<List<String>> getHiddenVideos() async {
    final List<dynamic> paths = await _platform.invokeMethod('getHiddenVideos');
    return paths.cast<String>();
  }

  Future<bool> pickVideoAndHide() async {
    final uriString = await _platform.invokeMethod('pickVideoUri');
    if (uriString != null) {
      final result = await _platform.invokeMethod('hideVideo', {'uri': uriString});
      return result == true;
    }
    return false;
  }

  // Future<bool> restoreVideo(String path) async {
  //   final success = await _platform.invokeMethod('restoreVideo', {'path': path});
  //   return success == true;
  // }


  Future<bool> deleteVideoInApp(String path) async {
    final bool? success = await _platform.invokeMethod('deleteVideoInApp', {'path': path});
    return success ?? false;
  }

  Future<bool> copyVideoToGallery(String path) async {
    final bool? success = await _platform.invokeMethod('copyVideoToGallery', {'path': path});
    return success ?? false;
  }


  Future<bool> moveVideoToFolder(String videoPath, String folderId) async {
    final result = await _platform.invokeMethod('moveVideoToFolder', {
      'videoPath': videoPath,
      'folderId': folderId,
    });
    return result == true;
  }

}
