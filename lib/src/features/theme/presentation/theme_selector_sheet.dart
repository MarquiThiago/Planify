import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/design_system/design_system.dart';

import '../cubit/theme_cubit.dart';

void showThemeSelectorSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => BlocProvider.value(
      value: context.read<ThemeCubit>(),
      child: const _ThemeSelectorContent(),
    ),
  );
}

class _ThemeSelectorContent extends StatelessWidget {
  const _ThemeSelectorContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, currentMode) {
        return Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.sm),
              _ThemeOption(
                icon: Icons.brightness_2_outlined,
                label: _ThemeStrings.dark,
                mode: ThemeMode.dark,
                currentMode: currentMode,
              ),
              _ThemeOption(
                icon: Icons.brightness_5_outlined,
                label: _ThemeStrings.light,
                mode: ThemeMode.light,
                currentMode: currentMode,
              ),
              _ThemeOption(
                icon: Icons.phone_android_outlined,
                label: _ThemeStrings.system,
                mode: ThemeMode.system,
                currentMode: currentMode,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.mode,
    required this.currentMode,
  });

  final IconData icon;
  final String label;
  final ThemeMode mode;
  final ThemeMode currentMode;

  @override
  Widget build(BuildContext context) {
    final isSelected = currentMode == mode;
    final color =
        isSelected ? context.colors.primary : context.colors.onSurface;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: context.colors.primary)
          : null,
      onTap: () {
        context.read<ThemeCubit>().setTheme(mode);
        Navigator.of(context).pop();
      },
    );
  }
}

class _ThemeStrings {
  static const String dark = 'Dark';
  static const String light = 'Light';
  static const String system = 'System';
}
