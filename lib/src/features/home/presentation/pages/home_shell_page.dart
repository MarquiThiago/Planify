import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/design_system/design_system.dart';
import '../cubit/home_nav_cubit.dart';
import '../home_strings.dart';
import 'cards_page.dart';
import 'home_tab_page.dart';
import 'menu_page.dart';
import 'records_page.dart';

class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key});

  static const _pages = [HomeTabPage(), RecordsPage(), CardsPage(), MenuPage()];

  static const _navItems = [
    PlanifyNavItem(
      icon: Icons.account_balance_outlined,
      label: HomeStrings.tabHome,
    ),
    PlanifyNavItem(
      icon: Icons.description_outlined,
      label: HomeStrings.tabRecords,
    ),
    PlanifyNavItem(icon: Icons.bar_chart_outlined, label: HomeStrings.tabCards),
    PlanifyNavItem(icon: Icons.menu, label: HomeStrings.tabMenu),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeNavCubit(),
      child: const _HomeShellBody(),
    );
  }
}

class _HomeShellBody extends StatelessWidget {
  const _HomeShellBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeNavCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: HomeShellPage._pages,
          ),
          bottomNavigationBar: PlanifyBottomNavBar(
            items: HomeShellPage._navItems,
            currentIndex: currentIndex,
            onTabSelected: context.read<HomeNavCubit>().selectTab,
            onAddTapped: () {
              // TODO: implementar ação de adicionar
            },
          ),
        );
      },
    );
  }
}
