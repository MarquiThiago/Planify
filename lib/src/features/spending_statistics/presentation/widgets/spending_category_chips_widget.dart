import 'package:flutter/material.dart';
import 'package:planify/src/core/design_system/design_system.dart';

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
            .map(
              (cat) => Padding(
                padding: const EdgeInsets.only(
                  right: SpendingStatisticsDimens.chipSpacing,
                ),
                child: PlanifyCategoryChip(
                  color: _hexToColor(cat.categoryColor),
                  name: cat.categoryName,
                  sublabel: SpendingStatisticsStrings.formatCurrency(
                    cat.totalAmount,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

Color _hexToColor(String hex) {
  final hexCode = hex.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
