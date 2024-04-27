// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/forecast_response.dart';
import '../../domain/usecase/forecast_usecase.dart';

part 'forecast_state.dart';

class ForecastCubit extends Cubit<ForecastState> {
  final ForecastUsecase weatherForecastUsecase;

  ForecastCubit({
    required this.weatherForecastUsecase,
  }) : super(ForecastInitial());

  Future<void> getForecast() async {
    try {
      emit(ForecastLoading());

      final responseModel = await weatherForecastUsecase();

      log('message: ${jsonEncode(responseModel)}');
      emit(ForecastSucceed(model: responseModel));

    } catch (ex, strackTrace) {
      emit(ForecastFailed(ex, strackTrace));
    }
  }
}
