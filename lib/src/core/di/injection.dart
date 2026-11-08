import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../logging/app_logger.dart';
import '../logging/console_logger.dart';
import '../logging/sentry_logger.dart';
import '../router/auth_cubit.dart';
import 'injection.config.dart';

/// Instância global do GetIt — use `getIt<T>()` em qualquer lugar do app.
final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

/// Módulo responsável por registrar dependências externas (Supabase, etc.)
/// que precisam de inicialização assíncrona antes do app subir.
@module
abstract class CoreModule {
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @lazySingleton
  AppLogger get appLogger =>
      kReleaseMode ? SentryLogger() : ConsoleLogger();

  @lazySingleton
  AuthCubit get authCubit => AuthCubit(GetIt.instance<SupabaseClient>());
}
