class BudgetStrings {
  // Overview
  static const String overviewTitle = 'Orçamento';
  static const String overviewEmptyTitle = 'Sem orçamento este mês';
  static const String overviewEmptySubtitle = 'Crie um orçamento para acompanhar seus gastos por categoria.';
  static const String overviewCreateButton = 'Criar orçamento';
  static const String overviewDeleteButton = 'Excluir orçamento';
  static const String overviewMonthlyIncome = 'Renda mensal';
  static const String overviewSavings = 'Reserva';
  static const String overviewSpendable = 'Disponível para gastar';
  static const String overviewTotalSpent = 'Total gasto';
  static const String overviewOf = 'de';
  static const String overviewErrorMessage = 'Erro ao carregar orçamento.';

  // Creation — Step 1
  static const String step1Title = 'Qual a sua renda mensal?';
  static const String step1IncomeLabel = 'Renda mensal';
  static const String step1IncomeHint = 'Ex: 5000';
  static const String step1SavingsLabel = 'Quanto deseja reservar?';
  static const String step1SavingsHint = 'Ex: 20';
  static const String step1SavingsSuffix = '%';
  static const String step1NextButton = 'Próximo';

  // Creation — Step 2
  static const String step2Title = 'Selecione as categorias';
  static const String step2Subtitle = 'Escolha em quais categorias deseja controlar seus gastos.';
  static const String step2NextButton = 'Próximo';

  // Creation — Step 3
  static const String step3Title = 'Defina os limites';
  static const String step3Subtitle = 'Distribua o valor disponível entre as categorias.';
  static const String step3Available = 'Disponível';
  static const String step3Remaining = 'Restante';
  static const String step3ConfirmButton = 'Criar orçamento';
  static const String step3OverBudgetError = 'O total ultrapassa o valor disponível.';
}
