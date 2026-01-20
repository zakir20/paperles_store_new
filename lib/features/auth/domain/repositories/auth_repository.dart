import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({ required String email, required String password});
  Future<Response> register(UserModel user);
  
  Future<void> saveSession(UserModel user); 
  Future<UserModel?> getUser(); 

  Future<bool> checkAuthStatus();

  Future<void> clearSession();

}
