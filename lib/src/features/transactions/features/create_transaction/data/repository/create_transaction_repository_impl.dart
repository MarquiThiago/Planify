import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repository/create_transaction_repository.dart';

class CreateTransactionRepositoryImpl implements CreateTransactionRepository {
  CreateTransactionRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<void> createTransaction({
    required String type,
    required double amount,
    required String accountId,
    required String categoryId,
    required DateTime date,
    String? description,
  }) async {
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
  }
}
