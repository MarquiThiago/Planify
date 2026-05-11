import 'package:flutter/material.dart';
import '../../design_system.dart';

/// Modal/Bottom Sheet padrão do Planify
class PlanifyModal extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String? confirmLabel;
  final String? cancelLabel;
  final bool showHeader;
  final EdgeInsetsGeometry? padding;

  const PlanifyModal({
    super.key,
    required this.title,
    required this.child,
    this.onConfirm,
    this.onCancel,
    this.confirmLabel,
    this.cancelLabel,
    this.showHeader = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          if (showHeader)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

          // Divider
          if (showHeader)
            Divider(
              color: context.colors.outline.withValues(alpha: 0.2),
              height: 1,
            ),

          // Conteúdo
          Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),

          // Botões (se houver ações)
          if (onConfirm != null || onCancel != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  if (onConfirm != null)
                    PlanifyButton.primary(
                      label: confirmLabel ?? 'Confirm',
                      onTap: () {
                        Navigator.pop(context);
                        onConfirm?.call();
                      },
                    ),
                  if (onCancel != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    PlanifyButton.outline(
                      label: cancelLabel ?? 'Cancel',
                      onTap: () {
                        Navigator.pop(context);
                        onCancel?.call();
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

/// Dialog customizado do Planify
class PlanifyDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String? confirmLabel;
  final String? cancelLabel;
  final bool barrierDismissible;

  const PlanifyDialog({
    super.key,
    required this.title,
    required this.child,
    this.onConfirm,
    this.onCancel,
    this.confirmLabel,
    this.cancelLabel,
    this.barrierDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Conteúdo
            child,
            const SizedBox(height: AppSpacing.lg),

            // Botões
            if (onConfirm != null || onCancel != null)
              Column(
                children: [
                  if (onConfirm != null)
                    PlanifyButton.primary(
                      label: confirmLabel ?? 'Confirm',
                      onTap: () {
                        Navigator.pop(context);
                        onConfirm?.call();
                      },
                    ),
                  if (onCancel != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    PlanifyButton.outline(
                      label: cancelLabel ?? 'Cancel',
                      onTap: () {
                        Navigator.pop(context);
                        onCancel?.call();
                      },
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Mostrar modal bottom sheet
Future<T?> showPlanifyModal<T>(
  BuildContext context, {
  required String title,
  required Widget child,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  String? confirmLabel,
  String? cancelLabel,
  bool showHeader = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (_) => PlanifyModal(
      title: title,
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      showHeader: showHeader,
      child: child,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.xl),
      ),
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}

/// Mostrar dialog customizado
Future<T?> showPlanifyDialog<T>(
  BuildContext context, {
  required String title,
  required Widget child,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  String? confirmLabel,
  String? cancelLabel,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => PlanifyDialog(
      title: title,
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      barrierDismissible: barrierDismissible,
      child: child,
    ),
  );
}
