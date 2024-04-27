// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'logical_cubit.dart';

class LogicalState extends Equatable {
  final double? latitude;
  final double? longitude;

  const LogicalState({
    this.latitude,
    this.longitude,
  });

  LogicalState copyWith({
    final double? latitude,
    final double? longitude,
  }) {
    return LogicalState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
      ];
}

final class LogicalInitial extends LogicalState {
  const LogicalInitial();
}
