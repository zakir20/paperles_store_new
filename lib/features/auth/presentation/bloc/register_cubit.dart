import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart'; 
import '../../data/models/user_model.dart'; 
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit(this.authRepository) : super(const RegisterInitial());

  // Logic: Takes only the data collected from  RegisterScreen UI
  Future<void> register(Map<String, dynamic> userData) async {
    emit(RegisterLoading(isPasswordVisible: state.isPasswordVisible));

    try {
      // Mapping only the specific fields present in  Registration Form
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

      // Sending the cleaned model to the repository
      final response = await authRepository.register(userModel);
      
      if (response.data['status'] == 'success') {
        emit(const RegisterSuccess());
      } else {
        emit(RegisterError(
          response.data['message'] ?? "Registration Failed", 
          isPasswordVisible: state.isPasswordVisible,
        ));
      }
    } catch (e) {
      emit(RegisterError(
        "Connection Error: Check server IP", 
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