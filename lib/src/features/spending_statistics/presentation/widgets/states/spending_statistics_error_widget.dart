import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../presentation/bloc/spending_statistics_bloc.dart';
import '../../../presentation/bloc/spending_statistics_event.dart';
import '../../../strings/spending_statistics_dimens.dart';
import '../../../strings/spending_statistics_strings.dart';

class SpendingStatisticsErrorWidget extends StatelessWidget {
  const SpendingStatisticsErrorWidget({
    super.key,
    required this.year,
    required this.month,
    required this.type,
  });

  final int year;
  final int month;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: SpendingStatisticsDimens.smallSpacing),
          TextButton(
            onPressed: () => context.read<SpendingStatisticsBloc>().add(
                  SpendingStatisticsWatchEvent(
                    year: year,
                    month: month,
                    type: type,
                  ),
                ),
            child: const Text(SpendingStatisticsStrings.errorRetry),
          ),
        ],
      ),
    );
  }
}
