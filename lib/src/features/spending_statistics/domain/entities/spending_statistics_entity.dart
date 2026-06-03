import 'package:equatable/equatable.dart';

import 'category_spending_entity.dart';

class SpendingStatisticsEntity extends Equatable {
  const SpendingStatisticsEntity({
    required this.categories,
    required this.totalAmount,
    required this.year,
    required this.month,
    required this.type,
  });

  final List<CategorySpendingEntity> categories;
  final double totalAmount;
  final int year;
  final int month;
  final String type; // 'expense' | 'income'

  @override
  List<Object?> get props => [categories, totalAmount, year, month, type];
}
