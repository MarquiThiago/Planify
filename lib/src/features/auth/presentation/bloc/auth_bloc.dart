import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../domain/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthInitial()) {
    on<SignInWithEmailRequested>(_onSignInWithEmail);
    on<SignInWithGoogleRequested>(_onSignInWithGoogle);
    on<SignInWithAppleRequested>(_onSignInWithApple);
    on<SignOutRequested>(_onSignOut);
  }

  final AuthRepository _repository;

  Future<void> _onSignInWithEmail(
    SignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _repository.signInWithEmail(event.email, event.password);
      // Sucesso: AuthChangeNotifier detecta a nova sessão e o GoRouter
      // redireciona automaticamente. Não é necessário emitir estado aqui.
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(const AuthError('Ocorreu um erro inesperado. Tente novamente.'));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _repository.signInWithGoogle();
      // Browser aberto com sucesso — volta ao estado inicial enquanto
      // o usuário autentica. O callback via deep link completa o fluxo.
      emit(const AuthInitial());
    } catch (_) {
      emit(const AuthError('Não foi possível abrir o login com Google.'));
    }
  }

  Future<void> _onSignInWithApple(
    SignInWithAppleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _repository.signInWithApple();
      emit(const AuthInitial());
    } catch (_) {
      emit(const AuthError('Não foi possível abrir o login com Apple.'));
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _repository.signOut();
    } catch (_) {
      emit(const AuthError('Não foi possível sair. Tente novamente.'));
    }
  }
}
