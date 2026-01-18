import 'package:dio/dio.dart';

abstract class AuthRepository {
  Future<Response> login(String email, String password);
  Future<Response> register(Map<String, dynamic> userData);
}