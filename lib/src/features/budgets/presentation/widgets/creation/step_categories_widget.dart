import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../transactions/features/create_transaction/domain/entities/category_entity.dart';
import '../../bloc/budget_creation/budget_creation_bloc.dart';
import '../../bloc/budget_creation/budget_creation_event.dart';
import '../../bloc/budget_creation/budget_creation_state.dart';
import '../../budget_dimens.dart';
import '../../budget_strings.dart';

class StepCategoriesWidget extends StatelessWidget {
  const StepCategoriesWidget({super.key, required this.state});

  final BudgetCreationStep2 state;

  Color _parseColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BudgetDimens.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            BudgetStrings.step2Title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: BudgetDimens.smallSpacing),
          Text(
            BudgetStrings.step2Subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: BudgetDimens.sectionSpacing),
          Expanded(
            child: ListView.separated(
              itemCount: state.categories.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: BudgetDimens.smallSpacing),
              itemBuilder: (context, index) {
                final category = state.categories[index];
                final isSelected =
                    state.selectedCategoryIds.contains(category.id);
                return _CategoryTile(
                  category: category,
                  isSelected: isSelected,
                  categoryColor: _parseColor(category.color),
                );
              },
            ),
          ),
          const SizedBox(height: BudgetDimens.itemSpacing),
          FilledButton(
            onPressed: state.canProceed
                ? () => context
                    .read<BudgetCreationBloc>()
                    .add(const BudgetCreationCategoriesConfirmed())
                : null,
            child: const Text(BudgetStrings.step2NextButton),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.isSelected,
    required this.categoryColor,
  });

  final CategoryEntity category;
  final bool isSelected;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(BudgetDimens.cardRadius),
      onTap: () => context
          .read<BudgetCreationBloc>()
          .add(BudgetCreationCategoryToggled(category.id)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(BudgetDimens.cardPadding),
        decoration: BoxDecoration(
          color: isSelected
              ? categoryColor.withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(BudgetDimens.cardRadius),
          border: Border.all(
            color: isSelected ? categoryColor : colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: BudgetDimens.categoryIconSize,
              height: BudgetDimens.categoryIconSize,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.label_outline, color: categoryColor, size: 20),
            ),
            const SizedBox(width: BudgetDimens.smallSpacing),
            Expanded(
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: categoryColor, size: 22),
          ],
        ),
      ),
    );
  }
}
