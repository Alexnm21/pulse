import 'package:pulse/features/dashboard/data/datasources/cpu_local_datasource.dart';

import '../../domain/entities/cpu_entity.dart';
import '../../domain/repositories/cpu_repository.dart';

class CpuRepositoryImpl implements CpuRepository {
  final CpuLocalDataSource _localDataSource;

  const CpuRepositoryImpl(this._localDataSource);

  @override
  Future<CpuEntity> getCpuUsage() async {
    return await _localDataSource.getLiveCpuUsage();
  }
}
