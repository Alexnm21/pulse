import 'package:pulse/features/dashboard/data/datasources/storage_local_datasource.dart';
import 'package:pulse/features/dashboard/domain/entities/storage_entity.dart';
import 'package:pulse/features/dashboard/domain/repositories/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  final StorageLocalDataSource _localDataSource;

  const StorageRepositoryImpl(this._localDataSource);

  @override
  Future<StorageEntity> getStorageUsage() async {
    return await _localDataSource.getLiveStorage();
  }
}
