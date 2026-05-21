import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  const TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    this.description,
    required this.date,
    required this.accountName,
    required this.categoryName,
    required this.categoryColor,
  });

  final String id;
  final String type; // 'income' | 'expense'
  final double amount;
  final String? description;
  final DateTime date;
  final String accountName;
  final String categoryName;
  final String categoryColor; // hex string e.g. '#FF5733'

  @override
  List<Object?> get props => [
        id,
        type,
        amount,
        description,
        date,
        accountName,
        categoryName,
        categoryColor,
      ];
}
