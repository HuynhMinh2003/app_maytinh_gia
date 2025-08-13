import 'dart:io';

import 'package:app_giau/activities/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../l10n/app_localizations.dart';
import '../modules/FileItem.dart';
import '../modules/Folder.dart';
import '../services/folder_service.dart';
import 'image_view.dart';

class FolderDetailScreen extends StatefulWidget {
  final bool openedFromCalculator;

  final Folder folder;

  const FolderDetailScreen({Key? key, required this.folder, this.openedFromCalculator =false}) : super(key: key);

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> with WidgetsBindingObserver{
  final NativeFolderService nativeFolderService = NativeFolderService();

  List<FileItem> _fileItems = [];
  bool _loading = false; // <-- thêm biến loading

  bool _isPickingFile = false;
  bool _isAwaitingDeletePermission = false;
  int _ignoreNextResume = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    nativeFolderService.setDeletePermissionListener(() {
      if (mounted) {
        setState(() {
          _isAwaitingDeletePermission = false;
        });
      }
    });
    _loadFiles();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_ignoreNextResume > 0) {
        _ignoreNextResume--;
        return;
      }
      if (widget.openedFromCalculator && !_isPickingFile && !_isAwaitingDeletePermission) {
        Navigator.of(context).popUntil((route) => route.settings.name == 'CalculatorScreen');
      }
    }
  }

  Future<void> _loadFiles() async {
    setState(() => _loading = true);
    final files = await NativeFolderService.getFilesInFolder(widget.folder.id);
    final List<FileItem> fileItems = [];

    for (final path in files) {
      final isImg = _isImageFile(path);
      final isVid = _isVideoFile(path);
      String? thumb;
      if (isImg) {
        thumb = await _getImageThumb(path);
      } else if (isVid) {
        thumb = await _getVideoThumb(path);
      }
      fileItems.add(FileItem(
        path: path,
        isImage: isImg,
        isVideo: isVid,
        thumbPath: thumb,
      ));
    }

    if (!mounted) return;
    setState(() {
      _fileItems = fileItems;
      _loading = false;
    });
  }

  Future<void> _pickAndHide() async {
    setState(() {
      _isPickingFile = true;
      _ignoreNextResume++;
      _loading = true;
    });
    bool success = await NativeFolderService.pickAndHideFile(widget.folder.id);
    setState(() {
      _isPickingFile = false;
    });

    if (success) {
      setState(() {
        _isAwaitingDeletePermission = true;
        _ignoreNextResume++;
      });
      await Future.delayed(const Duration(milliseconds: 400));
      await _loadFiles();
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  bool _isImageFile(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.png') ||
        ext.endsWith('.jpg') ||
        ext.endsWith('.jpeg') ||
        ext.endsWith('.gif') ||
        ext.endsWith('.bmp') ||
        ext.endsWith('.webp');
  }

  bool _isVideoFile(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.mp4') ||
        ext.endsWith('.mov') ||
        ext.endsWith('.avi') ||
        ext.endsWith('.wmv') ||
        ext.endsWith('.flv') ||
        ext.endsWith('.mkv');
  }

  Future<String?> _getImageThumb(String imagePath) async {
    final file = File(imagePath);
    final dir = await getTemporaryDirectory();
    final thumbPath = '${dir.path}/thumb_${file.uri.pathSegments.last}';

    if (await File(thumbPath).exists()) return thumbPath;

    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 150,
      minHeight: 150,
      quality: 80,
    );
    if (result == null) return null;
    await File(thumbPath).writeAsBytes(result);
    return thumbPath;
  }

  Future<String?> _getVideoThumb(String videoPath) async {
    final dir = await getTemporaryDirectory();
    final thumbPath = '${dir.path}/thumb_${File(videoPath).uri.pathSegments.last}.jpg';
    if (await File(thumbPath).exists()) return thumbPath;
    final thumb = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 150,
      quality: 60,
      thumbnailPath: thumbPath,
    );
    return thumb;
  }

  void _showDeleteFileInAppDialog(BuildContext rootContext, String filePath) {
    showDialog(
      context: rootContext,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.delete_file_title, // Ví dụ "Xóa file"
            style: TextStyle(fontFamily: "Oswald", fontWeight: FontWeight.bold, fontSize: 25.sp),
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.delete_file_confirm, // "Bạn có chắc muốn xóa file này khỏi app?"
          style: TextStyle(fontSize: 15.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(context).pop();
              bool success = await NativeFolderService.deleteFile(filePath);
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? AppLocalizations.of(context)!.delete_file_success
                      : AppLocalizations.of(context)!.delete_file_failed),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
              if (success && mounted) {
                await _loadFiles();
              }
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(color: Colors.white, fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showRestoreFileDialog(BuildContext rootContext, String filePath) {
    showDialog(
      context: rootContext,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.restore_file_title, // "Tải file về thư viện"
            style: TextStyle(fontFamily: "Oswald", fontWeight: FontWeight.bold, fontSize: 25.sp),
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.restore_file_confirm, // "Bạn có chắc muốn tải file này?"
          style: TextStyle(fontSize: 15.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel3,
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Navigator.of(context).pop();
              bool success = await NativeFolderService.restoreFile(filePath);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? AppLocalizations.of(context)!.restore_file_success1
                      : AppLocalizations.of(context)!.restore_file_failed1),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.restore,
              style: TextStyle(fontSize: 15.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showFileOptionsDialog(BuildContext context, String filePath) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(AppLocalizations.of(context)!.delete_file_title),
              onTap: () {
                Navigator.pop(context);
                _showDeleteFileInAppDialog(context, filePath);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.green),
              title: Text(AppLocalizations.of(context)!.restore_file_title),
              onTap: () {
                Navigator.pop(context);
                _showRestoreFileDialog(context, filePath);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              widget.folder.name,
              style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF022350),
            iconTheme: const IconThemeData(color: Colors.white),
            foregroundColor: Colors.white,
          ),
          body: Container(
            color: const Color(0xFF022350),
            child: _fileItems.isEmpty
                ? Column(children: [
                  Divider(),
              Expanded(child: Center(
                child: Text(
                  AppLocalizations.of(context)!.folder_empty,
                  style: TextStyle(fontSize: 15.sp, color: Colors.white),
                ),
              ))
            ],)
                : Column(children: [
                  Divider(),
                  Expanded(child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _fileItems.length,
                    itemBuilder: (context, index) {
                      final item = _fileItems[index];

                      if (item.isImage && item.thumbPath != null) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ImageViewer(
                                  imagePaths: _fileItems
                                      .where((e) => e.isImage)
                                      .map((e) => e.path)
                                      .toList(),
                                  initialIndex: _fileItems
                                      .where((e) => e.isImage)
                                      .toList()
                                      .indexOf(item),
                                ),
                              ),
                            );
                          },
                          onLongPress: () async {
                            _showFileOptionsDialog(context, item.path);
                          },
                          child: Image.file(
                            File(item.thumbPath!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.cannot_display_image,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (item.isVideo && item.thumbPath != null) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoPlayerFullScreen(
                                  videoPath: item.path,
                                ),
                              ),
                            );
                          },
                          onLongPress: () async {
                            _showFileOptionsDialog(context, item.path);
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(item.thumbPath!),
                                fit: BoxFit.cover,
                              ),
                              const Center(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white70,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Not supported or missing thumbnail
                        return Container(
                          color: Colors.grey,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.not_supported,
                              style: TextStyle(fontSize: 15.sp, color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                  ))
            ],),
          ),
          floatingActionButton: SizedBox(
            width: 80.w,
            height: 80.h,
            child: FloatingActionButton(
              backgroundColor: Colors.blue.withOpacity(0.4),
              elevation: 0,
              onPressed: _pickAndHide,
              child: const Icon(Icons.add, size: 36, color: Colors.white),
            ),
          ),
        ),
        if (_loading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
