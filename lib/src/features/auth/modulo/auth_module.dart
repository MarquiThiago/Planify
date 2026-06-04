import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repository/auth_repository_impl.dart';
import '../domain/repository/auth_repository.dart';
import '../presentation/bloc/auth_bloc.dart';
import '../presentation/bloc/password_recovery/password_recovery_bloc.dart';

@module
abstract class AuthModule {
  @lazySingleton
  AuthRepository get authRepository =>
      AuthRepositoryImpl(GetIt.instance<SupabaseClient>());

  AuthBloc get authBloc => AuthBloc(GetIt.instance<AuthRepository>());

  PasswordRecoveryBloc get passwordRecoveryBloc =>
      PasswordRecoveryBloc(GetIt.instance<AuthRepository>());
}
