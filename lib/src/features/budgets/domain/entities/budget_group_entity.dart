import 'package:equatable/equatable.dart';

import 'budget_entity.dart';

class BudgetGroupEntity extends Equatable {
  const BudgetGroupEntity({
    required this.id,
    required this.monthlyIncome,
    required this.savingsPct,
    required this.savingsAmount,
    required this.spendableAmount,
    required this.period,
    required this.budgets,
  });

  final String id;
  final double monthlyIncome;
  final double savingsPct;
  final double savingsAmount;
  final double spendableAmount;
  final DateTime period;
  final List<BudgetEntity> budgets;

  double get totalSpent => budgets.fold(0, (sum, b) => sum + b.spentAmount);
  double get totalBudgeted => budgets.fold(0, (sum, b) => sum + b.amount);

  @override
  List<Object?> get props => [
        id,
        monthlyIncome,
        savingsPct,
        savingsAmount,
        spendableAmount,
        period,
        budgets,
      ];
}
