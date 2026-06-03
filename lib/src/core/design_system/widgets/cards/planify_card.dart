import 'package:flutter/material.dart';

import '../../tokens/app_durations.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';

/// Card padrão do Planify.
///
/// ```dart
/// PlanifyCard(child: Text('Conteúdo'))
///
/// PlanifyCard.clickable(
///   onTap: () {},
///   child: Text('Clicável'),
/// )
/// ```
class PlanifyCard extends StatelessWidget {
  const PlanifyCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.cardPadding,
    this.onTap,
  });

  factory PlanifyCard.clickable({
    Key? key,
    required Widget child,
    required VoidCallback onTap,
    EdgeInsetsGeometry padding = AppSpacing.cardPadding,
  }) =>
      PlanifyCard(
        key: key,
        onTap: onTap,
        padding: padding,
        child: child,
      );

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: AppDurations.fast,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: AppRadius.cardBR,
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: AppRadius.cardBR,
              child: Padding(padding: padding, child: child),
            )
          : Padding(padding: padding, child: child),
    );
  }
}
