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
        return UserModel.fromJson(response.data['data']);
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
  Future<void> saveSession(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
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
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }
}
