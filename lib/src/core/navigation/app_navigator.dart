// Re-exporta o GoRouter para que as features precisem de apenas um import.
// Não há conflito com GoRouterHelper: o Dart resolve pela diferença de tipos
// (Routes vs String), então as duas extensões coexistem sem ambiguidade.
export 'package:go_router/go_router.dart';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../router/routes.dart';

extension AppNavigator on BuildContext {
  /// Navega para [route], substituindo a pilha de navegação.
  ///
  /// ```dart
  /// context.go(Routes.home);
  /// ```
  void go(Routes route, {Object? extra}) {
    GoRouter.of(this).go(route.path, extra: extra);
  }

  /// Navega para [route] com parâmetros de path e/ou query.
  ///
  /// ```dart
  /// context.goWith(Routes.transactionDetail, params: {'id': '42'});
  /// context.goWith(Routes.transactionList, queryParams: {'filter': 'income'});
  /// ```
  void goWith(
    Routes route, {
    Map<String, String> params = const {},
    Map<String, String> queryParams = const {},
    Object? extra,
  }) {
    final uri = Uri(
      path: route.resolve(params),
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    GoRouter.of(this).go(uri.toString(), extra: extra);
  }

  /// Empilha [route] preservando a pilha de navegação atual.
  Future<T?> push<T>(Routes route, {Object? extra}) {
    return GoRouter.of(this).push(route.path, extra: extra);
  }

  /// Empilha [route] com parâmetros de path e/ou query.
  Future<T?> pushWith<T>(
    Routes route, {
    Map<String, String> params = const {},
    Map<String, String> queryParams = const {},
    Object? extra,
  }) {
    final uri = Uri(
      path: route.resolve(params),
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    return GoRouter.of(this).push(uri.toString(), extra: extra);
  }

  /// Volta para a rota anterior.
  void pop<T>([T? result]) => GoRouter.of(this).pop(result);

  /// Retorna `true` se é possível voltar na pilha de navegação.
  bool canPop() => GoRouter.of(this).canPop();
}
