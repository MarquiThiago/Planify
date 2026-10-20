# Error Handling & Logging — Architecture Decision Record

## Overview

This document defines every decision made for the error handling and logging architecture in Planify. It is the single source of truth to be followed during implementation — no deviations without updating this document first.

---

## Stack & Packages

| Concern | Solution |
|---|---|
| Error representation | Sealed `Failure` hierarchy |
| Repository return type — futures | `Either<Failure, T>` via `dartz` |
| Repository return type — streams | `Stream<Either<Failure, T>>` |
| Repository error wrapper — futures | `RepositoryMixin.safeCall` |
| Repository error wrapper — streams | `RepositoryMixin.safeStream` |
| Logger abstraction | `AppLogger` abstract interface |
| Logger — production | `SentryLogger` (calls Sentry SDK) |
| Logger — development/debug | `ConsoleLogger` (prints to terminal) |
| BLoC-level logging | `AppBlocObserver` (auto, covers all BLoCs) |
| Logging dashboard | Sentry |

**Packages to add to `pubspec.yaml`:**
```yaml
dependencies:
  dartz: <latest>
  sentry_flutter: <latest>
```

---

## Folder Structure

Everything lives under `lib/src/core/`. Two new subfolders will be created:

```
lib/src/core/
├── errors/
│   ├── failures.dart          # Sealed Failure hierarchy
│   └── base_repository.dart   # BaseRepository mixin with safeCall
└── logging/
    ├── app_logger.dart        # Abstract AppLogger interface
    ├── sentry_logger.dart     # Production implementation
    ├── console_logger.dart    # Development implementation
    └── app_bloc_observer.dart # BlocObserver wired to AppLogger
```

> No other existing folder is modified. No global DI file is touched — each feature keeps its own module. A `CoreModule` (or equivalent) in `core/di/` will register the `AppLogger`.

---

## 1. Failure Hierarchy

### Decision
All errors in the application are represented as subtypes of a sealed `Failure` class. Exceptions are **never** propagated beyond the repository layer — they are always caught and converted to a `Failure`.

### Base class

```dart
// lib/src/core/errors/failures.dart

sealed class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}
```

### Subtypes

| Class | Mapped from | When to use |
|---|---|---|
| `AuthFailure` | Supabase `AuthException` | Login, signup, OAuth, password recovery failures |
| `SessionExpiredFailure` | Supabase `AuthException` with session-related codes | User session is invalid or expired |
| `DatabaseFailure` | Supabase `PostgrestException` | Any database read/write error; carries `pgCode` |
| `NetworkFailure` | `SocketException` / no connectivity | Device has no internet or request timed out |
| `UnexpectedFailure` | Any uncaught `Exception` | Fallback for anything not mapped above |

```dart
final class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

final class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure({required super.message, super.code});
}

final class DatabaseFailure extends Failure {
  final String? pgCode; // PostgreSQL error code (e.g. '23505')
  const DatabaseFailure({required super.message, this.pgCode, super.code});

  @override
  List<Object?> get props => [...super.props, pgCode];
}

final class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}
```

### Rules
- `Failure` subtypes live **only** in `core/errors/failures.dart`.
- New subtypes are only added here — features do **not** define their own `Failure` classes.
- The list will grow over time. Adding a new subtype requires updating this document.

---

## 2. Either<Failure, T> — Repository Return Type

### Decision
Every repository function returns `Either<Failure, T>` from the `dartz` package instead of throwing exceptions or returning nullable values.

- `Right(value)` → success
- `Left(failure)` → typed, descriptive failure

### Domain repository interface (contract)

```dart
abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getTransactions(int year, int month);
  Future<Either<Failure, void>> createTransaction(CreateTransactionEntity transaction);
}
```

### BLoC consumption

```dart
final result = await _repository.getTransactions(year, month);

result.fold(
  (failure) => emit(TransactionError(failure)),
  (transactions) => emit(TransactionSuccess(transactions)),
);
```

### BLoC error state

Every BLoC error state carries a `Failure`, **not** a raw `String`:

```dart
final class TransactionError extends TransactionState {
  final Failure failure;
  const TransactionError(this.failure);

  @override
  List<Object?> get props => [failure];
}
```

### UI consumption

The UI can pattern-match on the `Failure` type for contextual messaging:

```dart
TransactionError(:final failure) => switch (failure) {
  NetworkFailure() => const NoInternetWidget(),
  SessionExpiredFailure() => const SessionExpiredWidget(),
  _ => GenericErrorWidget(message: failure.message),
},
```

### Rules
- `Either` is **only** used at the repository boundary (domain `repository/` interface and `data/repository/` implementation).
- BLoCs and UI **never** work with `Either` directly — they consume the unwrapped value via `.fold()`.
- `Stream`-returning functions are **excluded** for now and will be addressed in a separate decision.

---

## 3. BaseRepository Mixin — safeCall Wrapper

### Decision
A `RepositoryMixin` provides a single `safeCall` method that:
1. Catches all known Supabase/network exceptions
2. Maps them to the correct `Failure` subtype
3. Logs the error with structured context via `AppLogger`
4. Returns `Either<Failure, T>`

This eliminates duplicated try/catch blocks in every repository function.

### Implementation

```dart
// lib/src/core/errors/base_repository.dart

mixin RepositoryMixin {
  AppLogger get logger;

  Future<Either<Failure, T>> safeCall<T>(
    Future<T> Function() operation, {
    required String operationName,
    Map<String, dynamic> context = const {},
  }) async {
    logger.debug('[$operationName] started', context: context);

    try {
      final result = await operation();
      logger.debug('[$operationName] succeeded');
      return Right(result);

    } on AuthException catch (e, st) {
      final failure = _isSessionError(e)
          ? SessionExpiredFailure(message: e.message, code: e.statusCode?.toString())
          : AuthFailure(message: e.message, code: e.statusCode?.toString());
      return _handleError(failure, st, operationName, context);

    } on PostgrestException catch (e, st) {
      final failure = DatabaseFailure(message: e.message, pgCode: e.code);
      return _handleError(failure, st, operationName, context);

    } on SocketException catch (e, st) {
      final failure = NetworkFailure(message: e.message);
      return _handleError(failure, st, operationName, context);

    } catch (e, st) {
      final failure = UnexpectedFailure(message: e.toString());
      return _handleError(failure, st, operationName, context);
    }
  }

  Either<Failure, T> _handleError<T>(
    Failure failure,
    StackTrace stackTrace,
    String operationName,
    Map<String, dynamic> context,
  ) {
    logger.error(
      operationName,
      failure: failure,
      stackTrace: stackTrace,
      context: context,
    );
    return Left(failure);
  }

  bool _isSessionError(AuthException e) {
    // Supabase session-related status codes
    const sessionCodes = ['401', '403'];
    return sessionCodes.contains(e.statusCode?.toString());
  }
}
```

### Usage in a repository

```dart
class TransactionRepositoryImpl with RepositoryMixin implements TransactionRepository {
  @override
  final AppLogger logger;

  final SupabaseClient _client;

  TransactionRepositoryImpl(this._client, this.logger);

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions(int year, int month) =>
      safeCall(
        () async {
          final data = await _client.from('transactions').select();
          return data.map((j) => TransactionModel.fromJson(j).toEntity()).toList();
        },
        operationName: 'TransactionRepository.getTransactions',
        context: {'year': year, 'month': month},
      );
}
```

### Rules
- Every `data/repository/` implementation class **must** use `with RepositoryMixin`.
- Every public repository method **must** be wrapped in `safeCall`.
- The `operationName` must follow the format `ClassName.methodName` for consistent log filtering in Sentry.
- The `context` map must include every parameter relevant to reproduce the error.
- Raw try/catch blocks are **forbidden** inside repository implementations.

---

## 4. RepositoryMixin — safeStream Wrapper

### Decision
`RepositoryMixin` also exposes a `safeStream` method for all `Stream`-returning repository functions. It mirrors `safeCall` in exception mapping and logging, but wraps a `Stream<T>` instead of a `Future<T>`.

### Return type: `Stream<Either<Failure, T>>`

Stream-returning repository functions return `Stream<Either<Failure, T>>` instead of `Stream<T>`. This means:

- `Right(value)` — a successful data emission
- `Left(failure)` — an error emission (startup failure or mid-stream error)

The stream itself **never throws** — errors become `Left` events. This allows the BLoC to handle all cases (startup failure, mid-stream error) with the same single `emit.forEach` call.

### Why not `Either<Failure, Stream<T>>`

The alternative `Either<Failure, Stream<T>>` was rejected because it only covers failures at subscription time. Errors that occur mid-stream (e.g. Supabase Realtime disconnection) would still require a separate error mechanism. `Stream<Either<Failure, T>>` covers all three failure points — startup, mid-stream, and reconnection — with one unified approach.

### Stream lifecycle after an error

When a `Left` is emitted, **the stream closes**. This is intentional. If a Supabase Realtime subscription fails mid-stream, the correct behavior is a clean restart — not keeping a half-alive subscription in an unknown state. The BLoC transitions to an error state and the user triggers a retry, which re-subscribes by dispatching the watch event again.

```
stream:  Right([...])  →  Right([...])  →  Left(NetworkFailure)  ← closes
```

### Implementation

Added to the same `RepositoryMixin` in `base_repository.dart`:

```dart
Stream<Either<Failure, T>> safeStream<T>(
  Stream<T> Function() streamBuilder, {
  required String operationName,
  Map<String, dynamic> context = const {},
}) async* {
  logger.debug('[$operationName] stream started', context: context);

  try {
    await for (final value in streamBuilder()) {
      yield Right(value);
    }
    logger.debug('[$operationName] stream closed');

  } on AuthException catch (e, st) {
    final failure = _isSessionError(e)
        ? SessionExpiredFailure(message: e.message, code: e.statusCode?.toString())
        : AuthFailure(message: e.message, code: e.statusCode?.toString());
    logger.error(operationName, failure: failure, stackTrace: st, context: context);
    yield Left(failure);

  } on PostgrestException catch (e, st) {
    final failure = DatabaseFailure(message: e.message, pgCode: e.code);
    logger.error(operationName, failure: failure, stackTrace: st, context: context);
    yield Left(failure);

  } on SocketException catch (e, st) {
    final failure = NetworkFailure(message: e.message);
    logger.error(operationName, failure: failure, stackTrace: st, context: context);
    yield Left(failure);

  } catch (e, st) {
    final failure = UnexpectedFailure(message: e.toString());
    logger.error(operationName, failure: failure, stackTrace: st, context: context);
    yield Left(failure);
  }
}
```

### Usage in a repository

```dart
@override
Stream<Either<Failure, List<AccountEntity>>> watchAccounts() =>
    safeStream(
      () => _client
          .from('accounts')
          .stream(primaryKey: ['id'])
          .map((data) => data.map((j) => AccountModel.fromJson(j).toEntity()).toList()),
      operationName: 'AccountRepository.watchAccounts',
    );
```

### BLoC consumption

Use `emit.forEach` — the correct BLoC API for streams. It handles subscription lifecycle automatically (cancels on BLoC close).

```dart
on<AccountWatchEvent>((event, emit) async {
  await emit.forEach<Either<Failure, List<AccountEntity>>>(
    _repository.watchAccounts(),
    onData: (result) => result.fold(
      (failure) => AccountError(failure),
      (accounts) => AccountSuccess(accounts),
    ),
    onError: (error, st) {
      // Should never be reached — safeStream absorbs all errors into Left.
      // Acts as a final safety net.
      final failure = UnexpectedFailure(message: error.toString());
      logger.fatal('Unhandled stream error', error: error, stackTrace: st);
      return AccountError(failure);
    },
  );
});
```

### safeCall vs safeStream — side by side

| | `safeCall` | `safeStream` |
|---|---|---|
| Input | `Future<T> Function()` | `Stream<T> Function()` |
| Return | `Future<Either<Failure, T>>` | `Stream<Either<Failure, T>>` |
| Error coverage | Single async call | Startup + mid-stream |
| After error | Returns `Left` | Emits `Left` then closes |
| BLoC consumption | `.fold()` on awaited result | `emit.forEach` |
| Logging | Same structured context | Same structured context |

### Rules
- Every stream-returning repository function **must** use `safeStream`.
- The domain `repository/` interface must declare the return type as `Stream<Either<Failure, T>>`.
- BLoCs consuming streams **must** use `emit.forEach` — never `.listen()` manually.
- The `onError` callback in `emit.forEach` is a safety net only — it should never be reached under normal operation.

---

## 6. AppLogger — Logger Abstraction

### Decision
An abstract `AppLogger` interface decouples the logging calls from the underlying SDK. This allows:
- Swapping implementations without touching any repository or BLoC code
- Injecting a `ConsoleLogger` in development and a `SentryLogger` in production
- Injecting a mock/no-op logger in unit tests

### Interface

```dart
// lib/src/core/logging/app_logger.dart

abstract interface class AppLogger {
  void debug(String message, {Map<String, dynamic> context});

  void info(String message, {Map<String, dynamic> context});

  void warning(String message, {Map<String, dynamic> context});

  void error(
    String operation, {
    required Failure failure,
    required StackTrace stackTrace,
    Map<String, dynamic> context,
  });

  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic> context,
  });
}
```

### Log levels and when to use each

| Level | Use when |
|---|---|
| `debug` | Operation started/succeeded, state transitions — dev only, not sent to Sentry |
| `info` | Meaningful user actions (signed in, created transaction, deleted budget) |
| `warning` | Recoverable issues, degraded behavior, deprecated usage |
| `error` | Caught exceptions — always includes `Failure` + `StackTrace` |
| `fatal` | Unhandled exceptions, app crashes, `BlocObserver.onError` |

---

## 7. SentryLogger — Production Implementation

### Decision
The production logger sends structured events to Sentry. `debug` logs are **not** sent to Sentry — they are no-ops in release mode.

```dart
// lib/src/core/logging/sentry_logger.dart

class SentryLogger implements AppLogger {
  @override
  void debug(String message, {Map<String, dynamic> context = const {}}) {
    // no-op in production
  }

  @override
  void info(String message, {Map<String, dynamic> context = const {}}) {
    Sentry.addBreadcrumb(Breadcrumb(
      message: message,
      level: SentryLevel.info,
      data: context,
    ));
  }

  @override
  void warning(String message, {Map<String, dynamic> context = const {}}) {
    Sentry.addBreadcrumb(Breadcrumb(
      message: message,
      level: SentryLevel.warning,
      data: context,
    ));
  }

  @override
  void error(
    String operation, {
    required Failure failure,
    required StackTrace stackTrace,
    Map<String, dynamic> context = const {},
  }) {
    Sentry.captureException(
      failure,
      stackTrace: stackTrace,
      hint: Hint.withMap({
        'operation': operation,
        'failure_type': failure.runtimeType.toString(),
        'failure_code': failure.code ?? 'none',
        ...context,
      }),
    );
  }

  @override
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic> context = const {},
  }) {
    Sentry.captureException(
      error ?? message,
      stackTrace: stackTrace,
      hint: Hint.withMap({'message': message, ...context}),
    );
  }
}
```

---

## 8. ConsoleLogger — Development Implementation

### Decision
The development logger prints structured output to the terminal using `debugPrint`. It is only used when `kDebugMode == true`. Nothing is sent to Sentry.

```dart
// lib/src/core/logging/console_logger.dart

class ConsoleLogger implements AppLogger {
  @override
  void debug(String message, {Map<String, dynamic> context = const {}}) {
    debugPrint('🔍 [DEBUG] $message ${_fmt(context)}');
  }

  @override
  void info(String message, {Map<String, dynamic> context = const {}}) {
    debugPrint('ℹ️  [INFO] $message ${_fmt(context)}');
  }

  @override
  void warning(String message, {Map<String, dynamic> context = const {}}) {
    debugPrint('⚠️  [WARN] $message ${_fmt(context)}');
  }

  @override
  void error(
    String operation, {
    required Failure failure,
    required StackTrace stackTrace,
    Map<String, dynamic> context = const {},
  }) {
    debugPrint('❌ [ERROR] [$operation] ${failure.runtimeType}: ${failure.message} ${_fmt(context)}');
    debugPrint(stackTrace.toString());
  }

  @override
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic> context = const {},
  }) {
    debugPrint('💀 [FATAL] $message | error: $error ${_fmt(context)}');
    if (stackTrace != null) debugPrint(stackTrace.toString());
  }

  String _fmt(Map<String, dynamic> context) =>
      context.isEmpty ? '' : '| ${context.entries.map((e) => '${e.key}=${e.value}').join(', ')}';
}
```

---

## 9. AppBlocObserver — BLoC-level Automatic Logging

### Decision
A single `AppBlocObserver` is registered at app startup and automatically logs every BLoC event, state transition, and uncaught error across the entire application — no changes needed inside individual BLoCs.

```dart
// lib/src/core/logging/app_bloc_observer.dart

class AppBlocObserver extends BlocObserver {
  final AppLogger _logger;

  AppBlocObserver(this._logger);

  @override
  void onEvent(Bloc bloc, Object? event) {
    _logger.debug(
      'BLoC Event',
      context: {
        'bloc': bloc.runtimeType.toString(),
        'event': event.runtimeType.toString(),
      },
    );
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    _logger.debug(
      'BLoC Transition',
      context: {
        'bloc': bloc.runtimeType.toString(),
        'from': transition.currentState.runtimeType.toString(),
        'to': transition.nextState.runtimeType.toString(),
      },
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _logger.fatal(
      'Uncaught BLoC error',
      error: error,
      stackTrace: stackTrace,
      context: {'bloc': bloc.runtimeType.toString()},
    );
    super.onError(bloc, error, stackTrace);
  }
}
```

### Registration in `main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  Bloc.observer = AppBlocObserver(getIt<AppLogger>());

  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
      options.tracesSampleRate = 0.2;
      options.environment = kReleaseMode ? 'production' : 'development';
    },
    appRunner: () => runApp(const App()),
  );
}
```

---

## 10. Dependency Injection

### Decision
`AppLogger` is registered as a `@lazySingleton` in `CoreModule`, environment-aware. All repositories receive the logger via constructor injection.

```dart
// lib/src/core/di/core_module.dart

@module
abstract class CoreModule {
  @lazySingleton
  AppLogger get logger => kReleaseMode ? SentryLogger() : ConsoleLogger();
}
```

Each repository module injects both `SupabaseClient` and `AppLogger`:

```dart
@module
abstract class TransactionModule {
  @lazySingleton
  TransactionRepository get transactionRepository => TransactionRepositoryImpl(
    getIt<SupabaseClient>(),
    getIt<AppLogger>(),   // injected here
  );
}
```

---

## 11. What is NOT covered (deferred decisions)

| Topic | Status |
|---|---|
| Offline support / local cache | Out of scope for this phase |
| User-facing error message mapping (i18n) | Out of scope for this phase |

---

## Implementation Checklist

When implementing, follow this order to avoid broken dependencies:

- [ ] Add `dartz` and `sentry_flutter` to `pubspec.yaml`
- [ ] Create `lib/src/core/errors/failures.dart` — sealed `Failure` hierarchy
- [ ] Create `lib/src/core/logging/app_logger.dart` — abstract interface
- [ ] Create `lib/src/core/logging/console_logger.dart`
- [ ] Create `lib/src/core/logging/sentry_logger.dart`
- [ ] Create `lib/src/core/logging/app_bloc_observer.dart`
- [ ] Create `lib/src/core/errors/base_repository.dart` — `RepositoryMixin` with `safeCall` + `safeStream`
- [ ] Update `CoreModule` in `lib/src/core/di/` to register `AppLogger`
- [ ] Update `main.dart` — register `AppBlocObserver` + initialize Sentry
- [ ] Run `build_runner` after DI changes
- [ ] Migrate each `data/repository/` Future-returning function to use `safeCall` and return `Either<Failure, T>`
- [ ] Migrate each `data/repository/` Stream-returning function to use `safeStream` and return `Stream<Either<Failure, T>>`
- [ ] Update each feature's domain `repository/` interface to match the new return types
- [ ] Update each BLoC: Future results consumed via `.fold()`, stream results consumed via `emit.forEach`
- [ ] Update all BLoC error states to carry `Failure` instead of `String`
