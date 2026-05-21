import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    this.icon,
  });

  final String id;
  final String name;
  final String type; // 'income' | 'expense'
  final String color; // hex string e.g. '#FF5733'
  final String? icon;

  @override
  List<Object?> get props => [id, name, type, color, icon];
}
