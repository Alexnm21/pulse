import 'package:pulse/features/dashboard/domain/entities/storage_entity.dart';
import 'package:pulse/features/dashboard/domain/repositories/storage_repository.dart';

class GetStorageUsageUseCase {

  const GetStorageUsageUseCase(this._repository);
  final StorageRepository _repository;

  Future<StorageEntity> call() async {
    return await _repository.getStorageUsage();
  }
}
