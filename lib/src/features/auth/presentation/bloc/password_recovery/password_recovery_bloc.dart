import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../features/auth/domain/repository/auth_repository.dart';
import 'password_recovery_event.dart';
import 'password_recovery_state.dart';

class PasswordRecoveryBloc
    extends Bloc<PasswordRecoveryEvent, PasswordRecoveryState> {
  PasswordRecoveryBloc(this._repository)
    : super(const PasswordRecoveryInitial()) {
    on<SendOtpRequested>(_onSendOtp);
    on<VerifyOtpRequested>(_onVerifyOtp);
    on<SetNewPasswordRequested>(_onSetNewPassword);
  }

  final AuthRepository _repository;

  Future<void> _onSendOtp(
    SendOtpRequested event,
    Emitter<PasswordRecoveryState> emit,
  ) async {
    emit(const PasswordRecoveryLoading());
    final result = await _repository.sendPasswordRecoveryOtp(event.email);
    result.fold(
      (failure) => emit(
        PasswordRecoveryError(failure: failure, step: RecoveryStep.email),
      ),
      (_) => emit(OtpSentSuccess(event.email)),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpRequested event,
    Emitter<PasswordRecoveryState> emit,
  ) async {
    emit(const PasswordRecoveryLoading());
    final result = await _repository.verifyPasswordRecoveryOtp(
      event.email,
      event.otp,
    );
    result.fold(
      (failure) => emit(
        PasswordRecoveryError(
          failure: failure,
          step: RecoveryStep.otp,
          email: event.email,
        ),
      ),
      (_) => emit(OtpVerifiedSuccess(event.email)),
    );
  }

  Future<void> _onSetNewPassword(
    SetNewPasswordRequested event,
    Emitter<PasswordRecoveryState> emit,
  ) async {
    emit(const PasswordRecoveryLoading());
    final result = await _repository.updatePasswordAndSignOut(event.password);
    result.fold(
      (failure) => emit(
        PasswordRecoveryError(failure: failure, step: RecoveryStep.newPassword),
      ),
      (_) => emit(const PasswordResetSuccess()),
    );
  }
}
