import 'package:flutter/material.dart';
import 'package:planify/src/core/design_system/design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../transaction_dimens.dart';

class RecordsLoadingWidget extends StatelessWidget {
  const RecordsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        padding: AppSpacing.pagePadding,
        itemCount: TransactionDimens.skeletonItemCount,
        itemBuilder: (_, index) => const _TransactionSkeleton(),
      ),
    );
  }
}

class _TransactionSkeleton extends StatelessWidget {
  const _TransactionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          children: [
            Container(
              width: TransactionDimens.categoryAvatarSize,
              height: TransactionDimens.categoryAvatarSize,
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: TransactionDimens.skeletonTitleHeight,
                    width: TransactionDimens.skeletonTitleWidth,
                    color: context.colors.surfaceContainerHighest,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    height: TransactionDimens.skeletonSubtitleHeight,
                    width: TransactionDimens.skeletonSubtitleWidth,
                    color: context.colors.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
            Container(
              height: TransactionDimens.skeletonTitleHeight,
              width: TransactionDimens.skeletonSubtitleWidth,
              color: context.colors.surfaceContainerHighest,
            ),
          ],
        ),
      ),
    );
  }
}
