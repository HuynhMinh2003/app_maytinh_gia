import 'package:app_giau/provider/local_provider.dart';
import 'package:app_giau/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    return ScreenUtilInit(
      designSize: const Size(384, 856.1777777777778),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          locale: provider.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('vi'),
            Locale('fr'),
            Locale('zh'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: provider.locale == null
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : const SplashScreen(), debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
