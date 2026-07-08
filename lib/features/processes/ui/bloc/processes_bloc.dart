import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/features/processes/domain/entities/process_entity.dart';
import 'package:pulse/features/processes/domain/enums/process_list_column.dart';
import 'package:pulse/features/processes/domain/usecases/get_processes.dart';
import 'package:pulse/features/processes/domain/usecases/kill_process.dart';

part 'processes_event.dart';
part 'processes_state.dart';

class ProcessesBloc extends Bloc<ProcessesEvent, ProcessesState> {
  ProcessesBloc({
    required GetProcessesUseCase getProcesses,
    required KillProcessUseCase killProcess,
  }) : _getProcesses = getProcesses,
       _killProcess = killProcess,
       super(ProcessesInitial()) {
    on<StartProcessesMonitoringEvent>(_onStartMonitoring);
    on<ProcessesTickEvent>(
      (event, emit) => emit(
        ProcessesLoaded(
          processes: event.processes,
          selectedProcess: state is ProcessesLoaded
              ? (state as ProcessesLoaded).selectedProcess
              : null,
          searchQuery: _currentQuery(emit),
          sortBy: _currentSortBy(emit),
          sortAscending: _currentSortAscending(emit),
        ),
      ),
    );
    on<ProcessesErrorEvent>(
      (event, emit) => emit(ProcessesError(message: event.message)),
    );
    on<SearchProcessesEvent>((event, emit) {
      if (state is ProcessesLoaded) {
        emit(
          ProcessesLoaded(
            processes: (state as ProcessesLoaded).processes,
            selectedProcess: (state as ProcessesLoaded).selectedProcess,
            searchQuery: event.query,
            sortBy: (state as ProcessesLoaded).sortBy,
            sortAscending: (state as ProcessesLoaded).sortAscending,
          ),
        );
      }
    });
    on<SortProcessesEvent>((event, emit) {
      if (state is ProcessesLoaded) {
        emit(
          ProcessesLoaded(
            processes: (state as ProcessesLoaded).processes,
            selectedProcess: (state as ProcessesLoaded).selectedProcess,
            searchQuery: (state as ProcessesLoaded).searchQuery,
            sortBy: event.column,
            sortAscending: event.ascending,
          ),
        );
      }
    });
    on<SelectProcessEvent>((event, emit) {
      if (state is! ProcessesLoaded) return;
      emit(
        ProcessesLoaded(
          processes: (state as ProcessesLoaded).processes,
          selectedProcess: event.process,
          searchQuery: (state as ProcessesLoaded).searchQuery,
          sortBy: (state as ProcessesLoaded).sortBy,
          sortAscending: (state as ProcessesLoaded).sortAscending,
        ),
      );
    });
    on<KillProcessEvent>(_onKillProcess);

    initialize();
  }
  final GetProcessesUseCase _getProcesses;
  final KillProcessUseCase _killProcess;
  Timer? _ticker;

  void _onStartMonitoring(
    StartProcessesMonitoringEvent event,
    Emitter<ProcessesState> emit,
  ) {
    emit(ProcessesLoading());
    _ticker?.cancel();

    _ticker = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final List<ProcessEntity> processes = await _getProcesses();
        if (isClosed) return;
        add(ProcessesTickEvent(processes: processes));
      } catch (e) {
        if (!isClosed) add(ProcessesErrorEvent(message: e.toString()));
      }
    });
  }

  String _currentQuery(Emitter<ProcessesState> emit) {
    if (state is ProcessesLoaded) return (state as ProcessesLoaded).searchQuery;
    return '';
  }

  ProcessListColumn? _currentSortBy(Emitter<ProcessesState> emit) {
    if (state is ProcessesLoaded) return (state as ProcessesLoaded).sortBy;
    return null;
  }

  bool _currentSortAscending(Emitter<ProcessesState> emit) {
    if (state is ProcessesLoaded) {
      return (state as ProcessesLoaded).sortAscending;
    }
    return true;
  }

  void initialize() {
    add(const StartProcessesMonitoringEvent());
  }

  void selectProcess(ProcessEntity process) {
    if (state is! ProcessesLoaded) return;

    final ProcessEntity? currentProcess =
        (state as ProcessesLoaded).selectedProcess;

    add(
      SelectProcessEvent(
        process: currentProcess?.pid == process.pid ? null : process,
      ),
    );
  }

  void killProcess(int pid) {
    add(KillProcessEvent(pid: pid));
  }

  Future<void> _onKillProcess(
    KillProcessEvent event,
    Emitter<ProcessesState> emit,
  ) async {
    if (state is! ProcessesLoaded) return;
    try {
      final result = await _killProcess(event.pid);
      final success = result['success'] as bool? ?? false;
      final message = result['message'] as String? ?? '';

      final updatedProcesses = (state as ProcessesLoaded)
          .processes
          .where((p) => p.pid != event.pid)
          .toList();

      emit(
        (state as ProcessesLoaded).copyWith(
          processes: updatedProcesses,
          selectedProcess: null,
          killResult: (success, message),
        ),
      );
    } catch (e) {
      emit(
        (state as ProcessesLoaded).copyWith(
          killResult: (false, 'Error: $e'),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
