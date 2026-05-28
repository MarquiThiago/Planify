import 'package:flutter/material.dart';
import 'package:planify/src/core/design_system/design_system.dart';

import '../../../domain/entities/transaction_entity.dart';
import '../../../presentation/get_transaction_strings.dart';

class RecordsSuccessWidget extends StatelessWidget {
  const RecordsSuccessWidget({super.key, required this.transactions});

  final List<TransactionEntity> transactions;

  Map<String, List<TransactionEntity>> _groupByDate(
    List<TransactionEntity> items,
  ) {
    final grouped = <String, List<TransactionEntity>>{};
    for (final t in items) {
      final key =
          '${t.date.day} ${GetTransactionStrings.months[t.date.month - 1]} ${t.date.year}';
      grouped.putIfAbsent(key, () => []).add(t);
    }
    return grouped;
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  String _formatAmount(TransactionEntity t) {
    final prefix = t.type == GetTransactionStrings.incomeType ? '+' : '-';
    return '$prefix\$${t.amount.toStringAsFixed(2)}';
  }

  Color _amountColor(TransactionEntity t) {
    return t.type == GetTransactionStrings.incomeType
        ? AppColors.income
        : AppColors.expense;
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: AppIconSize.xxl,
              color: context.colors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              GetTransactionStrings.emptyTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              GetTransactionStrings.emptySubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    final grouped = _groupByDate(transactions);
    final dateKeys = grouped.keys.toList();

    return ListView.builder(
      padding: AppSpacing.pagePadding,
      itemCount: dateKeys.length,
      itemBuilder: (context, index) {
        final dateKey = dateKeys[index];
        final dayTransactions = grouped[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: AppSpacing.sm,
                top: AppSpacing.sm,
              ),
              child: Text(
                dateKey,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ...dayTransactions.reversed.map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: PlanifyTransactionItem(
                  title: t.categoryName,
                  subtitle: t.accountName,
                  amount: _formatAmount(t),
                  icon: Icons.label_outline,
                  iconColor: _parseColor(t.categoryColor),
                  amountColor: _amountColor(t),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
