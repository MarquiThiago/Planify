import 'package:flutter/material.dart';
import '../../design_system.dart';

/// Card de orçamento com barra de progresso
class PlanifyBudgetCard extends StatelessWidget {
  final String title;
  final String amount;
  final String spent;
  final String remaining;
  final double progress; // 0.0 a 1.0
  final VoidCallback? onTap;
  final Color progressColor;

  const PlanifyBudgetCard({
    super.key,
    required this.title,
    required this.amount,
    required this.spent,
    required this.remaining,
    required this.progress,
    this.onTap,
    this.progressColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PlanifyCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'All Budgets',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Valor do orçamento
            Text(
              amount,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Barra de progresso
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: context.colors.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Informações de gasto
            Row(
              children: [
                Text(
                  spent,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  remaining,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
