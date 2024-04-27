
import '../../data/model/forecast_response.dart';

abstract class ForecastRepository {
  Future<ForecastResponse> weatherForecast();
}
