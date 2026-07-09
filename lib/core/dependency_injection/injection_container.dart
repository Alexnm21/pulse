import 'package:get_it/get_it.dart';
import 'package:pulse/features/dashboard/data/datasources/cpu_local_datasource.dart';
import 'package:pulse/features/dashboard/data/datasources/memory_local_datasource.dart';
import 'package:pulse/features/dashboard/data/datasources/storage_local_datasource.dart';
import 'package:pulse/features/dashboard/data/datasources/temperature_local_datasource.dart';
import 'package:pulse/features/dashboard/data/repositories/cpu_repository_impl.dart';
import 'package:pulse/features/dashboard/data/repositories/memory_repository_impl.dart';
import 'package:pulse/features/dashboard/data/repositories/storage_repository_impl.dart';
import 'package:pulse/features/dashboard/data/repositories/temperature_repository_impl.dart';
import 'package:pulse/features/dashboard/domain/repositories/cpu_repository.dart';
import 'package:pulse/features/dashboard/domain/repositories/memory_repository.dart';
import 'package:pulse/features/dashboard/domain/repositories/storage_repository.dart';
import 'package:pulse/features/dashboard/domain/repositories/temperature_repository.dart';
import 'package:pulse/features/dashboard/domain/usecases/get_cpu_usage.dart';
import 'package:pulse/features/dashboard/domain/usecases/get_memory_usage.dart';
import 'package:pulse/features/dashboard/domain/usecases/get_storage_usage.dart';
import 'package:pulse/features/dashboard/domain/usecases/get_temperature.dart';
import 'package:pulse/features/dashboard/ui/bloc/dashboard_bloc.dart';
import 'package:pulse/features/main/ui/bloc/main_bloc.dart';
import 'package:pulse/features/processes/data/datasources/processes_local_datasource.dart';
import 'package:pulse/features/processes/data/repositories/processes_repository_impl.dart';
import 'package:pulse/features/processes/domain/repositories/processes_repository.dart';
import 'package:pulse/features/processes/domain/usecases/get_processes.dart';
import 'package:pulse/features/processes/domain/usecases/kill_process.dart';
import 'package:pulse/features/processes/ui/bloc/processes_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  _initDataSources();
  _initRepositories();
  _initUseCases();

  _initBlocs();
}

void _initDataSources() {
  sl.registerLazySingleton(CpuLocalDataSource.new);
  sl.registerLazySingleton(MemoryLocalDataSource.new);
  sl.registerLazySingleton(TemperatureLocalDataSource.new);
  sl.registerLazySingleton(StorageLocalDataSource.new);
  sl.registerLazySingleton(ProcessesLocalDataSource.new);
}

void _initRepositories() {
  sl.registerLazySingleton<CpuRepository>(() => CpuRepositoryImpl(sl()));
  sl.registerLazySingleton<MemoryRepository>(() => MemoryRepositoryImpl(sl()));
  sl.registerLazySingleton<TemperatureRepository>(
    () => TemperatureRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<StorageRepository>(
    () => StorageRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProcessesRepository>(
    () => ProcessesRepositoryImpl(sl()),
  );
}

void _initUseCases() {
  sl.registerLazySingleton(() => GetCpuUsageUseCase(sl()));
  sl.registerLazySingleton(() => GetMemoryUsageUseCase(sl()));
  sl.registerLazySingleton(() => GetTemperatureUseCase(sl()));
  sl.registerLazySingleton(() => GetStorageUsageUseCase(sl()));
  sl.registerLazySingleton(() => GetProcessesUseCase(sl()));
  sl.registerLazySingleton(() => KillProcessUseCase(sl()));
}

void _initBlocs() {
  sl.registerLazySingleton(MainBloc.new);
  // Factory so a new instance is created each time the user navigates to
  // the view. The previous instance is closed and its polling timer
  // is cancelled when the user leaves. A singleton would keep polling forever.
  sl.registerFactory(
    () => DashboardBloc(
      getCpuUsage: sl(),
      getMemoryUsage: sl(),
      getTemperature: sl(),
      getStorageUsage: sl(),
    ),
  );
  sl.registerFactory(
    () => ProcessesBloc(
      getProcesses: sl(),
      killProcess: sl(),
    ),
  );
}
