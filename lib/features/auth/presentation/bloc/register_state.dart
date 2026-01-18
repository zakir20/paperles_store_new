import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  final bool isPasswordVisible;
  const RegisterState({this.isPasswordVisible = false});

  @override
  List<Object?> get props => [isPasswordVisible];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial({super.isPasswordVisible});
}

class RegisterLoading extends RegisterState {
  const RegisterLoading({super.isPasswordVisible});
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess({super.isPasswordVisible});
}

class RegisterError extends RegisterState {
  final String message;
  const RegisterError(this.message, {super.isPasswordVisible});

  @override
  List<Object?> get props => [message, isPasswordVisible];
}