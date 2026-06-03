import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/spending_statistics_entity.dart';
import '../../strings/spending_statistics_dimens.dart';
import '../../strings/spending_statistics_strings.dart';

class SpendingDonutChartWidget extends StatelessWidget {
  const SpendingDonutChartWidget({
    super.key,
    required this.entity,
    this.size = SpendingStatisticsDimens.chartSize,
    this.centerRadius = SpendingStatisticsDimens.chartCenterRadius,
    this.sectionRadius = SpendingStatisticsDimens.chartSectionRadius,
  });

  final SpendingStatisticsEntity entity;
  final double size;
  final double centerRadius;
  final double sectionRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeLabel = entity.type == 'expense'
        ? SpendingStatisticsStrings.expense
        : SpendingStatisticsStrings.income;

    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: entity.categories.isEmpty
                  ? [
                      PieChartSectionData(
                        value: 1,
                        color: theme.colorScheme.surfaceContainerHighest,
                        radius: sectionRadius,
                        showTitle: false,
                      ),
                    ]
                  : entity.categories
                      .map(
                        (cat) => PieChartSectionData(
                          value: cat.percentage * 100,
                          color: _hexToColor(cat.categoryColor),
                          radius: sectionRadius,
                          showTitle: false,
                        ),
                      )
                      .toList(),
              sectionsSpace: SpendingStatisticsDimens.chartSectionsSpace,
              centerSpaceRadius: centerRadius,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                typeLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: SpendingStatisticsDimens.xsmallSpacing),
              Text(
                SpendingStatisticsStrings.formatCurrency(entity.totalAmount),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color _hexToColor(String hex) {
  final hexCode = hex.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
