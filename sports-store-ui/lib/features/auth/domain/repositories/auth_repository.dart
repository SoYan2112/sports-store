import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String emailOrPhone, required String password});
  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });
  Future<void> forgotPassword({required String email});
  Future<UserEntity?> checkAuthStatus();
  Future<void> logout();
}
