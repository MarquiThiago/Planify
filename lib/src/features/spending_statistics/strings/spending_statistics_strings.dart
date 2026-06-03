class SpendingStatisticsStrings {
  static const String pageTitle = 'Estatísticas';
  static const String homeWidgetTitle = 'Categorias';
  static const String viewAllButton = 'Ver tudo';
  static const String expense = 'Despesa';
  static const String income = 'Receita';
  static const String emptyTitle = 'Nenhum lançamento encontrado';
  static const String emptySubtitle = 'Adicione uma transação para começar';
  static const String errorRetry = 'Tentar novamente';

  static const List<String> monthNames = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  static String formatMonth(int month, int year) =>
      '${monthNames[month - 1].toUpperCase()} $year';

  static String formatCurrency(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final intStr = parts[0];
    final decStr = parts[1];
    final buffer = StringBuffer();
    for (var i = 0; i < intStr.length; i++) {
      if (i > 0 && (intStr.length - i) % 3 == 0) buffer.write('.');
      buffer.write(intStr[i]);
    }
    return 'R\$ $buffer,$decStr';
  }
}
