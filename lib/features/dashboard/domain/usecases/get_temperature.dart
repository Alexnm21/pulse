import '../repositories/temperature_repository.dart';

class GetTemperatureUseCase {

  const GetTemperatureUseCase(this._repository);
  final TemperatureRepository _repository;

  Future<double> call() async {
    return await _repository.getTemperature();
  }
}
