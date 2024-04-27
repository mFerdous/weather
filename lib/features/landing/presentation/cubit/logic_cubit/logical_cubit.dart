// ignore_for_file: empty_catches

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/core/utils/nums.dart';

import '../../../data/model/forecast_response.dart';

part 'logical_state.dart';

class LogicalCubit extends Cubit<LogicalState> {
  LogicalCubit() : super(const LogicalInitial());

  Future<bool> getLatLng() async {
    Position position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    latitude = position.latitude;
    longitude = position.longitude;
    emit(state.copyWith(
        latitude: position.latitude, longitude: position.longitude));
    return true;
  }

  Future<void> setForecast(ForecastResponse response) async {
    emit(
      state.copyWith(
        location: response.location,
        current: response.current,
        forecast: response.forecast,
      ),
    );
  }
}
