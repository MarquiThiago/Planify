import 'package:equatable/equatable.dart';

import '../../domain/entities/category_entity.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    this.icon,
  });

  final String id;
  final String name;
  final String type;
  final String color;
  final String? icon;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      color: json['color'] as String? ?? '#808080',
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'color': color,
        'icon': icon,
      };

  CategoryEntity toEntity() => CategoryEntity(
        id: id,
        name: name,
        type: type,
        color: color,
        icon: icon,
      );

  @override
  List<Object?> get props => [id, name, type, color, icon];
}
