part of 'dashboard_bloc.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {

  DashboardLoaded({
    required this.cpu,
    required this.memory,
    required this.storage,
    required this.temperature,
  });
  final CpuEntity cpu;
  final MemoryEntity memory;
  final StorageEntity storage;
  final List<double> temperature;
}

class DashboardError extends DashboardState {

  DashboardError({required this.message});
  final String message;
}
