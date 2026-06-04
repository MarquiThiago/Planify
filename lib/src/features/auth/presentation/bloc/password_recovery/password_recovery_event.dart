import 'package:equatable/equatable.dart';

sealed class PasswordRecoveryEvent extends Equatable {
  const PasswordRecoveryEvent();

  @override
  List<Object?> get props => [];
}

final class SendOtpRequested extends PasswordRecoveryEvent {
  const SendOtpRequested(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class VerifyOtpRequested extends PasswordRecoveryEvent {
  const VerifyOtpRequested({required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  List<Object?> get props => [email, otp];
}

final class SetNewPasswordRequested extends PasswordRecoveryEvent {
  const SetNewPasswordRequested(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}
