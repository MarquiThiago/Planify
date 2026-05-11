# Design System — Exemplos Práticos

Exemplos de como usar os componentes e tokens do Design System Planify.

---

## 📌 Exemplo 1: Página Simples com Card

```dart
import 'package:flutter/material.dart';
import 'package:planify/src/core/design_system/design_system.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Transações'),
      ),
      body: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          children: [
            // Card com conteúdo
            PlanifyCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total de Gastos',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '\$5,350.43',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Botão primário
            PlanifyButton(
              label: 'Adicionar Transação',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 Exemplo 2: Usando Cores Dinâmicas

```dart
Container(
  padding: const EdgeInsets.all(AppSpacing.md),
  decoration: BoxDecoration(
    color: context.colors.surfaceContainerHigh,
    borderRadius: BorderRadius.circular(AppRadius.card),
    border: Border.all(
      color: context.colors.outline,
    ),
  ),
  child: Row(
    children: [
      Icon(
        Icons.arrow_downward,
        color: AppColors.expense, // Vermelho para despesa
      ),
      const SizedBox(width: AppSpacing.md),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Supermercado',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Hoje',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
      const Spacer(),
      Text(
        '-\$50.00',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.expense,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
)
```

---

## 🔘 Exemplo 3: Formulário com Inputs

```dart
class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          PlanifyCard(
            child: Column(
              children: [
                // Input de valor
                PlanifyTextField(
                  label: 'Valor',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: _amountController,
                  validator: (value) {
                    if (value?.isEmpty == true) return 'Obrigatório';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Input de descrição
                PlanifyTextField(
                  label: 'Descrição',
                  controller: _descriptionController,
                  maxLines: 3,
                  minLines: 1,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Botão de submit
          PlanifyButton(
            label: 'Salvar Transação',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Lógica de submit
              }
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 🎯 Exemplo 4: Bottom Navigation com Cores

```dart
BottomNavigationBar(
  backgroundColor: context.colors.surface,
  selectedItemColor: context.colors.primary,
  unselectedItemColor: context.colors.onSurfaceVariant,
  items: [
    BottomNavigationBarItem(
      icon: const Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.history),
      label: 'Records',
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.add),
      label: 'Add',
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.wallet),
      label: 'Cards',
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.menu),
      label: 'Menu',
    ),
  ],
)
```

---

## 💰 Exemplo 5: Indicador Income/Expense

```dart
class TransactionIndicator extends StatelessWidget {
  final bool isExpense;
  final String amount;

  const TransactionIndicator({
    super.key,
    required this.isExpense,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final color = isExpense ? AppColors.expense : AppColors.income;
    final icon = isExpense ? Icons.arrow_downward : Icons.arrow_upward;
    final prefix = isExpense ? '-' : '+';

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$prefix$amount',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 📊 Exemplo 6: Cards de Categoria com Cores

```dart
class CategoryCard extends StatelessWidget {
  final String name;
  final double amount;
  final Color color;
  final IconData icon;

  const CategoryCard({
    super.key,
    required this.name,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return PlanifyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Icon(
                Icons.more_vert,
                color: context.colors.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Uso:
CategoryCard(
  name: 'Alimentação',
  amount: 450.50,
  color: AppColors.primary,
  icon: Icons.restaurant,
)
```

---

## 🔄 Exemplo 7: Loading State com Skeleton

```dart
class TransactionListLoading extends StatelessWidget {
  const TransactionListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, __) => PlanifyCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 16,
              width: 150,
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 14,
              width: 100,
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 Exemplo 8: Custom Theme via Extension

Para adicionar temas customizados, estenda `color_scheme_ext.dart`:

```dart
extension CustomColors on ColorScheme {
  Color get incomeGreen => AppColors.income;
  Color get expenseRed => AppColors.expense;
  Color get transactionCard => AppColors.surface;
}

// Uso:
Text(
  'Entrada',
  style: TextStyle(color: context.colors.incomeGreen),
)
```

---

## ✅ Checklist para Novos Componentes

Ao criar um novo componente, siga:

- [ ] Use `AppSpacing.*` para todos os espaçamentos
- [ ] Use `AppRadius.*` para border radius
- [ ] Acesse cores via `context.colors` (respeita dark mode)
- [ ] Documente props e comportamento
- [ ] Teste em light e dark mode
- [ ] Adicione exemplo de uso
- [ ] Exporte em `design_system.dart`

---

**Última atualização**: 2026-05-11
