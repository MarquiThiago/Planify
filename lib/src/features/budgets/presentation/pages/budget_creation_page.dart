import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/budget_creation/budget_creation_bloc.dart';
import '../bloc/budget_creation/budget_creation_event.dart';
import '../bloc/budget_creation/budget_creation_state.dart';
import '../budget_strings.dart';
import '../widgets/creation/step_allocation_widget.dart';
import '../widgets/creation/step_categories_widget.dart';
import '../widgets/creation/step_income_widget.dart';

class BudgetCreationPage extends StatelessWidget {
  const BudgetCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BudgetCreationBloc>(),
      child: const _BudgetCreationView(),
    );
  }
}

class _BudgetCreationView extends StatelessWidget {
  const _BudgetCreationView();

  int _stepIndex(BudgetCreationState state) => switch (state) {
        BudgetCreationStep1() => 0,
        BudgetCreationStep2() => 1,
        BudgetCreationStep3() => 2,
        BudgetCreationLoading() => 0,
        BudgetCreationSuccess() => 0,
        BudgetCreationError() => 0,
      };

  bool _showStepIndicator(BudgetCreationState state) =>
      state is BudgetCreationStep1 ||
      state is BudgetCreationStep2 ||
      state is BudgetCreationStep3;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetCreationBloc, BudgetCreationState>(
      listener: (context, state) {
        if (state is BudgetCreationSuccess) {
          Navigator.of(context).pop(true);
        } else if (state is BudgetCreationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: BlocBuilder<BudgetCreationBloc, BudgetCreationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(BudgetStrings.overviewCreateButton),
              leading: _buildLeading(context, state),
              bottom: _showStepIndicator(state)
                  ? _StepIndicator(currentStep: _stepIndex(state))
                  : null,
            ),
            body: switch (state) {
              BudgetCreationStep1() => const StepIncomeWidget(),
              BudgetCreationStep2 s => StepCategoriesWidget(state: s),
              BudgetCreationStep3 s => StepAllocationWidget(state: s),
              BudgetCreationLoading() =>
                const Center(child: CircularProgressIndicator()),
              BudgetCreationSuccess() => const SizedBox.shrink(),
              BudgetCreationError() => const StepIncomeWidget(),
            },
          );
        },
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, BudgetCreationState state) {
    if (state is BudgetCreationStep1 || state is BudgetCreationLoading) {
      return null;
    }
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => context
          .read<BudgetCreationBloc>()
          .add(const BudgetCreationBackPressed()),
    );
  }
}

class _StepIndicator extends StatelessWidget implements PreferredSizeWidget {
  const _StepIndicator({required this.currentStep});

  final int currentStep;

  @override
  Size get preferredSize => const Size.fromHeight(4);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: (currentStep + 1) / 3,
      minHeight: 4,
    );
  }
}
