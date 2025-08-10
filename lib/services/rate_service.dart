import 'package:flutter/services.dart';

class RateService {
  static const _platform = MethodChannel('com.example.vault/channel');

  Future<int> getRating() async {
    try {
      final rating = await _platform.invokeMethod('getRating');
      return rating as int;
    } catch (e) {
      throw Exception("Lỗi lấy rating: $e");
    }
  }

  Future<void> saveRating(int rating) async {
    try {
      await _platform.invokeMethod('saveRating', {"rating": rating});
    } catch (e) {
      throw Exception("Lỗi lưu rating: $e");
    }
  }
}
