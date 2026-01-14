import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial(isPasswordVisible: false)) {
    
    on<TogglePasswordVisibilityEvent>((event, emit) {
      emit(AuthInitial(isPasswordVisible: !state.isPasswordVisible));
    });

    on<LoginEvent>((event, emit) async {
      final currentVisibility = state.isPasswordVisible;
      
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthError("Please fill all fields", isPasswordVisible: currentVisibility));
        return;
      }

      emit(AuthLoading(isPasswordVisible: currentVisibility));

      try {
        await Future.delayed(const Duration(seconds: 2));
        
        if (event.email == "admin@mail.com" && event.password == "123456") {
          emit(AuthSuccess(isPasswordVisible: currentVisibility));
        } else {
          emit(AuthError("Invalid email or password", isPasswordVisible: currentVisibility));
        }
      } catch (e) {
        emit(AuthError("Connection Failed", isPasswordVisible: currentVisibility));
      }
    });
  }
}