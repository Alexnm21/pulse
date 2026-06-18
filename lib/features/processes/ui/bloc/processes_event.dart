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
