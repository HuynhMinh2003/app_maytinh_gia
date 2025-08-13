import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';
import '../modules/Folder.dart';
import '../services/folder_service.dart';
import 'chitiet_folder.dart';

class FolderListScreen extends StatefulWidget {
  final bool openedFromCalculator;

  const FolderListScreen({Key? key, this.openedFromCalculator = false}) : super(key: key);

  @override
  State<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> with WidgetsBindingObserver{
  List<Folder> _folders = [];
  bool _ignoreNextResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Thêm observer lifecycle
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    final folders = await NativeFolderService.getFolders();

    folders.sort((a, b) {
      final statA = FileStat.statSync(a.path);
      final statB = FileStat.statSync(b.path);
      return statB.changed.compareTo(statA.changed); // mới nhất trước
    });

    setState(() {
      _folders = folders;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Loại observer khi dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Chỉ xử lý nếu màn này là top
    if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
    if (state == AppLifecycleState.resumed) {
      if (_ignoreNextResume) {
        _ignoreNextResume = false;
        return;
      }
      Navigator.of(
        context,
      ).popUntil((route) => route.settings.name == 'CalculatorScreen');
    }
  }

  void _showCreateFolderDialog() {
    final controller = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Center(child: Text(AppLocalizations.of(context)!.add_folder, style: TextStyle(fontFamily:"Oswald",fontWeight:FontWeight.bold,fontSize: 25.sp))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.dien_folder,
                    errorText: errorText,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel_folder, style: TextStyle(fontSize: 15.sp,color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  final name = controller.text.trim();
                  if (name.isEmpty) {
                    setState(() {
                      errorText = AppLocalizations.of(context)!.folder_name_required; // thêm chuỗi thông báo lỗi trong localization
                    });
                    return;
                  }
                  final success = await NativeFolderService.createFolder(name);
                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.d), backgroundColor: Colors.green));
                    _loadFolders();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.s), backgroundColor: Colors.red));
                  }
                },
                child: Text(AppLocalizations.of(context)!.okay_folder, style: TextStyle(fontSize: 15.sp,color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openFolder(Folder folder) {
    setState(() {
      _ignoreNextResume = true;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FolderDetailScreen(folder: folder, openedFromCalculator: true),
        settings: const RouteSettings(name: 'FolderDetailScreen'),
      ),
    );
  }

  void _showFolderOptions(BuildContext context, Folder folder) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(AppLocalizations.of(context)!.delete_folder_title, style: TextStyle(fontSize: 15.sp)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteFolderOnlyDialog(folder);
                },
              ),
              ListTile(
                leading: const Icon(Icons.download, color: Colors.green),
                title: Text(AppLocalizations.of(context)!.restore_folder_title,),
                onTap: () {
                  Navigator.pop(context);
                  _showRestoreFolderDialog(folder);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: Text(AppLocalizations.of(context)!.rename_folder, style: TextStyle(fontSize: 15.sp)),
                onTap: () {
                  Navigator.pop(context);
                  _showRenameFolderDialog(folder);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteFolderOnlyDialog(Folder folder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.delete_folder_title,
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              fontFamily: "Oswald",
            ),
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.delete_folder_confirm,
          style: TextStyle(fontSize: 15.sp),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final success = await NativeFolderService.deleteFolder(folder.id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.delete_success),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadFolders();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.delete_failed),
                    backgroundColor: Colors.red,
                  ),
                );
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

  void _showRestoreFolderDialog(Folder folder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.restore_folder_title,
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              fontFamily: "Oswald",
            ),
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.restore_folder_confirm,
          style: TextStyle(fontSize: 15.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel2,
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Navigator.pop(context);
              final success = await NativeFolderService.restoreFolder(folder.id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.restore_success),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.restore_failed),
                    backgroundColor: Colors.red,
                  ),
                );
              }
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

  void _showRenameFolderDialog(Folder folder) {
    final controller = TextEditingController(text: folder.name);
    String? errorText;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(child: Text(AppLocalizations.of(context)!.rename_folder_title, style: TextStyle(fontFamily:"Oswald", fontWeight: FontWeight.bold, fontSize: 25.sp))),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enter_new_folder_name,
                  errorText: errorText,
                ),
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() {
                      errorText = null;
                    });
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel_folder, style: TextStyle(fontSize: 15.sp, color: Colors.black)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    final newName = controller.text.trim();
                    if (newName.isEmpty) {
                      setState(() {
                        errorText = AppLocalizations.of(context)!.folder_name_required;
                      });
                      return;
                    }
                    final success = await NativeFolderService.renameFolder(folder.id, newName);
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.rename_success), backgroundColor: Colors.green),
                      );
                      _loadFolders();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.rename_failed), backgroundColor: Colors.red),
                      );
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.okay_folder, style: TextStyle(fontSize: 15.sp, color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.title_folder,
          style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF022350),
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF022350),
        child: _folders.isEmpty
            ? Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(),
          Expanded(child: Center(
            child: Text(
              AppLocalizations.of(context)!.no_folder,
              style: TextStyle(fontSize: 15.sp, color: Colors.white),
            ),
          ))
        ],
        )
            : Column(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Divider(),
            Expanded(child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _folders.length,
              itemBuilder: (context, index) {
              final folder = _folders[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[800],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.blueAccent.withOpacity(0.3),
                    highlightColor: Colors.blueAccent.withOpacity(0.1),
                    onTap: () => _openFolder(folder),
                    onLongPress: () => _showFolderOptions(context, folder),  // Thêm xử lý long press
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Row(
                        children: [
                          const Icon(Icons.folder, color: Colors.white, size: 28),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              folder.name,
                              style: TextStyle(fontSize: 20.sp, color: Colors.white),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              );
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
          onPressed: _showCreateFolderDialog,
          child: const Icon(Icons.add, size: 36, color: Colors.white), // icon lớn hơn
        ),
      ),
    );
  }
}

