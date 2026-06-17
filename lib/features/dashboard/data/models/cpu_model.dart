import '../../domain/entities/cpu_entity.dart';

class CpuModel extends CpuEntity {
  const CpuModel({
    required super.name,
    required super.totalLoad,
    required super.user,
    required super.system,
    required super.idle,
  });

  // Maps the [String: Any] Dictionary sent from Swift
  factory CpuModel.fromMap(Map<String, dynamic> map) {
    return CpuModel(
      name: map['name'] as String? ?? 'CPU',
      totalLoad: (map['totalLoad'] as num?)?.toDouble() ?? 0.0,
      user: (map['user'] as num?)?.toDouble() ?? 0.0,
      system: (map['system'] as num?)?.toDouble() ?? 0.0,
      idle: (map['idle'] as num?)?.toDouble() ?? 100.0,
    );
  }
}
