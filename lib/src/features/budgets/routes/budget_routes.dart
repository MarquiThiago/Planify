import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../presentation/pages/budget_creation_page.dart';
import '../presentation/pages/budget_overview_page.dart';

final budgetRoutes = <RouteBase>[
  GoRoute(
    path: Routes.budgetOverview.path,
    builder: (_, _) => const BudgetOverviewPage(),
  ),
  GoRoute(
    path: Routes.budgetCreation.path,
    builder: (_, _) => const BudgetCreationPage(),
  ),
];
