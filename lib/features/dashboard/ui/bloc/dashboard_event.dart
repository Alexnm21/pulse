part of 'dashboard_bloc.dart';

abstract class DashboardEvent {}

class StartCpuMonitoringEvent extends DashboardEvent {}

class SystemTickEvent extends DashboardEvent {
  final CpuEntity cpu;
  final MemoryEntity memory;
  final StorageEntity storage;
  final double temperature;

  SystemTickEvent({
    required this.cpu,
    required this.memory,
    required this.temperature,
    required this.storage,
  });
}

class DashboardErrorEvent extends DashboardEvent {
  final String message;

  DashboardErrorEvent({required this.message});
}
