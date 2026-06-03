import 'package:flutter/material.dart';

import '../../domain/entities/category_spending_entity.dart';
import '../../strings/spending_statistics_dimens.dart';
import '../../strings/spending_statistics_strings.dart';

class SpendingCategoryChipsWidget extends StatelessWidget {
  const SpendingCategoryChipsWidget({
    super.key,
    required this.categories,
    this.maxChips,
  });

  final List<CategorySpendingEntity> categories;

  /// When set, only the first [maxChips] items are shown.
  final int? maxChips;

  @override
  Widget build(BuildContext context) {
    final items =
        maxChips != null ? categories.take(maxChips!).toList() : categories;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items
            .map((cat) => Padding(
                  padding: const EdgeInsets.only(
                    right: SpendingStatisticsDimens.chipSpacing,
                  ),
                  child: _CategoryChip(category: cat),
                ))
            .toList(),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});

  final CategorySpendingEntity category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _hexToColor(category.categoryColor);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpendingStatisticsDimens.chipHorizontalPadding,
        vertical: SpendingStatisticsDimens.chipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius:
            BorderRadius.circular(SpendingStatisticsDimens.chipBorderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: SpendingStatisticsDimens.chipDotSize,
            height: SpendingStatisticsDimens.chipDotSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: SpendingStatisticsDimens.xsmallSpacing),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.categoryName,
                style: theme.textTheme.labelSmall,
              ),
              Text(
                SpendingStatisticsStrings.formatCurrency(category.totalAmount),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
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
