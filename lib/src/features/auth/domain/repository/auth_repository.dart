import 'package:dartz/dartz.dart';
import 'package:planify/src/core/failures/failures.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmail(
    String email,
    String password,
  );

  Future<Either<Failure, UserEntity>> signUpWithEmail(
    String email,
    String password,
  );

  Future<Either<Failure, Unit>> signInWithGoogle();

  Future<Either<Failure, Unit>> signInWithApple();

  Future<Either<Failure, Unit>> signOut();

  UserEntity? getCurrentUser();

  Future<Either<Failure, Unit>> sendPasswordRecoveryOtp(String email);

  Future<Either<Failure, Unit>> verifyPasswordRecoveryOtp(
    String email,
    String otp,
  );

  Future<Either<Failure, Unit>> updatePasswordAndSignOut(String newPassword);
}
