import 'dart:io';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../custom/favorite_item.dart';

class FavoriteService {
  static const MethodChannel _platform = MethodChannel('com.example.vault/channel');

  Future<List<FavoriteItem>> loadFavorites() async {
    final List<FavoriteItem> items = [];

    try {
      final List<dynamic> videoResult = await _platform.invokeMethod('getFavoriteVideos');
      final List<dynamic> imageResult = await _platform.invokeMethod('getFavoriteImages');

      // Videos
      for (String path in videoResult.cast<String>()) {
        final controller = VideoPlayerController.file(File(path));
        await controller.initialize();
        items.add(FavoriteItem(
          path: path,
          type: FavoriteType.video,
          controller: controller,
        ));
      }

      // Images
      for (String path in imageResult.cast<String>()) {
        items.add(FavoriteItem(
          path: path,
          type: FavoriteType.image,
        ));
      }
    } on PlatformException catch (e) {

    }

    return items;
  }
}
