import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/design_system/design_system.dart';
import 'package:planify/src/features/accounts/presentation/account_strings.dart';
import 'package:planify/src/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:planify/src/features/accounts/presentation/bloc/account_state.dart';
import 'package:planify/src/features/accounts/presentation/widgets/account_bottom_sheet.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeTabBody();
  }
}

class _HomeTabBody extends StatelessWidget {
  const _HomeTabBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.pagePadding,
          children: [
            BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) {
                return switch (state) {
                  AccountInitial() || AccountLoading() => const PlanifyBalanceCard(
                    title: AccountStrings.totalBalance,
                    amount: '',
                    isLoading: true,
                  ),
                  AccountSuccess(:final accounts) => PlanifyBalanceCard(
                    title: AccountStrings.totalBalance,
                    amount: _formatCurrency(
                      accounts.fold(0.0, (sum, a) => sum + a.balance),
                    ),
                    onTap: () => showAccountBottomSheet(context, accounts),
                  ),
                  AccountError() => const PlanifyBalanceCard(
                    title: AccountStrings.totalBalance,
                    amount: AccountStrings.balanceUnavailable,
                  ),
                };
              },
            ),
          ],
        ),
      ),
    );
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
