import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/repository/transaction_repository.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<List<TransactionEntity>> getTransactions(int year, int month) async {
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
  }

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
      'type': type,
      'amount': amount,
      'account_id': accountId,
      'category_id': categoryId,
      'date': dateStr,
      'description': description,
    });
  }
}
