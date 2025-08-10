import 'package:flutter/services.dart';

class CalculatorService {
  static const platform = MethodChannel("com.example.vault/channel");

  String input = '0';
  String result = '';

  void pressKey(String value) {
    if (input == '0') {
      input = value;
    } else {
      input += value;
    }
    result = '';
  }

  void clear() {
    input = '0';
    result = '';
  }

  void backspace() {
    if (input.length > 1) {
      input = input.substring(0, input.length - 1);
    } else {
      input = '0';
    }
  }

  Future<bool> checkPin() async {
    if (RegExp(r"^\d+$").hasMatch(input)) {
      final bool isValid = await platform.invokeMethod("validatePin", {"pin": input});
      return isValid;
    }
    return false;
  }

  Future<void> evaluate() async {
    final double evalResult = await platform.invokeMethod("evaluate", {"expression": input});
    if (evalResult % 1 == 0) {
      result = evalResult.toInt().toString();
    } else {
      String str = evalResult.toString();
      int dotIndex = str.indexOf('.');
      int decimalLength = dotIndex >= 0 ? str.length - dotIndex - 1 : 0;
      if (decimalLength > 6) {
        result = evalResult.toStringAsFixed(6);
      } else {
        result = str;
      }
    }
  }
}
