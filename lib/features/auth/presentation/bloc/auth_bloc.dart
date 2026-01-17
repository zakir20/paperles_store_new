import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteDataSource remoteDataSource;

  AuthBloc(this.remoteDataSource) : super(AuthInitial()) {
    
    on<TogglePasswordVisibilityEvent>((event, emit) {
      if (state is AuthInitial) {
        emit(AuthInitial(isPasswordVisible: !state.isPasswordVisible));
      } else if (state is AuthError) {
        emit(AuthError((state as AuthError).message, isPasswordVisible: !state.isPasswordVisible));
      } else {
        emit(AuthInitial(isPasswordVisible: !state.isPasswordVisible));
      }
    });

          on<LoginEvent>((event, emit) async {
            emit(AuthLoading(isPasswordVisible: state.isPasswordVisible));

            try {
              final response = await remoteDataSource.loginUser(event.email, event.password);

              if (response.data['status'] == 'success') {
                emit(AuthSuccess());
              } else {
                emit(AuthError(response.data['message']));
              }
            } catch (e) {
              emit(AuthError("Connection error. Check your local server IP."));
            }
          });

    on<RegisterSubmitted>((event, emit) async {
      emit(AuthLoading(isPasswordVisible: state.isPasswordVisible));

      try {
        final response = await remoteDataSource.registerUser(event);

        if (response.data['status'] == 'success') {
          emit(AuthSuccess());
        } else {
          emit(AuthError(response.data['message']));
        }
      } catch (e) {
        print("Network Error: $e");
        emit(AuthError("Connection failed. Check if your PC and Phone are on same Wi-Fi."));
      }
    });
  }
}