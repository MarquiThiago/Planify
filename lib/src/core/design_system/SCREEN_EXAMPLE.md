# Exemplo de Screen Completa

Exemplo prático de implementação da Home Screen usando todos os componentes do Design System.

---

## 📱 Home Screen — Implementação Completa

```dart
import 'package:flutter/material.dart';
import 'package:planify/src/core/design_system/design_system.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mock data
  final List<Map<String, dynamic>> transactions = [
    {
      'title': 'Shopping',
      'date': '31 Aug 2023',
      'amount': 25.56,
      'icon': Icons.shopping_bag,
      'isExpense': true,
    },
    {
      'title': 'Salary',
      'date': '30 Aug 2023',
      'amount': 5000.00,
      'icon': Icons.trending_up,
      'isExpense': false,
    },
    {
      'title': 'Coffee',
      'date': '29 Aug 2023',
      'amount': 5.50,
      'icon': Icons.local_cafe,
      'isExpense': true,
    },
  ];

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Entertainment',
      'amount': 3430.50,
      'icon': Icons.movie,
      'color': AppColors.info,
    },
    {
      'name': 'Food',
      'amount': 430.00,
      'icon': Icons.restaurant,
      'color': AppColors.warning,
    },
    {
      'name': 'Transport',
      'amount': 150.00,
      'icon': Icons.directions_car,
      'color': AppColors.success,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0,
      ),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          // 1. Balance Card
          PlanifyBalanceCard(
            title: 'Total Balance',
            amount: '\$26,000.00',
            subtitle: '-\$12,450.30 spent this month',
            onTap: () => _showAccountSelector(),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 2. Budget Card
          PlanifyBudgetCard(
            title: 'Budget',
            amount: '\$14,500.00 left',
            spent: '-\$12,450.30 spent',
            remaining: '\$4,649.70 left',
            progress: 0.72,
          ),
          const SizedBox(height: AppSpacing.lg),

          // 3. Categories Section
          _buildCategoriesSection(context),
          const SizedBox(height: AppSpacing.lg),

          // 4. Recent Transactions Section
          _buildTransactionsSection(context),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddRecordModal,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }

  // Section: Categories
  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Statistics'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 120,
          child: PageView(
            children: categories
                .map((cat) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: PlanifyCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: (cat['color'] as Color).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Icon(
                            cat['icon'] as IconData,
                            color: cat['color'] as Color,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.more_vert,
                          color: context.colors.onSurfaceVariant,
                          size: 20,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat['name'] as String,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '\$${(cat['amount'] as num).toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            color: cat['color'] as Color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))
                .toList(),
          ),
        ),
      ],
    );
  }

  // Section: Recent Transactions
  Widget _buildTransactionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (_, index) {
            final tx = transactions[index];
            return PlanifyTransactionItemSimple(
              title: tx['title'] as String,
              date: tx['date'] as String,
              amount: tx['amount'] as double,
              isExpense: tx['isExpense'] as bool,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transaction: ${tx['title']}')),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // Bottom Navigation
  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Records',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card),
          label: 'Cards',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
        ),
      ],
    );
  }

  // Modals
  void _showAddRecordModal() async {
    String selectedTab = 'Expense';
    double amount = 0;
    Color selectedColor = AppColors.primary;
    IconData selectedIcon = Icons.shopping_bag;
    int selectedAccount = 0;

    await showPlanifyModal(
      context,
      title: 'Add Record',
      child: StatefulBuilder(
        builder: (context, setState) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tab Selector
              PlanifyTabSelectorInline(
                tabs: const ['Expense', 'Income', 'Transfer'],
                selectedIndex: selectedTab == 'Expense'
                    ? 0
                    : selectedTab == 'Income'
                    ? 1
                    : 2,
                onTabChanged: (index) {
                  setState(() =>
                  selectedTab = ['Expense', 'Income', 'Transfer'][index]);
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Amount Display
              Center(
                child: Text(
                  '-\$${amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: selectedTab == 'Expense'
                        ? AppColors.expense
                        : AppColors.income,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Account Selection
              Text(
                'Account',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              PlanifySelectableList(
                items: [
                  SelectableItemData(
                    label: 'Total Balance',
                    subtitle: '\$26,000.40',
                    icon: Icons.account_balance_wallet,
                    iconColor: AppColors.primary,
                  ),
                  SelectableItemData(
                    label: 'Credit Card',
                    subtitle: '\$10,000',
                    icon: Icons.credit_card,
                    iconColor: AppColors.secondary,
                  ),
                  SelectableItemData(
                    label: 'Cash',
                    subtitle: '\$3,000',
                    icon: Icons.money,
                    iconColor: AppColors.success,
                  ),
                ],
                selectedIndex: selectedAccount,
                onItemSelected: (idx) =>
                setState(() => selectedAccount = idx),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Category Selection
              Text(
                'Category',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              PlanifySelectableItem(
                label: 'Transport',
                icon: Icons.directions_car,
                iconColor: selectedColor,
                isSelected: true,
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.lg),

              // Color & Icon Selection
              Text(
                'Choose Icon & Color',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              PlanifyColorPalettePreset(
                selectedColor: selectedColor,
                onColorSelected: (color) =>
                setState(() => selectedColor = color),
              ),
              const SizedBox(height: AppSpacing.lg),
              PlanifyIconPickerPreset(
                selectedIcon: selectedIcon,
                onIconSelected: (icon) =>
                setState(() => selectedIcon = icon),
                iconColor: selectedColor,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Date & Notes
              PlanifyTextField(
                label: 'Date & Time',
                readOnly: true,
                prefixIcon: const Icon(Icons.calendar_today),
              ),
              const SizedBox(height: AppSpacing.md),
              PlanifyTextField(
                label: 'Notes',
                maxLines: 3,
                minLines: 1,
              ),
            ],
          ),
        ),
      ),
      confirmLabel: 'Add Record',
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Record added: \$$amount')),
        );
      },
    );
  }

  void _showAccountSelector() async {
    await showPlanifyModal(
      context,
      title: 'Select Account',
      showHeader: true,
      child: PlanifySelectableList(
        items: [
          SelectableItemData(
            label: 'Total Balance',
            subtitle: '\$26,000.40',
            icon: Icons.account_balance_wallet,
          ),
          SelectableItemData(
            label: 'Credit Card',
            subtitle: '\$10,000',
            icon: Icons.credit_card,
          ),
          SelectableItemData(
            label: 'Debit Card',
            subtitle: '\$13,000.40',
            icon: Icons.card_giftcard,
          ),
          SelectableItemData(
            label: 'Cash',
            subtitle: '\$3,000',
            icon: Icons.money,
          ),
        ],
        selectedIndex: 0,
        onItemSelected: (index) => Navigator.pop(context),
      ),
    );
  }
}
```

---

## 📸 Resultado Visual

A implementação acima gera uma tela com:

1. **Header com AppBar** — "Home"
2. **Balance Card Grande** — Exibindo saldo total
3. **Budget Card** — Com progress bar
4. **Carrossel de Categorias** — Cada categoria em seu card
5. **Lista de Transações Recentes** — Items selecionáveis
6. **Bottom Navigation** — 4 tabs (Home, Records, Cards, Menu)
7. **FAB** — Botão flutuante para adicionar registro
8. **Modal Completo** — Com todos os componentes de seleção

---

## 🎯 Padrões Importantes

### 1. Organização Vertical
```dart
Column(
  children: [
    // Elemento 1
    const SizedBox(height: AppSpacing.lg),
    
    // Elemento 2
    const SizedBox(height: AppSpacing.lg),
  ],
)
```

### 2. Cards Sempre em PlanifyCard
```dart
PlanifyCard(
  child: YourContent(),
)
```

### 3. Modais via Helper
```dart
await showPlanifyModal(
  context,
  title: 'Title',
  child: widget,
  confirmLabel: 'Save',
  onConfirm: () {},
);
```

### 4. Cores via Context
```dart
Color color = context.colors.surface;
Color primary = context.colors.primary;
```

### 5. Espaçamentos Sempre Constantes
```dart
const SizedBox(height: AppSpacing.lg)  // ✅
SizedBox(height: 24)                   // ❌
```

---

## 📊 Estrutura de Dados Recomendada

Para manter consistência, estruture seus dados assim:

```dart
// Transação
final transaction = {
  'id': '1',
  'title': 'Shopping',
  'date': '31 Aug 2023',
  'amount': 25.56,
  'icon': Icons.shopping_bag,
  'iconColor': AppColors.primary,
  'isExpense': true,
  'category': 'Shopping',
  'account': 'Credit Card',
};

// Categoria
final category = {
  'id': '1',
  'name': 'Entertainment',
  'amount': 3430.50,
  'icon': Icons.movie,
  'color': AppColors.info,
  'budget': 5000.00,
};

// Account
final account = {
  'id': '1',
  'name': 'Total Balance',
  'balance': 26000.40,
  'icon': Icons.account_balance_wallet,
  'color': AppColors.primary,
};
```

---

## ✅ Checklist de Implementação

- [ ] Todos os espaçamentos usam `AppSpacing.*`
- [ ] Cores acessadas via `context.colors` ou `AppColors.*`
- [ ] Cards sempre usam `PlanifyCard` ou variações
- [ ] Modais usam helpers (`showPlanifyModal`, `showPlanifyDialog`)
- [ ] Lists usam componentes específicos (`PlanifyTransactionItem`, etc)
- [ ] Tema aplicado globalmente no `main.dart`
- [ ] Testado em light e dark mode
- [ ] Nenhum valor hardcoded na UI

---

**Última atualização**: 2026-05-11
