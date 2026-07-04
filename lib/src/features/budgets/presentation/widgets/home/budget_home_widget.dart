import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/design_system/design_system.dart';
import '../../../../../core/router/routes.dart';
import '../../../domain/entities/budget_group_entity.dart';
import '../../bloc/budget_overview/budget_overview_bloc.dart';
import '../../bloc/budget_overview/budget_overview_event.dart';
import '../../bloc/budget_overview/budget_overview_state.dart';
import '../../budget_dimens.dart';
import '../../budget_strings.dart';

class BudgetHomeWidget extends StatelessWidget {
  const BudgetHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<BudgetOverviewBloc>()
            ..add(BudgetOverviewLoadRequested(period: DateTime.now())),
      child: const _BudgetHomeContent(),
    );
  }
}

class _BudgetHomeContent extends StatelessWidget {
  const _BudgetHomeContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(BudgetDimens.cardPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(BudgetDimens.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                BudgetStrings.overviewTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const _ViewAllButton(),
            ],
          ),
          const SizedBox(height: BudgetDimens.smallSpacing),
          BlocBuilder<BudgetOverviewBloc, BudgetOverviewState>(
            builder: (context, state) {
              return switch (state) {
                BudgetOverviewInitial() ||
                BudgetOverviewLoading() => const _BudgetHomeLoading(),
                BudgetOverviewSuccess(:final group) => _BudgetHomeSummary(
                  group: group,
                ),
                BudgetOverviewEmpty() => const _BudgetHomeEmpty(),
                BudgetOverviewError() => const SizedBox.shrink(),
              };
            },
          ),
        ],
      ),
    );
  }
}

class _ViewAllButton extends StatelessWidget {
  const _ViewAllButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push(Routes.budgetOverview.path),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: BudgetDimens.homeButtonHorizontalPadding,
          vertical: BudgetDimens.homeButtonVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(BudgetDimens.homeButtonRadius),
        ),
        child: Text(
          BudgetStrings.homeViewAll,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _BudgetHomeSummary extends StatelessWidget {
  const _BudgetHomeSummary({required this.group});

  final BudgetGroupEntity group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = group.spendableAmount - group.totalSpent;
    final isOverBudget = group.totalSpent > group.spendableAmount;
    final progress = group.spendableAmount > 0
        ? (group.totalSpent / group.spendableAmount).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              _formatCurrency(remaining.abs()),
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isOverBudget
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              BudgetStrings.homeLeft,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Text(
          '-${_formatCurrency(group.totalSpent)} ${BudgetStrings.homeSpentThisMonth}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: BudgetDimens.itemSpacing),
        ClipRRect(
          borderRadius: BorderRadius.circular(BudgetDimens.progressBarHeight),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: BudgetDimens.progressBarHeight,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              isOverBudget
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
          ),
        ),
        if (group.budgets.isNotEmpty) ...[
          const SizedBox(height: BudgetDimens.itemSpacing),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: group.budgets
                  .map(
                    (budget) => Padding(
                      padding: const EdgeInsets.only(
                        right: BudgetDimens.smallSpacing,
                      ),
                      child: PlanifyCategoryChip(
                        color: _parseColor(budget.categoryColor),
                        name: budget.categoryName,
                        progress: budget.spentPercentage,
                        sublabel:
                            '${_formatCurrency(budget.spentAmount)} ${BudgetStrings.homeSpent}',
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  String _formatCurrency(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final intStr = parts[0];
    final decStr = parts[1];
    final buffer = StringBuffer();
    for (var i = 0; i < intStr.length; i++) {
      if (i > 0 && (intStr.length - i) % 3 == 0) buffer.write('.');
      buffer.write(intStr[i]);
    }
    return 'R\$ $buffer,$decStr';
  }
}

class _BudgetHomeEmpty extends StatelessWidget {
  const _BudgetHomeEmpty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BudgetDimens.itemSpacing),
      child: Text(
        BudgetStrings.overviewEmptyTitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _BudgetHomeLoading extends StatelessWidget {
  const _BudgetHomeLoading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColor = theme.colorScheme.onSurface;

    return Skeletonizer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Container(
                width: 160,
                height: 36,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                width: 60,
                height: 16,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: BudgetDimens.smallSpacing),
          Container(
            width: 140,
            height: 14,
            decoration: BoxDecoration(
              color: shimmerColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: BudgetDimens.itemSpacing),
          Container(
            height: BudgetDimens.progressBarHeight,
            decoration: BoxDecoration(
              color: shimmerColor,
              borderRadius: BorderRadius.circular(
                BudgetDimens.progressBarHeight,
              ),
            ),
          ),
          const SizedBox(height: BudgetDimens.itemSpacing),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                3,
                (_) => Padding(
                  padding: const EdgeInsets.only(
                    right: BudgetDimens.smallSpacing,
                  ),
                  child: Container(
                    width: 160,
                    height: 60,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(
                        BudgetDimens.chipRadius,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
