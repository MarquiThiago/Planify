import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/design_system/design_system.dart';
import 'package:planify/src/core/di/injection.dart';
import 'package:planify/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:planify/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:planify/src/features/theme/cubit/theme_cubit.dart';
import 'package:planify/src/features/theme/presentation/theme_selector_sheet.dart';

import '../menu_strings.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: const _MenuBody(),
    );
  }
}

class _MenuBody extends StatelessWidget {
  const _MenuBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                MenuStrings.pageTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                MenuStrings.sectionInformation,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) => _MenuItemTile(
                  icon: Icons.brightness_medium_outlined,
                  label: MenuStrings.themeMode,
                  subtitle: _themeModeLabel(themeMode),
                  onTap: () => showThemeSelectorSheet(context),
                ),
              ),
              _MenuItemTile(
                icon: Icons.settings_outlined,
                label: MenuStrings.settings,
                onTap: null,
              ),
              _MenuItemTile(
                icon: Icons.star_outline,
                label: MenuStrings.rateUs,
                onTap: null,
                isHighlighted: true,
              ),
              _MenuItemTile(
                icon: Icons.help_outline,
                label: MenuStrings.support,
                onTap: null,
              ),
              _MenuItemTile(
                icon: Icons.account_circle_outlined,
                label: MenuStrings.logout,
                onTap: () => _confirmLogout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.light => MenuStrings.themeModeLight,
        ThemeMode.dark => MenuStrings.themeModeDark,
        ThemeMode.system => MenuStrings.themeModeSystem,
      };

  Future<void> _confirmLogout(BuildContext context) async {
    final authBloc = context.read<AuthBloc>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(MenuStrings.logoutDialogTitle),
        content: const Text(MenuStrings.logoutDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(MenuStrings.logoutDialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(MenuStrings.logoutDialogConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      authBloc.add(const SignOutRequested());
    }
  }
}

class _MenuItemTile extends StatelessWidget {
  const _MenuItemTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.isHighlighted = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        isHighlighted ? context.colors.primary : theme.colorScheme.onSurface;
    final muted = context.colors.onSurfaceVariant;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, color: color, size: AppIconSize.md),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style:
                            theme.textTheme.bodyLarge?.copyWith(color: color),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: muted,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: color, size: AppIconSize.md),
              ],
            ),
          ),
        ),
        Divider(color: muted.withValues(alpha: 0.15), height: 1),
      ],
    );
  }
}
