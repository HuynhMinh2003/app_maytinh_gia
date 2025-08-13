import 'package:app_giau/activities/chon_lai_ngon_ngu.dart';
import 'package:app_giau/activities/chon_video.dart';
import 'package:app_giau/activities/info_list_page.dart';
import 'package:app_giau/activities/rate_screen.dart';
import 'package:app_giau/activities/tao_folder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';
import 'change_pin.dart';
import 'chon_anh.dart';
import 'hien_thi_yeu_thich.dart';

class ChonFile extends StatefulWidget {
  final bool openedFromCalculator;

  const ChonFile({Key? key, this.openedFromCalculator = false})
    : super(key: key);

  @override
  State<ChonFile> createState() => _ChonFileState();
}

class _ChonFileState extends State<ChonFile> with WidgetsBindingObserver {
  bool _ignoreNextResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Đăng ký listener lifecycle
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Hủy listener lifecycle
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        iconTheme: const IconThemeData(color: Colors.white),
        // Đặt màu trắng cho icon
        backgroundColor: const Color(0xFF022350),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: Colors.white,
            onSelected: (value) async {
              switch (value) {
                case 'setting1':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ChangePinScreen(openedFromCalculator: true),
                      settings: RouteSettings(name: 'ChangePinScreen'),
                    ),
                  );
                  break;
                case 'setting2':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LanguageSelectionAgainPage(
                        openedFromCalculator: true,
                      ),
                      settings: RouteSettings(
                        name: 'LanguageSelectionAgainPage',
                      ),
                    ),
                  );
                  break;
                case 'setting3':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => InfoListPage(openedFromCalculator: true),
                      settings: RouteSettings(name: 'InfoListPage'),
                    ),
                  );
                  break;
                case 'setting4':
                  showDialog(
                    context: context,
                    builder: (context) =>
                        const AlertDialog(content: RateScreen()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'setting1',
                child: Text(AppLocalizations.of(context)!.setting1),
              ),
              PopupMenuItem<String>(
                value: 'setting2',
                child: Text(AppLocalizations.of(context)!.setting2),
              ),
              PopupMenuItem<String>(
                value: 'setting3',
                child: Text(AppLocalizations.of(context)!.setting3),
              ),
              PopupMenuItem<String>(
                value: 'setting4',
                child: Text(AppLocalizations.of(context)!.setting4),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color(0xFF022350),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 250.h),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                AppLocalizations.of(context)!.type,
                style: TextStyle(
                  fontFamily: "Oswald",
                  fontWeight: FontWeight.bold,
                  fontSize: 35.sp,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 60.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImageCard(
                  context: context,
                  imagePath: 'assets/picture/picture.png',
                  label: AppLocalizations.of(context)!.type_1,
                  onTap: () {
                    setState(() {
                      _ignoreNextResume = true;
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ChonAnhScreen(openedFromCalculator: true),
                        settings: RouteSettings(name: 'ChonAnhScreen'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                buildImageCard(
                  context: context,
                  imagePath: 'assets/picture/video.png',
                  label: AppLocalizations.of(context)!.type_2,
                  onTap: () {
                    setState(() {
                      _ignoreNextResume = true;
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChonVideo(openedFromCalculator: true),
                        settings: RouteSettings(name: 'ChonVideo'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                buildImageCard(
                  context: context,
                  imagePath: 'assets/picture/love.png',
                  label: AppLocalizations.of(context)!.type_3,
                  onTap: () {
                    setState(() {
                      _ignoreNextResume = true;
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            FavoriteVideosScreen(openedFromCalculator: true),
                        settings: RouteSettings(name: 'FavoriteVideosScreen'),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(left: 26.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildImageCard(
                    context: context,
                    imagePath: 'assets/picture/folder.png',
                    label: AppLocalizations.of(context)!.type_4,
                    onTap: () {
                      setState(() {
                        _ignoreNextResume = true;
                      });
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              FolderListScreen(openedFromCalculator: true),
                          settings: RouteSettings(name: 'FolderListScreen'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageCard({
    required BuildContext context,
    required String imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blue.withOpacity(0.2),
        highlightColor: Colors.blue.withOpacity(0.1),
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Image.asset(imagePath, fit: BoxFit.contain)),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
