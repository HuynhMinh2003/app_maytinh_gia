import 'package:flutter/services.dart';

class AppInfoService {
  static const _platform = MethodChannel('com.example.vault/channel');

  static Future<String> getVersionName() async {
    try {
      final name = await _platform.invokeMethod('getAppVersion');
      return name ?? "Unknown";
    } catch (e) {
      return "Unknown";
    }
  }

  static Future<int> getVersionCode() async {
    try {
      final code = await _platform.invokeMethod('getAppVersionCode');
      return code ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
