import 'package:flutter/material.dart';
import '../../design_system.dart';

/// Seletor de ícones em grid
class PlanifyIconPicker extends StatelessWidget {
  final List<IconData> icons;
  final IconData? selectedIcon;
  final ValueChanged<IconData> onIconSelected;
  final int crossAxisCount;
  final double spacing;
  final Color? iconColor;
  final double iconSize;

  const PlanifyIconPicker({
    super.key,
    required this.icons,
    this.selectedIcon,
    required this.onIconSelected,
    this.crossAxisCount = 5,
    this.spacing = AppSpacing.md,
    this.iconColor,
    this.iconSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: icons.map((icon) {
        final isSelected = selectedIcon == icon;

        return GestureDetector(
          onTap: () => onIconSelected(icon),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? (iconColor ?? AppColors.primary).withValues(alpha: 0.1)
                  : context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: isSelected
                  ? Border.all(
                      color: iconColor ?? AppColors.primary,
                      width: 2,
                    )
                  : Border.all(
                      color: context.colors.outline.withValues(alpha: 0.2),
                    ),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: iconSize,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Ícones padrão para categorias de transação
class PlanifyIconPickerPreset extends StatelessWidget {
  final IconData? selectedIcon;
  final ValueChanged<IconData> onIconSelected;
  final Color? iconColor;

  const PlanifyIconPickerPreset({
    super.key,
    this.selectedIcon,
    required this.onIconSelected,
    this.iconColor,
  });

  static const List<IconData> defaultIcons = [
    // Transporte
    Icons.directions_car,
    Icons.directions_bus,
    Icons.flight,
    Icons.train,
    Icons.two_wheeler,

    // Alimentos
    Icons.restaurant,
    Icons.local_pizza,
    Icons.local_cafe,
    Icons.fastfood,
    Icons.shopping_cart,

    // Casa
    Icons.home,
    Icons.lightbulb,
    Icons.water,
    Icons.build,
    Icons.home_repair_service,

    // Entretenimento
    Icons.movie,
    Icons.sports,
    Icons.gamepad,
    Icons.music_note,
    Icons.sports_esports,

    // Saúde
    Icons.local_hospital,
    Icons.fitness_center,
    Icons.health_and_safety,
    Icons.spa,
    Icons.medical_services,

    // Shopping
    Icons.shopping_bag,
    Icons.checkroom,
    Icons.watch,
    Icons.favorite,
    Icons.palette,

    // Outros
    Icons.card_giftcard,
    Icons.school,
    Icons.work,
    Icons.paid,
    Icons.savings,
  ];

  @override
  Widget build(BuildContext context) {
    return PlanifyIconPicker(
      icons: defaultIcons,
      selectedIcon: selectedIcon,
      onIconSelected: onIconSelected,
      iconColor: iconColor ?? AppColors.primary,
      crossAxisCount: 5,
      iconSize: 32,
    );
  }
}

/// Card com ícone selecionável
class PlanifyIconDisplay extends StatelessWidget {
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const PlanifyIconDisplay({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(
        icon,
        color: iconColor ?? AppColors.primary,
        size: size * 0.6,
      ),
    );
  }
}
