import 'package:flutter/services.dart';

class PinService {
  static const _platform = MethodChannel('com.example.vault/channel');

  static Future<bool> validatePin(String pin) async {
    try {
      final result = await _platform.invokeMethod('validatePin', {'pin': pin});
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> savePin(String pin) async {
    try {
      await _platform.invokeMethod('savePin', {'pin': pin});
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getPin() async {
    try {
      final String? pin = await _platform.invokeMethod('getPin');
      return pin;
    } on PlatformException {
      return null;
    }
  }
}
