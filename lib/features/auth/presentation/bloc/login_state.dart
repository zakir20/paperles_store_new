import 'package:equatable/equatable.dart';
import 'package:paperless_store_upd/features/auth/data/models/user_model.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginInLoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginErrorState extends LoginState {
  final String message;

  LoginErrorState(this.message);

  @override
  List<Object?> get props => [];
}

class LoginSuccessState extends LoginState {
  final UserModel user;

  LoginSuccessState(this.user);

  @override
  List<Object?> get props => [];
}
