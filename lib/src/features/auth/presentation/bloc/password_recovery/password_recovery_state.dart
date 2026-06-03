import 'package:equatable/equatable.dart';

enum RecoveryStep { email, otp, newPassword }

sealed class PasswordRecoveryState extends Equatable {
  const PasswordRecoveryState();

  @override
  List<Object?> get props => [];
}

final class PasswordRecoveryInitial extends PasswordRecoveryState {
  const PasswordRecoveryInitial();
}

final class PasswordRecoveryLoading extends PasswordRecoveryState {
  const PasswordRecoveryLoading();
}

final class OtpSentSuccess extends PasswordRecoveryState {
  const OtpSentSuccess(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class OtpVerifiedSuccess extends PasswordRecoveryState {
  const OtpVerifiedSuccess(this.email);

  // Email is carried forward so the OTP step can re-render on error.
  final String email;

  @override
  List<Object?> get props => [email];
}

final class PasswordResetSuccess extends PasswordRecoveryState {
  const PasswordResetSuccess();
}

final class PasswordRecoveryError extends PasswordRecoveryState {
  const PasswordRecoveryError({
    required this.message,
    required this.step,
    this.email,
  });

  final String message;
  final RecoveryStep step;

  /// Preserved so the correct step widget can be re-rendered with context.
  final String? email;

  @override
  List<Object?> get props => [message, step, email];
}
