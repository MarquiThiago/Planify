import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction_entity.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

final class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

final class TransactionLoading extends TransactionState {
  const TransactionLoading({required this.year, required this.month});

  final int year;
  final int month;

  @override
  List<Object?> get props => [year, month];
}

final class TransactionSuccess extends TransactionState {
  const TransactionSuccess({
    required this.transactions,
    required this.year,
    required this.month,
  });

  final List<TransactionEntity> transactions;
  final int year;
  final int month;

  @override
  List<Object?> get props => [transactions, year, month];
}

final class TransactionError extends TransactionState {
  const TransactionError({
    required this.message,
    required this.year,
    required this.month,
  });

  final String message;
  final int year;
  final int month;

  @override
  List<Object?> get props => [message, year, month];
}
