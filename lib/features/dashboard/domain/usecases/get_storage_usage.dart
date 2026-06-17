import 'package:pulse/features/dashboard/domain/entities/storage_entity.dart';
import 'package:pulse/features/dashboard/domain/repositories/storage_repository.dart';

class GetStorageUsageUseCase {
  final StorageRepository _repository;

  const GetStorageUsageUseCase(this._repository);

  Future<StorageEntity> call() async {
    return await _repository.getStorageUsage();
  }
}
