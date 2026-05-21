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
import 'package:planify/src/core/router/auth_cubit.dart' as _i712;
import 'package:planify/src/features/accounts/domain/repository/account_repository.dart'
    as _i839;
import 'package:planify/src/features/accounts/modulo/account_module.dart'
    as _i913;
import 'package:planify/src/features/accounts/presentation/bloc/account_bloc.dart'
    as _i494;
import 'package:planify/src/features/auth/domain/repository/auth_repository.dart'
    as _i129;
import 'package:planify/src/features/auth/modulo/auth_module.dart' as _i288;
import 'package:planify/src/features/auth/presentation/bloc/auth_bloc.dart'
    as _i399;
import 'package:planify/src/features/transactions/domain/repository/category_repository.dart'
    as _i238;
import 'package:planify/src/features/transactions/domain/repository/transaction_repository.dart'
    as _i539;
import 'package:planify/src/features/transactions/modulo/transaction_module.dart'
    as _i129;
import 'package:planify/src/features/transactions/presentation/bloc/create_transaction/create_transaction_bloc.dart'
    as _i742;
import 'package:planify/src/features/transactions/presentation/bloc/transaction_bloc.dart'
    as _i1026;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final accountModule = _$AccountModule();
    final authModule = _$AuthModule();
    final transactionModule = _$TransactionModule();
    final coreModule = _$CoreModule();
    gh.factory<_i494.AccountBloc>(() => accountModule.accountBloc);
    gh.factory<_i399.AuthBloc>(() => authModule.authBloc);
    gh.factory<_i1026.TransactionBloc>(() => transactionModule.transactionBloc);
    gh.factory<_i742.CreateTransactionBloc>(
      () => transactionModule.createTransactionBloc,
    );
    gh.lazySingleton<_i454.SupabaseClient>(() => coreModule.supabaseClient);
    gh.lazySingleton<_i712.AuthCubit>(() => coreModule.authCubit);
    gh.lazySingleton<_i839.AccountRepository>(
      () => accountModule.accountRepository,
    );
    gh.lazySingleton<_i129.AuthRepository>(() => authModule.authRepository);
    gh.lazySingleton<_i539.TransactionRepository>(
      () => transactionModule.transactionRepository,
    );
    gh.lazySingleton<_i238.CategoryRepository>(
      () => transactionModule.categoryRepository,
    );
    return this;
  }
}

class _$AccountModule extends _i913.AccountModule {}

class _$AuthModule extends _i288.AuthModule {}

class _$TransactionModule extends _i129.TransactionModule {}

class _$CoreModule extends _i258.CoreModule {}
