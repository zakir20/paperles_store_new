import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository.dart'; 
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository; // Use Repository

  LoginCubit(this.authRepository) : super(const LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading(isPasswordVisible: state.isPasswordVisible));
    try {
      final response = await authRepository.login(email, password);
      
          if (response.data['status'] == 'success') {
            final String userName = response.data['data']['name'] ?? 'User';
            await authRepository.saveSession(userName); 

            emit(const LoginSuccess());
            } else {
            emit(LoginError(response.data['message'], isPasswordVisible: state.isPasswordVisible));
            }
    } catch (e) {
      emit(LoginError("Connection Error", isPasswordVisible: state.isPasswordVisible));
    }
  }

  void togglePassword() {
    final bool newVisibility = !state.isPasswordVisible;
    if (state is LoginError) {
      emit(LoginError((state as LoginError).message, isPasswordVisible: newVisibility));
    } else {
      emit(LoginInitial(isPasswordVisible: newVisibility));
    }
  }
}