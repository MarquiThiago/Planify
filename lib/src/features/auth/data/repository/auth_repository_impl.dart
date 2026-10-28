import 'package:dartz/dartz.dart';
import 'package:planify/src/core/failures/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../../../../core/repository_base/repository_base.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl with RepositoryBase implements AuthRepository {
  AuthRepositoryImpl(this._client);

  final SupabaseClient _client;

  // TODO: configure o scheme no Info.plist (iOS) e AndroidManifest.xml (Android)
  // e registre esta URL como redirect no Supabase Dashboard → Authentication → URL Configuration.
  static const _redirectUrl = 'io.supabase.planify://login-callback';

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail(
    String email,
    String password,
  ) =>
      safeCall<UserEntity>(
        () async {
          final response = await _client.auth.signInWithPassword(
            email: email,
            password: password,
          );
          final user = response.user;
          if (user == null) throw Exception('Falha ao autenticar usuário.');
          return UserModel.fromSupabaseUser(user).toEntity();
        },
        operationName: 'AuthRepository.signInWithEmail',
      );

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail(
    String email,
    String password,
  ) =>
      safeCall<UserEntity>(
        () async {
          final response = await _client.auth.signUp(
            email: email,
            password: password,
          );
          final user = response.user;
          if (user == null) throw Exception('Falha ao criar conta.');
          return UserModel.fromSupabaseUser(user).toEntity();
        },
        operationName: 'AuthRepository.signUpWithEmail',
      );

  @override
  Future<Either<Failure, Unit>> signInWithGoogle() =>
      safeCall<Unit>(
        () async {
          await _client.auth.signInWithOAuth(
            OAuthProvider.google,
            redirectTo: _redirectUrl,
          );
          return unit;
        },
        operationName: 'AuthRepository.signInWithGoogle',
      );

  @override
  Future<Either<Failure, Unit>> signInWithApple() =>
      safeCall<Unit>(
        () async {
          await _client.auth.signInWithOAuth(
            OAuthProvider.apple,
            redirectTo: _redirectUrl,
          );
          return unit;
        },
        operationName: 'AuthRepository.signInWithApple',
      );

  @override
  Future<Either<Failure, Unit>> signOut() =>
      safeCall<Unit>(
        () async {
          await _client.auth.signOut();
          return unit;
        },
        operationName: 'AuthRepository.signOut',
      );

  @override
  UserEntity? getCurrentUser() {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return UserModel.fromSupabaseUser(user).toEntity();
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordRecoveryOtp(String email) =>
      safeCall<Unit>(
        () async {
          await _client.auth.signInWithOtp(
            email: email,
            shouldCreateUser: false,
          );
          return unit;
        },
        operationName: 'AuthRepository.sendPasswordRecoveryOtp',
        context: {'email': email},
      );

  @override
  Future<Either<Failure, Unit>> verifyPasswordRecoveryOtp(
    String email,
    String otp,
  ) =>
      safeCall<Unit>(
        () async {
          await _client.auth.verifyOTP(
            email: email,
            token: otp,
            type: OtpType.email,
          );
          return unit;
        },
        operationName: 'AuthRepository.verifyPasswordRecoveryOtp',
        context: {'email': email},
      );

  @override
  Future<Either<Failure, Unit>> updatePasswordAndSignOut(
    String newPassword,
  ) =>
      safeCall<Unit>(
        () async {
          await _client.auth.updateUser(UserAttributes(password: newPassword));
          await _client.auth.signOut();
          return unit;
        },
        operationName: 'AuthRepository.updatePasswordAndSignOut',
      );
}
