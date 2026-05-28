import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/design_system/design_system.dart';
import 'package:planify/src/features/transactions/features/get_transactions/presentation/bloc/transaction_bloc.dart';
import 'package:planify/src/features/transactions/features/get_transactions/presentation/bloc/transaction_event.dart';
import 'package:planify/src/features/transactions/features/get_transactions/presentation/bloc/transaction_state.dart';
import 'package:planify/src/features/transactions/features/get_transactions/presentation/get_transaction_strings.dart';
import 'package:planify/src/features/transactions/features/create_transaction/presentation/widgets/transaction_bottom_sheet/create_transaction_bottom_sheet.dart';
import 'package:planify/src/features/transactions/features/get_transactions/presentation/widgets/states/records_error_widget.dart';
import 'package:planify/src/features/transactions/features/get_transactions/presentation/widgets/states/records_initial_widget.dart';
import 'package:planify/src/features/transactions/features/get_transactions/presentation/widgets/states/records_loading_widget.dart';
import 'package:planify/src/features/transactions/features/get_transactions/presentation/widgets/states/records_success_widget.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RecordsBody();
  }
}

class _RecordsBody extends StatelessWidget {
  const _RecordsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _RecordsHeader(),
            _PeriodSelector(),
            const Expanded(child: _RecordsContent()),
          ],
        ),
      ),
    );
  }
}

class _RecordsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            GetTransactionStrings.pageTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          GestureDetector(
            onTap: () {
              final transactionBloc = context.read<TransactionBloc>();
              showCreateTransactionBottomSheet(context).then((created) {
                if (created == true) {
                  transactionBloc.add(const TransactionRefreshEvent());
                }
              });
            },
            child: Container(
              width: AppIconSize.xxl,
              height: AppIconSize.xxl,
              decoration: BoxDecoration(
                color: context.colors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: context.colors.onPrimary,
                size: AppIconSize.lg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  void _showYearPicker(BuildContext context, int selectedYear) {
    final bloc = context.read<TransactionBloc>();
    final now = DateTime.now();
    final years = List.generate(6, (i) => now.year - i);

    showDialog<int>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(
          GetTransactionStrings.selectYear,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: years
            .map(
              (year) => SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(year),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text(
                    year.toString(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: year == selectedYear
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: year == selectedYear
                              ? context.colors.primary
                              : null,
                        ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ).then((pickedYear) {
      if (pickedYear != null && pickedYear != selectedYear) {
        bloc.add(TransactionChangeYearEvent(pickedYear));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final year = switch (state) {
          TransactionLoading(:final year) => year,
          TransactionSuccess(:final year) => year,
          TransactionError(:final year) => year,
          TransactionInitial() => DateTime.now().year,
        };
        final month = switch (state) {
          TransactionLoading(:final month) => month,
          TransactionSuccess(:final month) => month,
          TransactionError(:final month) => month,
          TransactionInitial() => DateTime.now().month,
        };

        final now = DateTime.now();
        final isCurrentMonth = year == now.year && month == now.month;

        return SizedBox(
          height: AppSpacing.xxl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => context
                    .read<TransactionBloc>()
                    .add(const TransactionPreviousMonthEvent()),
              ),
              GestureDetector(
                onTap: () => _showYearPicker(context, year),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${GetTransactionStrings.months[month - 1]} ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      year.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.colors.primary,
                          ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Icon(
                      Icons.arrow_drop_down,
                      color: context.colors.primary,
                      size: AppIconSize.lg,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: isCurrentMonth
                      ? context.colors.onSurfaceVariant.withValues(alpha: 0.3)
                      : null,
                ),
                onPressed: isCurrentMonth
                    ? null
                    : () => context
                        .read<TransactionBloc>()
                        .add(const TransactionNextMonthEvent()),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecordsContent extends StatelessWidget {
  const _RecordsContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return switch (state) {
          TransactionInitial() => const RecordsInitialWidget(),
          TransactionLoading() => const RecordsLoadingWidget(),
          TransactionSuccess(:final transactions) =>
            RecordsSuccessWidget(transactions: transactions),
          TransactionError(:final year, :final month) =>
            RecordsErrorWidget(year: year, month: month),
        };
      },
    );
  }
}
