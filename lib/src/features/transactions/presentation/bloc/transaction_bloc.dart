import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc(this._repository) : super(const TransactionInitial()) {
    on<TransactionLoadEvent>(_onLoad);
    on<TransactionPreviousMonthEvent>(_onPreviousMonth);
    on<TransactionNextMonthEvent>(_onNextMonth);
    on<TransactionChangeYearEvent>(_onChangeYear);
  }

  final TransactionRepository _repository;

  ({int year, int month}) get _currentPeriod => switch (state) {
        TransactionLoading(:final year, :final month) => (year: year, month: month),
        TransactionSuccess(:final year, :final month) => (year: year, month: month),
        TransactionError(:final year, :final month) => (year: year, month: month),
        TransactionInitial() => (
            year: DateTime.now().year,
            month: DateTime.now().month,
          ),
      };

  Future<void> _onLoad(
    TransactionLoadEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading(year: event.year, month: event.month));
    try {
      final transactions =
          await _repository.getTransactions(event.year, event.month);
      emit(TransactionSuccess(
        transactions: transactions,
        year: event.year,
        month: event.month,
      ));
    } catch (e) {
      emit(TransactionError(
        message: e.toString(),
        year: event.year,
        month: event.month,
      ));
    }
  }

  Future<void> _onPreviousMonth(
    TransactionPreviousMonthEvent event,
    Emitter<TransactionState> emit,
  ) async {
    final period = _currentPeriod;
    final newMonth = period.month == 1 ? 12 : period.month - 1;
    final newYear = period.month == 1 ? period.year - 1 : period.year;
    add(TransactionLoadEvent(year: newYear, month: newMonth));
  }

  Future<void> _onNextMonth(
    TransactionNextMonthEvent event,
    Emitter<TransactionState> emit,
  ) async {
    final period = _currentPeriod;
    final newMonth = period.month == 12 ? 1 : period.month + 1;
    final newYear = period.month == 12 ? period.year + 1 : period.year;
    add(TransactionLoadEvent(year: newYear, month: newMonth));
  }

  Future<void> _onChangeYear(
    TransactionChangeYearEvent event,
    Emitter<TransactionState> emit,
  ) async {
    add(TransactionLoadEvent(year: event.year, month: _currentPeriod.month));
  }
}
