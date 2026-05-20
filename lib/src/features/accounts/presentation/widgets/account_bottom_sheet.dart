import 'package:flutter/material.dart';
import 'package:planify/src/core/design_system/design_system.dart';

import '../../domain/entities/account_entity.dart';
import '../account_strings.dart';

/// Abre o bottom sheet de seleção de conta.
Future<void> showAccountBottomSheet(
  BuildContext context,
  List<AccountEntity> accounts,
) {
  final total = accounts.fold(0.0, (sum, a) => sum + a.balance);

  return showPlanifyModal(
    context,
    title: AccountStrings.selectAccount,
    child: _AccountBottomSheetContent(accounts: accounts, total: total),
  );
}

class _AccountBottomSheetContent extends StatelessWidget {
  const _AccountBottomSheetContent({
    required this.accounts,
    required this.total,
  });

  final List<AccountEntity> accounts;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlanifySelectableItem(
          label: AccountStrings.totalBalance,
          subtitle: _formatCurrency(total),
          icon: Icons.account_balance_outlined,
          iconColor: AppColors.primary,
          isSelected: false,
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(height: AppSpacing.md),
        ...accounts.map(
          (account) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: PlanifySelectableItem(
              label: account.name,
              subtitle: _formatCurrency(account.balance),
              icon: _iconForType(account.type),
              iconColor: _colorForType(account.type),
              isSelected: false,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  IconData _iconForType(String type) {
    return switch (type.toLowerCase()) {
      'credit' || 'credit_card' => Icons.credit_card_outlined,
      'debit' || 'checking' => Icons.payment_outlined,
      'cash' => Icons.payments_outlined,
      'savings' => Icons.savings_outlined,
      _ => Icons.account_balance_outlined,
    };
  }

  Color _colorForType(String type) {
    return switch (type.toLowerCase()) {
      'credit' || 'credit_card' => AppColors.secondary,
      'cash' => AppColors.success,
      'savings' => AppColors.info,
      _ => AppColors.primary,
    };
  }

  String _formatCurrency(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final intStr = parts[0];
    final decStr = parts[1];
    final buffer = StringBuffer();
    for (var i = 0; i < intStr.length; i++) {
      if (i > 0 && (intStr.length - i) % 3 == 0) buffer.write('.');
      buffer.write(intStr[i]);
    }
    return 'R\$ $buffer,$decStr';
  }
}
