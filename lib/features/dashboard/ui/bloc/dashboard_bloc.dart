import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/features/dashboard/domain/entities/memory_entity.dart';
import 'package:pulse/features/dashboard/domain/usecases/get_cpu_usage.dart';
import 'package:pulse/features/dashboard/domain/usecases/get_memory_usage.dart';

import '../../domain/entities/cpu_entity.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetCpuUsageUseCase _getCpuUsage;
  final GetMemoryUsageUseCase _getMemoryUsage;
  Timer? _ticker;

  DashboardBloc({
    required GetCpuUsageUseCase getCpuUsage,
    required GetMemoryUsageUseCase getMemoryUsage,
  }) : _getCpuUsage = getCpuUsage,
       _getMemoryUsage = getMemoryUsage,
       super(DashboardInitial()) {
    on<StartCpuMonitoringEvent>(_onStartMonitoring);
    on<SystemTickEvent>(
      (event, emit) =>
          emit(DashboardLoaded(cpu: event.cpu, memory: event.memory)),
    );
    on<DashboardErrorEvent>(
      (event, emit) => emit(DashboardError(message: event.message)),
    );

    initialize();
  }

  void _onStartMonitoring(
    StartCpuMonitoringEvent event,
    Emitter<DashboardState> emit,
  ) {
    emit(DashboardLoading());
    _ticker?.cancel();

    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        final cpuEntity = await _getCpuUsage();
        final memoryEntity = await _getMemoryUsage();

        if (!isClosed) {
          add(SystemTickEvent(cpu: cpuEntity, memory: memoryEntity));
        }
      } catch (e) {
        if (!isClosed) {
          add(DashboardErrorEvent(message: e.toString()));
        }
      }
    });
  }

  void initialize() {
    add(StartCpuMonitoringEvent());
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
