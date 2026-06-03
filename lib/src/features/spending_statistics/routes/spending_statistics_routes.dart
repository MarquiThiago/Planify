import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../presentation/pages/spending_statistics_page.dart';

class SpendingStatisticsRoutes {
  static const String statistics = 'spending-statistics';
}

final spendingStatisticsRoutes = <RouteBase>[
  GoRoute(
    path: Routes.spendingStatistics.path,
    name: SpendingStatisticsRoutes.statistics,
    builder: (_, _) => const SpendingStatisticsPage(),
  ),
];
