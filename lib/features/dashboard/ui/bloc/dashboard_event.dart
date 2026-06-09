part of 'dashboard_bloc.dart';

abstract class DashboardEvent {}

class StartCpuMonitoringEvent extends DashboardEvent {}

class SystemTickEvent extends DashboardEvent {
  final CpuEntity cpu;
  final MemoryEntity memory;

  SystemTickEvent({required this.cpu, required this.memory});
}

class DashboardErrorEvent extends DashboardEvent {
  final String message;

  DashboardErrorEvent({required this.message});
}
