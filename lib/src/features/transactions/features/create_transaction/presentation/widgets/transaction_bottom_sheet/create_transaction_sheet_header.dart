import 'package:flutter/material.dart';
import 'package:planify/src/features/transactions/features/create_transaction/presentation/create_transaction_strings.dart';

class CreateTransactionSheetHeader extends StatelessWidget {
  const CreateTransactionSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            CreateTransactionStrings.addRecord,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
