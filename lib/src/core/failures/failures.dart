import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message, this.code);

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message, super.code);
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, super.code);
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, super.code, {this.pgCode});
  final String? pgCode;

  @override
  List<Object?> get props => [message, code, pgCode];
}

final class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure(super.message, super.code);
}
