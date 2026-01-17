import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource remoteDataSource;

  AuthCubit(this.remoteDataSource) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading(isPasswordVisible: state.isPasswordVisible));
    try {
      final response = await remoteDataSource.loginUser(email, password);
      if (response.data['status'] == 'success') {
        emit(AuthSuccess());
      } else {
        emit(AuthError(response.data['message']));
      }
    } catch (e) {
      emit(AuthError("Connection Error"));
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    emit(AuthLoading(isPasswordVisible: state.isPasswordVisible));
    try {
      final response = await remoteDataSource.registerUser(userData);
      
      if (response.data['status'] == 'success') {
        emit(AuthSuccess());
      } else {
        emit(AuthError(response.data['message']));
      }
    } catch (e) {
      emit(AuthError("Registration Failed"));
    }
  }

  void togglePassword() {
    emit(AuthInitial(isPasswordVisible: !state.isPasswordVisible));
  }
}