import 'package:pulse/features/dashboard/domain/entities/memory_entity.dart';

class MemoryModel extends MemoryEntity {
  const MemoryModel({
    required super.totalMemory,
    required super.usedMemory,
    required super.appMemory,
    required super.wiredMemory,
    required super.compressedMemory,
  });

  factory MemoryModel.fromMap(Map<String, dynamic> map) {
    return MemoryModel(
      totalMemory: (map['totalMemory'] as num?)?.toDouble() ?? 0.0,
      usedMemory: (map['usedMemory'] as num?)?.toDouble() ?? 0.0,
      appMemory: (map['appMemory'] as num?)?.toDouble() ?? 0.0,
      wiredMemory: (map['wiredMemory'] as num?)?.toDouble() ?? 0.0,
      compressedMemory: (map['compressedMemory'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
