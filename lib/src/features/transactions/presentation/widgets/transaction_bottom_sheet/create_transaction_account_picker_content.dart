import 'package:flutter/material.dart';
import 'package:planify/src/core/design_system/design_system.dart';
import 'package:planify/src/features/accounts/domain/entities/account_entity.dart';

class CreateTransactionAccountPickerContent extends StatelessWidget {
  const CreateTransactionAccountPickerContent({
    super.key,
    required this.accounts,
    required this.selected,
  });

  final List<AccountEntity> accounts;
  final AccountEntity? selected;

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma conta encontrada',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: accounts
          .map(
            (account) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: PlanifySelectableItem(
                label: account.name,
                isSelected: selected?.id == account.id,
                icon: Icons.credit_card_outlined,
                iconColor: AppColors.primary,
                onTap: () => Navigator.of(context).pop(account),
              ),
            ),
          )
          .toList(),
    );
  }
}
