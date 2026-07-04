import 'package:flutter/material.dart';

import '../../tokens/app_spacing.dart';

class PlanifyCategoryChip extends StatelessWidget {
  const PlanifyCategoryChip({
    super.key,
    required this.color,
    required this.name,
    required this.sublabel,
    this.progress,
  });

  /// The category color, used for the background tint, indicator and sublabel.
  final Color color;

  /// Category display name.
  final String name;

  /// Secondary line below the name (e.g. "R$ 430,00 gasto").
  final String sublabel;

  /// When provided, shows a circular progress ring filled to this value (0–1).
  /// When null, shows a simple colored dot instead.
  final double? progress;

  static const double _ringSize = 36.0;
  static const double _dotSize = 12.0;
  static const double _strokeWidth = 3.0;
  static const double _horizontalPadding = 12.0;
  static const double _verticalPadding = 12.0;
  static const double _borderRadius = 16.0;
  static const double _backgroundOpacity = 0.15;
  static const double _ringBackgroundOpacity = 0.2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: _backgroundOpacity),
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (progress != null)
            SizedBox(
              width: _ringSize,
              height: _ringSize,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: _strokeWidth,
                backgroundColor: color.withValues(alpha: _ringBackgroundOpacity),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeCap: StrokeCap.round,
              ),
            )
          else
            Container(
              width: _dotSize,
              height: _dotSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                sublabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
