import '../../domain/entities/process_entity.dart';

class ProcessModel extends ProcessEntity {
  const ProcessModel({
    required super.pid,
    required super.name,
    required super.cpuUsage,
    required super.memoryMB,
    required super.user,
  });

  factory ProcessModel.fromMap(Map<String, dynamic> map) {
    return ProcessModel(
      pid: map['pid'] as int,
      name: map['name'] as String? ?? '',
      cpuUsage: (map['cpuUsage'] as num?)?.toDouble() ?? 0.0,
      memoryMB: (map['memoryUsageMB'] as num?)?.toDouble() ?? 0.0,
      user: map['user'] as String? ?? '',
    );
  }
}
