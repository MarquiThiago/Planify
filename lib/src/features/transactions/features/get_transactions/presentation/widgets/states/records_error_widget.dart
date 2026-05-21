import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/design_system/design_system.dart';

import '../../../presentation/bloc/transaction_bloc.dart';
import '../../../presentation/bloc/transaction_event.dart';
import '../../../presentation/get_transaction_strings.dart';

class RecordsErrorWidget extends StatelessWidget {
  const RecordsErrorWidget({
    super.key,
    required this.year,
    required this.month,
  });

  final int year;
  final int month;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: AppIconSize.xxl,
            color: context.colors.error,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            GetTransactionStrings.errorMessage,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context
                .read<TransactionBloc>()
                .add(TransactionLoadEvent(year: year, month: month)),
            child: const Text(GetTransactionStrings.retry),
          ),
        ],
      ),
    );
  }
}
