# Arquitetura do Projeto — Flutter Finance App

## Stack Tecnológica

- **Linguagem**: Dart / Flutter
- **Backend/Banco**: Supabase (via package oficial `supabase_flutter`)
- **State Management**: BLoC (`flutter_bloc`)
- **Injeção de Dependência**: GetIt + Injectable + build_runner
- **Navegação**: GoRouter
- **Igualdade/Imutabilidade**: Equatable (Entities e Models)
- **Loading Skeleton**: package `skeletonizer` (ou equivalente de skeleton)
- **Padrão Arquitetural**: Clean Architecture

---

## Estrutura de Pastas Raiz

```
lib/
└── src/
    ├── features/
    │   ├── auth/
    │   ├── transactions/
    │   └── [outras features]/
    └── [core ou shared — a definir]
```

> ⚠️ **Em aberto**: A pasta `core` ou `shared` (para erros genéricos, extensions, tema, constantes globais) ainda não foi definida. Quando for decidida, deve ser documentada aqui e seguir a mesma disciplina de separação de responsabilidades.

---

## Estrutura por Feature

Cada feature segue obrigatoriamente as três camadas do Clean Architecture:

```
lib/src/features/[feature_name]/
├── data/
│   ├── models/
│   └── repository/
├── domain/
│   ├── entities/
│   └── repository/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

---

## Camada: Data

### `data/models/`
- Contém as classes responsáveis pela **leitura e serialização dos JSONs** vindos do Supabase.
- Cada Model deve estender `Equatable`.
- Devem implementar `fromJson` e `toJson`.
- Podem ter um método `toEntity()` para converter para a Entity correspondente.

```dart
// ✅ Exemplo correto
class TransactionModel extends Equatable {
  final String id;
  final double amount;
  final String type;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'type': type,
  };

  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    amount: amount,
    type: type,
  );

  @override
  List<Object?> get props => [id, amount, type];
}
```

### `data/repository/`
- Contém a **implementação concreta** do repositório.
- Implementa a interface definida em `domain/repository/`.
- É aqui que o Supabase é chamado diretamente.
- Deve converter Models em Entities antes de retornar ao Domain/BLoC.

```dart
// ✅ Exemplo correto
class TransactionRepositoryImpl implements TransactionRepository {
  final SupabaseClient _client;

  TransactionRepositoryImpl(this._client);

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final response = await _client.from('transactions').select();
    return response
        .map((json) => TransactionModel.fromJson(json).toEntity())
        .toList();
  }
}
```

---

## Camada: Domain

### `domain/entities/`
- Contém as **Entities puras** do negócio.
- Devem estender `Equatable`.
- **Não devem** ter dependência de nenhum package externo além do Equatable.
- **Não devem** conter `fromJson`/`toJson` — isso é responsabilidade dos Models.
- São as classes que o BLoC passa para as telas.

```dart
// ✅ Exemplo correto
class TransactionEntity extends Equatable {
  final String id;
  final double amount;
  final String type;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
  });

  @override
  List<Object?> get props => [id, amount, type];
}

// ❌ Errado — Entity não deve ter fromJson
class TransactionEntity {
  factory TransactionEntity.fromJson(Map<String, dynamic> json) { ... } // PROIBIDO
}
```

### `domain/repository/`
- Contém apenas a **interface (abstract class)** do repositório.
- Define o contrato que a camada Data deve implementar.
- Trabalha **exclusivamente com Entities**, nunca com Models.

```dart
// ✅ Exemplo correto
abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions();
  Future<void> createTransaction(TransactionEntity transaction);
}
```

---

## Camada: Presentation

### `presentation/bloc/`

Quando houver **apenas um BLoC** na feature:
```
presentation/
└── bloc/
    ├── transaction_bloc.dart
    ├── transaction_event.dart
    └── transaction_state.dart
```

Quando houver **mais de um BLoC** na feature, criar subpastas:
```
presentation/
└── bloc/
    ├── transaction_list/
    │   ├── transaction_list_bloc.dart
    │   ├── transaction_list_event.dart
    │   └── transaction_list_state.dart
    └── transaction_form/
        ├── transaction_form_bloc.dart
        ├── transaction_form_event.dart
        └── transaction_form_state.dart
```

#### Estados: Sealed Classes

Os estados do BLoC **devem** ser definidos com `sealed class`:

```dart
// ✅ Obrigatório — usar sealed class
sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

final class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

final class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

final class TransactionSuccess extends TransactionState {
  final List<TransactionEntity> transactions;
  const TransactionSuccess(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

final class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}

// ❌ Proibido — não usar abstract class com extends para estados
abstract class TransactionState {}
class TransactionLoading extends TransactionState {} // ERRADO
```

#### Mapeamento de Estado no BlocBuilder

**Obrigatório usar `switch` ao invés de `if-else`**:

```dart
// ✅ Obrigatório
BlocBuilder<TransactionBloc, TransactionState>(
  builder: (context, state) {
    return switch (state) {
      TransactionInitial() => const TransactionInitialWidget(),
      TransactionLoading() => const TransactionLoadingWidget(),
      TransactionSuccess(:final transactions) => TransactionSuccessWidget(
          transactions: transactions,
        ),
      TransactionError(:final message) => TransactionErrorWidget(
          message: message,
        ),
    };
  },
)

// ❌ Proibido
BlocBuilder<TransactionBloc, TransactionState>(
  builder: (context, state) {
    if (state is TransactionLoading) {
      return const TransactionLoadingWidget();
    } else if (state is TransactionSuccess) { // ERRADO
      ...
    }
  },
)
```

### `presentation/pages/`

- Contém o **widget raiz da tela** (Page).
- É responsável por fornecer o BLoC via `BlocProvider`.
- Contém o `BlocBuilder` que delega para widgets específicos por estado.
- Não deve conter lógica de UI — apenas orquestração de estado.

```dart
// ✅ Exemplo correto
class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TransactionBloc>()..add(const TransactionLoadEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text(TransactionStrings.pageTitle)),
        body: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            return switch (state) {
              TransactionInitial() => const TransactionInitialWidget(),
              TransactionLoading() => const TransactionLoadingWidget(),
              TransactionSuccess(:final transactions) => TransactionSuccessWidget(
                  transactions: transactions,
                ),
              TransactionError(:final message) => TransactionErrorWidget(
                  message: message,
                ),
            };
          },
        ),
      ),
    );
  }
}
```

### `presentation/widgets/`

- Contém os **widgets filhos** correspondentes a cada estado.
- Nomenclatura padrão: `[Feature][Estado]Widget`
  - `TransactionLoadingWidget`
  - `TransactionSuccessWidget`
  - `TransactionErrorWidget`
  - `TransactionInitialWidget`

#### Widgets de Loading

Os widgets de loading **devem** ser criados com o package de Skeleton:

```dart
// ✅ Obrigatório para loading
class TransactionLoadingWidget extends StatelessWidget {
  const TransactionLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (_, __) => const TransactionCardSkeleton(),
      ),
    );
  }
}

// ❌ Proibido para loading
class TransactionLoadingWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(); // Não usar — usar Skeleton
  }
}
```

---

## Strings e Magic Numbers

### ❌ Proibido em qualquer widget ou código de UI
```dart
// Proibido — string literal no widget
Text('Minhas Transações')

// Proibido — magic number
SizedBox(height: 16)
Padding(padding: EdgeInsets.all(8))
```

### ✅ Obrigatório — isolar em classes de constantes

**Strings:**
```dart
class TransactionStrings {
  static const String pageTitle = 'Minhas Transações';
  static const String errorMessage = 'Erro ao carregar transações';
  static const String emptyState = 'Nenhuma transação encontrada';
}
```

**Valores numéricos (espaçamentos, tamanhos):**
```dart
class TransactionDimens {
  static const double cardPadding = 16.0;
  static const double cardSpacing = 8.0;
  static const int skeletonItemCount = 6;
}
```

Uso:
```dart
Text(TransactionStrings.pageTitle)
SizedBox(height: TransactionDimens.cardSpacing)
```

---

## Injeção de Dependência

### Estrutura da pasta `modulo`

Cada feature tem **seu próprio arquivo de módulo** na pasta `modulo`:

```
lib/src/features/[feature_name]/
└── modulo/
    └── transaction_module.dart
```

### Padrão com `@module` do Injectable

```dart
// ✅ Obrigatório — usar @module do Injectable
@module
abstract class TransactionModule {
  @lazySingleton
  TransactionRepository get transactionRepository => TransactionRepositoryImpl(
    getIt<SupabaseClient>(),
  );

  @factory
  TransactionBloc get transactionBloc => TransactionBloc(
    getIt<TransactionRepository>(),
  );
}
```

- Cada módulo registra **todos os BLoCs e Repositories** da sua feature.
- Após alterações, rodar obrigatoriamente: `dart run build_runner build --delete-conflicting-outputs`

---

## Navegação com GoRouter

### Cada feature define suas próprias rotas

```dart
// ✅ Cada feature tem seu arquivo de rotas
// lib/src/features/transactions/routes/transaction_routes.dart

final transactionRoutes = [
  GoRoute(
    path: '/transactions',
    name: TransactionRoutes.list,
    builder: (_, __) => const TransactionPage(),
  ),
  GoRoute(
    path: '/transactions/new',
    name: TransactionRoutes.create,
    builder: (_, __) => const TransactionFormPage(),
  ),
];

class TransactionRoutes {
  static const String list = 'transaction-list';
  static const String create = 'transaction-create';
}
```

- Os nomes de rotas devem ser **constantes** (sem string literal espalhada pelo código).
- O GoRouter principal agrega as rotas de cada feature:

```dart
final router = GoRouter(
  routes: [
    ...transactionRoutes,
    ...authRoutes,
    // outras features
  ],
);
```

---

## Regras Gerais — NÃO Violar

| ❌ Proibido | ✅ Obrigatório |
|------------|----------------|
| `if-else` no `BlocBuilder` | `switch` com sealed classes |
| `abstract class` para estados do BLoC | `sealed class` |
| String literal em widgets | Classe de constantes `*Strings` |
| Magic numbers em widgets | Classe de constantes `*Dimens` |
| `CircularProgressIndicator` para loading | Widget com Skeleton |
| `fromJson` em Entities | `fromJson` apenas em Models |
| Lógica de negócio em Pages | Pages apenas orquestram estado |
| Supabase chamado fora da camada Data | Supabase apenas em `data/repository/` |
| Rotas como strings soltas | Constantes em `*Routes` |
| Um módulo global de DI | Um módulo por feature |

---

## Checklist ao Criar uma Nova Feature

- [ ] Criar pasta `lib/src/features/[feature_name]/`
- [ ] Criar camada `data/models/` — Model com Equatable + fromJson/toJson/toEntity
- [ ] Criar camada `data/repository/` — implementação com Supabase
- [ ] Criar camada `domain/entities/` — Entity com Equatable
- [ ] Criar camada `domain/repository/` — interface abstract class
- [ ] Criar camada `presentation/bloc/` — sealed class para estados, switch no BlocBuilder
- [ ] Criar camada `presentation/pages/` — Page com BlocProvider + BlocBuilder
- [ ] Criar camada `presentation/widgets/` — um widget por estado, Loading com Skeleton
- [ ] Criar `modulo/[feature]_module.dart` — @module com Injectable
- [ ] Criar `routes/[feature]_routes.dart` — rotas e constantes de nome
- [ ] Criar classes de constantes `[Feature]Strings` e `[Feature]Dimens`
- [ ] Rodar `build_runner` após alterações no módulo de DI
