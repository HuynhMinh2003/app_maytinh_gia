import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../l10n/app_localizations.dart';
import '../services/app_version_service.dart';

class AppVersionPage extends StatefulWidget {
  const AppVersionPage({super.key});

  @override
  State<AppVersionPage> createState() => _AppVersionPageState();
}

class _AppVersionPageState extends State<AppVersionPage> with WidgetsBindingObserver{
  String _versionName = "";
  int _versionCode = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Đăng ký listener lifecycle
    _loadVersionInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Loại observer khi dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      Navigator.of(context).popUntil((route) => route.settings.name == 'CalculatorScreen');
    }
  }

  Future<void> _loadVersionInfo() async {
    final name = await AppInfoService.getVersionName();
    final code = await AppInfoService.getVersionCode();
    setState(() {
      _versionName = name;
      _versionCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF022350),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.app_version,
          style: TextStyle(color: Colors.white, fontSize: 25.sp, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF022350),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRow(AppLocalizations.of(context)!.version, _versionName),
            SizedBox(height: 8.h),
            _buildRow(AppLocalizations.of(context)!.build_version, _versionCode.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 20.sp, color: Colors.white)),
        SizedBox(width: 10.w),
        Text(value, style: TextStyle(fontSize: 20.sp, color: Colors.white)),
      ],
    );
  }
}
