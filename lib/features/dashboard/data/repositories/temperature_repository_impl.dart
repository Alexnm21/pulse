import 'package:pulse/features/dashboard/data/datasources/temperature_local_datasource.dart';
import 'package:pulse/features/dashboard/domain/repositories/temperature_repository.dart';

class TemperatureRepositoryImpl implements TemperatureRepository {

  const TemperatureRepositoryImpl(this._localDataSource);
  final TemperatureLocalDataSource _localDataSource;

  @override
  Future<double> getTemperature() => _localDataSource.getTemperature();
}
