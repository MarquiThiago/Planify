import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  const AccountEntity({
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

  @override
  List<Object?> get props => [id, userId, name, balance, type, createdAt];
}
