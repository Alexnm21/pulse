import '../repositories/processes_repository.dart';

class KillProcessUseCase {

  const KillProcessUseCase(this._repository);
  final ProcessesRepository _repository;

  Future<Map<String, dynamic>> call(int pid) async {
    return await _repository.killProcess(pid);
  }
}
