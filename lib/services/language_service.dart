import 'package:app_giau/activities/chon_file.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../provider/local_provider.dart';
import '../onboarding_screen.dart';

class LanguageService {
  static const platform = MethodChannel('com.example.vault/channel');

  /// Lưu ngôn ngữ vào Java Core
  Future<void> saveLanguageToJava(String langCode) async {
    try {
      await platform.invokeMethod('saveLanguage', {"langCode": langCode});
    } catch (e) {
      debugPrint("Lỗi lưu ngôn ngữ: $e");
    }
  }

  /// Chỉ đổi locale và lưu, không điều hướng
  Future<void> setLocaleOnly(
      BuildContext context,
      String langCode,
      ) async {
    final parts = langCode.split('_');
    Locale locale = parts.length == 2
        ? Locale(parts[0], parts[1].toUpperCase())
        : Locale(parts[0]);

    await Provider.of<LocaleProvider>(context, listen: false)
        .setLocale(locale);

    await saveLanguageToJava(langCode);
  }

  /// Đổi locale, lưu và điều hướng sang OnBoardingScreen
  Future<void> applyLanguage(
      BuildContext context,
      String langCode,
      ) async {
    await setLocaleOnly(context, langCode);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
    );
  }

  Future<void> applyLanguage1(
      BuildContext context,
      String langCode,
      ) async {
    await setLocaleOnly(context, langCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.content_language,style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,),
    );
  }
}
