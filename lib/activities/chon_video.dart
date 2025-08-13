import 'dart:io';
import 'package:app_giau/activities/video_player.dart';
import 'package:app_giau/services/video_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import '../modules/Folder.dart';
import '../services/folder_service.dart';

class ChonVideo extends StatefulWidget {
  final bool openedFromCalculator;

  const ChonVideo({Key? key, this.openedFromCalculator = false}) : super(key: key);

  @override
  State<ChonVideo> createState() => _ChonVideoState();
}

class _ChonVideoState extends State<ChonVideo> with WidgetsBindingObserver{
  final HiddenVideoService _videoService = HiddenVideoService();

  List<String> _allVideoPaths = [];
  List<String> _displayedPaths = [];
  final Map<String, String?> _thumbnails = {};
  final Map<String, bool> _thumbError = {};

  List<Folder> _folders = [];

  // Paging
  final int _pageSize = 60;
  int _currentPage = 0;
  bool _hasMore = true;
  bool _loadingPage = false;
  final ScrollController _scrollController = ScrollController();

  bool _isPickingVideo = false;
  bool _isAwaitingDeletePermission = false;
  int _ignoreNextResume = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initLoad();
    _loadFolders();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Loại observer khi dispose
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initLoad() async {
    _allVideoPaths = await _videoService.getHiddenVideos();
    _displayedPaths.clear();
    _currentPage = 0;
    _hasMore = true;
    await _loadMoreVideos();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Bỏ qua lần resume đầu tiên khi vừa mở màn này
      if (_ignoreNextResume > 0) {
        _ignoreNextResume--;
        return;
      }
      if (widget.openedFromCalculator && !_isPickingVideo && !_isAwaitingDeletePermission) {
        Navigator.of(context).popUntil((route) => route.settings.name == 'CalculatorScreen');
      }
    }
  }

  Future<void> _loadMoreVideos() async {
    if (!_hasMore || _loadingPage) return;
    _loadingPage = true;

    final start = _currentPage * _pageSize;
    final end = (_currentPage + 1) * _pageSize;
    final newPage = _allVideoPaths.sublist(
      start,
      end > _allVideoPaths.length ? _allVideoPaths.length : end,
    );

    await Future.wait(newPage.map((path) async {
      if (_thumbnails.containsKey(path) || _thumbError.containsKey(path)) return;
      try {
        final thumb = await _createVideoThumbnail(path);
        if (thumb != null) {
          _thumbnails[path] = thumb;
        } else {
          _thumbError[path] = true;
        }
      } catch (_) {
        _thumbError[path] = true;
      }
    }));

    setState(() {
      _displayedPaths.addAll(newPage);
      _currentPage++;
      _hasMore = end < _allVideoPaths.length;
      _loadingPage = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 400 &&
        _hasMore &&
        !_loadingPage) {
      _loadMoreVideos();
    }
  }

  Future<String?> _createVideoThumbnail(String videoPath) async {
    final dir = await getTemporaryDirectory();
    final thumbPath = '${dir.path}/thumb_${File(videoPath).uri.pathSegments.last}.jpg';
    if (await File(thumbPath).exists()) return thumbPath;
    final thumb = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 150,
      quality: 60,
      thumbnailPath: thumbPath,
    );
    return thumb;
  }

  Future<void> _loadFolders() async {
    // Giả sử bạn có service lấy folder native, bạn gọi như sau:
    _folders = await NativeFolderService.getFolders(); // hoặc tương tự
    setState(() {});
  }

  Future<void> _pickVideoAndHide() async {
    setState(() {
      _isPickingVideo = true;
      _ignoreNextResume++;
    });

    final success = await _videoService.pickVideoAndHide();

    setState(() {
      _isPickingVideo = false;
    });

    if (success) {
      setState(() {
        _isAwaitingDeletePermission = true;
        _ignoreNextResume++;
      });
      await _initLoad();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.error_2)),
      );
    }
  }

  void _showDeleteVideoInAppDialog(BuildContext rootContext, String path) {
    showDialog(
      context: rootContext,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.delete_2, // Ví dụ "Xóa video"
            style: TextStyle(fontFamily: "Oswald", fontWeight: FontWeight.bold, fontSize: 25.sp),
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.delete_22, // Ví dụ "Bạn có chắc chắn muốn xóa video này khỏi app?"
          style: TextStyle(fontSize: 15.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.delete_23, // "Hủy"
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(context).pop();
              bool success = await _videoService.deleteVideoInApp(path);
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? AppLocalizations.of(context)!.delete_24
                      : AppLocalizations.of(context)!.error_2),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
              if (success && mounted) {
                await _initLoad(); // load lại toàn bộ list từ đầu
              }
            },
            child: Text(
              AppLocalizations.of(context)!.delete_25, // "Xóa"
              style: TextStyle(color: Colors.white, fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showCopyVideoToGalleryDialog(BuildContext rootContext, String path) {
    showDialog(
      context: rootContext,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
              AppLocalizations.of(context)!.copyVideoToGalleryTitle,
            style: TextStyle(fontFamily: "Oswald", fontWeight: FontWeight.bold, fontSize: 25.sp,color: Colors.black),
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.copyVideoToGalleryConfirm,
          style: TextStyle(fontSize: 15.sp,color: Colors.black,
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.video_cancel,
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Navigator.of(context).pop();
              bool success = await _videoService.copyVideoToGallery(path);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? AppLocalizations.of(context)!.copyVideoToGallerySuccess
                      : AppLocalizations.of(context)!.copyVideoToGalleryFail),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.copy,
              style: TextStyle(fontSize: 15.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoveToFolderDialog(String videoPath) async {
    if (_folders.isEmpty) {
      await _initLoad(); // load lại toàn bộ list từ đầu
    }

    String? selectedFolderId;

    // Nếu chỉ có 1 folder thì auto chọn
    if (_folders.length == 1) {
      selectedFolderId = _folders.first.id;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Center(
                child: Text(
                  AppLocalizations.of(context)!.chooseFolderToMove,
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Oswald",
                  ),
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 150.h,
                child: _folders.isEmpty
                    ? Center(
                  child: Text(
                    AppLocalizations.of(context)!.noFoldersAvailable,
                    style: TextStyle(fontSize: 15.sp),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _folders.length,
                  itemBuilder: (context, index) {
                    final folder = _folders[index];
                    return RadioListTile<String>(
                      title: Text(folder.name),
                      value: folder.id,
                      groupValue: selectedFolderId,
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedFolderId = value;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.cancel1,
                    style: TextStyle(fontSize: 15.sp, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: selectedFolderId == null
                      ? null
                      : () async {
                    Navigator.pop(context);
                    bool success = await _videoService.moveVideoToFolder(
                      videoPath,
                      selectedFolderId!,
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.moveSuccessful,
                            style: TextStyle(fontSize: 15.sp),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      await _initLoad();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.moveFailed,
                            style: TextStyle(fontSize: 15.sp),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.move,
                    style: TextStyle(fontSize: 15.sp, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Dialog tùy chọn cho Video
  void _showVideoOptionsDialog(BuildContext context, String videoPath) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(AppLocalizations.of(context)!.delete_2), // "Xóa video"
              onTap: () {
                Navigator.pop(context);
                _showDeleteVideoInAppDialog(context, videoPath);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.green),
              title: Text(AppLocalizations.of(context)!.copyVideoToGalleryTitle,),
              onTap: () {
                Navigator.pop(context);
                _showCopyVideoToGalleryDialog(context, videoPath);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_copy, color: Colors.blue),
              title: Text(
                AppLocalizations.of(context)!.moveToFolder,
                style: TextStyle(fontSize: 15.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                _showMoveToFolderDialog(videoPath);
              },
            ),
          ],
        ),
      ),
    );
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
        child: _displayedPaths.isEmpty ?
        Column(children: [
          const Divider(),
          Expanded(child: Center(
            child: Text(
              AppLocalizations.of(context)!.no_videos, // bạn thêm string localization "no_images"
              style: TextStyle(fontSize: 15.sp, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ))
        ],):
        Column(
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
                itemCount: _displayedPaths.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _displayedPaths.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final videoPath = _displayedPaths[index];
                  final thumbPath = _thumbnails[videoPath];
                  final thumbErr = _thumbError[videoPath] ?? false;

                  return GestureDetector(
                    onTap: () => _showVideoPlayer(videoPath),
                    onLongPress: () => _showVideoOptionsDialog(context, videoPath),
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
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80.w,
        height: 80.h,
        child: FloatingActionButton(
          backgroundColor: Colors.blue.withOpacity(0.4),
          elevation: 0,
          onPressed: _pickVideoAndHide,
          child: const Icon(Icons.add, size: 36, color: Colors.white), // icon lớn hơn
        ),
      ),


    );

  }
}
