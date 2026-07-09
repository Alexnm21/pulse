import 'package:pulse/features/dashboard/domain/entities/memory_entity.dart';
import 'package:pulse/features/dashboard/domain/repositories/memory_repository.dart';

import '../datasources/memory_local_datasource.dart';

class MemoryRepositoryImpl implements MemoryRepository {

  const MemoryRepositoryImpl(this._localDataSource);
  final MemoryLocalDataSource _localDataSource;

  @override
  Future<MemoryEntity> getMemoryUsage() async {
    return await _localDataSource.getLiveMemoryUsage();
  }
}
