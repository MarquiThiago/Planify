import 'package:equatable/equatable.dart';

import '../../domain/entities/spending_statistics_entity.dart';

sealed class SpendingStatisticsState extends Equatable {
  const SpendingStatisticsState();

  @override
  List<Object?> get props => [];
}

final class SpendingStatisticsInitial extends SpendingStatisticsState {
  const SpendingStatisticsInitial();
}

final class SpendingStatisticsLoading extends SpendingStatisticsState {
  const SpendingStatisticsLoading({
    required this.year,
    required this.month,
    required this.type,
  });

  final int year;
  final int month;
  final String type;

  @override
  List<Object?> get props => [year, month, type];
}

final class SpendingStatisticsSuccess extends SpendingStatisticsState {
  const SpendingStatisticsSuccess(this.entity);

  final SpendingStatisticsEntity entity;

  @override
  List<Object?> get props => [entity];
}

final class SpendingStatisticsError extends SpendingStatisticsState {
  const SpendingStatisticsError({
    required this.message,
    required this.year,
    required this.month,
    required this.type,
  });

  final String message;
  final int year;
  final int month;
  final String type;

  @override
  List<Object?> get props => [message, year, month, type];
}
