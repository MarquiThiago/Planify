import 'package:flutter/material.dart';
import 'package:planify/src/core/design_system/design_system.dart';

class CreateTransactionFormField extends StatelessWidget {
  const CreateTransactionFormField({
    super.key,
    required this.label,
    this.value,
    this.placeholder,
    required this.icon,
    required this.onTap,
    this.valueColor,
  });

  final String label;
  final String? value;
  final String? placeholder;
  final IconData icon;
  final VoidCallback onTap;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final displayValue = value ?? placeholder ?? '';
    final isPlaceholder = value == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: context.colors.outline.withValues(alpha: 0.2),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    displayValue,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isPlaceholder
                          ? context.colors.onSurfaceVariant
                          : (valueColor ?? context.colors.onSurface),
                      fontWeight: isPlaceholder
                          ? FontWeight.normal
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              size: AppIconSize.lg,
              color: context.colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
