import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String username;
  final String? avatarUrl;

  /// Constrói um [UserModel] a partir do objeto [User] retornado pelo Supabase.
  /// Campos como username e avatarUrl são extraídos dos metadados do provedor OAuth
  /// (Google/Apple) ou definidos como fallback a partir do e-mail.
  factory UserModel.fromSupabaseUser(User user) {
    final metadata = user.userMetadata ?? {};
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      username: metadata['full_name'] as String? ??
          metadata['name'] as String? ??
          user.email?.split('@').first ??
          '',
      avatarUrl: metadata['avatar_url'] as String?,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'avatar_url': avatarUrl,
      };

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        username: username,
        avatarUrl: avatarUrl,
      );

  @override
  List<Object?> get props => [id, email, username, avatarUrl];
}
