import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:planify/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:planify/src/features/auth/presentation/bloc/auth_event.dart';

import '../startup/app_startup.dart';
import 'auth_cubit.dart';
import 'routes.dart';

// ─── Feature routes ───────────────────────────────────────────────────────────
import '../../features/auth/routes/auth_routes.dart';
// import '../../features/transactions/routes/transaction_routes.dart';
// ---------------------------------------------------------------------------

/// Instância global do GoRouter.
///
/// É uma variável top-level lazy — inicializada apenas quando primeiro
/// acessada, já após [configureDependencies()] ter sido chamado no main.
final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash.path,
  refreshListenable: _AuthRefreshListenable(GetIt.instance<AuthCubit>().stream),
  redirect: _redirect,
  routes: [
    // ── Splash ────────────────────────────────────────────────────────────
    GoRoute(path: Routes.splash.path, builder: (_, _) => const _SplashPage()),

    // ── Auth ──────────────────────────────────────────────────────────────
    ...authRoutes,

    // ── Home ──────────────────────────────────────────────────────────────
    GoRoute(
      path: Routes.home.path,
      builder: (_, _) => const _PlaceholderPage(label: 'Home'),
    ),

    // ── Transactions ──────────────────────────────────────────────────────
    GoRoute(
      path: Routes.transactionList.path,
      builder: (_, _) => const _PlaceholderPage(label: 'Transactions'),
      routes: [
        GoRoute(
          path: ':id', // resulta em /transactions/:id
          builder: (_, state) => _PlaceholderPage(
            label: 'Transaction ${state.pathParameters['id']}',
          ),
        ),
      ],
    ),
  ],
);

// ─── Redirect / Guards ────────────────────────────────────────────────────────

/// Rotas que não exigem autenticação.
const _publicRoutes = {Routes.splash, Routes.login};

String? _redirect(BuildContext context, GoRouterState state) {
  final location = state.matchedLocation;
  final splashDone = AppStartup.splashCompleted;
  final isAuthenticated =
      GetIt.instance<AuthCubit>().state is AuthAuthenticated;

  final currentRoute = Routes.values.firstWhere(
    (r) => r.path == location,
    orElse: () =>
        Routes.home, // rota com parâmetro dinâmico — trata como protegida
  );

  // 1. Força splash apenas na primeira abertura (não no hot reload).
  if (!splashDone && currentRoute != Routes.splash) {
    return Routes.splash.path;
  }

  // 2. Splash já exibida — não deixa voltar a ela.
  if (splashDone && currentRoute == Routes.splash) {
    return isAuthenticated ? Routes.home.path : Routes.login.path;
  }

  // 3. Rota protegida sem autenticação → login.
  final isPublic = _publicRoutes.contains(currentRoute);
  if (splashDone && !isAuthenticated && !isPublic) {
    return Routes.login.path;
  }

  // 4. Usuário autenticado tentando acessar login → home.
  if (splashDone && isAuthenticated && currentRoute == Routes.login) {
    return Routes.home.path;
  }

  return null;
}

// ─── Splash page ──────────────────────────────────────────────────────────────

class _SplashPage extends StatefulWidget {
  const _SplashPage();

  @override
  State<_SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<_SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // TODO: substitua por sua lógica de inicialização real (animação, prefetch, etc.)
    await Future<void>.delayed(const Duration(seconds: 2));
    AppStartup.markSplashCompleted();

    // Dispara re-avaliação do redirect.
    appRouter.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

// ─── Auth refresh listenable ──────────────────────────────────────────────────

/// Adapta o stream do [AuthCubit] para o [Listenable] exigido pelo GoRouter.
class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(Stream<AuthCubitState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthCubitState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// ─── Placeholder ──────────────────────────────────────────────────────────────

/// Placeholder temporário — remova conforme as Pages reais forem criadas.
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
        leading: IconButton(
          onPressed: () =>
              GetIt.instance<AuthBloc>().add(const SignOutRequested()),
          icon: const Icon(Icons.logout),
        ),
      ),
      body: Center(child: Text(label)),
    );
  }
}
