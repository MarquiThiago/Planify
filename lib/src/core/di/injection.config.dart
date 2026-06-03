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
import 'package:planify/src/features/spending_statistics/domain/repository/spending_statistics_repository.dart'
    as _i374;
import 'package:planify/src/features/spending_statistics/modulo/spending_statistics_module.dart'
    as _i1004;
import 'package:planify/src/features/spending_statistics/presentation/bloc/spending_statistics_bloc.dart'
    as _i70;
import 'package:planify/src/features/transactions/features/create_transaction/domain/repository/category_repository.dart'
    as _i598;
import 'package:planify/src/features/transactions/features/create_transaction/domain/repository/create_transaction_repository.dart'
    as _i166;
import 'package:planify/src/features/transactions/features/create_transaction/modulo/create_transaction_module.dart'
    as _i559;
import 'package:planify/src/features/transactions/features/create_transaction/presentation/bloc/create_transaction_bloc.dart'
    as _i465;
import 'package:planify/src/features/transactions/features/get_transactions/domain/repository/get_transaction_repository.dart'
    as _i550;
import 'package:planify/src/features/transactions/features/get_transactions/modulo/get_transaction_module.dart'
    as _i363;
import 'package:planify/src/features/transactions/features/get_transactions/presentation/bloc/transaction_bloc.dart'
    as _i1060;
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
    final spendingStatisticsModule = _$SpendingStatisticsModule();
    final createTransactionModule = _$CreateTransactionModule();
    final getTransactionModule = _$GetTransactionModule();
    final coreModule = _$CoreModule();
    gh.factory<_i494.AccountBloc>(() => accountModule.accountBloc);
    gh.factory<_i399.AuthBloc>(() => authModule.authBloc);
    gh.factory<_i70.SpendingStatisticsBloc>(
      () => spendingStatisticsModule.spendingStatisticsBloc,
    );
    gh.factory<_i465.CreateTransactionBloc>(
      () => createTransactionModule.createTransactionBloc,
    );
    gh.factory<_i1060.TransactionBloc>(
      () => getTransactionModule.transactionBloc,
    );
    gh.lazySingleton<_i454.SupabaseClient>(() => coreModule.supabaseClient);
    gh.lazySingleton<_i712.AuthCubit>(() => coreModule.authCubit);
    gh.lazySingleton<_i839.AccountRepository>(
      () => accountModule.accountRepository,
    );
    gh.lazySingleton<_i129.AuthRepository>(() => authModule.authRepository);
    gh.lazySingleton<_i374.SpendingStatisticsRepository>(
      () => spendingStatisticsModule.spendingStatisticsRepository,
    );
    gh.lazySingleton<_i166.CreateTransactionRepository>(
      () => createTransactionModule.createTransactionRepository,
    );
    gh.lazySingleton<_i598.CategoryRepository>(
      () => createTransactionModule.categoryRepository,
    );
    gh.lazySingleton<_i550.GetTransactionRepository>(
      () => getTransactionModule.getTransactionRepository,
    );
    return this;
  }
}

class _$AccountModule extends _i913.AccountModule {}

class _$AuthModule extends _i288.AuthModule {}

class _$SpendingStatisticsModule extends _i1004.SpendingStatisticsModule {}

class _$CreateTransactionModule extends _i559.CreateTransactionModule {}

class _$GetTransactionModule extends _i363.GetTransactionModule {}

class _$CoreModule extends _i258.CoreModule {}
