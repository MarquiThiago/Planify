import 'package:flutter/material.dart';
import '../../design_system.dart';

/// Card de saldo total — destaque principal da tela home
class PlanifyBalanceCard extends StatelessWidget {
  final String title;
  final String amount;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isLoading;

  const PlanifyBalanceCard({
    super.key,
    required this.title,
    required this.amount,
    this.subtitle,
    this.onTap,
    this.isLoading = false,
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  color: context.colors.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (isLoading)
              SizedBox(
                height: 40,
                child: Skeleton(enabled: true, child: Container()),
              )
            else
              Text(
                amount,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.expense,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton placeholder para carregamento
class Skeleton extends StatelessWidget {
  final bool enabled;
  final Widget child;
  final BorderRadius borderRadius;

  const Skeleton({
    super.key,
    required this.enabled,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.sm)),
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
