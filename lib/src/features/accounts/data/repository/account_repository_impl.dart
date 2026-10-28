import 'package:dartz/dartz.dart';
import 'package:planify/src/core/failures/failures.dart';
import 'package:planify/src/core/repository_base/repository_base.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/repository/account_repository.dart';
import '../models/account_model.dart';

class AccountRepositoryImpl with RepositoryBase implements AccountRepository {
  AccountRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Either<Failure, List<AccountEntity>>> getAccounts() =>
      safeCall<List<AccountEntity>>(
        () async {
          final response = await _client
              .from('accounts')
              .select()
              .order('created_at', ascending: false);
          return response
              .map((json) => AccountModel.fromJson(json).toEntity())
              .toList();
        },
        operationName: 'AccountRepository.getAccounts',
      );

  @override
  Stream<Either<Failure, List<AccountEntity>>> watchAccounts() {
    final userId = _client.auth.currentUser!.id;
    return safeWatch<List<AccountEntity>>(
      () => _client
          .from('accounts')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .map(
            (rows) => rows
                .map((json) => AccountModel.fromJson(json).toEntity())
                .toList(),
          ),
      operationName: 'AccountRepository.watchAccounts',
    );
  }
}
