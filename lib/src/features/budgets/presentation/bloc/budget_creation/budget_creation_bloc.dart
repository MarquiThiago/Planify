import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../transactions/features/create_transaction/domain/entities/category_entity.dart';
import '../../../../transactions/features/create_transaction/domain/repository/category_repository.dart';
import '../../../domain/repository/budget_repository.dart';
import 'budget_creation_event.dart';
import 'budget_creation_state.dart';

class BudgetCreationBloc extends Bloc<BudgetCreationEvent, BudgetCreationState> {
  BudgetCreationBloc(this._budgetRepository, this._categoryRepository)
      : super(const BudgetCreationStep1()) {
    on<BudgetCreationIncomeSubmitted>(_onIncomeSubmitted);
    on<BudgetCreationCategoryToggled>(_onCategoryToggled);
    on<BudgetCreationCategoriesConfirmed>(_onCategoriesConfirmed);
    on<BudgetCreationAllocationUpdated>(_onAllocationUpdated);
    on<BudgetCreationSubmitted>(_onSubmitted);
    on<BudgetCreationBackPressed>(_onBackPressed);
  }

  final BudgetRepository _budgetRepository;
  final CategoryRepository _categoryRepository;

  // Accumulated wizard data
  double _monthlyIncome = 0;
  double _savingsPct = 0;
  double _spendableAmount = 0;
  List<CategoryEntity> _availableCategories = [];

  Future<void> _onIncomeSubmitted(
    BudgetCreationIncomeSubmitted event,
    Emitter<BudgetCreationState> emit,
  ) async {
    emit(const BudgetCreationLoading());
    try {
      _monthlyIncome = event.monthlyIncome;
      _savingsPct = event.savingsPct;
      _spendableAmount = _monthlyIncome * (1 - _savingsPct / 100);

      _availableCategories = await _categoryRepository.getCategories();
      final expenseCategories =
          _availableCategories.where((c) => c.type == 'expense').toList();

      emit(BudgetCreationStep2(
        monthlyIncome: _monthlyIncome,
        savingsPct: _savingsPct,
        spendableAmount: _spendableAmount,
        categories: expenseCategories,
        selectedCategoryIds: const [],
      ));
    } catch (_) {
      emit(const BudgetCreationError('Erro ao carregar categorias.'));
    }
  }

  void _onCategoryToggled(
    BudgetCreationCategoryToggled event,
    Emitter<BudgetCreationState> emit,
  ) {
    final current = state;
    if (current is! BudgetCreationStep2) return;

    final selected = List<String>.from(current.selectedCategoryIds);
    if (selected.contains(event.categoryId)) {
      selected.remove(event.categoryId);
    } else {
      selected.add(event.categoryId);
    }

    emit(current.copyWith(selectedCategoryIds: selected));
  }

  void _onCategoriesConfirmed(
    BudgetCreationCategoriesConfirmed event,
    Emitter<BudgetCreationState> emit,
  ) {
    final current = state;
    if (current is! BudgetCreationStep2 || !current.canProceed) return;

    final selectedCategories = current.categories
        .where((c) => current.selectedCategoryIds.contains(c.id))
        .toList();

    // Distribute spendable amount equally as default
    final equalShare =
        double.parse((_spendableAmount / selectedCategories.length).toStringAsFixed(2));
    final allocations = {for (final c in selectedCategories) c.id: equalShare};

    emit(BudgetCreationStep3(
      spendableAmount: _spendableAmount,
      selectedCategories: selectedCategories,
      allocations: allocations,
    ));
  }

  void _onAllocationUpdated(
    BudgetCreationAllocationUpdated event,
    Emitter<BudgetCreationState> emit,
  ) {
    final current = state;
    if (current is! BudgetCreationStep3) return;

    final updated = Map<String, double>.from(current.allocations)
      ..[event.categoryId] = event.amount;

    emit(current.copyWith(allocations: updated));
  }

  Future<void> _onSubmitted(
    BudgetCreationSubmitted event,
    Emitter<BudgetCreationState> emit,
  ) async {
    final current = state;
    if (current is! BudgetCreationStep3 || !current.canSubmit) return;

    emit(const BudgetCreationLoading());
    try {
      await _budgetRepository.createBudgetGroup(
        monthlyIncome: _monthlyIncome,
        savingsPct: _savingsPct,
        period: event.period,
        categoryAllocations: current.allocations,
      );
      emit(const BudgetCreationSuccess());
    } on PostgrestException catch (e) {
      final message = e.code == '23505'
          ? 'Já existe um orçamento criado para este mês.'
          : 'Erro ao criar orçamento. Tente novamente.';
      emit(BudgetCreationError(message));
    } catch (_) {
      emit(const BudgetCreationError('Erro ao criar orçamento. Tente novamente.'));
    }
  }

  void _onBackPressed(
    BudgetCreationBackPressed event,
    Emitter<BudgetCreationState> emit,
  ) {
    final current = state;
    if (current is BudgetCreationStep2) {
      emit(const BudgetCreationStep1());
    } else if (current is BudgetCreationStep3) {
      final expenseCategories =
          _availableCategories.where((c) => c.type == 'expense').toList();
      final selectedIds =
          current.selectedCategories.map((c) => c.id).toList();
      emit(BudgetCreationStep2(
        monthlyIncome: _monthlyIncome,
        savingsPct: _savingsPct,
        spendableAmount: _spendableAmount,
        categories: expenseCategories,
        selectedCategoryIds: selectedIds,
      ));
    }
  }
}
