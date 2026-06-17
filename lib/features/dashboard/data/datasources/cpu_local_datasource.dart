import 'package:flutter/services.dart';

import '../models/cpu_model.dart';

class CpuLocalDataSource {
  static const _channel = MethodChannel('com.pulse.app/cpu');

  Future<CpuModel> getLiveCpuUsage() async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeMapMethod(
        'getCpuUsage',
      );

      if (result == null) {
        throw Exception("Didn't receive CPU data");
      }

      final formattedMap = result.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      return CpuModel.fromMap(formattedMap);
    } catch (e) {
      throw Exception("Error interacting with macOS native channel: $e");
    }
  }
}
