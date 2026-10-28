import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/failures/failures.dart';

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
    await emit.forEach(
      _repository.watchBudgetGroup(event.period),
      onData: (result) => result.fold(
        (failure) => BudgetOverviewError(failure),
        (group) =>
            group == null ? const BudgetOverviewEmpty() : BudgetOverviewSuccess(group),
      ),
      onError: (error, _) =>
          BudgetOverviewError(UnexpectedFailure(error.toString(), null)),
    );
  }

  Future<void> _onDeleteRequested(
    BudgetOverviewDeleteRequested event,
    Emitter<BudgetOverviewState> emit,
  ) async {
    final result = await _repository.deleteBudgetGroup(event.groupId);
    result.fold(
      (failure) => emit(BudgetOverviewError(failure)),
      // O stream detecta o DELETE na tabela budget_groups via Realtime
      // e emite BudgetOverviewEmpty automaticamente.
      (_) => null,
    );
  }
}
