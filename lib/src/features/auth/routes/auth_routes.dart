import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../presentation/pages/login_page.dart';

final authRoutes = <RouteBase>[
  GoRoute(
    path: Routes.login.path,
    builder: (_, _) => const LoginPage(),
  ),
];
