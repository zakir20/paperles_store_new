import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit(this.authRepository) : super(const LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading(isPasswordVisible: state.isPasswordVisible));
    try {
      final response = await authRepository.login(email, password);
      
      // 1. Check with Status Code 
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        
        // 2. Call Repository to handle SharedPreferences 
        final String name = response.data['data']['name'] ?? 'User';
        await authRepository.saveSession(name); 

        emit(const LoginSuccess());
      } else {
        final errorMessage = response.data['message'] ?? "Login Failed";
        emit(LoginError(errorMessage, isPasswordVisible: state.isPasswordVisible));
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