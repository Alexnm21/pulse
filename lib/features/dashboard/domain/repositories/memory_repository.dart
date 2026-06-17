import 'package:pulse/features/dashboard/domain/entities/memory_entity.dart';

abstract class MemoryRepository {
  Future<MemoryEntity> getMemoryUsage();
}
