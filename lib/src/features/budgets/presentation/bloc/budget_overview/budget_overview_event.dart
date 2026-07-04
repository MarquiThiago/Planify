abstract class BudgetOverviewEvent {
  const BudgetOverviewEvent();
}

final class BudgetOverviewLoadRequested extends BudgetOverviewEvent {
  const BudgetOverviewLoadRequested({required this.period});

  final DateTime period;
}

final class BudgetOverviewDeleteRequested extends BudgetOverviewEvent {
  const BudgetOverviewDeleteRequested({required this.groupId, required this.period});

  final String groupId;
  final DateTime period;
}
