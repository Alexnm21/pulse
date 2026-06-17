import 'package:flutter/services.dart';

class TemperatureLocalDataSource {
  static const _channel = MethodChannel('com.pulse.app/temperature');

  Future<double> getTemperature() async {
    try {
      final double? result = await _channel.invokeMethod('getTemperature');

      if (result == null) {
        throw Exception("Didn't receive temperature data");
      }

      return result;
    } catch (e) {
      throw Exception("Error interacting with macOS native channel: $e");
    }
  }
}
