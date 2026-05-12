# Componentes Planify — Guia Completo

Documentação detalhada dos componentes específicos da aplicação Planify.

---

## 📊 Cards Financeiros

### PlanifyBalanceCard
Card grande que exibe o saldo total na tela home.

**Propriedades:**
```dart
PlanifyBalanceCard(
  title: 'Total Balance',           // Título do card
  amount: '\$26,000.00',             // Valor principal
  subtitle: '-\$12,450.30 spent',    // Texto secundário (opcional)
  onTap: () {},                      // Ação ao tocar (opcional)
  isLoading: false,                  // Estado de carregamento
)
```

**Exemplo:**
```dart
PlanifyBalanceCard(
  title: 'Total Balance',
  amount: '\$26,000.40',
  subtitle: '-\$12,450.30 spent this month',
)
```

---

### PlanifyBudgetCard
Card com barra de progresso para exibir orçamentos.

**Propriedades:**
```dart
PlanifyBudgetCard(
  title: 'Budget',
  amount: '\$14,500.00 left',
  spent: '-\$12,450.30 spent',
  remaining: '\$4,649.70 left',
  progress: 0.65,                    // 0.0 a 1.0
  progressColor: AppColors.primary,  // Cor da barra
  onTap: () {},                      // Ação ao tocar
)
```

**Exemplo:**
```dart
PlanifyBudgetCard(
  title: 'Budget',
  amount: '\$14,500.00 left',
  spent: '-\$12,450.30 spent',
  remaining: '\$4,649.70 left',
  progress: 0.72,
)
```

---

## 🔄 Items de Transação

### PlanifyTransactionItem
Item flexível para lista de transações com ícone customizável.

**Propriedades:**
```dart
PlanifyTransactionItem(
  title: 'Shopping',
  subtitle: '31 Aug 2023',
  amount: '-\$25.56',
  icon: Icons.shopping_bag,
  iconColor: AppColors.secondary,
  amountColor: AppColors.error,      // Cor do valor (opcional)
  onTap: () {},                       // Ação ao tocar
  trailing: widget,                   // Widget no final (opcional)
)
```

**Exemplo:**
```dart
PlanifyTransactionItem(
  title: 'Supermercado',
  subtitle: 'Hoje',
  amount: '-\$50.00',
  icon: Icons.shopping_cart,
  iconColor: AppColors.primary,
  amountColor: AppColors.expense,
)
```

---

### PlanifyTransactionItemSimple
Item simplificado com indicador automático de income/expense.

**Propriedades:**
```dart
PlanifyTransactionItemSimple(
  title: 'Salary Deposit',
  date: '31 Aug 2023',
  amount: 5000.00,
  isExpense: false,                  // true = despesa, false = renda
  customColor: AppColors.income,     // Cor customizada (opcional)
  onTap: () {},
)
```

**Exemplo:**
```dart
PlanifyTransactionItemSimple(
  title: 'Shopping',
  date: '31 Aug 2023',
  amount: 25.56,
  isExpense: true,
)
```

---

## 🔘 Seletores (Tabs)

### PlanifyTabSelector
Abas padrão com indicador inferior.

**Propriedades:**
```dart
PlanifyTabSelector(
  tabs: ['Expense', 'Income', 'Transfer'],
  selectedIndex: 0,
  onTabChanged: (index) {
    setState(() => _currentTab = index);
  },
  indicatorColor: AppColors.primary,
)
```

**Exemplo:**
```dart
PlanifyTabSelector(
  tabs: ['Expense', 'Income', 'Transfer'],
  selectedIndex: _tabIndex,
  onTabChanged: (index) => setState(() => _tabIndex = index),
)
```

---

### PlanifyTabSelectorInline
Abas em estilo capsule (com background).

**Propriedades:**
```dart
PlanifyTabSelectorInline(
  tabs: ['Expense', 'Income', 'Transfer'],
  selectedIndex: 0,
  onTabChanged: (index) {},
  backgroundColor: context.colors.surfaceVariant,  // Fundo base
  selectedColor: AppColors.primary,                 // Cor selecionada
  unselectedColor: context.colors.onSurfaceVariant, // Cor não selecionada
)
```

---

## 📝 Seleção de Items

### PlanifySelectableItem
Item individual selecionável.

**Propriedades:**
```dart
PlanifySelectableItem(
  label: 'Total Balance',
  subtitle: '\$26,000.40',
  icon: Icons.account_balance_wallet,
  iconColor: AppColors.primary,
  isSelected: true,
  onTap: () {},
  selectedBackgroundColor: AppColors.primary.withValues(alpha: 0.1),
)
```

---

### PlanifySelectableList
Lista de items selecionáveis.

**Propriedades:**
```dart
PlanifySelectableList(
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
  ],
  selectedIndex: 0,
  onItemSelected: (index) {},
  multiSelect: false,                    // true para múltiplas seleções
)
```

**Exemplo Multi-Select:**
```dart
PlanifySelectableList(
  items: accountItems,
  selectedIndices: [0, 2],
  onMultiSelectChanged: (indices) => setState(() => _selected = indices),
  multiSelect: true,
)
```

---

## 🎨 Seletor de Cores

### PlanifyColorPicker
Grid customizável de cores.

**Propriedades:**
```dart
PlanifyColorPicker(
  colors: [
    AppColors.primary,
    AppColors.secondary,
    AppColors.success,
    AppColors.warning,
  ],
  selectedColor: AppColors.primary,
  onColorSelected: (color) {},
  crossAxisCount: 6,        // Colunas
  spacing: AppSpacing.md,   // Espaço entre cores
  colorSize: 48,            // Tamanho de cada cor
)
```

---

### PlanifyColorPalettePreset
Paleta padrão Planify (6 cores principais).

```dart
PlanifyColorPalettePreset(
  selectedColor: _selectedColor,
  onColorSelected: (color) => setState(() => _selectedColor = color),
)
```

**Cores incluídas:**
- Primary (Roxo)
- Success (Verde)
- Warning (Laranja)
- Secondary (Rosa)
- Info (Azul)
- White (Branco)

---

### PlanifyColorPickerExtended
Paleta expandida (20 cores com variações).

```dart
PlanifyColorPickerExtended(
  selectedColor: _color,
  onColorSelected: (color) {},
)
```

---

## 🎯 Seletor de Ícones

### PlanifyIconPicker
Grid customizável de ícones.

```dart
PlanifyIconPicker(
  icons: [Icons.shopping_bag, Icons.restaurant, Icons.car],
  selectedIcon: Icons.shopping_bag,
  onIconSelected: (icon) {},
  crossAxisCount: 5,
  iconColor: AppColors.primary,
  iconSize: 32,
)
```

---

### PlanifyIconPickerPreset
Conjunto padrão de ícones (40+ ícones categorizados).

```dart
PlanifyIconPickerPreset(
  selectedIcon: _icon,
  onIconSelected: (icon) => setState(() => _icon = icon),
  iconColor: AppColors.primary,
)
```

**Categorias de ícones incluídas:**
- Transporte (carro, ônibus, avião, trem)
- Alimentos (restaurante, pizza, café, fast food)
- Casa (luz, água, construção)
- Entretenimento (filme, esportes, games, música)
- Saúde (hospital, academia, saúde)
- Shopping (bolsa, roupas, relógio, jóias)
- Outros (presentes, escola, trabalho, poupança)

---

### PlanifyIconDisplay
Card de exibição de ícone.

```dart
PlanifyIconDisplay(
  icon: Icons.shopping_bag,
  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
  iconColor: AppColors.primary,
  size: 48,
)
```

---

## 🪟 Modais

### PlanifyModal
Bottom sheet customizado.

**Propriedades:**
```dart
PlanifyModal(
  title: 'Add Record',
  child: YourContent(),
  onConfirm: () {},
  onCancel: () {},
  confirmLabel: 'Save',
  cancelLabel: 'Cancel',
  showHeader: true,
  padding: EdgeInsets.all(AppSpacing.lg),
)
```

---

### PlanifyDialog
Dialog customizado.

```dart
PlanifyDialog(
  title: 'Confirm',
  child: Text('Tem certeza?'),
  onConfirm: () {},
  confirmLabel: 'Yes',
  barrierDismissible: true,
)
```

---

## 📱 Helpers para Mostrar Modais

### showPlanifyModal()
Helper para exibir modal bottom sheet.

```dart
await showPlanifyModal(
  context,
  title: 'Select Icon & Color',
  child: Column(
    children: [
      Text('Escolha uma cor:'),
      PlanifyColorPalettePreset(
        onColorSelected: (color) {},
      ),
      SizedBox(height: AppSpacing.lg),
      Text('Escolha um ícone:'),
      PlanifyIconPickerPreset(
        onIconSelected: (icon) {},
      ),
    ],
  ),
  confirmLabel: 'Save',
  onConfirm: () {},
);
```

---

### showPlanifyDialog()
Helper para exibir dialog.

```dart
await showPlanifyDialog(
  context,
  title: 'Delete',
  child: Text('Deseja deletar esta transação?'),
  confirmLabel: 'Delete',
  cancelLabel: 'Cancel',
  onConfirm: () { /* deletar */ },
);
```

---

## 🎯 Exemplo Prático: Modal Completo

```dart
Future<void> _showAddRecordModal() async {
  String selectedTab = 'Expense';
  Color selectedColor = AppColors.primary;
  IconData selectedIcon = Icons.shopping_bag;
  int selectedAccount = 0;

  await showPlanifyModal(
    context,
    title: 'Add Record',
    child: StatefulBuilder(
      builder: (context, setState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tabs
          PlanifyTabSelectorInline(
            tabs: ['Expense', 'Income', 'Transfer'],
            selectedIndex: selectedTab == 'Expense' ? 0 : selectedTab == 'Income' ? 1 : 2,
            onTabChanged: (index) {
              setState(() => selectedTab = ['Expense', 'Income', 'Transfer'][index]);
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Valor
          PlanifyTextField(label: 'Amount'),
          const SizedBox(height: AppSpacing.lg),

          // Seleção de account
          Text('Account', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          PlanifySelectableList(
            items: [
              SelectableItemData(label: 'Total Balance', subtitle: '\$26,000'),
              SelectableItemData(label: 'Credit Card', subtitle: '\$10,000'),
            ],
            selectedIndex: selectedAccount,
            onItemSelected: (idx) => setState(() => selectedAccount = idx),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Cores e ícones
          Text('Choose Icon & Color', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          PlanifyColorPalettePreset(
            selectedColor: selectedColor,
            onColorSelected: (color) => setState(() => selectedColor = color),
          ),
          const SizedBox(height: AppSpacing.md),
          PlanifyIconPickerPreset(
            selectedIcon: selectedIcon,
            onIconSelected: (icon) => setState(() => selectedIcon = icon),
            iconColor: selectedColor,
          ),
        ],
      ),
    ),
    confirmLabel: 'Save',
    onConfirm: () {
      // Lógica para salvar
    },
  );
}
```

---

## ✅ Checklist de Uso

Ao usar componentes Planify:

- [ ] Importe via `import 'package:planify/src/core/design_system/design_system.dart'`
- [ ] Use `AppSpacing.*` para espaçamentos
- [ ] Acesse cores via `context.colors` quando possível
- [ ] Teste em light e dark mode
- [ ] Mantenha consistência visual
- [ ] Documente uso customizado em comentários
- [ ] Use tipos corretos de componentes (não force um genérico quando há específico)

---

**Última atualização**: 2026-05-11  
**Versão**: 1.0
