import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/spending_statistics_repository.dart';
import 'spending_statistics_event.dart';
import 'spending_statistics_state.dart';

class SpendingStatisticsBloc
    extends Bloc<SpendingStatisticsEvent, SpendingStatisticsState> {
  SpendingStatisticsBloc(this._repository)
      : super(const SpendingStatisticsInitial()) {
    on<SpendingStatisticsWatchEvent>(_onWatch);
    on<SpendingStatisticsTypeChangedEvent>(_onTypeChanged);
    on<SpendingStatisticsPreviousMonthEvent>(_onPreviousMonth);
    on<SpendingStatisticsNextMonthEvent>(_onNextMonth);
    on<SpendingStatisticsDataUpdatedEvent>(_onDataUpdated);
    on<SpendingStatisticsErrorReceivedEvent>(_onErrorReceived);
  }

  final SpendingStatisticsRepository _repository;
  StreamSubscription<dynamic>? _subscription;

  ({int year, int month, String type}) get _currentPeriod => switch (state) {
        SpendingStatisticsLoading(:final year, :final month, :final type) =>
          (year: year, month: month, type: type),
        SpendingStatisticsSuccess(:final entity) => (
            year: entity.year,
            month: entity.month,
            type: entity.type,
          ),
        SpendingStatisticsError(:final year, :final month, :final type) =>
          (year: year, month: month, type: type),
        SpendingStatisticsInitial() => (
            year: DateTime.now().year,
            month: DateTime.now().month,
            type: 'expense',
          ),
      };

  Future<void> _onWatch(
    SpendingStatisticsWatchEvent event,
    Emitter<SpendingStatisticsState> emit,
  ) async {
    await _subscription?.cancel();
    emit(SpendingStatisticsLoading(
      year: event.year,
      month: event.month,
      type: event.type,
    ));

    _subscription = _repository
        .watchSpendingStatistics(
          year: event.year,
          month: event.month,
          type: event.type,
        )
        .listen(
          (entity) => add(SpendingStatisticsDataUpdatedEvent(entity)),
          onError: (Object error) => add(SpendingStatisticsErrorReceivedEvent(
            message: error.toString(),
            year: event.year,
            month: event.month,
            type: event.type,
          )),
        );
  }

  Future<void> _onTypeChanged(
    SpendingStatisticsTypeChangedEvent event,
    Emitter<SpendingStatisticsState> emit,
  ) async {
    final period = _currentPeriod;
    add(SpendingStatisticsWatchEvent(
      year: period.year,
      month: period.month,
      type: event.type,
    ));
  }

  Future<void> _onPreviousMonth(
    SpendingStatisticsPreviousMonthEvent event,
    Emitter<SpendingStatisticsState> emit,
  ) async {
    final period = _currentPeriod;
    final newMonth = period.month == 1 ? 12 : period.month - 1;
    final newYear = period.month == 1 ? period.year - 1 : period.year;
    add(SpendingStatisticsWatchEvent(
      year: newYear,
      month: newMonth,
      type: period.type,
    ));
  }

  Future<void> _onNextMonth(
    SpendingStatisticsNextMonthEvent event,
    Emitter<SpendingStatisticsState> emit,
  ) async {
    final period = _currentPeriod;
    final newMonth = period.month == 12 ? 1 : period.month + 1;
    final newYear = period.month == 12 ? period.year + 1 : period.year;
    add(SpendingStatisticsWatchEvent(
      year: newYear,
      month: newMonth,
      type: period.type,
    ));
  }

  Future<void> _onDataUpdated(
    SpendingStatisticsDataUpdatedEvent event,
    Emitter<SpendingStatisticsState> emit,
  ) async {
    emit(SpendingStatisticsSuccess(event.entity));
  }

  Future<void> _onErrorReceived(
    SpendingStatisticsErrorReceivedEvent event,
    Emitter<SpendingStatisticsState> emit,
  ) async {
    emit(SpendingStatisticsError(
      message: event.message,
      year: event.year,
      month: event.month,
      type: event.type,
    ));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
