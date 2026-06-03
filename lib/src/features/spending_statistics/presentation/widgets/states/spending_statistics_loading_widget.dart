import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../strings/spending_statistics_dimens.dart';

class SpendingStatisticsLoadingWidget extends StatelessWidget {
  const SpendingStatisticsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: SpendingStatisticsDimens.sectionSpacing),
            // Fake donut chart
            Container(
              height: SpendingStatisticsDimens.chartSize,
              width: SpendingStatisticsDimens.chartSize,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const _FakeDonut(),
            ),
            const SizedBox(height: SpendingStatisticsDimens.sectionSpacing),
            // Fake chips row
            Row(
              children: List.generate(
                3,
                (_) => Padding(
                  padding: const EdgeInsets.only(
                    right: SpendingStatisticsDimens.chipSpacing,
                  ),
                  child: Container(
                    width: 100,
                    height: SpendingStatisticsDimens.chipHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(
                        SpendingStatisticsDimens.chipBorderRadius,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: SpendingStatisticsDimens.sectionSpacing),
            // Fake linear bars
            ...List.generate(
              SpendingStatisticsDimens.skeletonBarCount,
              (_) => Padding(
                padding: const EdgeInsets.only(
                  bottom: SpendingStatisticsDimens.itemSpacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 80, height: 14, color: Colors.grey),
                        Container(width: 60, height: 14, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(
                      height: SpendingStatisticsDimens.xsmallSpacing,
                    ),
                    Container(
                      height: SpendingStatisticsDimens.linearBarHeight,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(
                          SpendingStatisticsDimens.linearBarBorderRadius,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FakeDonut extends StatelessWidget {
  const _FakeDonut();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 40),
      ),
    );
  }
}
