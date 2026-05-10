// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:planify/src/core/di/injection.dart' as _i258;
import 'package:planify/src/core/router/auth_change_notifier.dart' as _i805;
import 'package:planify/src/features/auth/domain/repository/auth_repository.dart'
    as _i129;
import 'package:planify/src/features/auth/modulo/auth_module.dart' as _i288;
import 'package:planify/src/features/auth/presentation/bloc/auth_bloc.dart'
    as _i399;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final authModule = _$AuthModule();
    final coreModule = _$CoreModule();
    gh.factory<_i399.AuthBloc>(() => authModule.authBloc);
    gh.lazySingleton<_i454.SupabaseClient>(() => coreModule.supabaseClient);
    gh.lazySingleton<_i805.AuthChangeNotifier>(
      () => coreModule.authChangeNotifier,
    );
    gh.lazySingleton<_i129.AuthRepository>(() => authModule.authRepository);
    return this;
  }
}

class _$AuthModule extends _i288.AuthModule {}

class _$CoreModule extends _i258.CoreModule {}
