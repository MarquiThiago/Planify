import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/design_system/design_system.dart';

import '../../bloc/create_transaction/create_transaction_bloc.dart';
import '../../bloc/create_transaction/create_transaction_event.dart';
import '../../bloc/create_transaction/create_transaction_state.dart';
import '../../transaction_strings.dart';

class CreateTransactionAmountInput extends StatelessWidget {
  const CreateTransactionAmountInput({
    super.key,
    required this.state,
    required this.typeColor,
    required this.controller,
  });

  final CreateTransactionReady state;
  final Color typeColor;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final prefix = state.type == TransactionStrings.incomeType ? '+\$' : '-\$';
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant);
    final amountStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
      color: typeColor,
      fontWeight: FontWeight.bold,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        children: [
          Text(
            state.type == TransactionStrings.expenseType
                ? TransactionStrings.expenseLabel
                : TransactionStrings.incomeLabel,
            style: labelStyle,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(prefix, style: amountStyle),
              IntrinsicWidth(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.start,
                  style: amountStyle,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: amountStyle?.copyWith(
                      color: context.colors.onSurfaceVariant.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    enabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => context
                      .read<CreateTransactionBloc>()
                      .add(CreateTransactionAmountChanged(value)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
