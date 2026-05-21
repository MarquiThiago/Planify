import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/design_system/design_system.dart';
import 'package:planify/src/core/di/injection.dart';

import '../../bloc/create_transaction/create_transaction_bloc.dart';
import '../../bloc/create_transaction/create_transaction_event.dart';
import '../../bloc/create_transaction/create_transaction_state.dart';
import '../../transaction_dimens.dart';
import 'create_transaction_error_content.dart';
import 'create_transaction_form_content.dart';
import 'create_transaction_loading_content.dart';

/// Shows the create transaction bottom sheet.
/// Returns [true] if a transaction was successfully created.
Future<bool?> showCreateTransactionBottomSheet(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;

  return showModalBottomSheet<bool>(
    showDragHandle: false,
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => BlocProvider(
      create: (_) =>
          getIt<CreateTransactionBloc>()
            ..add(const CreateTransactionInitialized()),
      child: SizedBox(
        height: screenHeight * TransactionDimens.sheetHeightFactor,
        child: const _CreateTransactionSheet(),
      ),
    ),
  );
}

class _CreateTransactionSheet extends StatefulWidget {
  const _CreateTransactionSheet();

  @override
  State<_CreateTransactionSheet> createState() =>
      _CreateTransactionSheetState();
}

class _CreateTransactionSheetState extends State<_CreateTransactionSheet> {
  final _notesController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTransactionBloc, CreateTransactionState>(
      listener: (context, state) {
        if (state is CreateTransactionReady && state.submitError != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.submitError!)));
        }
        if (state is CreateTransactionSuccess) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) => switch (state) {
        CreateTransactionInitial() ||
        CreateTransactionLoadingDeps() => const CreateTransactionLoadingContent(),
        CreateTransactionReady() => CreateTransactionFormContent(
          state: state,
          notesController: _notesController,
          amountController: _amountController,
        ),
        CreateTransactionError(:final message) => CreateTransactionErrorContent(
          message: message,
        ),
        CreateTransactionSuccess() => const SizedBox.shrink(),
      },
    );
  }
}
