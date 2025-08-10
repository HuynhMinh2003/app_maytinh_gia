import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../l10n/app_localizations.dart';
import '../services/image_service.dart';
import 'image_view.dart';

class ChonAnhScreen extends StatefulWidget {
  const ChonAnhScreen({Key? key}) : super(key: key);

  @override
  State<ChonAnhScreen> createState() => _ChonAnhScreenState();
}

class _ChonAnhScreenState extends State<ChonAnhScreen> {
  final ImageService _imageService = ImageService();
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadHiddenImages();
  }

  Future<void> _loadHiddenImages() async {
    _imagePaths = await _imageService.getHiddenImages();
    setState(() {});
  }

  Future<void> _pickImageAndHide() async {
    bool success = await _imageService.pickImageAndHide();
    if (success) {
      _loadHiddenImages();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.error_1)),
      );
    }
  }

  void _restoreImage(String path) async {
    bool success = await _imageService.restoreImage(path);
    if (success) {
      _loadHiddenImages();
    }
  }

  void _showDeleteDialog(BuildContext rootContext, String path) {
    showDialog(
      context: rootContext,
      builder: (context) => AlertDialog(
        title: Center(child: Text(AppLocalizations.of(context)!.delete_1, style: TextStyle(fontFamily:"Oswald",fontWeight:FontWeight.bold,fontSize: 25.sp)),),
        content: Text(AppLocalizations.of(context)!.delete_12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.delete_13,style: TextStyle(fontSize: 15.sp,color: Colors.black),),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              _restoreImage(path);
              ScaffoldMessenger.of(rootContext).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.delete_14)),
              );
            },
            child: Text(AppLocalizations.of(context)!.delete_15, style: TextStyle(fontSize: 15.sp,color: Colors.green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title_1, style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFF022350),
        iconTheme: const IconThemeData(color: Colors.white), // Đặt màu trắng cho icon
        foregroundColor: Colors.white, // Đặt màu chữ trắng cho title nếu cần
      ),
      body: Container(
        color: Color(0xFF022350),
        child: Column(
          children: [
            Divider(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
                itemCount: _imagePaths.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Mở xem toàn bộ ảnh, bắt đầu từ index vừa bấm
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ImageViewer(
                            imagePaths: _imagePaths,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      _showDeleteDialog(context,_imagePaths[index]);
                    },
                    child: Image.file(File(_imagePaths[index]), fit: BoxFit.cover),
                  );
                },
              ),
            ),
            SizedBox(
              height: 70.h,
              width:  230.w,
              child: ElevatedButton(
                onPressed: _pickImageAndHide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2), // giống FloatingActionButton
                  foregroundColor: Colors.white, // chữ trắng
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r), // bo tròn giống Floating
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h), // padding đẹp
                  elevation: 0, // không đổ bóng
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.blue),
                    SizedBox(width: 8.w),
                    Text(
                      AppLocalizations.of(context)!.title_2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
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
