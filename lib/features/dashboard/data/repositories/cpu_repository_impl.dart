import 'package:pulse/features/dashboard/data/datasources/cpu_local_datasource.dart';

import '../../domain/entities/cpu_entity.dart';
import '../../domain/repositories/cpu_repository.dart';

class CpuRepositoryImpl implements CpuRepository {

  const CpuRepositoryImpl(this._localDataSource);
  final CpuLocalDataSource _localDataSource;

  @override
  Future<CpuEntity> getCpuUsage() async {
    return await _localDataSource.getLiveCpuUsage();
  }
}
