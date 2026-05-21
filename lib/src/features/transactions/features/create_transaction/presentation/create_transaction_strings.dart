class CreateTransactionStrings {
  CreateTransactionStrings._();

  // Types
  static const String expenseType = 'expense';
  static const String incomeType = 'income';
  static const String expenseLabel = 'Expense';
  static const String incomeLabel = 'Income';

  // Submit
  static const String addRecord = 'Add Record';

  // Form fields
  static const String accountLabel = 'Account';
  static const String categoryLabel = 'Category';
  static const String dateTimeLabel = 'Date & Time';
  static const String notesLabel = 'Notes';
  static const String notesHint = 'Add a note...';

  // Pickers
  static const String selectAccount = 'Selecionar conta';
  static const String selectCategory = 'Selecionar categoria';

  // Error states
  static const String loadError = 'Erro ao carregar dados';
  static const String retry = 'Tentar novamente';

  static const List<String> monthsAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
}
