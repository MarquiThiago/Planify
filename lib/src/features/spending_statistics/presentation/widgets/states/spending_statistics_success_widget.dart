import 'package:flutter/material.dart';
import 'package:planify/src/core/design_system/design_system.dart';

import '../../../domain/entities/spending_statistics_entity.dart';
import '../../../strings/spending_statistics_dimens.dart';
import '../../../strings/spending_statistics_strings.dart';
import '../spending_category_chips_widget.dart';
import '../spending_donut_chart_widget.dart';
import '../spending_linear_bars_widget.dart';

class SpendingStatisticsSuccessWidget extends StatelessWidget {
  const SpendingStatisticsSuccessWidget({
    super.key,
    required this.entity,
  });

  final SpendingStatisticsEntity entity;

  @override
  Widget build(BuildContext context) {
    if (entity.categories.isEmpty) {
      return _EmptyState();
    }

    final theme = Theme.of(context);
    final cardDecoration = BoxDecoration(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius:
          BorderRadius.circular(SpendingStatisticsDimens.cardBorderRadius),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: SpendingStatisticsDimens.smallSpacing),
          // ── Donut + chips card ───────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(SpendingStatisticsDimens.cardPadding),
            decoration: cardDecoration,
            child: Column(
              children: [
                const SizedBox(height: SpendingStatisticsDimens.smallSpacing),
                Center(child: SpendingDonutChartWidget(entity: entity)),
                const SizedBox(height: SpendingStatisticsDimens.sectionSpacing),
                SpendingCategoryChipsWidget(categories: entity.categories),
                const SizedBox(height: SpendingStatisticsDimens.smallSpacing),
              ],
            ),
          ),
          const SizedBox(height: SpendingStatisticsDimens.itemSpacing),
          // ── Linear bars card ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(SpendingStatisticsDimens.cardPadding),
            decoration: cardDecoration,
            child: Column(
              children: [
                const SizedBox(height: SpendingStatisticsDimens.smallSpacing),
                SpendingLinearBarsWidget(categories: entity.categories),
              ],
            ),
          ),
          const SizedBox(height: SpendingStatisticsDimens.itemSpacing),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.pie_chart_outline,
            size: AppIconSize.xxl,
            color: context.colors.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            SpendingStatisticsStrings.emptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            SpendingStatisticsStrings.emptySubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
