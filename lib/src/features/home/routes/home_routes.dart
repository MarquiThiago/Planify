import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../presentation/pages/home_shell_page.dart';

final homeRoutes = <RouteBase>[
  GoRoute(
    path: Routes.home.path,
    builder: (_, _) => const HomeShellPage(),
  ),
];
