import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/repository/forecast_repository.dart';
import '../model/forecast_response.dart';
import '../remote/forecast_remote.dart';

class ForecastRepositoryImpl implements ForecastRepository {
  final ConnectionChecker connectionChecker;
  final ForecastRemote forecastRemote;

  ForecastRepositoryImpl(
    this.connectionChecker,
    this.forecastRemote,
  );

  @override
  Future<ForecastResponse> weatherForecast() async {
    if (!await connectionChecker.isConnected()) throw NoInternetException();
    ForecastResponse forecastResponse =
        await forecastRemote.weatherForecast();
    return forecastResponse;
  }
}
