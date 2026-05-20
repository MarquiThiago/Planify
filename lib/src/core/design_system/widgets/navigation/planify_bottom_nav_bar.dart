import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_icon_size.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';

const double _addButtonSize = 56.0;

class PlanifyNavItem {
  const PlanifyNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Bottom navigation bar padrão do Planify.
///
/// Renderiza até 4 itens com um botão de ação central (+).
/// Os índices de [currentIndex] e [onTabSelected] ignoram o botão central:
/// 0 = primeiro item, 1 = segundo, 2 = terceiro, 3 = quarto.
///
/// ```dart
/// PlanifyBottomNavBar(
///   items: const [
///     PlanifyNavItem(icon: Icons.home_outlined, label: 'Home'),
///     PlanifyNavItem(icon: Icons.description_outlined, label: 'Records'),
///     PlanifyNavItem(icon: Icons.bar_chart_outlined, label: 'Cards'),
///     PlanifyNavItem(icon: Icons.menu, label: 'Menu'),
///   ],
///   currentIndex: 0,
///   onTabSelected: (i) => cubit.selectTab(i),
///   onAddTapped: () => showAddModal(context),
/// )
/// ```
class PlanifyBottomNavBar extends StatelessWidget {
  const PlanifyBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onAddTapped,
  }) : assert(items.length == 4, 'PlanifyBottomNavBar requires exactly 4 items');

  final List<PlanifyNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAddTapped;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                item: items[0],
                selected: currentIndex == 0,
                onTap: () => onTabSelected(0),
              ),
              _NavItem(
                item: items[1],
                selected: currentIndex == 1,
                onTap: () => onTabSelected(1),
              ),
              _AddButton(onTap: onAddTapped),
              _NavItem(
                item: items[2],
                selected: currentIndex == 2,
                onTap: () => onTabSelected(2),
              ),
              _NavItem(
                item: items[3],
                selected: currentIndex == 3,
                onTap: () => onTabSelected(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final PlanifyNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : AppColors.neutral400;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: AppIconSize.lg, color: color),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _addButtonSize + AppSpacing.md,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: _addButtonSize,
            height: _addButtonSize,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.textPrimary,
              size: AppIconSize.lg,
            ),
          ),
        ),
      ),
    );
  }
}
