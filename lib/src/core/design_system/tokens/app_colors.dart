import 'package:flutter/material.dart';

/// Paleta de cores raw do Planify — Design System baseado no Figma.
///
/// ⚠️ Use estas constantes apenas para compor o [ColorScheme] em [AppTheme].
/// Em widgets, acesse sempre via [context.colors] para garantir suporte ao dark mode.
class AppColors {
  AppColors._();

  // ── Seed (cor primária que gera a paleta Material 3 automaticamente) ──────
  static const Color seed = Color(0xFF7c5cff); // Roxo principal (Figma)

  // ── Primary (Roxo) ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF7c5cff);
  static const Color primaryLight = Color(0xFF9d8fff);
  static const Color primaryDark = Color(0xFF5d45cc);
  static const Color primary50 = Color(0xFFF3EFFF);
  static const Color primary100 = Color(0xFFE6DCFF);
  static const Color primary200 = Color(0xFFCDB8FF);
  static const Color primary300 = Color(0xFFB495FF);
  static const Color primary400 = Color(0xFF9d8fff);
  static const Color primary500 = Color(0xFF7c5cff);
  static const Color primary600 = Color(0xFF6a47ff);
  static const Color primary700 = Color(0xFF5d45cc);
  static const Color primary800 = Color(0xFF453399);

  // ── Secondary (Rosa/Magenta) ──────────────────────────────────────────────
  static const Color secondary = Color(0xFFff5e78);
  static const Color secondaryLight = Color(0xFFff8a9b);
  static const Color secondaryDark = Color(0xFFcc4961);
  static const Color secondary50 = Color(0xFFFFF0F5);
  static const Color secondary100 = Color(0xFFffDCE8);
  static const Color secondary200 = Color(0xFFffB8D1);
  static const Color secondary300 = Color(0xFFff95BA);
  static const Color secondary400 = Color(0xFFff8a9b);
  static const Color secondary500 = Color(0xFFff5e78);
  static const Color secondary600 = Color(0xFFff4466);
  static const Color secondary700 = Color(0xFFcc4961);

  // ── Tertiary / Info (Azul claro) ──────────────────────────────────────────
  static const Color info = Color(0xFF00d9ff);
  static const Color infoLight = Color(0xFF33e6ff);
  static const Color infoDark = Color(0xFF00a6cc);
  static const Color info50 = Color(0xFFE0FDFF);
  static const Color info100 = Color(0xFFB3F9FF);
  static const Color info200 = Color(0xFF80F5FF);
  static const Color info300 = Color(0xFF4DF1FF);
  static const Color info400 = Color(0xFF33e6ff);
  static const Color info500 = Color(0xFF00d9ff);
  static const Color info600 = Color(0xFF00b3d9);
  static const Color info700 = Color(0xFF00a6cc);

  // ── Success (Verde) ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF00d9a3);
  static const Color successLight = Color(0xFF33e6b8);
  static const Color successDark = Color(0xFF00a67d);
  static const Color success50 = Color(0xFFE8FFF7);
  static const Color success100 = Color(0xFFB3FFEE);
  static const Color success200 = Color(0xFF80FFE5);
  static const Color success300 = Color(0xFF4DFFDC);
  static const Color success400 = Color(0xFF33e6b8);
  static const Color success500 = Color(0xFF00d9a3);
  static const Color success600 = Color(0xFF00b389);
  static const Color success700 = Color(0xFF00a67d);

  // ── Warning (Laranja) ─────────────────────────────────────────────────────
  static const Color warning = Color(0xFFff9500);
  static const Color warningLight = Color(0xFFffa633);
  static const Color warningDark = Color(0xFFcc7700);
  static const Color warning50 = Color(0xFFFFF5E8);
  static const Color warning100 = Color(0xFFffddb3);
  static const Color warning200 = Color(0xFFffc680);
  static const Color warning300 = Color(0xFFffb34d);
  static const Color warning400 = Color(0xFFffa633);
  static const Color warning500 = Color(0xFFff9500);
  static const Color warning600 = Color(0xFFe67e00);
  static const Color warning700 = Color(0xFFcc7700);

  // ── Error (Vermelho) ──────────────────────────────────────────────────────
  static const Color error = Color(0xFFff5e78);
  static const Color errorLight = Color(0xFFff8a9b);
  static const Color errorDark = Color(0xFFcc4961);
  static const Color error50 = Color(0xFFFFF0F5);
  static const Color error100 = Color(0xFFffdce8);
  static const Color error200 = Color(0xFFffb8d1);
  static const Color error300 = Color(0xFFff95ba);
  static const Color error400 = Color(0xFFff8a9b);
  static const Color error500 = Color(0xFFff5e78);
  static const Color error600 = Color(0xFFff4466);
  static const Color error700 = Color(0xFFcc4961);

  // ── Neutral (Escala cinza escura para dark theme) ──────────────────────────
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF3F3F3);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color neutral300 = Color(0xFFD1D1D1);
  static const Color neutral400 = Color(0xFF808080);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF2d2d2d);
  static const Color neutral800 = Color(0xFF1a1a1a);
  static const Color neutral900 = Color(0xFF0f0f0f);

  // ── Background (Dark theme) ───────────────────────────────────────────────
  static const Color background = Color(0xFF0f0f0f); // Preto profundo
  static const Color surface = Color(0xFF1a1a1a); // Superfícies (cards)
  static const Color surfaceVariant = Color(0xFF2d2d2d);
  static const Color surfaceLight = Color(0xFF3d3d3d);

  // ── Text Colors (Dark theme) ──────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFffffff);
  static const Color textSecondary = Color(0xFFb3b3b3);
  static const Color textTertiary = Color(0xFF808080);

  // ── Borders ───────────────────────────────────────────────────────────────
  static const Color border = Color(0xFF3d3d3d);
  static const Color borderLight = Color(0xFF2d2d2d);

  // ── Semantic (Income / Expense) ───────────────────────────────────────────
  static const Color income = Color(0xFF00d9a3); // Verde
  static const Color expense = Color(0xFFff5e78); // Rosa/Vermelho
}
