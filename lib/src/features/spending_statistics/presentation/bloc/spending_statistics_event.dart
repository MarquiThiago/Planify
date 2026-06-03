import 'package:equatable/equatable.dart';

import '../../domain/entities/spending_statistics_entity.dart';

sealed class SpendingStatisticsEvent extends Equatable {
  const SpendingStatisticsEvent();

  @override
  List<Object?> get props => [];
}

final class SpendingStatisticsWatchEvent extends SpendingStatisticsEvent {
  const SpendingStatisticsWatchEvent({
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

final class SpendingStatisticsTypeChangedEvent extends SpendingStatisticsEvent {
  const SpendingStatisticsTypeChangedEvent(this.type);

  final String type;

  @override
  List<Object?> get props => [type];
}

final class SpendingStatisticsPreviousMonthEvent extends SpendingStatisticsEvent {
  const SpendingStatisticsPreviousMonthEvent();
}

final class SpendingStatisticsNextMonthEvent extends SpendingStatisticsEvent {
  const SpendingStatisticsNextMonthEvent();
}

// Internal event — not exposed outside the BLoC
final class SpendingStatisticsDataUpdatedEvent extends SpendingStatisticsEvent {
  const SpendingStatisticsDataUpdatedEvent(this.entity);

  final SpendingStatisticsEntity entity;

  @override
  List<Object?> get props => [entity];
}

final class SpendingStatisticsErrorReceivedEvent
    extends SpendingStatisticsEvent {
  const SpendingStatisticsErrorReceivedEvent({
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
