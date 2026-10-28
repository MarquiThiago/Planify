import 'package:equatable/equatable.dart';
import 'package:planify/src/core/failures/failures.dart';

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
    required this.failure,
    required this.year,
    required this.month,
  });

  final Failure failure;
  final int year;
  final int month;

  @override
  List<Object?> get props => [failure, year, month];
}
