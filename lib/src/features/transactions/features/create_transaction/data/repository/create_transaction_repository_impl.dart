import 'package:dartz/dartz.dart';
import 'package:planify/src/core/failures/failures.dart';
import 'package:planify/src/core/repository_base/repository_base.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repository/create_transaction_repository.dart';

class CreateTransactionRepositoryImpl
    with RepositoryBase
    implements CreateTransactionRepository {
  CreateTransactionRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Either<Failure, Unit>> createTransaction({
    required String type,
    required double amount,
    required String accountId,
    required String categoryId,
    required DateTime date,
    String? description,
  }) =>
      safeCall<Unit>(
        () async {
          final dateStr =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

          await _client.from('transactions').insert({
            'user_id': _client.auth.currentUser!.id,
            'type': type,
            'amount': amount,
            'account_id': accountId,
            'category_id': categoryId,
            'date': dateStr,
            'description': description,
          });
          return unit;
        },
        operationName: 'CreateTransactionRepository.createTransaction',
        context: {'type': type, 'amount': amount},
      );
}
