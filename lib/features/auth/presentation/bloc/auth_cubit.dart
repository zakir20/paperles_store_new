import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../../data/datasources/auth_remote_data_source.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource remoteDataSource;

  AuthCubit(this.remoteDataSource) : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading(isPasswordVisible: state.isPasswordVisible));
    
    try {
      final response = await remoteDataSource.loginUser(email, password);
      
      if (response.data['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', response.data['data']['name'] ?? 'User');
        await prefs.setBool('is_logged_in', true);

        emit(const AuthSuccess());
      } else {
        emit(AuthError(response.data['message'], isPasswordVisible: state.isPasswordVisible));
      }
    } catch (e) {
      emit(AuthError("Connection Error: Server unreachable", isPasswordVisible: state.isPasswordVisible));
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    emit(AuthLoading(isPasswordVisible: state.isPasswordVisible));
    
    try {
      final response = await remoteDataSource.registerUser(userData);
      
      if (response.data['status'] == 'success') {
        emit(const AuthSuccess());
      } else {
        emit(AuthError(response.data['message'], isPasswordVisible: state.isPasswordVisible));
      }
    } catch (e) {
      emit(AuthError("Registration Failed: Please check your internet", isPasswordVisible: state.isPasswordVisible));
    }
  }


  void togglePassword() {
    final bool newVisibility = !state.isPasswordVisible;

    if (state is AuthError) {
      emit(AuthError((state as AuthError).message, isPasswordVisible: newVisibility));
    } else if (state is AuthLoading) {
      emit(AuthLoading(isPasswordVisible: newVisibility));
    } else if (state is AuthSuccess) {
      emit(AuthSuccess(isPasswordVisible: newVisibility));
    } else {
      emit(AuthInitial(isPasswordVisible: newVisibility));
    }
  }
}