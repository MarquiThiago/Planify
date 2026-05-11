/// Referência centralizada de ícones SVG do Planify
class AppSvgIcons {
  AppSvgIcons._();

  // ── Categorias ────────────────────────────────────────────────────────────
  static const String transportCategory = 'assets/icons/categories/transport.svg';
  static const String foodCategory = 'assets/icons/categories/food.svg';
  static const String entertainmentCategory = 'assets/icons/categories/entertainment.svg';
  static const String shoppingCategory = 'assets/icons/categories/shopping.svg';
  static const String healthCategory = 'assets/icons/categories/health.svg';
  static const String utilitiesCategory = 'assets/icons/categories/utilities.svg';

  // ── Transações ────────────────────────────────────────────────────────────
  static const String incomeTransaction = 'assets/icons/transactions/income.svg';
  static const String expenseTransaction = 'assets/icons/transactions/expense.svg';
  static const String transferTransaction = 'assets/icons/transactions/transfer.svg';

  // ── Ações ─────────────────────────────────────────────────────────────────
  static const String addAction = 'assets/icons/actions/add.svg';
  static const String editAction = 'assets/icons/actions/edit.svg';
  static const String deleteAction = 'assets/icons/actions/delete.svg';
  static const String filterAction = 'assets/icons/actions/filter.svg';
  static const String searchAction = 'assets/icons/actions/search.svg';
  static const String settingsAction = 'assets/icons/actions/settings.svg';

  // ── Método auxiliar para validar existência
  static bool isValidPath(String path) {
    return path.startsWith('assets/icons/');
  }
}
