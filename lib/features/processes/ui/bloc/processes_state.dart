part of 'processes_bloc.dart';

abstract class ProcessesState {}

class ProcessesInitial extends ProcessesState {}

class ProcessesLoading extends ProcessesState {}

class ProcessesLoaded extends ProcessesState {

  ProcessesLoaded({
    required this.processes,
    this.searchQuery = '',
  });
  final List<ProcessEntity> processes;
  final String searchQuery;

  List<ProcessEntity> get filteredProcesses {
    if (searchQuery.isEmpty) return processes;
    final query = searchQuery.toLowerCase();
    return processes.where((p) => p.name.toLowerCase().contains(query)).toList();
  }
}

class ProcessesError extends ProcessesState {

  ProcessesError({required this.message});
  final String message;
}
