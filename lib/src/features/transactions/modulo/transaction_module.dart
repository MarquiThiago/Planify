import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:planify/src/features/accounts/domain/repository/account_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repository/category_repository_impl.dart';
import '../data/repository/transaction_repository_impl.dart';
import '../domain/repository/category_repository.dart';
import '../domain/repository/transaction_repository.dart';
import '../presentation/bloc/create_transaction/create_transaction_bloc.dart';
import '../presentation/bloc/transaction_bloc.dart';

@module
abstract class TransactionModule {
  @lazySingleton
  TransactionRepository get transactionRepository =>
      TransactionRepositoryImpl(GetIt.instance<SupabaseClient>());

  @lazySingleton
  CategoryRepository get categoryRepository =>
      CategoryRepositoryImpl(GetIt.instance<SupabaseClient>());

  TransactionBloc get transactionBloc =>
      TransactionBloc(GetIt.instance<TransactionRepository>());

  CreateTransactionBloc get createTransactionBloc => CreateTransactionBloc(
        GetIt.instance<TransactionRepository>(),
        GetIt.instance<AccountRepository>(),
        GetIt.instance<CategoryRepository>(),
      );
}
