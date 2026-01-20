import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_store_upd/core/network/api_failure.dart';

import '../../domain/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit(this.authRepository) : super(LoginInitialState());

  Future<void> login(String email, String password) async {
    emit(LoginInLoadingState());

    try {
      final user = await authRepository.login(
        email: email,
        password: password,
      );

      await authRepository.saveSession(user.name);

      emit(LoginSuccessState(user));
    } on Failure catch (e) {
      emit(LoginErrorState(e.message));
    } catch (_) {
      emit(LoginErrorState('Connection error'));
    }
  }
}
