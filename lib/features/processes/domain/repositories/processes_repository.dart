import '../entities/process_entity.dart';

abstract class ProcessesRepository {
  Future<List<ProcessEntity>> getProcesses();

  Future<Map<String, dynamic>> killProcess(int pid);
}
