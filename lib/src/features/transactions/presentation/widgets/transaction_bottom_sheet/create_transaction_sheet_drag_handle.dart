import 'package:flutter/material.dart';
import 'package:planify/src/core/design_system/design_system.dart';

class CreateTransactionSheetDragHandle extends StatelessWidget {
  const CreateTransactionSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.md,
        right: AppSpacing.md,
        left: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40),
          Container(
            width: 60,
            height: 5,
            decoration: BoxDecoration(
              color: context.colors.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: context.colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
