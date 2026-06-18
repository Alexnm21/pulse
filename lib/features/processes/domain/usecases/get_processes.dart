import '../entities/process_entity.dart';
import '../repositories/processes_repository.dart';

class GetProcessesUseCase {

  const GetProcessesUseCase(this._repository);
  final ProcessesRepository _repository;

  Future<List<ProcessEntity>> call() async {
    return await _repository.getProcesses();
  }
}
