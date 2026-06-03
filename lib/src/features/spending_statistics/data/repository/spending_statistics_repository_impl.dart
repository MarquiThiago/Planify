import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/category_spending_entity.dart';
import '../../domain/entities/spending_statistics_entity.dart';
import '../../domain/repository/spending_statistics_repository.dart';
import '../models/category_spending_model.dart';

class SpendingStatisticsRepositoryImpl implements SpendingStatisticsRepository {
  SpendingStatisticsRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Stream<SpendingStatisticsEntity> watchSpendingStatistics({
    required int year,
    required int month,
    required String type,
  }) {
    final userId = _client.auth.currentUser!.id;

    return _client
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .asyncMap((_) => _fetchStatistics(
              userId: userId,
              year: year,
              month: month,
              type: type,
            ));
  }

  Future<SpendingStatisticsEntity> _fetchStatistics({
    required String userId,
    required int year,
    required int month,
    required String type,
  }) async {
    final firstDay =
        '${year.toString()}-${month.toString().padLeft(2, '0')}-01';
    final lastDayOfMonth = DateTime(year, month + 1, 0).day;
    final lastDay =
        '${year.toString()}-${month.toString().padLeft(2, '0')}-${lastDayOfMonth.toString().padLeft(2, '0')}';

    final rows = await _client
        .from('transactions')
        .select('amount, categories(id, name, color)')
        .eq('user_id', userId)
        .eq('type', type)
        .gte('date', firstDay)
        .lte('date', lastDay);

    return _computeStatistics(rows, year, month, type);
  }

  SpendingStatisticsEntity _computeStatistics(
    List<Map<String, dynamic>> rows,
    int year,
    int month,
    String type,
  ) {
    final models = rows.map(CategorySpendingModel.fromJson).toList();

    final Map<String, _CategoryAccumulator> grouped = {};
    for (final model in models) {
      if (grouped.containsKey(model.categoryId)) {
        grouped[model.categoryId]!.totalAmount += model.amount;
      } else {
        grouped[model.categoryId] = _CategoryAccumulator(
          categoryId: model.categoryId,
          categoryName: model.categoryName,
          categoryColor: model.categoryColor,
          totalAmount: model.amount,
        );
      }
    }

    final totalAmount =
        grouped.values.fold(0.0, (sum, acc) => sum + acc.totalAmount);

    final categories = grouped.values
        .map((acc) => CategorySpendingEntity(
              categoryId: acc.categoryId,
              categoryName: acc.categoryName,
              categoryColor: acc.categoryColor,
              totalAmount: acc.totalAmount,
              percentage:
                  totalAmount > 0 ? acc.totalAmount / totalAmount : 0.0,
            ))
        .toList()
      ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    return SpendingStatisticsEntity(
      categories: categories,
      totalAmount: totalAmount,
      year: year,
      month: month,
      type: type,
    );
  }
}

class _CategoryAccumulator {
  _CategoryAccumulator({
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    required this.totalAmount,
  });

  final String categoryId;
  final String categoryName;
  final String categoryColor;
  double totalAmount;
}
