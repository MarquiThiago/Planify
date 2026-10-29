import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthInitial()) {
    on<SignInWithEmailRequested>(_onSignInWithEmail);
    on<SignInWithGoogleRequested>(_onSignInWithGoogle);
    on<SignInWithAppleRequested>(_onSignInWithApple);
    on<SignOutRequested>(_onSignOut);
    on<SignUpModeEntered>(_onSignUpModeEntered);
    on<SignUpModeCancelled>(_onSignUpModeCancelled);
    on<SignUpWithEmailRequested>(_onSignUpWithEmail);
  }

  final AuthRepository _repository;

  Future<void> _onSignInWithEmail(
    SignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _repository.signInWithEmail(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(failure)),
      // Sucesso: AuthChangeNotifier detecta a nova sessão e o GoRouter
      // redireciona automaticamente. Não é necessário emitir estado aqui.
      (_) => null,
    );
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _repository.signInWithGoogle();
    result.fold(
      (failure) => emit(AuthError(failure)),
      // Browser aberto com sucesso — volta ao estado inicial enquanto
      // o usuário autentica. O callback via deep link completa o fluxo.
      (_) => emit(const AuthInitial()),
    );
  }

  Future<void> _onSignInWithApple(
    SignInWithAppleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _repository.signInWithApple();
    result.fold(
      (failure) => emit(AuthError(failure)),
      (_) => emit(const AuthInitial()),
    );
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _repository.signOut();
    result.fold(
      (failure) => emit(AuthError(failure)),
      (_) => null, // GoRouter handles redirect on session clear
    );
  }

  void _onSignUpModeEntered(
    SignUpModeEntered event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthSignUpMode());
  }

  void _onSignUpModeCancelled(
    SignUpModeCancelled event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthInitial());
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _repository.signUpWithEmail(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(failure)),
      // Sucesso: AuthChangeNotifier detecta a nova sessão e o GoRouter
      // redireciona automaticamente. Não é necessário emitir estado aqui.
      (_) => null,
    );
  }
}
