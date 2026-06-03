import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../strings/spending_statistics_dimens.dart';
import '../../strings/spending_statistics_strings.dart';
import '../bloc/spending_statistics_bloc.dart';
import '../bloc/spending_statistics_event.dart';
import '../bloc/spending_statistics_state.dart';
import '../widgets/states/spending_statistics_error_widget.dart';
import '../widgets/states/spending_statistics_loading_widget.dart';
import '../widgets/states/spending_statistics_success_widget.dart';

class SpendingStatisticsPage extends StatelessWidget {
  const SpendingStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SpendingStatisticsBloc>()
        ..add(SpendingStatisticsWatchEvent(
          year: DateTime.now().year,
          month: DateTime.now().month,
          type: 'expense',
        )),
      child: const _SpendingStatisticsView(),
    );
  }
}

class _SpendingStatisticsView extends StatelessWidget {
  const _SpendingStatisticsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SpendingStatisticsStrings.pageTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SpendingStatisticsDimens.cardPadding,
          ),
          child: Column(
            children: [
              const SizedBox(height: SpendingStatisticsDimens.smallSpacing),
              const _PeriodSelector(),
              const SizedBox(height: SpendingStatisticsDimens.smallSpacing),
              const _TypeToggle(),
              const SizedBox(height: SpendingStatisticsDimens.smallSpacing),
              const Expanded(child: _StatisticsContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpendingStatisticsBloc, SpendingStatisticsState>(
      builder: (context, state) {
        final period = switch (state) {
          SpendingStatisticsLoading(:final year, :final month) =>
            (year: year, month: month),
          SpendingStatisticsSuccess(:final entity) =>
            (year: entity.year, month: entity.month),
          SpendingStatisticsError(:final year, :final month) =>
            (year: year, month: month),
          SpendingStatisticsInitial() => (
              year: DateTime.now().year,
              month: DateTime.now().month,
            ),
        };

        final bloc = context.read<SpendingStatisticsBloc>();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () =>
                  bloc.add(const SpendingStatisticsPreviousMonthEvent()),
            ),
            SizedBox(
              width: 140,
              child: Text(
                SpendingStatisticsStrings.formatMonth(
                  period.month,
                  period.year,
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () =>
                  bloc.add(const SpendingStatisticsNextMonthEvent()),
            ),
          ],
        );
      },
    );
  }
}

class _TypeToggle extends StatelessWidget {
  const _TypeToggle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpendingStatisticsBloc, SpendingStatisticsState>(
      builder: (context, state) {
        final currentType = switch (state) {
          SpendingStatisticsLoading(:final type) => type,
          SpendingStatisticsSuccess(:final entity) => entity.type,
          SpendingStatisticsError(:final type) => type,
          SpendingStatisticsInitial() => 'expense',
        };

        final bloc = context.read<SpendingStatisticsBloc>();
        final theme = Theme.of(context);

        return Container(
          height: SpendingStatisticsDimens.toggleHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(
              SpendingStatisticsDimens.toggleBorderRadius,
            ),
          ),
          child: Row(
            children: [
              _ToggleButton(
                label: SpendingStatisticsStrings.expense,
                isSelected: currentType == 'expense',
                onTap: () => bloc.add(
                  const SpendingStatisticsTypeChangedEvent('expense'),
                ),
              ),
              _ToggleButton(
                label: SpendingStatisticsStrings.income,
                isSelected: currentType == 'income',
                onTap: () => bloc.add(
                  const SpendingStatisticsTypeChangedEvent('income'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(
              SpendingStatisticsDimens.toggleBorderRadius,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatisticsContent extends StatelessWidget {
  const _StatisticsContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpendingStatisticsBloc, SpendingStatisticsState>(
      builder: (context, state) {
        return switch (state) {
          SpendingStatisticsInitial() ||
          SpendingStatisticsLoading() =>
            const SpendingStatisticsLoadingWidget(),
          SpendingStatisticsSuccess(:final entity) =>
            SpendingStatisticsSuccessWidget(entity: entity),
          SpendingStatisticsError(:final year, :final month, :final type) =>
            SpendingStatisticsErrorWidget(
              year: year,
              month: month,
              type: type,
            ),
        };
      },
    );
  }
}
