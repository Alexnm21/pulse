import 'package:flutter/services.dart';
import '../models/process_model.dart';

class ProcessesLocalDataSource {
  static const _channel = MethodChannel('com.pulse.app/processes');

  Future<List<ProcessModel>> getProcesses() async {
    try {
      final List<dynamic>? result = await _channel.invokeListMethod('getProcesses');
      if (result == null) throw Exception("Didn't receive processes data");
      return result
          .cast<Map<dynamic, dynamic>>()
          .map((e) => e.map((key, value) => MapEntry(key.toString(), value)))
          .map(ProcessModel.fromMap)
          .toList();
    } catch (e) {
      throw Exception('Error interacting with macOS native channel: $e');
    }
  }

  Future<Map<String, dynamic>> killProcess(int pid) async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeMapMethod(
        'killProcess',
        {'pid': pid},
      );
      if (result == null) throw Exception("Didn't receive kill result");
      return result.map((key, value) => MapEntry(key.toString(), value));
    } catch (e) {
      throw Exception('Error killing process: $e');
    }
  }
}
