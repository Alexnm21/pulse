import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/features/processes/domain/entities/process_entity.dart';
import 'package:pulse/features/processes/domain/usecases/get_processes.dart';

part 'processes_event.dart';
part 'processes_state.dart';

class ProcessesBloc extends Bloc<ProcessesEvent, ProcessesState> {

  ProcessesBloc({
    required GetProcessesUseCase getProcesses,
  }) : _getProcesses = getProcesses,
       super(ProcessesInitial()) {
    on<StartProcessesMonitoringEvent>(_onStartMonitoring);
    on<ProcessesTickEvent>(
      (event, emit) => emit(
        ProcessesLoaded(
          processes: event.processes,
          searchQuery: _currentQuery(emit),
        ),
      ),
    );
    on<ProcessesErrorEvent>(
      (event, emit) => emit(ProcessesError(message: event.message)),
    );
    on<SearchProcessesEvent>(
      (event, emit) {
        if (state is ProcessesLoaded) {
          emit(
            ProcessesLoaded(
              processes: (state as ProcessesLoaded).processes,
              searchQuery: event.query,
            ),
          );
        }
      },
    );

    initialize();
  }
  final GetProcessesUseCase _getProcesses;
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

  void initialize() {
    add(const StartProcessesMonitoringEvent());
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
