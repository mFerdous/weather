import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constant/api_constants.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/header_provider/header_provider.dart';
import '../../../../core/resources/error_msg_res.dart';
import '../../../../core/utils/nums.dart';
import '../model/forecast_response.dart';

abstract class ForecastRemote {
  Future<ForecastResponse> weatherForecast();
}

class ForecastRemoteImpl implements ForecastRemote {
  static const weatherForecastEndpoint =
      ApiConstants.baseApiUrl + ApiConstants.forecastUrl;
  final HeaderProvider _headerProvider;

  ForecastRemoteImpl(this._headerProvider);
  var url = Uri.parse(weatherForecastEndpoint);

  @override
  Future<ForecastResponse> weatherForecast() async {
    ForecastResponse res;

    var queryParams = {'key': weatherApiKey,'q': '$latitude,$longitude' , 'days': '3', 'aqi': 'yes'};
    url = url.replace(queryParameters: queryParams);

    final headers = _headerProvider();

    final response = await http.get(url, headers: headers);


    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      res = ForecastResponse.fromJson(jsonBody);

      return res;
    } else if (response.statusCode == 204) {
      throw ServerException(
        message: ErrorMsgRes.kNoContent,
        statusCode: response.statusCode,
      );
    } else if (response.statusCode == 400) {
      throw ServerException(
        message: ErrorMsgRes.kBadRequest,
        statusCode: response.statusCode,
      );
    } else if (response.statusCode == 401) {
      throw ServerException(
        message: ErrorMsgRes.kUnauthorized,
        statusCode: response.statusCode,
      );
    } else if (response.statusCode == 404) {
      throw ServerException(
        message: ErrorMsgRes.kNotFound,
        statusCode: response.statusCode,
      );
    } else if (response.statusCode == 408) {
      throw ServerException(
        message: ErrorMsgRes.kRequestTimeOut,
        statusCode: response.statusCode,
      );
    } else if (response.statusCode == 431) {
      throw ServerException(
        message: ErrorMsgRes.kTooManyRequest,
        statusCode: response.statusCode,
      );
    } else if (response.statusCode == 500) {
      throw ServerException(
        message: ErrorMsgRes.kServerError,
        statusCode: response.statusCode,
      );
    } else if (response.statusCode == 503) {
      throw ServerException(
        message: ErrorMsgRes.kServiceUnavailable,
        statusCode: response.statusCode,
      );
    } else {
      throw ServerException(
        message: response.body,
        statusCode: response.statusCode,
      );
    }
  }
}
