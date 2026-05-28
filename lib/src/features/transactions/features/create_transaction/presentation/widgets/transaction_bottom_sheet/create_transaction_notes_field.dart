import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/design_system/design_system.dart';
import '../../bloc/create_transaction_bloc.dart';
import '../../bloc/create_transaction_event.dart';
import '../../create_transaction_strings.dart';

class CreateTransactionNotesField extends StatelessWidget {
  const CreateTransactionNotesField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colors.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CreateTransactionStrings.notesLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          TextField(
            controller: controller,
            onChanged: (value) => context.read<CreateTransactionBloc>().add(
              CreateTransactionNotesChanged(value),
            ),
            decoration: InputDecoration(
              hintText: CreateTransactionStrings.notesHint,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              isDense: true,
              contentPadding: const EdgeInsets.only(top: AppSpacing.xs),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: null,
          ),
        ],
      ),
    );
  }
}
