import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/routes.dart';
import '../bloc/budget_overview/budget_overview_bloc.dart';
import '../bloc/budget_overview/budget_overview_event.dart';
import '../bloc/budget_overview/budget_overview_state.dart';
import '../budget_strings.dart';
import '../widgets/overview/budget_overview_empty_widget.dart';
import '../widgets/overview/budget_overview_error_widget.dart';
import '../widgets/overview/budget_overview_loading_widget.dart';
import '../widgets/overview/budget_overview_success_widget.dart';

class BudgetOverviewPage extends StatelessWidget {
  const BudgetOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BudgetOverviewBloc>()
        ..add(BudgetOverviewLoadRequested(period: DateTime.now())),
      child: const _BudgetOverviewView(),
    );
  }
}

class _BudgetOverviewView extends StatelessWidget {
  const _BudgetOverviewView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(BudgetStrings.overviewTitle),
        actions: [
          BlocBuilder<BudgetOverviewBloc, BudgetOverviewState>(
            builder: (context, state) {
              if (state is! BudgetOverviewSuccess) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: BudgetStrings.overviewDeleteButton,
                onPressed: () => _confirmDelete(context, state.group.id),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<BudgetOverviewBloc, BudgetOverviewState>(
        builder: (context, state) {
          return switch (state) {
            BudgetOverviewInitial() => const SizedBox.shrink(),
            BudgetOverviewLoading() => const BudgetOverviewLoadingWidget(),
            BudgetOverviewSuccess(:final group) =>
              BudgetOverviewSuccessWidget(group: group),
            BudgetOverviewEmpty() => BudgetOverviewEmptyWidget(
                onCreateTap: () => context.push(Routes.budgetCreation.path),
              ),
            BudgetOverviewError(:final message) =>
              BudgetOverviewErrorWidget(message: message),
          };
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String groupId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(BudgetStrings.overviewDeleteButton),
        content: const Text('Tem certeza que deseja excluir o orçamento deste mês?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<BudgetOverviewBloc>().add(
                    BudgetOverviewDeleteRequested(
                      groupId: groupId,
                      period: DateTime.now(),
                    ),
                  );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
