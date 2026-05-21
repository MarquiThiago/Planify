import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends Equatable {
  const TransactionModel({
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
  final String type;
  final double amount;
  final String? description;
  final DateTime date;
  final String accountName;
  final String categoryName;
  final String categoryColor;

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final category = json['categories'] as Map<String, dynamic>? ?? {};
    final account = json['accounts'] as Map<String, dynamic>? ?? {};

    return TransactionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      accountName: account['name'] as String? ?? '',
      categoryName: category['name'] as String? ?? '',
      categoryColor: category['color'] as String? ?? '#808080',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'amount': amount,
        'description': description,
        'date': date.toIso8601String(),
        'account_name': accountName,
        'category_name': categoryName,
        'category_color': categoryColor,
      };

  TransactionEntity toEntity() => TransactionEntity(
        id: id,
        type: type,
        amount: amount,
        description: description,
        date: date,
        accountName: accountName,
        categoryName: categoryName,
        categoryColor: categoryColor,
      );

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
