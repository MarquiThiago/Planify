import 'package:equatable/equatable.dart';

class BudgetEntity extends Equatable {
  const BudgetEntity({
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

  double get remainingAmount => amount - spentAmount;
  bool get isOverBudget => spentAmount > amount;
  double get spentPercentage => amount > 0 ? (spentAmount / amount).clamp(0.0, 1.0) : 0.0;

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
