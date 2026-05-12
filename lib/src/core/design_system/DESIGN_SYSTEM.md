# Design System — Planify

Design System do Planify baseado no projeto Figma compartilhado. Estrutura centralizada de cores, tipografia, espaçamentos e componentes reutilizáveis.

---

## 📁 Estrutura

```
lib/src/core/design_system/
├── tokens/
│   ├── app_colors.dart          # Paleta de cores
│   ├── app_spacing.dart         # Espaçamentos (base 4px)
│   ├── app_radius.dart          # Border radius
│   ├── app_shadows.dart         # Elevações/Sombras
│   ├── app_durations.dart       # Durações de animações
│   └── app_icon_size.dart       # Tamanhos de ícones
├── theme/
│   ├── app_theme.dart           # Tema geral (ThemeData)
│   └── color_scheme_ext.dart    # Extensões de ColorScheme
├── widgets/
│   ├── avatar/
│   │   └── planify_avatar.dart
│   ├── buttons/
│   │   └── planify_button.dart
│   ├── cards/
│   │   └── planify_card.dart
│   ├── inputs/
│   │   └── planify_text_field.dart
│   └── feedback/
│       └── planify_error_banner.dart
└── design_system.dart           # Exportação centralizada
```

---

## 🎨 Paleta de Cores

### Cores Primárias (Roxo)
- **Primary**: `#7c5cff` — Cor de destaque principal
- **Primary Light**: `#9d8fff` — Variação clara
- **Primary Dark**: `#5d45cc` — Variação escura

### Cores Secundárias (Rosa/Magenta)
- **Secondary**: `#ff5e78` — Cor secundária
- **Secondary Light**: `#ff8a9b`
- **Secondary Dark**: `#cc4961`

### Cores de Estado
- **Success (Verde)**: `#00d9a3` — Sucesso/Positivo
- **Warning (Laranja)**: `#ff9500` — Aviso/Cautela
- **Error (Vermelho)**: `#ff5e78` — Erro/Negativo
- **Info (Azul Claro)**: `#00d9ff` — Informação

### Cores de Background
- **Background**: `#0f0f0f` — Fundo principal (preto profundo)
- **Surface**: `#1a1a1a` — Superfícies (cards, surfaces)
- **Surface Variant**: `#2d2d2d` — Variação
- **Surface Light**: `#3d3d3d` — Mais clara

### Cores de Texto
- **Text Primary**: `#ffffff` — Texto principal
- **Text Secondary**: `#b3b3b3` — Texto secundário
- **Text Tertiary**: `#808080` — Texto auxiliar

### Cores Financeiras
- **Income (Verde)**: `#00d9a3`
- **Expense (Rosa)**: `#ff5e78`

---

## 📏 Espaçamentos

Base 4px — escala consistente:

```dart
AppSpacing.xxs  // 2px
AppSpacing.xs   // 4px
AppSpacing.sm   // 8px
AppSpacing.md   // 16px
AppSpacing.lg   // 24px
AppSpacing.xl   // 32px
AppSpacing.xxl  // 48px
AppSpacing.xxxl // 64px
```

Também há insets prontos:
```dart
AppSpacing.pagePadding   // 24px horizontal, 16px vertical
AppSpacing.cardPadding   // 16px em todos os lados
```

---

## 🔲 Border Radius

```dart
AppRadius.xs         // 4px
AppRadius.sm         // 8px
AppRadius.md         // 12px — padrão para inputs
AppRadius.lg         // 16px — padrão para cards
AppRadius.xl         // 24px — padrão para dialogs
AppRadius.full       // 999px — círculos

// Semânticos:
AppRadius.button        // 12px
AppRadius.card          // 16px
AppRadius.input         // 12px
AppRadius.bottomSheet   // 24px (top corners)
```

---

## 🧩 Componentes

### Button (`planify_button.dart`)
Botão primário do aplicativo

```dart
PlanifyButton(
  label: 'Add Record',
  onPressed: () {},
)
```

### Card (`planify_card.dart`)
Card padrão para organizar conteúdo

```dart
PlanifyCard(
  child: YourWidget(),
  padding: AppSpacing.cardPadding,
)
```

### TextField (`planify_text_field.dart`)
Input de texto com validação

```dart
PlanifyTextField(
  label: 'Amount',
  keyboardType: TextInputType.number,
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
)
```

### Avatar (`planify_avatar.dart`)
Avatar circular para usuários/accounts

```dart
PlanifyAvatar(
  initials: 'JD',
  backgroundColor: AppColors.primary,
)
```

### Error Banner (`planify_error_banner.dart`)
Banner para exibir erros

```dart
PlanifyErrorBanner(
  message: 'Erro ao carregar dados',
  onRetry: () {},
)
```

---

## 🎭 Como Usar

### 1. Importar o Design System
```dart
import 'package:planify/src/core/design_system/design_system.dart';
```

### 2. Acessar Cores
```dart
// Em widgets que têm BuildContext
Color primary = context.colors.primary; // via extension

// Ou direto (usar com cuidado, não respeita modo escuro)
Color color = AppColors.primary;
```

### 3. Usar Espaçamentos
```dart
SizedBox(height: AppSpacing.md)
Padding(padding: EdgeInsets.all(AppSpacing.lg))
```

### 4. Aplicar Border Radius
```dart
BorderRadius.circular(AppRadius.card)
BorderRadius.only(
  topLeft: Radius.circular(AppRadius.bottomSheet),
  topRight: Radius.circular(AppRadius.bottomSheet),
)
```

### 5. Usar Componentes
```dart
PlanifyButton(label: 'Save', onPressed: () {})
PlanifyCard(child: myWidget)
PlanifyTextField(label: 'Name')
```

---

## 🎯 Dark Mode

O tema é automaticamente **dark-first**. O arquivo `app_theme.dart` gera dois temas:

- `AppTheme.light` — Light theme (gerado via ColorScheme)
- `AppTheme.dark` — Dark theme (padrão, gerado via ColorScheme)

No `main.dart`:
```dart
MaterialApp.router(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system,  // Segue preferência do sistema
)
```

---

## 📝 Tipografia

Definida automaticamente no `AppTheme` via `google_fonts` com tipografia **Inter**.

Acesse via `Theme.of(context).textTheme`:

```dart
Text('Title', style: Theme.of(context).textTheme.headlineMedium)
Text('Body', style: Theme.of(context).textTheme.bodyMedium)
```

---

## 📦 Extensões

### ColorScheme Extension
Acesso conveniente a cores via `context`:

```dart
// Em qualquer widget com BuildContext
context.colors.primary      // Cor primária
context.colors.surface      // Superfície
context.colors.error        // Erro
```

Acrescente e customize conforme necessário em `color_scheme_ext.dart`.

---

## 🚀 Boas Práticas

1. **Nunca use magic numbers** — sempre use `AppSpacing`, `AppRadius`, `AppColors`
2. **Acesse cores via `context.colors`** — respeita modo escuro
3. **Reutilize componentes** — `PlanifyButton`, `PlanifyCard`, etc.
4. **Mantenha escala consistente** — base 4px para tudo
5. **Documente novos tokens** — adicione no arquivo apropriado
6. **Teste em light e dark mode** — tema funciona em ambos

---

## 📚 Referências

- Material Design 3: https://m3.material.io/
- Google Fonts (Inter): https://fonts.google.com/specimen/Inter
- Paleta baseada em: [Figma do Planify]

---

**Última atualização**: 2026-05-11  
**Versão**: 1.0 (Figma Aligned)
