import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/design_system/design_system.dart';

import '../../bloc/create_transaction/create_transaction_bloc.dart';
import '../../bloc/create_transaction/create_transaction_event.dart';
import '../../transaction_strings.dart';
import 'create_transaction_sheet_drag_handle.dart';
import 'create_transaction_sheet_header.dart';

class CreateTransactionErrorContent extends StatelessWidget {
  const CreateTransactionErrorContent({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CreateTransactionSheetDragHandle(),
        const CreateTransactionSheetHeader(),
        Expanded(
          child: Center(
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
                  TransactionStrings.loadError,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => context.read<CreateTransactionBloc>().add(
                    const CreateTransactionInitialized(),
                  ),
                  child: Text(TransactionStrings.retry),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
