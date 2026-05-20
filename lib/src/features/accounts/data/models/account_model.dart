import 'package:equatable/equatable.dart';

import '../../domain/entities/account_entity.dart';

class AccountModel extends Equatable {
  const AccountModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.balance,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String name;
  final double balance;
  final String type;
  final DateTime createdAt;

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      balance: (json['balance'] as num).toDouble(),
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'balance': balance,
        'type': type,
        'created_at': createdAt.toIso8601String(),
      };

  AccountEntity toEntity() => AccountEntity(
        id: id,
        userId: userId,
        name: name,
        balance: balance,
        type: type,
        createdAt: createdAt,
      );

  @override
  List<Object?> get props => [id, userId, name, balance, type, createdAt];
}
