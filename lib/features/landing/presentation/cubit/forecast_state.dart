part of 'forecast_cubit.dart';

abstract class ForecastState extends Equatable {
  const ForecastState();

  @override
  List<Object> get props => [];
}

class ForecastInitial extends ForecastState {}

class ForecastLoading extends ForecastState {}

class ForecastFailed extends ForecastState {
  final StackTrace stackTrace;
  final Object exception;

  const ForecastFailed(this.exception, this.stackTrace);
}

class ForecastSucceed extends ForecastState {
  final ForecastResponse model;

  const ForecastSucceed({
    required this.model,
  });
}

