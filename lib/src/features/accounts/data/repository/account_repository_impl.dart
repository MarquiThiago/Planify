import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/repository/account_repository.dart';
import '../models/account_model.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<List<AccountEntity>> getAccounts() async {
    final response = await _client
        .from('accounts')
        .select()
        .order('created_at', ascending: false);
    return response
        .map((json) => AccountModel.fromJson(json).toEntity())
        .toList();
  }
}
