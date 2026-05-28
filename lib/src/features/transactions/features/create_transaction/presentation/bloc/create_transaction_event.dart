import 'package:equatable/equatable.dart';
import 'package:planify/src/features/accounts/domain/entities/account_entity.dart';

import '../../domain/entities/category_entity.dart';

sealed class CreateTransactionEvent extends Equatable {
  const CreateTransactionEvent();

  @override
  List<Object?> get props => [];
}

final class CreateTransactionInitialized extends CreateTransactionEvent {
  const CreateTransactionInitialized();
}

final class CreateTransactionTypeChanged extends CreateTransactionEvent {
  const CreateTransactionTypeChanged(this.type);

  final String type;

  @override
  List<Object?> get props => [type];
}

final class CreateTransactionAmountChanged extends CreateTransactionEvent {
  const CreateTransactionAmountChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class CreateTransactionAccountSelected extends CreateTransactionEvent {
  const CreateTransactionAccountSelected(this.account);

  final AccountEntity account;

  @override
  List<Object?> get props => [account];
}

final class CreateTransactionCategorySelected extends CreateTransactionEvent {
  const CreateTransactionCategorySelected(this.category);

  final CategoryEntity category;

  @override
  List<Object?> get props => [category];
}

final class CreateTransactionDateTimeChanged extends CreateTransactionEvent {
  const CreateTransactionDateTimeChanged(this.dateTime);

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class CreateTransactionNotesChanged extends CreateTransactionEvent {
  const CreateTransactionNotesChanged(this.notes);

  final String notes;

  @override
  List<Object?> get props => [notes];
}

final class CreateTransactionSubmitted extends CreateTransactionEvent {
  const CreateTransactionSubmitted();
}
