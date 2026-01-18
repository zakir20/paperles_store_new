import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart'; 
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository; // Use Repository

  RegisterCubit(this.authRepository) : super(const RegisterInitial());

  Future<void> register(Map<String, dynamic> userData) async {
    emit(RegisterLoading(isPasswordVisible: state.isPasswordVisible));
    try {
      final response = await authRepository.register(userData);
      
      if (response.data['status'] == 'success') {
        emit(const RegisterSuccess());
      } else {
        emit(RegisterError(response.data['message'], isPasswordVisible: state.isPasswordVisible));
      }
    } catch (e) {
      emit(RegisterError("Registration Failed", isPasswordVisible: state.isPasswordVisible));
    }
  }

  void togglePassword() {
    final bool newVisibility = !state.isPasswordVisible;
    if (state is RegisterError) {
      emit(RegisterError((state as RegisterError).message, isPasswordVisible: newVisibility));
    } else {
      emit(RegisterInitial(isPasswordVisible: newVisibility));
    }
  }
}