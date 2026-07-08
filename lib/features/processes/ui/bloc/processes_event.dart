part of 'processes_bloc.dart';

abstract class ProcessesEvent {
  const ProcessesEvent();
}

class StartProcessesMonitoringEvent extends ProcessesEvent {
  const StartProcessesMonitoringEvent();
}

class ProcessesTickEvent extends ProcessesEvent {
  ProcessesTickEvent({required this.processes});
  final List<ProcessEntity> processes;
}

class ProcessesErrorEvent extends ProcessesEvent {
  const ProcessesErrorEvent({required this.message});
  final String message;
}

class SearchProcessesEvent extends ProcessesEvent {
  const SearchProcessesEvent({required this.query});
  final String query;
}

class SortProcessesEvent extends ProcessesEvent {
  const SortProcessesEvent({required this.column, required this.ascending});
  final ProcessListColumn column;
  final bool ascending;
}

class SelectProcessEvent extends ProcessesEvent {
  const SelectProcessEvent({this.process});
  final ProcessEntity? process;
}

class KillProcessEvent extends ProcessesEvent {
  const KillProcessEvent({required this.pid});
  final int pid;
}
