import 'package:flutter/material.dart';
import 'package:planify/src/core/design_system/design_system.dart';

import '../../transaction_strings.dart';

class RecordsInitialWidget extends StatelessWidget {
  const RecordsInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
            TransactionStrings.emptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            TransactionStrings.emptySubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
