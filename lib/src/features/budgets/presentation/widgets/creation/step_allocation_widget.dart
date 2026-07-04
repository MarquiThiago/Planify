import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../transactions/features/create_transaction/domain/entities/category_entity.dart';
import '../../bloc/budget_creation/budget_creation_bloc.dart';
import '../../bloc/budget_creation/budget_creation_event.dart';
import '../../bloc/budget_creation/budget_creation_state.dart';
import '../../budget_dimens.dart';
import '../../budget_strings.dart';

class StepAllocationWidget extends StatefulWidget {
  const StepAllocationWidget({super.key, required this.state});

  final BudgetCreationStep3 state;

  @override
  State<StepAllocationWidget> createState() => _StepAllocationWidgetState();
}

class _StepAllocationWidgetState extends State<StepAllocationWidget> {
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final category in widget.state.selectedCategories)
        category.id: TextEditingController(
          text: widget.state.allocations[category.id]?.toStringAsFixed(2) ?? '',
        ),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetCreationBloc, BudgetCreationState>(
      builder: (context, state) {
        final current =
            state is BudgetCreationStep3 ? state : widget.state;

        return Padding(
          padding: const EdgeInsets.all(BudgetDimens.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                BudgetStrings.step3Title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: BudgetDimens.smallSpacing),
              Text(
                BudgetStrings.step3Subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(height: BudgetDimens.itemSpacing),
              _RemainingBanner(state: current),
              const SizedBox(height: BudgetDimens.itemSpacing),
              Expanded(
                child: ListView.separated(
                  itemCount: current.selectedCategories.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: BudgetDimens.itemSpacing),
                  itemBuilder: (context, index) {
                    final category = current.selectedCategories[index];
                    return _AllocationField(
                      category: category,
                      controller: _controllers[category.id]!,
                      categoryColor: _parseColor(category.color),
                      onChanged: (value) {
                        final parsed =
                            double.tryParse(value.replaceAll(',', '.')) ?? 0;
                        context.read<BudgetCreationBloc>().add(
                              BudgetCreationAllocationUpdated(
                                categoryId: category.id,
                                amount: parsed,
                              ),
                            );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: BudgetDimens.itemSpacing),
              if (!current.canSubmit && current.remainingAmount < 0)
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: BudgetDimens.smallSpacing),
                  child: Text(
                    BudgetStrings.step3OverBudgetError,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              FilledButton(
                onPressed: current.canSubmit
                    ? () => context.read<BudgetCreationBloc>().add(
                          BudgetCreationSubmitted(period: DateTime.now()),
                        )
                    : null,
                child: const Text(BudgetStrings.step3ConfirmButton),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RemainingBanner extends StatelessWidget {
  const _RemainingBanner({required this.state});

  final BudgetCreationStep3 state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isOver = state.remainingAmount < 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BudgetDimens.cardPadding,
        vertical: BudgetDimens.smallSpacing,
      ),
      decoration: BoxDecoration(
        color: isOver
            ? colorScheme.errorContainer
            : colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(BudgetDimens.cardRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            BudgetStrings.step3Remaining,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            'R\$ ${state.remainingAmount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isOver ? colorScheme.error : colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _AllocationField extends StatelessWidget {
  const _AllocationField({
    required this.category,
    required this.controller,
    required this.categoryColor,
    required this.onChanged,
  });

  final CategoryEntity category;
  final TextEditingController controller;
  final Color categoryColor;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        const SizedBox(width: BudgetDimens.smallSpacing),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.end,
            decoration: const InputDecoration(
              prefixText: 'R\$ ',
              isDense: true,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
