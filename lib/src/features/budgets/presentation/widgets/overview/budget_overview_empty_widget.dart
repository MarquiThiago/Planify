import 'package:flutter/material.dart';

import '../../budget_dimens.dart';
import '../../budget_strings.dart';

class BudgetOverviewEmptyWidget extends StatelessWidget {
  const BudgetOverviewEmptyWidget({super.key, required this.onCreateTap});

  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BudgetDimens.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: BudgetDimens.itemSpacing),
            Text(
              BudgetStrings.overviewEmptyTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BudgetDimens.smallSpacing),
            Text(
              BudgetStrings.overviewEmptySubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BudgetDimens.sectionSpacing),
            FilledButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add),
              label: const Text(BudgetStrings.overviewCreateButton),
            ),
          ],
        ),
      ),
    );
  }
}
