import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class SignInWithEmailRequested extends AuthEvent {
  const SignInWithEmailRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

final class SignInWithGoogleRequested extends AuthEvent {
  const SignInWithGoogleRequested();
}

final class SignInWithAppleRequested extends AuthEvent {
  const SignInWithAppleRequested();
}

final class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}
