import 'package:flutter/material.dart';

import '../../tokens/app_durations.dart';
import '../../tokens/app_icon_size.dart';
import '../../tokens/app_spacing.dart';

enum _ButtonVariant { primary, secondary, outline, ghost }

/// Botão padrão do Planify.
///
/// ```dart
/// PlanifyButton.primary(label: 'Entrar', onTap: _submit)
/// PlanifyButton.outline(label: 'Cancelar', onTap: _cancel, isFullWidth: false)
/// PlanifyButton.primary(label: 'Salvando...', onTap: null, isLoading: true)
/// ```
class PlanifyButton extends StatelessWidget {
  const PlanifyButton._({
    required this.label,
    required this.onTap,
    required _ButtonVariant variant,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  }) : _variant = variant;

  factory PlanifyButton.primary({
    required String label,
    required VoidCallback? onTap,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = true,
  }) =>
      PlanifyButton._(
        label: label,
        onTap: onTap,
        variant: _ButtonVariant.primary,
        icon: icon,
        isLoading: isLoading,
        isFullWidth: isFullWidth,
      );

  factory PlanifyButton.secondary({
    required String label,
    required VoidCallback? onTap,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = true,
  }) =>
      PlanifyButton._(
        label: label,
        onTap: onTap,
        variant: _ButtonVariant.secondary,
        icon: icon,
        isLoading: isLoading,
        isFullWidth: isFullWidth,
      );

  factory PlanifyButton.outline({
    required String label,
    required VoidCallback? onTap,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = true,
  }) =>
      PlanifyButton._(
        label: label,
        onTap: onTap,
        variant: _ButtonVariant.outline,
        icon: icon,
        isLoading: isLoading,
        isFullWidth: isFullWidth,
      );

  factory PlanifyButton.ghost({
    required String label,
    required VoidCallback? onTap,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) =>
      PlanifyButton._(
        label: label,
        onTap: onTap,
        variant: _ButtonVariant.ghost,
        icon: icon,
        isLoading: isLoading,
        isFullWidth: isFullWidth,
      );

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final _ButtonVariant _variant;

  @override
  Widget build(BuildContext context) {
    final child = _ButtonContent(
      label: label,
      icon: icon,
      isLoading: isLoading,
      variant: _variant,
    );

    final button = switch (_variant) {
      _ButtonVariant.primary => FilledButton(
          onPressed: isLoading ? null : onTap,
          child: child,
        ),
      _ButtonVariant.secondary => FilledButton.tonal(
          onPressed: isLoading ? null : onTap,
          child: child,
        ),
      _ButtonVariant.outline => OutlinedButton(
          onPressed: isLoading ? null : onTap,
          child: child,
        ),
      _ButtonVariant.ghost => TextButton(
          onPressed: isLoading ? null : onTap,
          child: child,
        ),
    };

    if (!isFullWidth) return button;

    return SizedBox(width: double.infinity, child: button);
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.isLoading,
    required this.variant,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;
  final _ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AnimatedSwitcher(
        duration: AppDurations.fast,
        child: SizedBox(
          key: const ValueKey('loading'),
          width: AppIconSize.md,
          height: AppIconSize.md,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: variant == _ButtonVariant.primary
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppIconSize.md),
          const SizedBox(width: AppSpacing.sm),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
