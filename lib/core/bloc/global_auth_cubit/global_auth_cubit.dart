import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_store_upd/features/auth/domain/repositories/auth_repository.dart';

import 'global_auth_state.dart';

class GlobalAuthCubit extends Cubit<GlobalAuthState> {
  final AuthRepository authRepository;

  GlobalAuthCubit(this.authRepository) : super(const Unauthenticated());

  Future<void> checkAuthStatus() async {
    final name = await authRepository.getUserName();
    if (name != null && name.isNotEmpty) {
      emit(Authenticated(userName: name));
    } else {
      emit(const Unauthenticated());
    }
  }

  void setAuthenticated(String name) {
    emit(Authenticated(userName: name));
  }

  Future<void> logout() async {
    await authRepository.clearSession();
    emit(const Unauthenticated());
  }
}
