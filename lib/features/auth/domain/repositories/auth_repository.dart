import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<bool> checkAuthStatus();

  Future<void> saveSession(String name);

  Future<void> clearSession();

  Future<String?> getUserName();
}
