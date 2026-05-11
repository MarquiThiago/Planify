import 'package:flutter/material.dart';

/// Extensions de acesso fluente ao tema via [BuildContext].
///
/// ```dart
/// Text('Olá', style: context.textTheme.titleLarge)
/// Container(color: context.colors.primary)
/// ```
extension BuildContextThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
