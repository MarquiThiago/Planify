import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:planify/src/features/accounts/domain/repository/account_repository.dart';

import '../../../domain/repository/category_repository.dart';
import '../../../domain/repository/transaction_repository.dart';
import '../../transaction_strings.dart';
import 'create_transaction_event.dart';
import 'create_transaction_state.dart';

class CreateTransactionBloc
    extends Bloc<CreateTransactionEvent, CreateTransactionState> {
  CreateTransactionBloc(
    this._transactionRepository,
    this._accountRepository,
    this._categoryRepository,
  ) : super(const CreateTransactionInitial()) {
    on<CreateTransactionInitialized>(_onInitialized);
    on<CreateTransactionTypeChanged>(_onTypeChanged);
    on<CreateTransactionAmountChanged>(_onAmountChanged);
    on<CreateTransactionAccountSelected>(_onAccountSelected);
    on<CreateTransactionCategorySelected>(_onCategorySelected);
    on<CreateTransactionDateTimeChanged>(_onDateTimeChanged);
    on<CreateTransactionNotesChanged>(_onNotesChanged);
    on<CreateTransactionSubmitted>(_onSubmitted);
  }

  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  final CategoryRepository _categoryRepository;

  Future<void> _onInitialized(
    CreateTransactionInitialized event,
    Emitter<CreateTransactionState> emit,
  ) async {
    emit(const CreateTransactionLoadingDeps());
    try {
      final accounts = await _accountRepository.getAccounts();
      final categories = await _categoryRepository.getCategories();
      emit(CreateTransactionReady(
        accounts: accounts,
        allCategories: categories,
        type: TransactionStrings.expenseType,
        selectedDateTime: DateTime.now(),
      ));
    } catch (e) {
      emit(CreateTransactionError(e.toString()));
    }
  }

  void _onTypeChanged(
    CreateTransactionTypeChanged event,
    Emitter<CreateTransactionState> emit,
  ) {
    final ready = state as CreateTransactionReady;
    emit(ready.copyWith(type: event.type, clearCategory: true));
  }

  void _onAmountChanged(
    CreateTransactionAmountChanged event,
    Emitter<CreateTransactionState> emit,
  ) {
    final ready = state as CreateTransactionReady;
    emit(ready.copyWith(amountRaw: event.value));
  }

  void _onAccountSelected(
    CreateTransactionAccountSelected event,
    Emitter<CreateTransactionState> emit,
  ) {
    final ready = state as CreateTransactionReady;
    emit(ready.copyWith(selectedAccount: event.account));
  }

  void _onCategorySelected(
    CreateTransactionCategorySelected event,
    Emitter<CreateTransactionState> emit,
  ) {
    final ready = state as CreateTransactionReady;
    emit(ready.copyWith(selectedCategory: event.category));
  }

  void _onDateTimeChanged(
    CreateTransactionDateTimeChanged event,
    Emitter<CreateTransactionState> emit,
  ) {
    final ready = state as CreateTransactionReady;
    emit(ready.copyWith(selectedDateTime: event.dateTime));
  }

  void _onNotesChanged(
    CreateTransactionNotesChanged event,
    Emitter<CreateTransactionState> emit,
  ) {
    final ready = state as CreateTransactionReady;
    emit(ready.copyWith(notes: event.notes));
  }

  Future<void> _onSubmitted(
    CreateTransactionSubmitted event,
    Emitter<CreateTransactionState> emit,
  ) async {
    final ready = state as CreateTransactionReady;
    if (!ready.canSubmit) return;

    emit(ready.copyWith(isSubmitting: true, clearSubmitError: true));
    try {
      await _transactionRepository.createTransaction(
        type: ready.type,
        amount: ready.amountValue,
        accountId: ready.selectedAccount!.id,
        categoryId: ready.selectedCategory!.id,
        date: ready.selectedDateTime,
        description: ready.notes.trim().isEmpty ? null : ready.notes.trim(),
      );
      emit(const CreateTransactionSuccess());
    } catch (e) {
      emit(ready.copyWith(isSubmitting: false, submitError: e.toString()));
    }
  }
}
