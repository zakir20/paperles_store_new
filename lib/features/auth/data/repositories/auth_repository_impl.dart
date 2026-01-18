import 'package:dio/dio.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Response> login(String email, String password) async {
    // logic here to  save to local DB
    return await remoteDataSource.loginUser(email, password);
  }

  @override
  Future<Response> register(Map<String, dynamic> userData) async {
    return await remoteDataSource.registerUser(userData);
  }
}