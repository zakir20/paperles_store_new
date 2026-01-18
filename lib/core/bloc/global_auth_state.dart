import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import 'global_auth_state.dart';

class GlobalAuthCubit extends Cubit<GlobalAuthState> {
  final AuthRepository authRepository;

  GlobalAuthCubit(this.authRepository) : super(AuthUnknown());

  Future<void> checkAuthStatus() async {
    // Calling Repository instead of SharedPreferences directly
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
    // Calling Repository to clear data
    await authRepository.clearSession();
    emit(Unauthenticated());
  }
}