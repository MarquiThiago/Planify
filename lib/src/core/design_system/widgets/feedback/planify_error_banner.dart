import 'package:flutter/material.dart';

import '../../tokens/app_icon_size.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';

/// Banner de erro inline do Planify.
///
/// ```dart
/// PlanifyErrorBanner(
///   message: 'Erro ao carregar transações',
///   onRetry: () => bloc.add(const LoadTransactions()),
/// )
/// ```
class PlanifyErrorBanner extends StatelessWidget {
  const PlanifyErrorBanner({
    super.key,
    required this.message,
    this.onRetry,
    this.onDismiss,
  });

  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: scheme.onErrorContainer,
            size: AppIconSize.md,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onErrorContainer,
                  ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: AppSpacing.xs),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: scheme.onErrorContainer,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
          if (onDismiss != null) ...[
            const SizedBox(width: AppSpacing.xs),
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(Icons.close),
              iconSize: AppIconSize.sm,
              color: scheme.onErrorContainer,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}
