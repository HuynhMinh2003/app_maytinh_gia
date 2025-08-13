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
  final bool openedFromCalculator;

  const FavoriteVideosScreen({Key? key, this.openedFromCalculator = false}) : super(key: key);

  @override
  State<FavoriteVideosScreen> createState() => _FavoriteVideosScreenState();
}

class _FavoriteVideosScreenState extends State<FavoriteVideosScreen> with WidgetsBindingObserver {
  final List<FavoriteItem> favoriteItems = [];
  final FavoriteService _favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Thêm observer lifecycle
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final items = await _favoriteService.loadFavorites();

      final validItems = items.where((item) => File(item.path).existsSync()).toList();

      if (!mounted) return;
      setState(() {
        favoriteItems
          ..clear()
          ..addAll(validItems);
      });

      // final invalidItems = items.where((item) => !File(item.path).existsSync());
      // for (var item in invalidItems) {
      //   await _favoriteService.removeFavorite(item.path);
      // }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        // Xử lý lỗi nếu cần
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Loại observer khi dispose
    for (var item in favoriteItems) {
      item.controller?.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      Navigator.of(context).popUntil((route) => route.settings.name == 'CalculatorScreen');
    }
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
