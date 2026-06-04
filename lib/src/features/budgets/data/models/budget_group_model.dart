import 'package:equatable/equatable.dart';

import '../../domain/entities/budget_entity.dart';
import '../../domain/entities/budget_group_entity.dart';

class BudgetGroupModel extends Equatable {
  const BudgetGroupModel({
    required this.id,
    required this.monthlyIncome,
    required this.savingsPct,
    required this.savingsAmount,
    required this.spendableAmount,
    required this.period,
  });

  final String id;
  final double monthlyIncome;
  final double savingsPct;
  final double savingsAmount;
  final double spendableAmount;
  final DateTime period;

  factory BudgetGroupModel.fromJson(Map<String, dynamic> json) {
    return BudgetGroupModel(
      id: json['group_id'] as String,
      monthlyIncome: (json['monthly_income'] as num).toDouble(),
      savingsPct: (json['savings_pct'] as num).toDouble(),
      savingsAmount: (json['savings_amount'] as num).toDouble(),
      spendableAmount: (json['spendable_amount'] as num).toDouble(),
      period: DateTime.parse(json['period'] as String),
    );
  }

  BudgetGroupEntity toEntity(List<BudgetEntity> budgets) => BudgetGroupEntity(
        id: id,
        monthlyIncome: monthlyIncome,
        savingsPct: savingsPct,
        savingsAmount: savingsAmount,
        spendableAmount: spendableAmount,
        period: period,
        budgets: budgets,
      );

  @override
  List<Object?> get props => [
        id,
        monthlyIncome,
        savingsPct,
        savingsAmount,
        spendableAmount,
        period,
      ];
}
