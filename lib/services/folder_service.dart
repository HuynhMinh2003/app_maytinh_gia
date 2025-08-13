import 'dart:convert';
import 'package:flutter/services.dart';

import '../modules/Folder.dart';

class NativeFolderService {
  static const MethodChannel _channel = MethodChannel('com.example.vault/channel');

  VoidCallback? _onDeletePermissionFinished;

  // Hàm để đặt listener callback khi delete permission xử lý xong
  void setDeletePermissionListener(VoidCallback callback) {
    _onDeletePermissionFinished = callback;
  }

  NativeFolderService() {
    // Lắng nghe method call từ native
    _channel.setMethodCallHandler((call) async {
      if (call.method == "deletePermissionResult") {
        // Khi nhận được callback, gọi callback đã đăng ký (nếu có)
        if (_onDeletePermissionFinished != null) {
          _onDeletePermissionFinished!();
        }
      }
    });
  }

  static Future<bool> createFolder(String folderName) async {
    final result = await _channel.invokeMethod('createFolder', {"folderName": folderName});
    return result == true;
  }

  static Future<List<Folder>> getFolders() async {
    final List<dynamic> list = await _channel.invokeMethod('getFolders');

    for (var e in list) {
      print("DEBUG folder raw: $e");
    }

    return list.map((e) => Folder.fromMap(jsonDecode(e))).toList();
  }


  static Future<List<String>> getFilesInFolder(String folderId) async {
    final List<dynamic> list = await _channel.invokeMethod('getFilesInFolder', {"folderId": folderId});
    return list.cast<String>();
  }

  static Future<bool> pickAndHideFile(String folderId) async {
    final result = await _channel.invokeMethod('pickAndHideFile', {"folderId": folderId});
    return result == true;
  }

  static Future<bool> deleteFile(String filePath) async {
    final result = await _channel.invokeMethod('deleteFile', {"filePath": filePath});
    return result == true;
  }

  static Future<bool> restoreFile(String filePath) async {
    final result = await _channel.invokeMethod('restoreFile', {"filePath": filePath});
    return result == true;
  }

  static Future<bool> deleteFolder(String folderId) async {
    final result = await _channel.invokeMethod('deleteFolder', {"folderId": folderId});
    return result == true;
  }

  static Future<bool> renameFolder(String folderId, String newName) async {
    final result = await _channel.invokeMethod('renameFolder', {"folderId": folderId, "newName": newName});
    return result == true;
  }

  // Khôi phục toàn bộ file ra thư viện
  static Future<bool> restoreFolder(String folderId) async {
    final result = await _channel.invokeMethod('restoreFolder', {"folderId": folderId});
    return result == true;
  }

}
