import 'package:dio/dio.dart';
import '../../data/models/user_model.dart'; 

abstract class AuthRepository {
  Future<Response> login(String email, String password);
  
  Future<Response> register(UserModel user);
  
  Future<bool> checkAuthStatus();
  Future<void> saveSession(String name);
  Future<void> clearSession();
  Future<String?> getUserName();
}