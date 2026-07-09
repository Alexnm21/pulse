import '../entities/memory_entity.dart';
import '../repositories/memory_repository.dart';

class GetMemoryUsageUseCase {

  const GetMemoryUsageUseCase(this._repository);
  final MemoryRepository _repository;

  Future<MemoryEntity> call() async {
    return await _repository.getMemoryUsage();
  }
}
