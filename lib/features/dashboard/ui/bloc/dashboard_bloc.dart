import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/features/dashboard/domain/usecases/get_cpu_usage.dart';

import '../../domain/entities/cpu_entity.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetCpuUsageUseCase _getCpuUsage; //
  Timer? _ticker;

  DashboardBloc({required GetCpuUsageUseCase getCpuUsage})
    : _getCpuUsage = getCpuUsage,
      super(DashboardInitial()) {
    on<StartCpuMonitoringEvent>(_onStartMonitoring);
    on<CpuTickEvent>((event, emit) => emit(DashboardLoaded(event.cpu)));

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
        if (!isClosed) add(CpuTickEvent(cpuEntity));
      } catch (_) {}
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
