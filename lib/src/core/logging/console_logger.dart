import 'package:flutter/foundation.dart';

import '../failures/failures.dart';
import 'app_logger.dart';

class ConsoleLogger implements AppLogger {
  @override
  void debug(String message, {Map<String, dynamic> context = const {}}) {
    debugPrint('🔍 [DEBUG] $message${_fmt(context)}');
  }

  @override
  void info(String message, {Map<String, dynamic> context = const {}}) {
    debugPrint('ℹ️  [INFO]  $message${_fmt(context)}');
  }

  @override
  void warning(String message, {Map<String, dynamic> context = const {}}) {
    debugPrint('⚠️  [WARN]  $message${_fmt(context)}');
  }

  @override
  void error(
    String operation, {
    required Failure failure,
    required StackTrace stackTrace,
    Map<String, dynamic> context = const {},
  }) {
    debugPrint(
      '❌ [ERROR] [$operation] ${failure.runtimeType}: ${failure.message}${_fmt(context)}',
    );
    debugPrint(stackTrace.toString());
  }

  @override
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic> context = const {},
  }) {
    debugPrint('💀 [FATAL] $message | error: $error${_fmt(context)}');
    if (stackTrace != null) debugPrint(stackTrace.toString());
  }

  String _fmt(Map<String, dynamic> context) {
    if (context.isEmpty) return '';
    final pairs = context.entries.map((e) => '${e.key}=${e.value}').join(', ');
    return ' | $pairs';
  }
}
