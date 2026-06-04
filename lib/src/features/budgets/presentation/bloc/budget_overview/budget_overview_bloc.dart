import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/budget_repository.dart';
import 'budget_overview_event.dart';
import 'budget_overview_state.dart';

class BudgetOverviewBloc extends Bloc<BudgetOverviewEvent, BudgetOverviewState> {
  BudgetOverviewBloc(this._repository) : super(const BudgetOverviewInitial()) {
    on<BudgetOverviewLoadRequested>(_onLoadRequested);
    on<BudgetOverviewDeleteRequested>(_onDeleteRequested);
  }

  final BudgetRepository _repository;

  Future<void> _onLoadRequested(
    BudgetOverviewLoadRequested event,
    Emitter<BudgetOverviewState> emit,
  ) async {
    emit(const BudgetOverviewLoading());
    try {
      final group = await _repository.getBudgetGroup(event.period);
      if (group == null) {
        emit(const BudgetOverviewEmpty());
      } else {
        emit(BudgetOverviewSuccess(group));
      }
    } catch (_) {
      emit(const BudgetOverviewError('Erro ao carregar orçamento.'));
    }
  }

  Future<void> _onDeleteRequested(
    BudgetOverviewDeleteRequested event,
    Emitter<BudgetOverviewState> emit,
  ) async {
    emit(const BudgetOverviewLoading());
    try {
      await _repository.deleteBudgetGroup(event.groupId);
      emit(const BudgetOverviewEmpty());
    } catch (_) {
      emit(const BudgetOverviewError('Erro ao excluir orçamento.'));
    }
  }
}
