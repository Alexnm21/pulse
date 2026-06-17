import '../repositories/temperature_repository.dart';

class GetTemperatureUseCase {
  final TemperatureRepository _repository;

  const GetTemperatureUseCase(this._repository);

  Future<double> call() async {
    return await _repository.getTemperature();
  }
}
