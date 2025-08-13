import 'dart:io';
import 'package:flutter/material.dart';

import '../services/image_view_service.dart';

class ImageViewer extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const ImageViewer({
    Key? key,
    required this.imagePaths,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> with WidgetsBindingObserver{
  final _favoriteService = ImageViewService();
  late PageController _controller;
  late int _currentIndex;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Thêm observer lifecycle
    _controller = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
    _loadFavoriteStatus();

    _controller.addListener(() {
      final newIndex = _controller.page?.round() ?? _currentIndex;
      if (newIndex != _currentIndex) {
        setState(() => _currentIndex = newIndex);
        _loadFavoriteStatus();
      }
    });
  }

  Future<void> _loadFavoriteStatus() async {
    isFavorite = await _favoriteService.checkFavorite(widget.imagePaths[_currentIndex]);
    setState(() {});
  }

  Future<void> _toggleFavorite() async {
    isFavorite = await _favoriteService.toggleFavorite(widget.imagePaths[_currentIndex]);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? 'Đã thêm vào mục yêu thích' : 'Đã xoá khỏi mục yêu thích'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
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
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) {
          return Center(
            child: Image.file(
              File(widget.imagePaths[index]),
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
