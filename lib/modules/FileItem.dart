class FileItem {
  final String path;
  final bool isImage;
  final bool isVideo;
  final String? thumbPath;

  FileItem({
    required this.path,
    required this.isImage,
    required this.isVideo,
    required this.thumbPath,
  });
}