import 'package:pulse/features/dashboard/domain/entities/storage_entity.dart';

abstract class StorageRepository {
  Future<StorageEntity> getStorageUsage();
}
