import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repository/transaction_repository_impl.dart';
import '../domain/repository/transaction_repository.dart';
import '../presentation/bloc/transaction_bloc.dart';

@module
abstract class TransactionModule {
  @lazySingleton
  TransactionRepository get transactionRepository =>
      TransactionRepositoryImpl(GetIt.instance<SupabaseClient>());

  TransactionBloc get transactionBloc =>
      TransactionBloc(GetIt.instance<TransactionRepository>());
}
