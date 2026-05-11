# Paleta de Cores — Planify

Paleta completa de cores baseada no design do Figma.

---

## 🎨 Cores Primárias

### Roxo (Primary)
```
Primary Dark  #5d45cc
Primary       #7c5cff  ← Cor principal
Primary Light #9d8fff
```

**Uso:** Botões primários, ícones ativos, links, destaques

```dart
AppColors.primary          // #7c5cff
AppColors.primaryLight     // #9d8fff
AppColors.primaryDark      // #5d45cc
```

---

## 🎨 Cores Secundárias

### Rosa/Magenta (Secondary)
```
Secondary Dark  #cc4961
Secondary       #ff5e78  ← Cor secundária
Secondary Light #ff8a9b
```

**Uso:** Ações secundárias, avisos, estado de erro

```dart
AppColors.secondary        // #ff5e78
AppColors.secondaryLight   // #ff8a9b
AppColors.secondaryDark    // #cc4961
```

---

## 🟢 Cores de Estado

### Sucesso (Verde)
```
Success Dark   #00a67d
Success        #00d9a3  ← Sucesso/Positivo
Success Light  #33e6b8
```

**Uso:** Transações de entrada, confirmações, status positivo

```dart
AppColors.success          // #00d9a3
AppColors.income           // #00d9a3 (alias)
```

### Aviso (Laranja)
```
Warning Dark   #cc7700
Warning        #ff9500  ← Aviso/Cautela
Warning Light  #ffa633
```

**Uso:** Avisos, estados pendentes, atenção

```dart
AppColors.warning          // #ff9500
```

### Erro (Vermelho)
```
Error Dark   #cc4961
Error        #ff5e78  ← Erro/Negativo
Error Light  #ff8a9b
```

**Uso:** Transações de saída, erros, status negativo, delete

```dart
AppColors.error            // #ff5e78
AppColors.expense          // #ff5e78 (alias financeiro)
```

### Info (Azul Claro)
```
Info Dark   #00a6cc
Info        #00d9ff  ← Informação
Info Light  #33e6ff
```

**Uso:** Informações, notificações, destaque secundário

```dart
AppColors.info             // #00d9ff
```

---

## 🌑 Cores Neutras (Background/Dark Theme)

### Escala Cinza Escura
```
Neutral 900 (Background)  #0f0f0f  ← Fundo principal
Neutral 800 (Surface)     #1a1a1a  ← Cards e surfaces
Neutral 700 (Variant)     #2d2d2d  ← Variações
Neutral 600 (Light)       #3d3d3d  ← Mais clara
Neutral 500               #6B7280  ← Texto secundário
Neutral 400               #808080  ← Texto terciário
Neutral 300               #D1D5DB
Neutral 200               #E5E7EB
Neutral 100               #F3F4F6
Neutral 50                #F9FAFB
```

**Uso:**
```dart
AppColors.background       // #0f0f0f
AppColors.surface          // #1a1a1a
AppColors.surfaceVariant   // #2d2d2d
AppColors.surfaceLight     // #3d3d3d
```

---

## 🔤 Cores de Texto

```
Text Primary    #ffffff (Branco)
Text Secondary  #b3b3b3 (Cinza médio)
Text Tertiary   #808080 (Cinza escuro)
```

**Uso:**
```dart
AppColors.textPrimary      // #ffffff
AppColors.textSecondary    // #b3b3b3
AppColors.textTertiary     // #808080
```

---

## 🔲 Cores de Borda

```
Border        #3d3d3d  ← Borda padrão
Border Light  #2d2d2d  ← Borda leve
```

**Uso:**
```dart
AppColors.border           // #3d3d3d
AppColors.borderLight      // #2d2d2d
```

---

## 💰 Cores Financeiras (Semânticas)

```
Income   #00d9a3  ← Entradas (Verde)
Expense  #ff5e78  ← Saídas (Rosa/Vermelho)
```

**Uso em transações:**
```dart
// Entrada
Icon(Icons.arrow_upward, color: AppColors.income)
Text('-\$50.00', style: TextStyle(color: AppColors.expense))

// Saída
Icon(Icons.arrow_downward, color: AppColors.expense)
Text('+\$100.00', style: TextStyle(color: AppColors.income))
```

---

## 📱 Como Usar em Widgets

### Acessar via Context (Recomendado)
```dart
// Respeita dark/light mode automaticamente
Color primaryColor = context.colors.primary;
Color surfaceColor = context.colors.surface;
```

### Acessar Direto (Use com Moderação)
```dart
// Use apenas para cores que não variam com tema
Color expenseColor = AppColors.expense;
Color incomeColor = AppColors.income;
```

### Em Texto
```dart
Text(
  'Sucesso!',
  style: TextStyle(color: context.colors.onSurface),
)

// Ou com TextTheme
Text(
  'Título',
  style: Theme.of(context).textTheme.headlineSmall,
)
```

### Em Containers
```dart
Container(
  color: context.colors.surface,
  decoration: BoxDecoration(
    color: context.colors.surfaceContainer,
    border: Border.all(color: context.colors.outline),
    borderRadius: BorderRadius.circular(AppRadius.card),
  ),
)
```

### Em Icons
```dart
Icon(
  Icons.arrow_downward,
  color: AppColors.expense,
  size: 24,
)
```

---

## 🎯 Combinações Recomendadas

### Card Padrão
```
Background: AppColors.surface (#1a1a1a)
Text: AppColors.textPrimary (#ffffff)
Border: AppColors.border (#3d3d3d)
```

### Botão Primário
```
Background: AppColors.primary (#7c5cff)
Text: AppColors.textPrimary (#ffffff)
Hover/Press: AppColors.primaryDark (#5d45cc)
```

### Status Positive
```
Foreground: AppColors.success (#00d9a3)
Background: AppColors.success.withOpacity(0.1)
```

### Status Negative
```
Foreground: AppColors.error (#ff5e78)
Background: AppColors.error.withOpacity(0.1)
```

---

## 🔄 Variações com Opacity

Para efeitos de hover, disabled, etc:

```dart
// Hover effect
AppColors.primary.withOpacity(0.8)

// Disabled state
AppColors.primary.withOpacity(0.5)

// Background subtil
AppColors.success.withOpacity(0.1)

// Overlay
AppColors.background.withOpacity(0.7)
```

---

## ✅ Checklist de Cores

Ao implementar um novo elemento:

- [ ] Escolha a cor apropriada (primary, secondary, semantic)
- [ ] Acesse via `context.colors` quando possível
- [ ] Teste em light e dark mode
- [ ] Use opacity apenas para variações (hover, disabled)
- [ ] Mantenha contraste (WCAG AA minimum 4.5:1 para texto)
- [ ] Documente a escolha da cor no comentário
- [ ] Não use magic hex values — use `AppColors.*`

---

## 📊 Paleta Completa (Tabela)

| Categoria | Nome | Hex | Luz | RGB |
|-----------|------|-----|-----|-----|
| Primary | Roxo | `#7c5cff` | 100% | rgb(124, 92, 255) |
| Secondary | Rosa | `#ff5e78` | 100% | rgb(255, 94, 120) |
| Success | Verde | `#00d9a3` | 100% | rgb(0, 217, 163) |
| Warning | Laranja | `#ff9500` | 100% | rgb(255, 149, 0) |
| Error | Vermelho | `#ff5e78` | 100% | rgb(255, 94, 120) |
| Info | Azul | `#00d9ff` | 100% | rgb(0, 217, 255) |
| Background | Preto | `#0f0f0f` | 6% | rgb(15, 15, 15) |
| Surface | Cinza escuro | `#1a1a1a` | 10% | rgb(26, 26, 26) |
| Text Primary | Branco | `#ffffff` | 100% | rgb(255, 255, 255) |
| Text Secondary | Cinza médio | `#b3b3b3` | 70% | rgb(179, 179, 179) |

---

**Última atualização**: 2026-05-11  
**Baseado em**: Figma Planify Project  
**Modo**: Dark Theme (Primary)
