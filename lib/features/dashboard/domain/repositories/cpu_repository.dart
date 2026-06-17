import '../entities/cpu_entity.dart';

abstract class CpuRepository {
  Future<CpuEntity> getCpuUsage();
}
