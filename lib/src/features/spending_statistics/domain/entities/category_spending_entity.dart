import 'package:equatable/equatable.dart';

class CategorySpendingEntity extends Equatable {
  const CategorySpendingEntity({
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    required this.totalAmount,
    required this.percentage,
  });

  final String categoryId;
  final String categoryName;
  final String categoryColor; // hex e.g. '#FF5733'
  final double totalAmount;
  final double percentage; // 0.0 to 1.0

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        categoryColor,
        totalAmount,
        percentage,
      ];
}
