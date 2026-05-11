# Guia de Ícones SVG — Planify

Como importar e usar ícones SVG do Figma no projeto.

---

## 📋 Estrutura de Pastas

```
assets/
└── icons/
    ├── categories/
    │   ├── transport.svg
    │   ├── food.svg
    │   ├── entertainment.svg
    │   └── ...
    ├── transactions/
    │   ├── income.svg
    │   ├── expense.svg
    │   └── transfer.svg
    └── actions/
        ├── add.svg
        ├── edit.svg
        ├── delete.svg
        └── ...
```

---

## 🎨 Passo a Passo: Exportar do Figma

### 1. Selecionar o Ícone
- Abra seu projeto no Figma
- Selecione o ícone/componente que deseja exportar

### 2. Exportar como SVG
- No painel direito, procure por **Export** (ou menu ⋯ > Export)
- Clique em **+ Add export**
- Escolha o formato: **SVG**
- Clique em **Export**

### 3. Renomear e Organizar
- Nomeie o arquivo com format snake_case (ex: `shopping_bag.svg`)
- Coloque na pasta apropriada (`categories/`, `transactions/` ou `actions/`)

### 4. Atualizar AppSvgIcons
Adicione a referência em `lib/src/core/design_system/icons/app_svg_icons.dart`:

```dart
static const String shoppingCategory = 'assets/icons/categories/shopping_bag.svg';
```

---

## 💻 Usar no Código

### Uso Básico
```dart
import 'package:planify/src/core/design_system/design_system.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Forma simples
SvgPicture.asset(AppSvgIcons.shoppingCategory)

// Com widget wrapper (recomendado)
PlanifySvgIcon(
  AppSvgIcons.shoppingCategory,
  size: 32,
  color: AppColors.primary,
)
```

---

## 🎯 Widgets Disponíveis

### 1. PlanifySvgIcon
Ícone SVG simples com cor customizável.

```dart
PlanifySvgIcon(
  AppSvgIcons.shoppingCategory,
  size: 32,                          // Tamanho do ícone
  color: AppColors.primary,          // Cor (opcional)
  fit: BoxFit.contain,               // Ajuste
  alignment: Alignment.center,       // Alinhamento
  width: 32,                         // Largura (opcional)
  height: 32,                        // Altura (opcional)
)
```

### 2. PlanifySvgIconButton
Ícone SVG dentro de um botão/container.

```dart
PlanifySvgIconButton(
  assetPath: AppSvgIcons.editAction,
  onPressed: () {},
  size: 24,                          // Tamanho do ícone
  iconColor: AppColors.primary,      // Cor do ícone
  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
  containerSize: 48,                 // Tamanho do container
)
```

### 3. PlanifySvgIconLarge
Ícone grande em card com background.

```dart
PlanifySvgIconLarge(
  assetPath: AppSvgIcons.entertainmentCategory,
  size: 48,
  backgroundColor: AppColors.info.withValues(alpha: 0.15),
  iconColor: AppColors.info,
  padding: EdgeInsets.all(AppSpacing.md),
)
```

---

## 📝 Exemplos Práticos

### Exemplo 1: Categoria em Card
```dart
PlanifyCard(
  child: Row(
    children: [
      PlanifySvgIconLarge(
        assetPath: AppSvgIcons.foodCategory,
        size: 48,
        backgroundColor: AppColors.warning.withValues(alpha: 0.15),
        iconColor: AppColors.warning,
      ),
      const SizedBox(width: AppSpacing.md),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Food', style: Theme.of(context).textTheme.bodyMedium),
          Text('\$450.00', style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    ],
  ),
)
```

### Exemplo 2: Lista de Transações com SVG
```dart
PlanifyTransactionItem(
  title: 'Shopping',
  subtitle: '31 Aug 2023',
  amount: '-\$25.56',
  icon: Icons.shopping_bag,  // Ainda pode usar Material Icons
  iconColor: AppColors.primary,
)

// Ou com SVG
Container(
  decoration: BoxDecoration(
    color: AppColors.primary.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(AppRadius.md),
  ),
  padding: EdgeInsets.all(AppSpacing.sm),
  child: PlanifySvgIcon(
    AppSvgIcons.shoppingCategory,
    size: 24,
    color: AppColors.primary,
  ),
)
```

### Exemplo 3: Action Buttons
```dart
Row(
  children: [
    PlanifySvgIconButton(
      assetPath: AppSvgIcons.editAction,
      onPressed: () => _editRecord(),
      iconColor: AppColors.primary,
    ),
    const SizedBox(width: AppSpacing.md),
    PlanifySvgIconButton(
      assetPath: AppSvgIcons.deleteAction,
      onPressed: () => _deleteRecord(),
      iconColor: AppColors.error,
      backgroundColor: AppColors.error.withValues(alpha: 0.1),
    ),
  ],
)
```

---

## 🎨 Colorindo SVGs

Os SVGs são coloridos usando `ColorFilter`. O widget wrapper faz isso automaticamente:

```dart
PlanifySvgIcon(
  AppSvgIcons.shoppingCategory,
  color: AppColors.primary,  // A cor é aplicada automaticamente
)
```

**Nota importante:** Para que a coloração funcione, o SVG deve:
- Ter cor **preta** ou cinza como base no Figma
- Ser exportado **sem cores** (deixar opção de herdar cor)

Se o SVG tiver cores definidas, ele pode não respeitar o `ColorFilter`.

---

## 📦 Usando SvgPicture Direto

Se precisar de mais controle, use `flutter_svg` diretamente:

```dart
import 'package:flutter_svg/flutter_svg.dart';

SvgPicture.asset(
  'assets/icons/categories/shopping.svg',
  width: 32,
  height: 32,
  colorFilter: const ColorFilter.mode(
    Colors.red,
    BlendMode.srcIn,
  ),
)
```

---

## ✅ Checklist de Importação

Ao adicionar um novo SVG:

- [ ] Exportar do Figma como **SVG**
- [ ] Colocar em pasta apropriada (`categories/`, `transactions/`, `actions/`)
- [ ] Renomear com **snake_case** (ex: `shopping_bag.svg`)
- [ ] Adicionar referência em `AppSvgIcons` class
- [ ] Usar via `PlanifySvgIcon` ou similar
- [ ] Testar cor (deve aceitar `ColorFilter`)
- [ ] Testar em light e dark mode

---

## 🐛 Troubleshooting

### SVG não aparece
**Solução:** Verifique se o path está correto no `AppSvgIcons` e se o arquivo existe na pasta correta.

### SVG não muda de cor
**Solução:** O SVG pode ter cores definidas internamente. No Figma:
1. Selecione o ícone
2. Defina a cor como **Preto** (#000000)
3. Exporte novamente

### Erro "File not found"
**Solução:** Confirme que:
1. O path em `AppSvgIcons` está correto
2. O arquivo existe na pasta `assets/icons/`
3. Rodou `flutter pub get` após adicionar assets no `pubspec.yaml`

### SVG muito pixelado
**Solução:** Aumentar a propriedade `size` do widget SVG. SVGs são escaláveis, mas para melhor performance, mantenha em tamanho razoável (não >512px).

---

## 🚀 Dicas de Performance

- Prefira usar Material Icons (`Icons.xxx`) para ícones padrão
- Use SVG customizado apenas para ícones únicos do design
- Mantenha SVGs simples (evite muitas formas complexas)
- Cache automático pelo Flutter (não se preocupe)

---

## 📚 Referências

- [flutter_svg documentation](https://pub.dev/packages/flutter_svg)
- [Exporting from Figma](https://help.figma.com/en/articles/360049283914)
- [SVG Best Practices](https://developer.mozilla.org/en-US/docs/Web/SVG)

---

**Última atualização**: 2026-05-11
