import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_store_upd/features/auth/domain/repositories/auth_repository.dart';
import '../../../../features/auth/data/models/user_model.dart'; 

import 'global_auth_state.dart';

class GlobalAuthCubit extends Cubit<GlobalAuthState> {
  final AuthRepository authRepository;

  GlobalAuthCubit(this.authRepository) : super(const Unauthenticated());

  Future<void> checkAuthStatus() async {
    final user = await authRepository.getUser();
    
    if (user != null) {
      emit(Authenticated(user: user));
    } else {
      emit(const Unauthenticated());
    }
  }

  void setAuthenticated(UserModel user) {
    emit(Authenticated(user: user));
  }

  Future<void> logout() async {
    await authRepository.clearSession();
    emit(const Unauthenticated());
  }
}