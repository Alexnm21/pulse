part of 'dashboard_bloc.dart';

abstract class DashboardEvent {}

class StartCpuMonitoringEvent extends DashboardEvent {}

class CpuTickEvent extends DashboardEvent {
  final CpuEntity cpu;
  CpuTickEvent(this.cpu);
}
