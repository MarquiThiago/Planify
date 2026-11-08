import 'package:sentry_flutter/sentry_flutter.dart';

import '../failures/failures.dart';
import 'app_logger.dart';

class SentryLogger implements AppLogger {
  /// no-op em produção — evita ruído no Sentry com logs de debug.
  @override
  void debug(String message, {Map<String, dynamic> context = const {}}) {}

  /// Enviado como breadcrumb estruturado na aba Logs do Sentry.
  @override
  void info(String message, {Map<String, dynamic> context = const {}}) {
    Sentry.logger.info(message, attributes: _toAttributes(context));
  }

  /// Enviado como breadcrumb estruturado na aba Logs do Sentry.
  @override
  void warning(String message, {Map<String, dynamic> context = const {}}) {
    Sentry.logger.warn(message, attributes: _toAttributes(context));
  }

  /// Captura a exceção com stack trace real via captureException —
  /// gera agrupamento, deduplicação e source maps no Sentry.
  @override
  void error(
    String operation, {
    required Failure failure,
    required StackTrace stackTrace,
    Map<String, dynamic> context = const {},
  }) {
    Sentry.captureException(
      failure,
      stackTrace: stackTrace,
      withScope: (scope) async {
        scope.setTag('operation', operation);
        scope.setTag('failure_type', failure.runtimeType.toString());
        if (failure.code != null) {
          scope.setTag('failure_code', failure.code!);
        }
        if (failure case DatabaseFailure(:final pgCode?)) {
          scope.setTag('pg_code', pgCode);
        }
        for (final entry in context.entries) {
          await scope.setContexts(entry.key, entry.value);
        }
      },
    );
  }

  /// Captura erros não tratados com nível fatal.
  @override
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic> context = const {},
  }) {
    Sentry.captureException(
      error ?? message,
      stackTrace: stackTrace,
      withScope: (scope) async {
        scope.level = SentryLevel.fatal;
        await scope.setContexts('meta', {'message': message});
        for (final entry in context.entries) {
          await scope.setContexts(entry.key, entry.value);
        }
      },
    );
  }

  Map<String, SentryAttribute> _toAttributes(Map<String, dynamic> context) {
    return context.map(
      (key, value) => MapEntry(
        key,
        switch (value) {
          int v => SentryAttribute.int(v),
          double v => SentryAttribute.double(v),
          bool v => SentryAttribute.bool(v),
          _ => SentryAttribute.string(value.toString()),
        },
      ),
    );
  }
}
