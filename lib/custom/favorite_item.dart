import 'package:video_player/video_player.dart';

enum FavoriteType { image, video }

class FavoriteItem {
  final String path;
  final FavoriteType type;
  final VideoPlayerController? controller;

  FavoriteItem({required this.path, required this.type, this.controller});
}
