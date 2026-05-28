import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repository/get_transaction_repository_impl.dart';
import '../domain/repository/get_transaction_repository.dart';
import '../presentation/bloc/transaction_bloc.dart';

@module
abstract class GetTransactionModule {
  @lazySingleton
  GetTransactionRepository get getTransactionRepository =>
      GetTransactionRepositoryImpl(GetIt.instance<SupabaseClient>());

  TransactionBloc get transactionBloc =>
      TransactionBloc(GetIt.instance<GetTransactionRepository>());
}
