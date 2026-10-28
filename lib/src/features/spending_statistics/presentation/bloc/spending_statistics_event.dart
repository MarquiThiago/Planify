import 'package:equatable/equatable.dart';

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

final class SpendingStatisticsPreviousMonthEvent
    extends SpendingStatisticsEvent {
  const SpendingStatisticsPreviousMonthEvent();
}

final class SpendingStatisticsNextMonthEvent extends SpendingStatisticsEvent {
  const SpendingStatisticsNextMonthEvent();
}
