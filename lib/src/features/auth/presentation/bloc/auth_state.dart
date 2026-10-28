import 'package:equatable/equatable.dart';
import 'package:planify/src/core/failures/failures.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSignUpMode extends AuthState {
  const AuthSignUpMode();
}

/// Emitido quando um erro ocorre durante o sign-in ou sign-up.
/// A navegação em caso de sucesso é tratada pelo [AuthChangeNotifier] + GoRouter redirect.
final class AuthError extends AuthState {
  const AuthError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
