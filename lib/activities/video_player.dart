import 'dart:io';
import 'package:app_giau/services/video_view_service.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerFullScreen extends StatefulWidget {
  final String videoPath;
  const VideoPlayerFullScreen({Key? key, required this.videoPath}) : super(key: key);

  @override
  State<VideoPlayerFullScreen> createState() => _VideoPlayerFullScreenState();
}

class _VideoPlayerFullScreenState extends State<VideoPlayerFullScreen> with WidgetsBindingObserver{
  late VideoPlayerController _controller;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Đăng ký listener lifecycle
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    final result = await VideoViewService.checkFavorite(widget.videoPath);
    setState(() {
      isFavorite = result;
    });
  }

  void _toggleFavorite() async {
    final newStatus = await VideoViewService.toggleFavorite(widget.videoPath);
    setState(() {
      isFavorite = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            isFavorite ? 'Đã thêm vào mục yêu thích' : 'Đã xoá khỏi mục yêu thích'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Loại observer khi dispose
    _controller.dispose();
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
      backgroundColor: const Color(0xFF022350),
      appBar: AppBar(
        backgroundColor: const Color(0xFF022350),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          )
        ],
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: _controller.value.isInitialized
          ? FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.2),
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
          color: Colors.blue,
        ),
      )
          : null,
    );
  }
}
