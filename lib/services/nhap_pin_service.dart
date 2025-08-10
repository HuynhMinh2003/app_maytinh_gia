import 'package:flutter/material.dart';
import 'package:app_giau/l10n/app_localizations.dart';
import 'package:flutter/services.dart';

class NhapPinService {
  static const _platform = MethodChannel('com.example.vault/channel');

  Future<bool> savePin(String pin) async {
    final result = await _platform.invokeMethod('savePin', {'pin': pin});
    return result == true;
  }

  Future<bool> confirmPin(BuildContext context, String pin1, String pin2) async {
    if (pin1.isEmpty || pin2.isEmpty) {
      _showToast(context, AppLocalizations.of(context)!.msg_pin_empty, false);
      return false;
    }
    if (pin1 != pin2) {
      _showToast(context, AppLocalizations.of(context)!.msg_pin_not_match, false);
      return false;
    }
    try {
      final success = await savePin(pin1);
      _showToast(
        context,
        success
            ? AppLocalizations.of(context)!.msg_pin_success
            : AppLocalizations.of(context)!.msg_pin_error,
        success,
      );
      return success;
    } catch (e) {
      _showToast(context, e.toString(), false);
      return false;
    }
  }

  void _showToast(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }
}
