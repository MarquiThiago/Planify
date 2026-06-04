import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../presentation/pages/forgot_password_page.dart';
import '../presentation/pages/login_page.dart';

final authRoutes = <RouteBase>[
  GoRoute(
    path: Routes.login.path,
    builder: (_, _) => const LoginPage(),
  ),
  GoRoute(
    path: Routes.forgotPassword.path,
    builder: (_, _) => const ForgotPasswordPage(),
  ),
];
