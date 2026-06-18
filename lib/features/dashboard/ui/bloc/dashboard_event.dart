part of 'dashboard_bloc.dart';

abstract class DashboardEvent {}

class StartCpuMonitoringEvent extends DashboardEvent {}

class SystemTickEvent extends DashboardEvent {

  SystemTickEvent({
    required this.cpu,
    required this.memory,
    required this.temperature,
    required this.storage,
  });
  final CpuEntity cpu;
  final MemoryEntity memory;
  final StorageEntity storage;
  final double temperature;
}

class DashboardErrorEvent extends DashboardEvent {

  DashboardErrorEvent({required this.message});
  final String message;
}
