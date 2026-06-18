import '../../domain/entities/process_entity.dart';
import '../../domain/repositories/processes_repository.dart';
import '../datasources/processes_local_datasource.dart';

class ProcessesRepositoryImpl implements ProcessesRepository {

  const ProcessesRepositoryImpl(this._localDataSource);
  final ProcessesLocalDataSource _localDataSource;

  @override
  Future<List<ProcessEntity>> getProcesses() async {
    return await _localDataSource.getProcesses();
  }
}
