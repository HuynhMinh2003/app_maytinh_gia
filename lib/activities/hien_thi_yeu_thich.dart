import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../custom/favorite_item.dart';
import '../l10n/app_localizations.dart';
import 'image_view.dart';
import 'video_player.dart';
import '../services/favorite_service.dart';

class FavoriteVideosScreen extends StatefulWidget {
  const FavoriteVideosScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteVideosScreen> createState() => _FavoriteVideosScreenState();
}

class _FavoriteVideosScreenState extends State<FavoriteVideosScreen> {
  final List<FavoriteItem> favoriteItems = [];
  final FavoriteService _favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final items = await _favoriteService.loadFavorites();
    setState(() {
      favoriteItems
        ..clear()
        ..addAll(items);
    });
  }

  @override
  void dispose() {
    for (var item in favoriteItems) {
      item.controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF022350),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.favoriteTitle,
          style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF022350),
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      body: favoriteItems.isEmpty
          ? Center(
        child: Text(
          AppLocalizations.of(context)!.noFavoritesMessage,
          style: TextStyle(fontSize: 15.sp, color: Colors.white),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10,
        ),
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final item = favoriteItems[index];
          return GestureDetector(
            onTap: () {
              if (item.type == FavoriteType.video) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerFullScreen(videoPath: item.path),
                  ),
                );
              } else {
                final imagePaths = favoriteItems
                    .where((e) => e.type == FavoriteType.image)
                    .map((e) => e.path)
                    .toList();
                final initialIndex = imagePaths.indexOf(item.path);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImageViewer(
                      imagePaths: imagePaths,
                      initialIndex: initialIndex,
                    ),
                  ),
                );
              }
            },
            child: item.type == FavoriteType.video
                ? item.controller != null && item.controller!.value.isInitialized
                ? AspectRatio(
              aspectRatio: item.controller!.value.aspectRatio,
              child: VideoPlayer(item.controller!),
            )
                : const Center(child: CircularProgressIndicator())
                : Image.file(
              File(item.path),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
