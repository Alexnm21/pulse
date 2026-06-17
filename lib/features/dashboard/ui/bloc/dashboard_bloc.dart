import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/features/dashboard/domain/entities/memory_entity.dart';
import 'package:pulse/features/dashboard/domain/entities/storage_entity.dart';
import 'package:pulse/features/dashboard/domain/usecases/get_cpu_usage.dart';
import 'package:pulse/features/dashboard/domain/usecases/get_memory_usage.dart';
import 'package:pulse/features/dashboard/domain/usecases/get_storage_usage.dart';
import 'package:pulse/features/dashboard/domain/usecases/get_temperature.dart';

import '../../domain/entities/cpu_entity.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

const int _temperatureSparklineLength = 20;

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetCpuUsageUseCase _getCpuUsage;
  final GetMemoryUsageUseCase _getMemoryUsage;
  final GetStorageUsageUseCase _getStorageUsage;
  final GetTemperatureUseCase _getTemperature;
  Timer? _ticker;

  DashboardBloc({
    required GetCpuUsageUseCase getCpuUsage,
    required GetMemoryUsageUseCase getMemoryUsage,
    required GetTemperatureUseCase getTemperature,
    required GetStorageUsageUseCase getStorageUsage,
  }) : _getStorageUsage = getStorageUsage,
       _getCpuUsage = getCpuUsage,
       _getMemoryUsage = getMemoryUsage,
       _getTemperature = getTemperature,
       super(DashboardInitial()) {
    on<StartCpuMonitoringEvent>(_onStartMonitoring);
    on<SystemTickEvent>(
      (event, emit) => emit(
        DashboardLoaded(
          cpu: event.cpu,
          memory: event.memory,
          storage: event.storage,
          temperature: _addTemperature(event.temperature),
        ),
      ),
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
        final CpuEntity cpuEntity = await _getCpuUsage();
        final MemoryEntity memoryEntity = await _getMemoryUsage();
        final StorageEntity storageEntity = await _getStorageUsage();
        final double temperature = await _getTemperature();

        if (isClosed) return;

        add(
          SystemTickEvent(
            cpu: cpuEntity,
            memory: memoryEntity,
            temperature: temperature,
            storage: storageEntity,
          ),
        );
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

  List<double> _addTemperature(double value) {
    if (state is! DashboardLoaded) return [];

    final List<double> temperatureHistory = [
      ...(state as DashboardLoaded).temperature,
    ];
    temperatureHistory.add(value);
    if (temperatureHistory.length > _temperatureSparklineLength) {
      temperatureHistory.removeAt(0);
    }
    return temperatureHistory;
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
