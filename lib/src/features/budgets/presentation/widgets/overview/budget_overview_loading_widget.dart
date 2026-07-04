import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../budget_dimens.dart';

class BudgetOverviewLoadingWidget extends StatelessWidget {
  const BudgetOverviewLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Padding(
        padding: const EdgeInsets.all(BudgetDimens.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SkeletonSummaryCard(),
            const SizedBox(height: BudgetDimens.sectionSpacing),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: BudgetDimens.skeletonItemCount,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: BudgetDimens.itemSpacing),
              itemBuilder: (_, _) => const _SkeletonBudgetItem(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(BudgetDimens.cardRadius),
      ),
    );
  }
}

class _SkeletonBudgetItem extends StatelessWidget {
  const _SkeletonBudgetItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BudgetDimens.cardPadding),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(BudgetDimens.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: BudgetDimens.categoryIconSize,
                height: BudgetDimens.categoryIconSize,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: BudgetDimens.smallSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 120, height: 14, color: Colors.grey),
                    const SizedBox(height: 4),
                    Container(width: 80, height: 12, color: Colors.grey),
                  ],
                ),
              ),
              Container(width: 60, height: 14, color: Colors.grey),
            ],
          ),
          const SizedBox(height: BudgetDimens.smallSpacing),
          Container(
            width: double.infinity,
            height: BudgetDimens.progressBarHeight,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
