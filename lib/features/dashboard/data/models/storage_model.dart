import 'package:pulse/features/dashboard/domain/entities/storage_entity.dart';

class StorageModel extends StorageEntity {
  StorageModel({
    required super.totalStorage,
    required super.usedStorage,
    required super.freeStorage,
  });

  factory StorageModel.fromJson(Map<String, dynamic> json) {
    return StorageModel(
      totalStorage: json['totalStorage'],
      usedStorage: json['usedStorage'],
      freeStorage: json['freeStorage'],
    );
  }
}
