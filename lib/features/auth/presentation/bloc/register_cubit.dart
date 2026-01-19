import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart'; 
import '../../data/models/user_model.dart'; 
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit(this.authRepository) : super(const RegisterInitial());

  Future<void> register(Map<String, dynamic> userData) async {
    emit(RegisterLoading(isPasswordVisible: state.isPasswordVisible));

    try {
      final userModel = UserModel(
        name: userData['registrantName'],
        email: userData['email'],
        phone: userData['phoneNumber'],
        password: userData['password'],
        shopName: userData['shopName'],
        proprietorName: userData['proprietorName'],
        shopType: userData['shopType'],
        address: userData['address'],
        tradeLicense: userData['tradeLicense'],
        profileImagePath: userData['profileImagePath'],
        tradeLicensePath: userData['tradeLicensePath'],
      );

      final response = await authRepository.register(userModel);
      
      // 200 means OK, 201 means Created (standard for successful registration)
      if ((response.statusCode == 200 || response.statusCode == 201) && 
          response.data['status'] == 'success') {
        emit(const RegisterSuccess());
      } else {
        // Handle cases where server is online but returns an error (e.g., 400 Bad Request)
        final errorMessage = response.data['message'] ?? "Registration Failed";
        emit(RegisterError(
          errorMessage, 
          isPasswordVisible: state.isPasswordVisible,
        ));
      }
    } catch (e) {
      // Handles Network timeout, 404, or 500 errors caught by Dio
      emit(RegisterError(
        "Connection Error: Please check your server or network", 
        isPasswordVisible: state.isPasswordVisible,
      ));
    }
  }

  void togglePassword() {
    final bool newVisibility = !state.isPasswordVisible;
    if (state is RegisterError) {
      emit(RegisterError((state as RegisterError).message, isPasswordVisible: newVisibility));
    } else if (state is RegisterLoading) {
      emit(RegisterLoading(isPasswordVisible: newVisibility));
    } else {
      emit(RegisterInitial(isPasswordVisible: newVisibility));
    }
  }
}