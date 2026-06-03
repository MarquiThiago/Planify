import 'package:flutter/material.dart';

import '../../domain/entities/category_spending_entity.dart';
import '../../strings/spending_statistics_dimens.dart';
import '../../strings/spending_statistics_strings.dart';

class SpendingLinearBarsWidget extends StatelessWidget {
  const SpendingLinearBarsWidget({
    super.key,
    required this.categories,
  });

  final List<CategorySpendingEntity> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories
          .map((cat) => Padding(
                padding: const EdgeInsets.only(
                  bottom: SpendingStatisticsDimens.itemSpacing,
                ),
                child: _CategoryBar(category: cat),
              ))
          .toList(),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.category});

  final CategorySpendingEntity category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _hexToColor(category.categoryColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.categoryName,
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              SpendingStatisticsStrings.formatCurrency(category.totalAmount),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: SpendingStatisticsDimens.xsmallSpacing),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            SpendingStatisticsDimens.linearBarBorderRadius,
          ),
          child: LinearProgressIndicator(
            value: category.percentage,
            minHeight: SpendingStatisticsDimens.linearBarHeight,
            backgroundColor: color.withValues(
              alpha: SpendingStatisticsDimens.linearBarBackgroundOpacity,
            ),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

Color _hexToColor(String hex) {
  final hexCode = hex.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
