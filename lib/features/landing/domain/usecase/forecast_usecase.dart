

import '../../data/model/forecast_response.dart';
import '../repository/forecast_repository.dart';

class ForecastUsecase {
  final ForecastRepository _forecastRepository;

  ForecastUsecase(this._forecastRepository);

  Future<ForecastResponse> call() =>
      _forecastRepository.weatherForecast();
}
