import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repository/account_repository_impl.dart';
import '../domain/repository/account_repository.dart';
import '../presentation/bloc/account_bloc.dart';

@module
abstract class AccountModule {
  @lazySingleton
  AccountRepository get accountRepository =>
      AccountRepositoryImpl(GetIt.instance<SupabaseClient>());

  AccountBloc get accountBloc =>
      AccountBloc(GetIt.instance<AccountRepository>());
}
