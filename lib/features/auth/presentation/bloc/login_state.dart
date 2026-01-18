import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  final bool isPasswordVisible;
  const LoginState({this.isPasswordVisible = false});

  @override
  List<Object?> get props => [isPasswordVisible];
}

class LoginInitial extends LoginState {
  const LoginInitial({super.isPasswordVisible});
}

class LoginLoading extends LoginState {
  const LoginLoading({super.isPasswordVisible});
}

class LoginSuccess extends LoginState {
  const LoginSuccess({super.isPasswordVisible});
}

class LoginError extends LoginState {
  final String message;
  const LoginError(this.message, {super.isPasswordVisible});

  @override
  List<Object?> get props => [message, isPasswordVisible];
}