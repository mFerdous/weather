// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'logical_cubit.dart';

class LogicalState extends Equatable {
  final double? latitude;
  final double? longitude;
  final Location? location;
  final Current? current;
  final Forecast? forecast;

  const LogicalState({
    this.latitude,
    this.longitude,
    this.location,
    this.current,
    this.forecast,
  });

  LogicalState copyWith({
    final double? latitude,
    final double? longitude,
    final Location? location,
    final Current? current,
    final Forecast? forecast,
  }) {
    return LogicalState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      location: location ?? this.location,
      current: current ?? this.current,
      forecast: forecast ?? this.forecast,
    );
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        location,
        current,
        forecast,
      ];
}

final class LogicalInitial extends LogicalState {
  const LogicalInitial();
}
