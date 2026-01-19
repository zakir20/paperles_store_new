import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_store_upd/features/auth/domain/repositories/auth_repository.dart';
import 'global_auth_state.dart';

class GlobalAuthCubit extends Cubit<GlobalAuthState> {
  final AuthRepository authRepository;

  GlobalAuthCubit(this.authRepository) : super(Unauthenticated());

  Future<void> checkAuthStatus() async {
    final bool isLoggedIn = await authRepository.checkAuthStatus();

    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  void setAuthenticated() {
    emit(Authenticated());
  }

  Future<void> logout() async {
    await authRepository.clearSession();
    emit(Unauthenticated());
  }
}