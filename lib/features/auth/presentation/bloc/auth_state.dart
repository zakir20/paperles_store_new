abstract class AuthState {
  final bool isPasswordVisible;
  AuthState({this.isPasswordVisible = false});
}

class AuthInitial extends AuthState {
  AuthInitial({super.isPasswordVisible});
}

class AuthLoading extends AuthState {
  AuthLoading({super.isPasswordVisible});
}

class AuthSuccess extends AuthState {
  AuthSuccess({super.isPasswordVisible});
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message, {super.isPasswordVisible});
}