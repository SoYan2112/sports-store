import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences sharedPreferences;
  static const String _tokenKey = 'SPORTS_STORE_ACCESS_TOKEN';
  static const String _userKey = 'SPORTS_STORE_USER_DATA';

  AuthRepositoryImpl({required this.sharedPreferences});

  @override
  Future<UserEntity> login({required String emailOrPhone, required String password}) async {
    // Giả lập tương tác API backend Microsoft SQL Server
    await Future.delayed(const Duration(milliseconds: 600));

    if (password.length < 6) {
      throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
    }

    final user = UserModel(
      id: 'USR_001',
      fullName: 'Nguyễn Văn Thể Thao',
      email: emailOrPhone.contains('@') ? emailOrPhone : 'user@sportsstore.vn',
      phoneNumber: emailOrPhone.contains('@') ? '0912345678' : emailOrPhone,
      role: 'USER',
      token: 'jwt_mock_token_sports_store_vn_2026',
    );

    // Cache Token & User Info
    await sharedPreferences.setString(_tokenKey, user.token!);
    await sharedPreferences.setString(_userKey, jsonEncode(user.toJson()));

    return user;
  }

  @override
  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final user = UserModel(
      id: 'USR_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phoneNumber: phone,
      role: 'USER',
      token: 'jwt_mock_token_register_2026',
    );

    await sharedPreferences.setString(_tokenKey, user.token!);
    await sharedPreferences.setString(_userKey, jsonEncode(user.toJson()));

    return user;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Giả lập gửi OTP qua SMS / Email
  }

  @override
  Future<UserEntity?> checkAuthStatus() async {
    final token = sharedPreferences.getString(_tokenKey);
    final userData = sharedPreferences.getString(_userKey);

    if (token != null && userData != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(userData);
        return UserModel.fromJson(json);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_userKey);
  }
}
