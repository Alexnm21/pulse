import '../entities/cpu_entity.dart';
import '../repositories/cpu_repository.dart';

class GetCpuUsageUseCase {
  final CpuRepository _repository;

  const GetCpuUsageUseCase(this._repository);

  Future<CpuEntity> call() async {
    return await _repository.getCpuUsage();
  }
}
