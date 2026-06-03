import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../strings/spending_statistics_dimens.dart';
import '../../strings/spending_statistics_strings.dart';
import '../bloc/spending_statistics_bloc.dart';
import '../bloc/spending_statistics_event.dart';
import '../bloc/spending_statistics_state.dart';
import 'spending_category_chips_widget.dart';
import 'spending_donut_chart_widget.dart';
import 'states/spending_statistics_error_widget.dart';
import 'states/spending_statistics_loading_widget.dart';

class SpendingHomeWidget extends StatelessWidget {
  const SpendingHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SpendingStatisticsBloc>()
        ..add(SpendingStatisticsWatchEvent(
          year: DateTime.now().year,
          month: DateTime.now().month,
          type: 'expense',
        )),
      child: const _SpendingHomeContent(),
    );
  }
}

class _SpendingHomeContent extends StatelessWidget {
  const _SpendingHomeContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(SpendingStatisticsDimens.cardPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius:
            BorderRadius.circular(SpendingStatisticsDimens.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                SpendingStatisticsStrings.homeWidgetTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () =>
                    context.push(Routes.spendingStatistics.path),
                child: Text(SpendingStatisticsStrings.viewAllButton),
              ),
            ],
          ),
          const SizedBox(height: SpendingStatisticsDimens.smallSpacing),
          BlocBuilder<SpendingStatisticsBloc, SpendingStatisticsState>(
            builder: (context, state) {
              return switch (state) {
                SpendingStatisticsInitial() ||
                SpendingStatisticsLoading() =>
                  const _HomeLoadingContent(),
                SpendingStatisticsSuccess(:final entity) => Column(
                    children: [
                      Center(
                        child: SpendingDonutChartWidget(
                          entity: entity,
                          size:
                              SpendingStatisticsDimens.homeChartSize,
                          centerRadius:
                              SpendingStatisticsDimens.homeChartCenterRadius,
                          sectionRadius:
                              SpendingStatisticsDimens.homeChartSectionRadius,
                        ),
                      ),
                      const SizedBox(
                        height: SpendingStatisticsDimens.smallSpacing,
                      ),
                      SpendingCategoryChipsWidget(
                        categories: entity.categories,
                        maxChips:
                            SpendingStatisticsDimens.homeWidgetMaxChips,
                      ),
                    ],
                  ),
                SpendingStatisticsError(:final year, :final month, :final type) =>
                  SpendingStatisticsErrorWidget(
                    year: year,
                    month: month,
                    type: type,
                  ),
              };
            },
          ),
        ],
      ),
    );
  }
}

class _HomeLoadingContent extends StatelessWidget {
  const _HomeLoadingContent();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: SpendingStatisticsDimens.homeChartSize,
      child: Center(child: SpendingStatisticsLoadingWidget()),
    );
  }
}
