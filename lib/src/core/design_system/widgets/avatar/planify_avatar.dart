import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';

enum AvatarSize { sm, md, lg, xl }

/// Avatar padrão do Planify.
/// Exibe a foto do usuário ou as iniciais como fallback.
///
/// ```dart
/// PlanifyAvatar(imageUrl: user.avatarUrl, name: user.username)
/// PlanifyAvatar(name: 'Thiago Lima', size: AvatarSize.lg)
/// ```
class PlanifyAvatar extends StatelessWidget {
  const PlanifyAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = AvatarSize.md,
  });

  final String name;
  final String? imageUrl;
  final AvatarSize size;

  double get _dimension => switch (size) {
        AvatarSize.sm => 28,
        AvatarSize.md => 40,
        AvatarSize.lg => 56,
        AvatarSize.xl => 80,
      };

  double get _fontSize => switch (size) {
        AvatarSize.sm => 10,
        AvatarSize.md => 14,
        AvatarSize.lg => 20,
        AvatarSize.xl => 28,
      };

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: _dimension,
      height: _dimension,
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _Initials(
                  initials: _initials,
                  fontSize: _fontSize,
                  scheme: scheme,
                ),
              )
            : _Initials(
                initials: _initials,
                fontSize: _fontSize,
                scheme: scheme,
              ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({
    required this.initials,
    required this.fontSize,
    required this.scheme,
  });

  final String initials;
  final double fontSize;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.indigo100,
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.indigo700,
          ),
        ),
      ),
    );
  }
}
