abstract class BudgetCreationEvent {
  const BudgetCreationEvent();
}

final class BudgetCreationIncomeSubmitted extends BudgetCreationEvent {
  const BudgetCreationIncomeSubmitted({
    required this.monthlyIncome,
    required this.savingsPct,
  });

  final double monthlyIncome;
  final double savingsPct;
}

final class BudgetCreationCategoryToggled extends BudgetCreationEvent {
  const BudgetCreationCategoryToggled(this.categoryId);

  final String categoryId;
}

final class BudgetCreationCategoriesConfirmed extends BudgetCreationEvent {
  const BudgetCreationCategoriesConfirmed();
}

final class BudgetCreationAllocationUpdated extends BudgetCreationEvent {
  const BudgetCreationAllocationUpdated({
    required this.categoryId,
    required this.amount,
  });

  final String categoryId;
  final double amount;
}

final class BudgetCreationSubmitted extends BudgetCreationEvent {
  const BudgetCreationSubmitted({required this.period});

  final DateTime period;
}

final class BudgetCreationBackPressed extends BudgetCreationEvent {
  const BudgetCreationBackPressed();
}
