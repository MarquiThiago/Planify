import 'package:flutter/material.dart';
import '../../design_system.dart';

/// Seletor de cores em grid
class PlanifyColorPicker extends StatelessWidget {
  final List<Color> colors;
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;
  final int crossAxisCount;
  final double spacing;
  final double colorSize;

  const PlanifyColorPicker({
    super.key,
    required this.colors,
    this.selectedColor,
    required this.onColorSelected,
    this.crossAxisCount = 6,
    this.spacing = AppSpacing.md,
    this.colorSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: colors.map((color) {
        final isSelected = selectedColor == color;

        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: Colors.white,
                      width: 3,
                    )
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}

/// Paleta padrão de cores Planify
class PlanifyColorPalettePreset extends StatelessWidget {
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;

  const PlanifyColorPalettePreset({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
  });

  static const List<Color> defaultColors = [
    AppColors.primary,
    AppColors.success,
    AppColors.warning,
    AppColors.secondary,
    AppColors.info,
    Color(0xFFffffff), // Branco
  ];

  @override
  Widget build(BuildContext context) {
    return PlanifyColorPicker(
      colors: defaultColors,
      selectedColor: selectedColor,
      onColorSelected: onColorSelected,
      crossAxisCount: 6,
      colorSize: 48,
    );
  }
}

/// Seletor de cores expandido com mais opções
class PlanifyColorPickerExtended extends StatelessWidget {
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;

  const PlanifyColorPickerExtended({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
  });

  static const List<Color> extendedColors = [
    // Roxo
    AppColors.primary,
    AppColors.primaryLight,
    AppColors.primaryDark,
    // Rosa
    AppColors.secondary,
    AppColors.secondaryLight,
    AppColors.secondaryDark,
    // Verde
    AppColors.success,
    AppColors.successLight,
    AppColors.successDark,
    // Laranja
    AppColors.warning,
    AppColors.warningLight,
    AppColors.warningDark,
    // Azul
    AppColors.info,
    AppColors.infoLight,
    AppColors.infoDark,
    // Erro
    AppColors.error,
    AppColors.errorLight,
    AppColors.errorDark,
    // Neutros
    Color(0xFFffffff),
    AppColors.neutral500,
    AppColors.neutral800,
  ];

  @override
  Widget build(BuildContext context) {
    return PlanifyColorPicker(
      colors: extendedColors,
      selectedColor: selectedColor,
      onColorSelected: onColorSelected,
      crossAxisCount: 5,
      colorSize: 56,
    );
  }
}
