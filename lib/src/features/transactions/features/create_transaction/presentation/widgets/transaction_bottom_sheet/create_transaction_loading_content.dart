import 'package:flutter/material.dart';

import 'create_transaction_sheet_drag_handle.dart';
import 'create_transaction_sheet_header.dart';

class CreateTransactionLoadingContent extends StatelessWidget {
  const CreateTransactionLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CreateTransactionSheetDragHandle(),
        CreateTransactionSheetHeader(),
        Expanded(child: Center(child: CircularProgressIndicator())),
      ],
    );
  }
}
