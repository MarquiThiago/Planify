import 'package:flutter_test/flutter_test.dart';
import 'package:planify/src/features/accounts/data/models/account_model.dart';

void main() {
  group('AccountModel tests', () {
    final accountModel = AccountModel(
      id: '1',
      userId: 'user_1',
      name: 'Test Account',
      balance: 100.0,
      type: 'savings',
      createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
    );

    final createdAt = DateTime.parse('2023-01-01T00:00:00Z');

    final accountJson = {
      'id': '1',
      'user_id': 'user_1',
      'name': 'Test Account',
      'balance': 100.0,
      'type': 'savings',
      'created_at': createdAt.toIso8601String(),
    };

    test('reads account data fromJson', () {
      final model = AccountModel.fromJson(accountJson);
      expect(model, accountModel);
    });
    test('converts account model to entity', () {
      final accountEntity = accountModel.toEntity();

      expect(accountEntity.id, accountModel.id);
      expect(accountEntity.userId, accountModel.userId);
      expect(accountEntity.name, accountModel.name);
      expect(accountEntity.balance, accountModel.balance);
    });

    test('converts account model to Json', () {
      final json = accountModel.toJson();

      expect(json, accountJson);
    });
  });
}
