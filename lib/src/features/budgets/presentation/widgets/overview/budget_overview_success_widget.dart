import 'package:flutter/material.dart';

import '../../../domain/entities/budget_entity.dart';
import '../../../domain/entities/budget_group_entity.dart';
import '../../budget_dimens.dart';
import '../../budget_strings.dart';

class BudgetOverviewSuccessWidget extends StatelessWidget {
  const BudgetOverviewSuccessWidget({super.key, required this.group});

  final BudgetGroupEntity group;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(BudgetDimens.pagePadding),
      children: [
        _SummaryCard(group: group),
        const SizedBox(height: BudgetDimens.sectionSpacing),
        ...group.budgets.map(
          (budget) => Padding(
            padding: const EdgeInsets.only(bottom: BudgetDimens.itemSpacing),
            child: _BudgetCategoryCard(budget: budget),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.group});

  final BudgetGroupEntity group;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(BudgetDimens.cardPadding),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(BudgetDimens.cardRadius),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: BudgetStrings.overviewMonthlyIncome,
            value: group.monthlyIncome,
            context: context,
          ),
          const SizedBox(height: BudgetDimens.smallSpacing),
          _SummaryRow(
            label:
                '${BudgetStrings.overviewSavings} (${group.savingsPct.toStringAsFixed(0)}%)',
            value: group.savingsAmount,
            context: context,
          ),
          const Divider(height: BudgetDimens.itemSpacing),
          _SummaryRow(
            label: BudgetStrings.overviewSpendable,
            value: group.spendableAmount,
            context: context,
            bold: true,
          ),
          const SizedBox(height: BudgetDimens.smallSpacing),
          _SummaryRow(
            label: BudgetStrings.overviewTotalSpent,
            value: group.totalSpent,
            context: context,
            valueColor: group.totalSpent > group.spendableAmount
                ? colorScheme.error
                : colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.context,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final double value;
  final BuildContext context;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          'R\$ ${value.toStringAsFixed(2)}',
          style: style?.copyWith(color: valueColor),
        ),
      ],
    );
  }
}

class _BudgetCategoryCard extends StatelessWidget {
  const _BudgetCategoryCard({required this.budget});

  final BudgetEntity budget;

  Color _parseColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryColor = _parseColor(budget.categoryColor);
    final progressColor =
        budget.isOverBudget ? colorScheme.error : categoryColor;

    return Container(
      padding: const EdgeInsets.all(BudgetDimens.cardPadding),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(BudgetDimens.cardRadius),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: BudgetDimens.categoryIconSize,
                height: BudgetDimens.categoryIconSize,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.label_outline,
                  color: categoryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: BudgetDimens.smallSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.categoryName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'R\$ ${budget.spentAmount.toStringAsFixed(2)} ${BudgetStrings.overviewOf} R\$ ${budget.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                budget.isOverBudget
                    ? '-R\$ ${(budget.spentAmount - budget.amount).toStringAsFixed(2)}'
                    : 'R\$ ${budget.remainingAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: budget.isOverBudget
                          ? colorScheme.error
                          : colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: BudgetDimens.smallSpacing),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: budget.spentPercentage,
              minHeight: BudgetDimens.progressBarHeight,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }
}
