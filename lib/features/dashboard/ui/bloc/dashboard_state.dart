part of 'dashboard_bloc.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final CpuEntity cpu;
  final MemoryEntity memory;

  DashboardLoaded({required this.cpu, required this.memory});
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}
