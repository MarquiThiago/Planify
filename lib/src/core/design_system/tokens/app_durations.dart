/// Durações de animação padrão do Planify.
///
/// ```dart
/// AnimatedOpacity(duration: AppDurations.normal, ...)
/// ```
class AppDurations {
  AppDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration xSlow = Duration(milliseconds: 500);
}
