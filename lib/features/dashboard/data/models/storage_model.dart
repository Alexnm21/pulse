import 'package:pulse/features/dashboard/domain/entities/storage_entity.dart';

class StorageModel extends StorageEntity {
  const StorageModel({
    required super.totalStorage,
    required super.usedStorage,
    required super.freeStorage,
  });

  factory StorageModel.fromMap(Map<String, dynamic> map) {
    return StorageModel(
      totalStorage: (map['totalStorage'] as num?)?.toDouble() ?? 0.0,
      usedStorage: (map['usedStorage'] as num?)?.toDouble() ?? 0.0,
      freeStorage: (map['freeStorage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
