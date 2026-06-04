import '../entities/budget_group_entity.dart';

abstract class BudgetRepository {
  Future<void> createBudgetGroup({
    required double monthlyIncome,
    required double savingsPct,
    required DateTime period,
    required Map<String, double> categoryAllocations,
  });

  Future<BudgetGroupEntity?> getBudgetGroup(DateTime period);

  Future<void> deleteBudgetGroup(String groupId);
}
