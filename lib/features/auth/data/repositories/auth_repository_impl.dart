import 'dart:convert'; 
import 'package:flutter/foundation.dart';
import 'package:paperless_store_upd/core/network/api_failure.dart';
import 'package:paperless_store_upd/core/network/network_executor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkExecutor networkExecutor;

  AuthRepositoryImpl(this.networkExecutor);

  final String _loginPath = 'auth/login.php';

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await networkExecutor.executePost(
        endpoint: _loginPath,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final user = UserModel.fromJson(response.data['data']);
        
        await saveSession(user); 
        
        return user;
      }

      throw Failure(
        response.data?['message']?.toString() ?? 'Login failed',
      );
    } catch (e, stackTrace) {
      debugPrintStack(label: e.toString(), stackTrace: stackTrace);

      if (e is Failure) {
        rethrow;
      }

      throw Failure(e.toString());
    }
  }

  @override
  Future<void> saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    
    final String userJson = jsonEncode(user.toJson());
    
    await prefs.setString('user_data', userJson);
    await prefs.setBool('is_logged_in', true);
  }

  @override
  Future<bool> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  @override
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user_data');
    
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }
}