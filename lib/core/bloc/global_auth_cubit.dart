import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_store_upd/features/auth/domain/repositories/auth_repository.dart';
import 'global_auth_state.dart';

class GlobalAuthCubit extends Cubit<GlobalAuthState> {
  final AuthRepository authRepository;

  GlobalAuthCubit(this.authRepository) : super(Unauthenticated());

  Future<void> checkAuthStatus() async {
    final bool isLoggedIn = await authRepository.checkAuthStatus();

    if (isLoggedIn) {
        final name = await authRepository.getUserName(); 
        emit(Authenticated(userName: name ?? "User"));
        } else {
          emit(const Unauthenticated());
        }
          }

  void setAuthenticated(String name) {
    emit(Authenticated(userName: name));
  }

  Future<void> logout() async {
    await authRepository.clearSession();
    emit(Unauthenticated());
  }
}