/// Enum central de rotas do app.
///
/// Uso simples:      context.go(Routes.home)
/// Uso com params:   context.goWith(Routes.transactionDetail, params: {'id': '42'})
enum Routes {
  splash('/splash'),
  login('/login'),
  home('/home'),

  // Transactions
  transactionList('/transactions'),
  transactionDetail('/transactions/:id'),

  // Statistics
  spendingStatistics('/statistics'),

  // Password recovery
  forgotPassword('/forgot-password');

  const Routes(this.path);

  /// Path literal, incluindo parâmetros no formato `:param`.
  final String path;

  /// Resolve o path substituindo parâmetros pelos valores fornecidos.
  ///
  /// Exemplo:
  /// ```dart
  /// Routes.transactionDetail.resolve({'id': '42'}) // '/transactions/42'
  /// ```
  String resolve([Map<String, String> params = const {}]) {
    var resolved = path;
    for (final entry in params.entries) {
      resolved = resolved.replaceAll(':${entry.key}', entry.value);
    }
    return resolved;
  }
}
