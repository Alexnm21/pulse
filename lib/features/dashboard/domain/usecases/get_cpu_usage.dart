import '../entities/cpu_entity.dart';
import '../repositories/cpu_repository.dart';

class GetCpuUsageUseCase {

  const GetCpuUsageUseCase(this._repository);
  final CpuRepository _repository;

  Future<CpuEntity> call() async {
    return await _repository.getCpuUsage();
  }
}
