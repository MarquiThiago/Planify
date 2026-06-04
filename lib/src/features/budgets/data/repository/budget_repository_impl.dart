import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/budget_group_entity.dart';
import '../../domain/repository/budget_repository.dart';
import '../models/budget_group_model.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<void> createBudgetGroup({
    required double monthlyIncome,
    required double savingsPct,
    required DateTime period,
    required Map<String, double> categoryAllocations,
  }) async {
    final userId = _client.auth.currentUser!.id;
    final savingsAmount = monthlyIncome * savingsPct / 100;
    final spendableAmount = monthlyIncome - savingsAmount;
    final periodStr = _formatPeriod(period);

    final groupResponse = await _client
        .from('budget_groups')
        .insert({
          'user_id': userId,
          'monthly_income': monthlyIncome,
          'savings_pct': savingsPct,
          'savings_amount': savingsAmount,
          'spendable_amount': spendableAmount,
          'period': periodStr,
        })
        .select()
        .single();

    final groupId = groupResponse['id'] as String;

    await _client.from('budgets').insert(
          categoryAllocations.entries
              .map(
                (e) => {
                  'group_id': groupId,
                  'user_id': userId,
                  'category_id': e.key,
                  'amount': e.value,
                },
              )
              .toList(),
        );
  }

  @override
  Future<BudgetGroupEntity?> getBudgetGroup(DateTime period) async {
    final response = await _client.rpc(
      'get_budget_group_with_spent',
      params: {'p_period': _formatPeriod(period)},
    ) as List<dynamic>;

    if (response.isEmpty) return null;

    final rows = response.cast<Map<String, dynamic>>();
    final group = BudgetGroupModel.fromJson(rows.first);
    final budgets = rows.map((row) => BudgetModel.fromJson(row).toEntity()).toList();

    return group.toEntity(budgets);
  }

  @override
  Stream<BudgetGroupEntity?> watchBudgetGroup(DateTime period) {
    final controller = StreamController<BudgetGroupEntity?>();

    Future<void> fetch() async {
      try {
        final result = await getBudgetGroup(period);
        if (!controller.isClosed) controller.add(result);
      } catch (e) {
        if (!controller.isClosed) controller.addError(e);
      }
    }

    final channel = _client.channel('budget_watch_${_formatPeriod(period)}');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'budget_groups',
          callback: (_) => fetch(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'transactions',
          callback: (_) => fetch(),
        )
        .subscribe();

    fetch();

    controller.onCancel = () {
      _client.removeChannel(channel);
      controller.close();
    };

    return controller.stream;
  }

  @override
  Future<void> deleteBudgetGroup(String groupId) async {
    await _client.from('budget_groups').delete().eq('id', groupId);
  }

  String _formatPeriod(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-01';
}
