import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global_auth_state.dart';

class GlobalAuthCubit extends Cubit<GlobalAuthState> {
  GlobalAuthCubit() : super(AuthUnknown());

  // Check if the user has a "Session" saved in the phone
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Read the boolean we saved during Login
    final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  // Call this when Login is successful
  void setAuthenticated() {
    emit(Authenticated());
  }

  // Call this when user clicks Logout
  Future<void> setUnauthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    emit(Unauthenticated());
  }
  //  LOGOUT LOGIC
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Clear the "Cookie" from the phone's memory
    await prefs.clear(); 
    
    //  Change the state to Unauthenticated (UI will see this)
    emit(Unauthenticated());
  }
}