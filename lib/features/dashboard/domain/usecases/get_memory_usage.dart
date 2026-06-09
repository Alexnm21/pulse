import '../entities/memory_entity.dart';
import '../repositories/memory_repository.dart';

class GetMemoryUsageUseCase {
  final MemoryRepository _repository;

  const GetMemoryUsageUseCase(this._repository);

  Future<MemoryEntity> call() async {
    return await _repository.getMemoryUsage();
  }
}
