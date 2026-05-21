import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:planify/src/features/accounts/domain/repository/account_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repository/category_repository_impl.dart';
import '../data/repository/create_transaction_repository_impl.dart';
import '../domain/repository/category_repository.dart';
import '../domain/repository/create_transaction_repository.dart';
import '../presentation/bloc/create_transaction_bloc.dart';

@module
abstract class CreateTransactionModule {
  @lazySingleton
  CreateTransactionRepository get createTransactionRepository =>
      CreateTransactionRepositoryImpl(GetIt.instance<SupabaseClient>());

  @lazySingleton
  CategoryRepository get categoryRepository =>
      CategoryRepositoryImpl(GetIt.instance<SupabaseClient>());

  CreateTransactionBloc get createTransactionBloc => CreateTransactionBloc(
        GetIt.instance<CreateTransactionRepository>(),
        GetIt.instance<AccountRepository>(),
        GetIt.instance<CategoryRepository>(),
      );
}
