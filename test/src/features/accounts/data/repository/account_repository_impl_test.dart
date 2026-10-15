import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planify/src/features/accounts/data/repository/account_repository_impl.dart';
import 'package:planify/src/features/accounts/domain/entities/account_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockAccountRepositoryImpl extends Mock implements AccountRepositoryImpl {}

class MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder {}

void main() {
  late final MockSupabaseClient mockSupabaseClient;
  late final MockAccountRepositoryImpl mockAccountRepositoryImpl;
  late final MockPostgrestFilterBuilder mockPostgrestFilterBuilder;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockAccountRepositoryImpl = MockAccountRepositoryImpl();
    mockPostgrestFilterBuilder = MockPostgrestFilterBuilder();

    GetIt.instance.registerSingleton<SupabaseClient>(mockSupabaseClient);
    GetIt.instance.registerSingleton<AccountRepositoryImpl>(
      mockAccountRepositoryImpl,
    );
  });

  final AccountEntity accountEntity = AccountEntity(
    id: '1',
    userId: 'user_1',
    name: 'Test Account',
    balance: 100.0,
    type: 'savings',
    createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
  );
  final List<Map<String, dynamic>> response = [
    {
      'id': '1',
      'user_id': 'user_1',
      'name': 'Test Account',
      'balance': 100.0,
      'type': 'savings',
      'created_at': DateTime.parse('2023-01-01T00:00:00Z').toIso8601String(),
    },
  ];
}
