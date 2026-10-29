import 'package:dartz/dartz.dart';
import 'package:planify/src/core/failures/failures.dart';
import 'package:planify/src/core/repository_base/repository_base.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/repository/get_transaction_repository.dart';
import '../models/transaction_model.dart';

class GetTransactionRepositoryImpl
    with RepositoryBase
    implements GetTransactionRepository {
  GetTransactionRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions(
    int year,
    int month,
  ) =>
      safeCall<List<TransactionEntity>>(
        () async {
          final firstDay =
              '${year.toString()}-${month.toString().padLeft(2, '0')}-01';
          final lastDayOfMonth = DateTime(year, month + 1, 0).day;
          final lastDay =
              '${year.toString()}-${month.toString().padLeft(2, '0')}-${lastDayOfMonth.toString().padLeft(2, '0')}';

          final response = await _client
              .from('transactions')
              .select('*, categories(name, color), accounts(name)')
              .gte('date', firstDay)
              .lte('date', lastDay)
              .order('date', ascending: false);

          return response
              .map((json) => TransactionModel.fromJson(json).toEntity())
              .toList();
        },
        operationName: 'GetTransactionRepository.getTransactions',
        context: {'year': year, 'month': month},
      );
}
