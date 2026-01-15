import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial(isPasswordVisible: false)) {
    
    // 1. Handle Show/Hide Password Toggle
    on<TogglePasswordVisibilityEvent>((event, emit) {
      emit(AuthInitial(isPasswordVisible: !state.isPasswordVisible));
    });

    // 2. Handle Login Logic
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading(isPasswordVisible: state.isPasswordVisible));
      await Future.delayed(const Duration(seconds: 2)); // Simulate API
      
      if (event.email == "zakir@mail.com" && event.password == "123456") {
        emit(AuthSuccess(isPasswordVisible: state.isPasswordVisible));
      } else {
        emit(AuthError("Invalid credentials", isPasswordVisible: state.isPasswordVisible));
      }
    });

    // 3. Handle Registration Logic (The "Done" process)
    on<RegisterSubmitted>((event, emit) async {
      emit(AuthLoading(isPasswordVisible: state.isPasswordVisible));

      try {
        // --- This is where the magic happens ---
        // In the future, you will call: await repository.register(event.registrantName, ...)
        
        print("Registering: ${event.shopName} for ${event.registrantName}");
        
        // Simulating network delay
        await Future.delayed(const Duration(seconds: 3));

        // On Success
        emit(AuthSuccess(isPasswordVisible: state.isPasswordVisible));
      } catch (e) {
        emit(AuthError("Registration failed. Try again.", isPasswordVisible: state.isPasswordVisible));
      }
    });
  }
}