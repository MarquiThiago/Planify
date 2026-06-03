import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signOut();
  UserEntity? getCurrentUser();

  // Password recovery
  Future<void> sendPasswordRecoveryOtp(String email);
  Future<void> verifyPasswordRecoveryOtp(String email, String otp);
  Future<void> updatePasswordAndSignOut(String newPassword);
}
