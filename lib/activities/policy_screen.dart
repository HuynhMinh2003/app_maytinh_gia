import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';

class PolicyScreen extends StatefulWidget {
  final bool openedFromCalculator;

  const PolicyScreen({Key? key, this.openedFromCalculator = false}) : super(key: key);
  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> with WidgetsBindingObserver{
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF022350),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.title_policy,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF022350),
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            AppLocalizations.of(context)!.content_policy,
            style: TextStyle(fontSize: 15.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
