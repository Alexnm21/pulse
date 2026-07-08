// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'processes_bloc.dart';

abstract class ProcessesState {}

class ProcessesInitial extends ProcessesState {}

class ProcessesLoading extends ProcessesState {}

class ProcessesLoaded extends ProcessesState {
  ProcessesLoaded({
    required this.processes,
    this.selectedProcess,
    this.searchQuery = '',
    this.sortBy,
    this.sortAscending = true,
    this.killResult,
  });
  final List<ProcessEntity> processes;
  final ProcessEntity? selectedProcess;
  final String searchQuery;
  final ProcessListColumn? sortBy;
  final bool sortAscending;
  final (bool success, String message)? killResult;

  double get maxMemoryMB => processes.isEmpty
      ? 0.0
      : processes.map((p) => p.memoryMB).reduce((a, b) => a > b ? a : b);

  List<ProcessEntity> get filteredProcesses {
    var result = processes;

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where((p) => p.name.toLowerCase().contains(query))
          .toList();
    }

    if (sortBy != null) {
      result = [...result];
      result.sort((a, b) {
        final cmp = switch (sortBy!) {
          ProcessListColumn.name => a.name.compareTo(b.name),
          ProcessListColumn.cpu => a.cpuUsage.compareTo(b.cpuUsage),
          ProcessListColumn.memory => a.memoryMB.compareTo(b.memoryMB),
          ProcessListColumn.user => 0,
        };
        return sortAscending ? cmp : -cmp;
      });
    }

    return result;
  }

  ProcessesLoaded copyWith({
    List<ProcessEntity>? processes,
    ProcessEntity? selectedProcess,
    String? searchQuery,
    ProcessListColumn? sortBy,
    bool? sortAscending,
    (bool success, String message)? killResult,
  }) {
    return ProcessesLoaded(
      processes: processes ?? this.processes,
      selectedProcess: selectedProcess ?? this.selectedProcess,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      killResult: killResult ?? this.killResult,
    );
  }
}

class ProcessesError extends ProcessesState {
  ProcessesError({required this.message});
  final String message;
}
