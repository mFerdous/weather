// ignore_for_file: empty_catches

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'logical_state.dart';

class LogicalCubit extends Cubit<LogicalState> {
  LogicalCubit() : super(const LogicalInitial());

  Future<void> getLatLng() async {
    Position position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    emit(state.copyWith(
        latitude: position.latitude, longitude: position.longitude));
  }
}
