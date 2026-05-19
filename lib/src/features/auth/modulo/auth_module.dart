import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repository/auth_repository_impl.dart';
import '../domain/repository/auth_repository.dart';
import '../presentation/bloc/auth_bloc.dart';

@module
abstract class AuthModule {
  @lazySingleton
  AuthRepository get authRepository =>
      AuthRepositoryImpl(GetIt.instance<SupabaseClient>());

  // Sem anotação = factory (nova instância por chamada) em módulos injectable 2.x
  AuthBloc get authBloc => AuthBloc(GetIt.instance<AuthRepository>());
}
