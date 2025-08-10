import 'dart:io';
import 'package:app_giau/activities/video_player.dart';
import 'package:app_giau/services/video_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../l10n/app_localizations.dart';

class ChonVideo extends StatefulWidget {
  const ChonVideo({Key? key}) : super(key: key);

  @override
  State<ChonVideo> createState() => _ChonVideoState();
}

class _ChonVideoState extends State<ChonVideo> {
  final HiddenVideoService _videoService = HiddenVideoService();

  List<String> _videoPaths = [];
  Map<String, String> _thumbnails = {};

  @override
  void initState() {
    super.initState();
    _loadHiddenVideos();
  }

  Future<void> _loadHiddenVideos() async {
    final paths = await _videoService.getHiddenVideos();
    setState(() {
      _videoPaths = paths;
    });
    _generateThumbnails();
  }

  Future<void> _pickVideoAndHide() async {
    final success = await _videoService.pickVideoAndHide();
    if (success) {
      _loadHiddenVideos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.error_2)),
      );
    }
  }

  Future<void> _restoreVideo(String path) async {
    final success = await _videoService.restoreVideo(path);
    if (success) _loadHiddenVideos();
  }

  void _showDeleteDialog(BuildContext rootContext, String path) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.delete_2,
            style: TextStyle(
              fontFamily: "Oswald",
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
            ),
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.delete_22,
          style: TextStyle(fontSize: 15.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.delete_23,
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _restoreVideo(path);
              ScaffoldMessenger.of(rootContext).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.delete_24),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.delete_25,
              style: TextStyle(color: Colors.green, fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateThumbnails() async {
    for (final path in _videoPaths) {
      final thumb = await VideoThumbnail.thumbnailFile(
        video: path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 150,
        quality: 60,
      );
      if (thumb != null) {
        setState(() {
          _thumbnails[path] = thumb;
        });
      }
    }
  }

  void _showVideoPlayer(String path) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => VideoPlayerFullScreen(videoPath: path)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.title_12,
          style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF022350),
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF022350),
        child: Column(
          children: [
            const Divider(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _videoPaths.length,
                itemBuilder: (context, index) {
                  final videoPath = _videoPaths[index];
                  final thumbPath = _thumbnails[videoPath];

                  return GestureDetector(
                    onTap: () => _showVideoPlayer(videoPath),
                    onLongPress: () => _showDeleteDialog(context, videoPath),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        thumbPath != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(thumbPath),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                            : Container(color: Colors.black12),
                        const Icon(
                          Icons.play_circle_outline,
                          size: 38,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 70.h,
              width: 248.w,
              child: ElevatedButton(
                onPressed: _pickVideoAndHide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 14.h,
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, size: 24, color: Colors.blue),
                    SizedBox(width: 8.w),
                    Text(
                      AppLocalizations.of(context)!.title_22,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }
}
