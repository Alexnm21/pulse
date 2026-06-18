import '../../domain/entities/process_entity.dart';

class ProcessModel extends ProcessEntity {
  const ProcessModel({
    required super.name,
    required super.cpuUsage,
    required super.memoryUsage,
    required super.user,
  });

  factory ProcessModel.fromMap(Map<String, dynamic> map) {
    return ProcessModel(
      name: map['name'] as String? ?? '',
      cpuUsage: (map['cpuUsage'] as num?)?.toDouble() ?? 0.0,
      memoryUsage: (map['memoryUsage'] as num?)?.toDouble() ?? 0.0,
      user: map['user'] as String? ?? '',
    );
  }
}
