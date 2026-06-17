import 'package:pulse/features/dashboard/data/datasources/temperature_local_datasource.dart';
import 'package:pulse/features/dashboard/domain/repositories/temperature_repository.dart';

class TemperatureRepositoryImpl implements TemperatureRepository {
  final TemperatureLocalDataSource _localDataSource;
  TemperatureRepositoryImpl(this._localDataSource);
  @override
  Future<double> getTemperature() => _localDataSource.getTemperature();
}
