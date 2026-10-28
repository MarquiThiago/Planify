import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:planify/src/core/failures/failures.dart';
import 'package:planify/src/core/repository_base/repository_base.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/budget_group_entity.dart';
import '../../domain/repository/budget_repository.dart';
import '../models/budget_group_model.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl with RepositoryBase implements BudgetRepository {
  BudgetRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Either<Failure, Unit>> createBudgetGroup({
    required double monthlyIncome,
    required double savingsPct,
    required DateTime period,
    required Map<String, double> categoryAllocations,
  }) =>
      safeCall<Unit>(
        () async {
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
          return unit;
        },
        operationName: 'BudgetRepository.createBudgetGroup',
        context: {'period': _formatPeriod(period), 'monthlyIncome': monthlyIncome},
      );

  @override
  Future<Either<Failure, BudgetGroupEntity?>> getBudgetGroup(
    DateTime period,
  ) =>
      safeCall<BudgetGroupEntity?>(
        () async {
          final response = await _client.rpc(
            'get_budget_group_with_spent',
            params: {'p_period': _formatPeriod(period)},
          ) as List<dynamic>;

          if (response.isEmpty) return null;

          final rows = response.cast<Map<String, dynamic>>();
          final group = BudgetGroupModel.fromJson(rows.first);
          final budgets =
              rows.map((row) => BudgetModel.fromJson(row).toEntity()).toList();

          return group.toEntity(budgets);
        },
        operationName: 'BudgetRepository.getBudgetGroup',
        context: {'period': _formatPeriod(period)},
      );

  @override
  Stream<Either<Failure, BudgetGroupEntity?>> watchBudgetGroup(
    DateTime period,
  ) {
    final controller = StreamController<Either<Failure, BudgetGroupEntity?>>();
    final userId = _client.auth.currentUser!.id;

    // Re-uses getBudgetGroup which already returns Either — errors are forwarded
    // as Left without closing the stream, so the BLoC keeps receiving updates.
    Future<void> fetch() async {
      final result = await getBudgetGroup(period);
      if (!controller.isClosed) controller.add(result);
    }

    final channelName = 'budget_watch_${userId}_${_formatPeriod(period)}';
    final channel = _client.channel(channelName);

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'budget_groups',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (_) => fetch(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'transactions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
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
  Future<Either<Failure, Unit>> deleteBudgetGroup(String groupId) =>
      safeCall<Unit>(
        () async {
          await _client.from('budget_groups').delete().eq('id', groupId);
          return unit;
        },
        operationName: 'BudgetRepository.deleteBudgetGroup',
        context: {'groupId': groupId},
      );

  String _formatPeriod(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-01';
}
