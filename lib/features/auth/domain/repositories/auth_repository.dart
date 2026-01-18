abstract class AuthRepository {
  Future<Response> login(String email, String password);
  Future<Response> register(Map<String, dynamic> userData);
  
  Future<bool> checkAuthStatus();
  Future<void> saveSession(String name);
  Future<void> clearSession();
}