import '../failures/failures.dart';

abstract interface class AppLogger {
  /// Operações iniciadas/concluídas. Apenas dev — não enviado ao Sentry.
  void debug(String message, {Map<String, dynamic> context});

  /// Ações relevantes do usuário (login, criação de transação, etc.).
  void info(String message, {Map<String, dynamic> context});

  /// Problemas recuperáveis ou comportamento degradado.
  void warning(String message, {Map<String, dynamic> context});

  /// Exceção capturada — sempre inclui Failure + StackTrace.
  void error(
    String operation, {
    required Failure failure,
    required StackTrace stackTrace,
    Map<String, dynamic> context,
  });

  /// Exceção não capturada ou crash — disparado pelo AppBlocObserver.
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic> context,
  });
}
