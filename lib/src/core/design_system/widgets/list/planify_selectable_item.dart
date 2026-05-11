import 'package:flutter/material.dart';
import '../../design_system.dart';

/// Item selecionável para listas (accounts, categorias, etc)
class PlanifySelectableItem extends StatelessWidget {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? selectedBackgroundColor;
  final Color? selectedBorderColor;

  const PlanifySelectableItem({
    super.key,
    required this.label,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.isSelected = false,
    required this.onTap,
    this.trailing,
    this.selectedBackgroundColor,
    this.selectedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedBackgroundColor ?? AppColors.primary.withValues(alpha: 0.1))
              : context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isSelected
                ? (selectedBorderColor ?? AppColors.primary)
                : context.colors.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Ícone
            if (icon != null)
              Container(
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.primary,
                  size: 24,
                ),
              ),
            if (icon != null) const SizedBox(width: AppSpacing.md),

            // Conteúdo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Trailing
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.md),
              trailing!,
            ] else if (isSelected) ...[
              const SizedBox(width: AppSpacing.md),
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Lista selecionável com múltiplos itens
class PlanifySelectableList extends StatelessWidget {
  final List<SelectableItemData> items;
  final int? selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool multiSelect;
  final List<int> selectedIndices;
  final ValueChanged<List<int>>? onMultiSelectChanged;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  const PlanifySelectableList({
    super.key,
    required this.items,
    this.selectedIndex,
    required this.onItemSelected,
    this.multiSelect = false,
    this.selectedIndices = const [],
    this.onMultiSelectChanged,
    this.padding,
    this.spacing = AppSpacing.md,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(height: spacing),
        itemBuilder: (_, index) {
          final item = items[index];
          final isSelected = multiSelect
              ? selectedIndices.contains(index)
              : selectedIndex == index;

          return PlanifySelectableItem(
            label: item.label,
            subtitle: item.subtitle,
            icon: item.icon,
            iconColor: item.iconColor,
            isSelected: isSelected,
            onTap: () {
              if (multiSelect) {
                final newIndices = List<int>.from(selectedIndices);
                if (newIndices.contains(index)) {
                  newIndices.remove(index);
                } else {
                  newIndices.add(index);
                }
                onMultiSelectChanged?.call(newIndices);
              } else {
                onItemSelected(index);
              }
            },
            trailing: item.trailing,
          );
        },
      ),
    );
  }
}

/// Dados para um item selecionável
class SelectableItemData {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;

  SelectableItemData({
    required this.label,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailing,
  });
}
