import 'package:equatable/equatable.dart';

class CategorySpendingModel extends Equatable {
  const CategorySpendingModel({
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    required this.amount,
  });

  final String categoryId;
  final String categoryName;
  final String categoryColor;
  final double amount;

  factory CategorySpendingModel.fromJson(Map<String, dynamic> json) {
    final category = json['categories'] as Map<String, dynamic>? ?? {};
    return CategorySpendingModel(
      categoryId: category['id'] as String? ?? '',
      categoryName: category['name'] as String? ?? 'Outros',
      categoryColor: category['color'] as String? ?? '#808080',
      amount: (json['amount'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [categoryId, categoryName, categoryColor, amount];
}
