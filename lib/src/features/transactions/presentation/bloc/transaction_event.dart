import 'package:equatable/equatable.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

final class TransactionLoadEvent extends TransactionEvent {
  const TransactionLoadEvent({required this.year, required this.month});

  final int year;
  final int month;

  @override
  List<Object?> get props => [year, month];
}

final class TransactionPreviousMonthEvent extends TransactionEvent {
  const TransactionPreviousMonthEvent();
}

final class TransactionNextMonthEvent extends TransactionEvent {
  const TransactionNextMonthEvent();
}

final class TransactionChangeYearEvent extends TransactionEvent {
  const TransactionChangeYearEvent(this.year);

  final int year;

  @override
  List<Object?> get props => [year];
}
