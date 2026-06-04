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
    try {
      await _repository.sendPasswordRecoveryOtp(event.email);
      emit(OtpSentSuccess(event.email));
    } catch (e) {
      emit(PasswordRecoveryError(
        message: _mapError(e),
        step: RecoveryStep.email,
      ));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpRequested event,
    Emitter<PasswordRecoveryState> emit,
  ) async {
    emit(const PasswordRecoveryLoading());
    try {
      await _repository.verifyPasswordRecoveryOtp(event.email, event.otp);
      emit(OtpVerifiedSuccess(event.email));
    } catch (e) {
      emit(PasswordRecoveryError(
        message: _mapError(e),
        step: RecoveryStep.otp,
        email: event.email,
      ));
    }
  }

  Future<void> _onSetNewPassword(
    SetNewPasswordRequested event,
    Emitter<PasswordRecoveryState> emit,
  ) async {
    emit(const PasswordRecoveryLoading());
    try {
      await _repository.updatePasswordAndSignOut(event.password);
      emit(const PasswordResetSuccess());
    } catch (e) {
      emit(PasswordRecoveryError(
        message: _mapError(e),
        step: RecoveryStep.newPassword,
      ));
    }
  }

  String _mapError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('invalid') || msg.contains('expired')) {
      return 'Código inválido ou expirado. Tente novamente.';
    }
    if (msg.contains('not found') || msg.contains('user')) {
      return 'E-mail não encontrado. Verifique e tente novamente.';
    }
    return 'Ocorreu um erro inesperado. Tente novamente.';
  }
}
