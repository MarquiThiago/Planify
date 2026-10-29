import 'package:equatable/equatable.dart';
import 'package:planify/src/core/failures/failures.dart';

import '../../../domain/entities/budget_group_entity.dart';

sealed class BudgetOverviewState extends Equatable {
  const BudgetOverviewState();

  @override
  List<Object?> get props => [];
}

final class BudgetOverviewInitial extends BudgetOverviewState {
  const BudgetOverviewInitial();
}

final class BudgetOverviewLoading extends BudgetOverviewState {
  const BudgetOverviewLoading();
}

final class BudgetOverviewSuccess extends BudgetOverviewState {
  const BudgetOverviewSuccess(this.group);

  final BudgetGroupEntity group;

  @override
  List<Object?> get props => [group];
}

final class BudgetOverviewEmpty extends BudgetOverviewState {
  const BudgetOverviewEmpty();
}

final class BudgetOverviewError extends BudgetOverviewState {
  const BudgetOverviewError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
