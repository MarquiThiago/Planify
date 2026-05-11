import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ─── States ──────────────────────────────────────────────────────────────────

sealed class AuthCubitState extends Equatable {
  const AuthCubitState();

  @override
  List<Object?> get props => [];
}

final class AuthAuthenticated extends AuthCubitState {
  const AuthAuthenticated();
}

final class AuthUnauthenticated extends AuthCubitState {
  const AuthUnauthenticated();
}

// ─── Cubit ───────────────────────────────────────────────────────────────────

class AuthCubit extends Cubit<AuthCubitState> {
  AuthCubit(SupabaseClient client)
      : super(
          client.auth.currentSession != null
              ? const AuthAuthenticated()
              : const AuthUnauthenticated(),
        ) {
    _subscription = client.auth.onAuthStateChange.listen((data) {
      if (data.session != null) {
        emit(const AuthAuthenticated());
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
