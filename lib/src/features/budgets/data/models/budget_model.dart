import 'package:equatable/equatable.dart';

import '../../domain/entities/budget_entity.dart';

class BudgetModel extends Equatable {
  const BudgetModel({
    required this.id,
    required this.groupId,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
    required this.amount,
    required this.spentAmount,
  });

  final String id;
  final String groupId;
  final String categoryId;
  final String categoryName;
  final String categoryColor;
  final String? categoryIcon;
  final double amount;
  final double spentAmount;

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['budget_id'] as String,
      groupId: json['group_id'] as String,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      categoryColor: json['category_color'] as String,
      categoryIcon: json['category_icon'] as String?,
      amount: (json['budgeted_amount'] as num).toDouble(),
      spentAmount: (json['spent_amount'] as num).toDouble(),
    );
  }

  BudgetEntity toEntity() => BudgetEntity(
        id: id,
        groupId: groupId,
        categoryId: categoryId,
        categoryName: categoryName,
        categoryColor: categoryColor,
        categoryIcon: categoryIcon,
        amount: amount,
        spentAmount: spentAmount,
      );

  @override
  List<Object?> get props => [
        id,
        groupId,
        categoryId,
        categoryName,
        categoryColor,
        categoryIcon,
        amount,
        spentAmount,
      ];
}
