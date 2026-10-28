import 'package:equatable/equatable.dart';
import 'package:planify/src/core/failures/failures.dart';

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
    required this.failure,
    required this.year,
    required this.month,
    required this.type,
  });

  final Failure failure;
  final int year;
  final int month;
  final String type;

  @override
  List<Object?> get props => [failure, year, month, type];
}
