part of 'dashboard_bloc.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final CpuEntity cpu;
  final MemoryEntity memory;
  final StorageEntity storage;
  final List<double> temperature;

  DashboardLoaded({
    required this.cpu,
    required this.memory,
    required this.storage,
    required this.temperature,
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}
