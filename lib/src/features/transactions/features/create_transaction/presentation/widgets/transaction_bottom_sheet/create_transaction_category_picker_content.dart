import 'package:flutter/material.dart';
import 'package:planify/src/core/design_system/design_system.dart';

import '../../../domain/entities/category_entity.dart';

class CreateTransactionCategoryPickerContent extends StatelessWidget {
  const CreateTransactionCategoryPickerContent({
    super.key,
    required this.categories,
    required this.selected,
  });

  final List<CategoryEntity> categories;
  final CategoryEntity? selected;

  Color _parseColor(String hex) {
    final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma categoria encontrada',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: categories
          .map(
            (cat) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: PlanifySelectableItem(
                label: cat.name,
                isSelected: selected?.id == cat.id,
                icon: Icons.label_outline,
                iconColor: _parseColor(cat.color),
                onTap: () => Navigator.of(context).pop(cat),
              ),
            ),
          )
          .toList(),
    );
  }
}
