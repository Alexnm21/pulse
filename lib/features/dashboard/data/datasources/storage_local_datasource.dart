import 'package:flutter/services.dart';
import 'package:pulse/features/dashboard/data/models/storage_model.dart';

class StorageLocalDataSource {
  static const _channel = MethodChannel('com.pulse.app/storage');

  Future<StorageModel> getLiveStorage() async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
        'getStorageUsage',
      );

      if (result == null) {
        throw Exception("Didn't receive storage data");
      }
      final formattedMap = result.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      return StorageModel.fromJson(formattedMap);
    } catch (e) {
      throw Exception("Error interacting with macOS native channel: $e");
    }
  }
}
