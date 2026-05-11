import 'package:flutter/material.dart';

/// Escala de border radius do Planify.
///
/// ```dart
/// BorderRadius.circular(AppRadius.card)
/// BorderRadius.circular(AppRadius.button)
/// ```
class AppRadius {
  AppRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0;

  // ── Semânticos ────────────────────────────────────────────────────────────
  static const double button = md;
  static const double card = lg;
  static const double input = md;
  static const double chip = full;
  static const double dialog = xl;
  static const double bottomSheet = xl;

  // ── BorderRadius prontos ──────────────────────────────────────────────────
  static final BorderRadius buttonBR = BorderRadius.circular(button);
  static final BorderRadius cardBR = BorderRadius.circular(card);
  static final BorderRadius inputBR = BorderRadius.circular(input);
  static final BorderRadius bottomSheetBR = BorderRadius.only(
    topLeft: Radius.circular(bottomSheet),
    topRight: Radius.circular(bottomSheet),
  );
}
