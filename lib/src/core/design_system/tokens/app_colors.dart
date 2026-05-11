import 'package:flutter/material.dart';

/// Paleta de cores raw do Planify.
///
/// ⚠️ Use estas constantes apenas para compor o [ColorScheme] em [AppTheme].
/// Em widgets, acesse sempre via [context.colors] para garantir suporte ao dark mode.
class AppColors {
  AppColors._();

  // ── Seed (gera toda a paleta Material 3 automaticamente) ─────────────────
  static const Color seed = Color(0xFF4F46E5); // Indigo 600

  // ── Indigo (brand) ────────────────────────────────────────────────────────
  static const Color indigo50 = Color(0xFFEEF2FF);
  static const Color indigo100 = Color(0xFFE0E7FF);
  static const Color indigo200 = Color(0xFFC7D2FE);
  static const Color indigo300 = Color(0xFFA5B4FC);
  static const Color indigo400 = Color(0xFF818CF8);
  static const Color indigo500 = Color(0xFF6366F1);
  static const Color indigo600 = Color(0xFF4F46E5);
  static const Color indigo700 = Color(0xFF4338CA);
  static const Color indigo800 = Color(0xFF3730A3);
  static const Color indigo900 = Color(0xFF312E81);

  // ── Neutral ───────────────────────────────────────────────────────────────
  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral900 = Color(0xFF111827);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  // ── Income / Expense (domínio financeiro) ─────────────────────────────────
  static const Color income = Color(0xFF22C55E);
  static const Color expense = Color(0xFFEF4444);
}
