import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF022350),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title_policy, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp, color: Colors.white)),
        backgroundColor: const Color(0xFF022350),
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(AppLocalizations.of(context)!.content_policy, style: TextStyle(fontSize: 15.sp, color: Colors.white)),
        ),
      ),
    );
  }
}
