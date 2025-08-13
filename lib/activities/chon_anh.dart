import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../l10n/app_localizations.dart';
import '../modules/Folder.dart';
import '../services/folder_service.dart';
import '../services/image_service.dart';
import 'image_view.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ChonAnhScreen extends StatefulWidget {
  final bool openedFromCalculator;

  const ChonAnhScreen({Key? key, this.openedFromCalculator = false})
    : super(key: key);

  @override
  State<ChonAnhScreen> createState() => _ChonAnhScreenState();
}

class _ChonAnhScreenState extends State<ChonAnhScreen> with WidgetsBindingObserver {
  final ImageService _imageService = ImageService();
  List<String> _allImagePaths = [];
  List<String> _displayedPaths = [];
  List<Folder> _folders = [];

  // Map lưu cache thumbnail: key = ảnh gốc, value = đường dẫn file thumbnail
  Map<String, String?> _thumbnails = {};
  Map<String, bool> _thumbError = {};

  // PAGING
  final int _pageSize = 60;
  int _currentPage = 0;
  bool _hasMore = true;
  bool _loadingPage = false;
  final ScrollController _scrollController = ScrollController();

  bool _isPickingImage = false;
  bool _isAwaitingDeletePermission = false;
  int _ignoreNextResume = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _imageService.setDeletePermissionListener(() {
      if (mounted) {
        setState(() {
          _isAwaitingDeletePermission = false;
        });
      }
    });
    _initLoad();
    _loadFolders();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_ignoreNextResume > 0) {
        _ignoreNextResume--;
        return;
      }
      if (widget.openedFromCalculator && !_isPickingImage && !_isAwaitingDeletePermission) {
        Navigator.of(context).popUntil((route) => route.settings.name == 'CalculatorScreen');
      }
    }
  }

  Future<void> _initLoad() async {
    _allImagePaths = await _imageService.getHiddenImages();
    _displayedPaths.clear();
    _currentPage = 0;
    _hasMore = true;
    await _loadMoreImages();
    setState(() {});
  }

  Future<void> _loadFolders() async {
    _folders = await NativeFolderService.getFolders(); // hoặc tương tự
    setState(() {});
  }

  Future<void> _pickImageAndHide() async {
    setState(() {
      _isPickingImage = true;
      _ignoreNextResume++;
    });

    bool success = await _imageService.pickImageAndHide();

    setState(() {
      _isPickingImage = false;
    });

    if (success) {
      setState(() {
        _isAwaitingDeletePermission = true;
        _ignoreNextResume++;
      });
      await _initLoad();
    }
  }

  Future<void> _loadMoreImages() async {
    if (!_hasMore || _loadingPage) return;
    _loadingPage = true;

    final start = _currentPage * _pageSize;
    final end = (_currentPage + 1) * _pageSize;
    final newPage = _allImagePaths.sublist(
      start,
      end > _allImagePaths.length ? _allImagePaths.length : end,
    );

    await Future.wait(newPage.map((path) async {
      if (_thumbnails.containsKey(path) || _thumbError.containsKey(path)) return;
      try {
        final thumb = await _createThumbnail(path);
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
      _hasMore = end < _allImagePaths.length;
      _loadingPage = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 400 &&
        _hasMore &&
        !_loadingPage) {
      _loadMoreImages();
    }
  }

  Future<String?> _createThumbnail(String imagePath) async {
    final file = File(imagePath);
    final dir = await getTemporaryDirectory();
    final thumbPath = '${dir.path}/thumb_${file.uri.pathSegments.last}';

    final thumbFile = File(thumbPath);

    if (await thumbFile.exists()) return thumbPath;

    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 150,
      minHeight: 150,
      quality: 80,
    );

    if (result == null) return null;

    await thumbFile.writeAsBytes(result);
    return thumbPath;
  }

  Future<void> _showMoveToFolderDialog(String imagePath) async {
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
                    bool success = await _imageService.moveImageToFolder(
                        imagePath, selectedFolderId!);
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

  void _showDeleteImageInAppDialog(BuildContext rootContext, String path) {
    showDialog(
      context: rootContext,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.delete_1,
            style: TextStyle(
              fontFamily: "Oswald",
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
            ),
          ),
        ),
        content: Text(AppLocalizations.of(context)!.delete_12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.delete_13,
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(context).pop();

              bool success = await _imageService.deleteImageInApp(path);

              // Nếu widget không còn mounted thì dừng, tránh lỗi gọi context
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? AppLocalizations.of(context)!.delete_14
                      : AppLocalizations.of(context)!.error_1),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );

              // Nếu cần reload UI thì gọi hàm _loadHiddenImages(), cũng kiểm tra mounted
              if (success && mounted) {
                await _initLoad(); // load lại toàn bộ list từ đầu
              }
            },
            child: Text(
              AppLocalizations.of(context)!.delete_15,
              style: TextStyle(fontSize: 15.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showCopyImageToGalleryDialog(BuildContext rootContext, String path) {
    showDialog(
      context: rootContext,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.copy_to_gallery_title,
            style: TextStyle(
              fontFamily: "Oswald",
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
            ),
          ),
        ),
        content: Text(AppLocalizations.of(context)!.copy_to_gallery_content,),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.copy_to_gallery_cancel,
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Navigator.of(context).pop();
              bool success = await _imageService.copyImageToGallery(path);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? AppLocalizations.of(context)!.copy_to_gallery_success
                      : AppLocalizations.of(context)!.copy_to_gallery_fail),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.copy_to_gallery_confirm,
              style: TextStyle(fontSize: 15.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, String imagePath) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            // Nút xóa ảnh trong app
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                AppLocalizations.of(context)!.delete_1, // "Xóa ảnh"
                style: TextStyle(fontSize: 15.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteImageInAppDialog(context, imagePath);
              },
            ),

            // Nút tải ảnh về thư viện
            ListTile(
              leading: const Icon(Icons.download, color: Colors.green),
              title: Text(
                AppLocalizations.of(context)!.copy_to_gallery_title,
                style: TextStyle(fontSize: 15.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                _showCopyImageToGalleryDialog(context, imagePath);
              },
            ),

            // Nút di chuyển sang folder khác (giữ nguyên)
            ListTile(
              leading: const Icon(Icons.folder_copy, color: Colors.blue),
              title: Text(
                AppLocalizations.of(context)!.moveToFolder,
                style: TextStyle(fontSize: 15.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                _showMoveToFolderDialog(imagePath);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.title_1,
          style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF022350),
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF022350),
        child: _displayedPaths.isEmpty
            ? Column(
          children: [
            const Divider(),
            Expanded(
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.no_images,
                  style: TextStyle(fontSize: 15.sp, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        )
            : Column(
          children: [
            const Divider(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _displayedPaths.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _displayedPaths.length) {
                    // Loading cuối trang
                    return const Center(child: CircularProgressIndicator());
                  }
                  final imagePath = _displayedPaths[index];
                  final thumbPath = _thumbnails[imagePath];
                  final thumbErr = _thumbError[imagePath] ?? false;

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ImageViewer(
                            imagePaths: _displayedPaths,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      _showOptionsDialog(context, imagePath);
                    },
                    child: thumbErr
                        ? Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.red, size: 40),
                    )
                        : thumbPath != null
                        ? Image.file(
                      File(thumbPath),
                      fit: BoxFit.cover,
                    )
                        : Container(
                      color: Colors.grey[300],
                      child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
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
          onPressed: _pickImageAndHide,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      )
    );
  }
}
