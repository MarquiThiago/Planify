import 'package:equatable/equatable.dart';

import 'package:planify/src/features/accounts/domain/entities/account_entity.dart';

import '../../../domain/entities/category_entity.dart';
import '../../transaction_strings.dart';

sealed class CreateTransactionState extends Equatable {
  const CreateTransactionState();

  @override
  List<Object?> get props => [];
}

final class CreateTransactionInitial extends CreateTransactionState {
  const CreateTransactionInitial();
}

final class CreateTransactionLoadingDeps extends CreateTransactionState {
  const CreateTransactionLoadingDeps();
}

final class CreateTransactionReady extends CreateTransactionState {
  const CreateTransactionReady({
    required this.accounts,
    required this.allCategories,
    required this.type,
    this.amountRaw = '',
    this.selectedAccount,
    this.selectedCategory,
    required this.selectedDateTime,
    this.notes = '',
    this.isSubmitting = false,
    this.submitError,
  });

  final List<AccountEntity> accounts;
  final List<CategoryEntity> allCategories;
  final String type;
  final String amountRaw;
  final AccountEntity? selectedAccount;
  final CategoryEntity? selectedCategory;
  final DateTime selectedDateTime;
  final String notes;
  final bool isSubmitting;
  final String? submitError;

  List<CategoryEntity> get filteredCategories =>
      allCategories.where((c) => c.type == type).toList();

  double get amountValue => double.tryParse(amountRaw) ?? 0.0;

  String get formattedAmount {
    final prefix =
        type == TransactionStrings.incomeType ? '+' : '-';
    return '$prefix\$${amountValue.toStringAsFixed(2)}';
  }

  bool get canSubmit =>
      amountRaw.isNotEmpty &&
      amountValue > 0 &&
      selectedAccount != null &&
      selectedCategory != null;

  CreateTransactionReady copyWith({
    List<AccountEntity>? accounts,
    List<CategoryEntity>? allCategories,
    String? type,
    String? amountRaw,
    AccountEntity? selectedAccount,
    bool clearAccount = false,
    CategoryEntity? selectedCategory,
    bool clearCategory = false,
    DateTime? selectedDateTime,
    String? notes,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
  }) {
    return CreateTransactionReady(
      accounts: accounts ?? this.accounts,
      allCategories: allCategories ?? this.allCategories,
      type: type ?? this.type,
      amountRaw: amountRaw ?? this.amountRaw,
      selectedAccount:
          clearAccount ? null : (selectedAccount ?? this.selectedAccount),
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError:
          clearSubmitError ? null : (submitError ?? this.submitError),
    );
  }

  @override
  List<Object?> get props => [
        accounts,
        allCategories,
        type,
        amountRaw,
        selectedAccount,
        selectedCategory,
        selectedDateTime,
        notes,
        isSubmitting,
        submitError,
      ];
}

final class CreateTransactionSuccess extends CreateTransactionState {
  const CreateTransactionSuccess();
}

final class CreateTransactionError extends CreateTransactionState {
  const CreateTransactionError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
