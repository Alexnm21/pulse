import 'package:flutter/services.dart';

import '../models/memory_model.dart';

class MemoryLocalDataSource {
  static const _channel = MethodChannel('com.pulse.app/memory');

  Future<MemoryModel> getLiveMemoryUsage() async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeMapMethod(
        'getMemoryUsage',
      );

      if (result == null) {
        throw Exception("Didn't receive memory data");
      }

      final formattedMap = result.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      return MemoryModel.fromMap(formattedMap);
    } catch (e) {
      throw Exception("Error interacting with macOS native channel: $e");
    }
  }
}
