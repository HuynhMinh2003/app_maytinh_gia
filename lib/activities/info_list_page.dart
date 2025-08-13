import 'package:app_giau/activities/policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';
import '../services/app_version_service.dart';

class InfoListPage extends StatefulWidget {
  final bool openedFromCalculator;

  const InfoListPage({Key? key, this.openedFromCalculator = false}) : super(key: key);
  @override
  State<InfoListPage> createState() => _InfoListPageState();
}

class _InfoListPageState extends State<InfoListPage> with WidgetsBindingObserver{
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
    if (state == AppLifecycleState.resumed && mounted) {
      Navigator.of(context).popUntil((route) => route.settings.name == 'CalculatorScreen');
    }
  }


  void _showInformationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.title_app1,
            style: TextStyle(
              fontFamily: "Oswald",
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
              color: Colors.black,
            ),
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.info_app,
          style: TextStyle(fontSize: 15.sp, color: Colors.black),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.okay,
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showVersionDialog(BuildContext context) async {
    final versionName = await AppInfoService.getVersionName();
    final versionCode = await AppInfoService.getVersionCode();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.app_version,
            style: TextStyle(
              fontFamily: "Oswald",
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
              color: Colors.black,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.version,
                  style: TextStyle(fontSize: 15.sp, color: Colors.black),
                ),
                Text(
                  '$versionName',
                  style: TextStyle(fontSize: 15.sp, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.build_version,
                  style: TextStyle(fontSize: 15.sp, color: Colors.black),
                ),
                Text(
                  '$versionCode',
                  style: TextStyle(fontSize: 15.sp, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.okay,
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.policy,
        'title': AppLocalizations.of(context)!.title_policy,
        'onTap': () => Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => PolicyScreen(openedFromCalculator: true),
    settings: RouteSettings(name: 'PolicyScreen'),
    ))
      },
      {
        'icon': Icons.info_outline,
        'title': AppLocalizations.of(context)!.title_app1,
        'onTap': () => _showInformationDialog(context),
      },
      {
        'icon': Icons.system_update_alt,
        'title': AppLocalizations.of(context)!.app_version,
        'onTap': () => _showVersionDialog(context),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF022350),
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: const Color(0xFF022350),
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.white.withOpacity(0.3),
            thickness: 1,
            indent: 10, // thụt vào để tránh icon
            endIndent: 10,
          ),
          itemBuilder: (context, index) {
            return Card(
              color: const Color(0xFF03376A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(items[index]['icon'] as IconData, color: Colors.white),
                title: Text(
                  items[index]['title'] as String,
                  style: TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 22.sp,
                    color: Colors.white,
                  ),
                ),
                onTap: items[index]['onTap'] as void Function(),
              ),
            );
          },
        ),
      ),
    );
  }
}
