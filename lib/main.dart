import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/core/design_system/design_system.dart';
import 'src/core/di/injection.dart';
import 'src/core/logging/app_bloc_observer.dart';
import 'src/core/logging/app_logger.dart';
import 'src/core/router/app_router.dart';
import 'src/features/theme/cubit/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const sentryDsn = String.fromEnvironment('SENTRY_DSN');

  if (kReleaseMode && sentryDsn.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDsn;
        options.environment = 'production';
        options.enableAutoSessionTracking = true;
        options.enableLogs = true;
        options.tracesSampleRate = 0.2;
      },
      appRunner: () => _bootstrap(),
    );
  } else {
    await _bootstrap();
  }
}

Future<void> _bootstrap() async {
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  await configureDependencies();

  Bloc.observer = AppBlocObserver(getIt<AppLogger>());

  _listenToDeepLinks();

  runApp(const App());
}

void _listenToDeepLinks() {
  final appLinks = AppLinks();
  appLinks.uriLinkStream.listen((uri) {
    Supabase.instance.client.auth.getSessionFromUrl(uri);
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) => MaterialApp.router(
          title: 'Planify',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
