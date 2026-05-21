class TransactionStrings {
  TransactionStrings._();

  // Page
  static const String pageTitle = 'Records';
  static const String addRecord = 'Add Record';

  // Types
  static const String expenseType = 'expense';
  static const String incomeType = 'income';
  static const String expenseLabel = 'Expense';
  static const String incomeLabel = 'Income';

  // Period selector
  static const String selectYear = 'Selecionar ano';

  // Form fields
  static const String accountLabel = 'Account';
  static const String categoryLabel = 'Category';
  static const String dateTimeLabel = 'Date & Time';
  static const String notesLabel = 'Notes';
  static const String notesHint = 'Add a note...';

  // Pickers
  static const String selectAccount = 'Selecionar conta';
  static const String selectCategory = 'Selecionar categoria';

  // Error / empty states
  static const String errorMessage = 'Erro ao carregar transações';
  static const String loadError = 'Erro ao carregar dados';
  static const String emptyTitle = 'Nenhuma transação encontrada';
  static const String emptySubtitle = 'Adicione uma transação para começar';
  static const String retry = 'Tentar novamente';

  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> monthsAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
}
