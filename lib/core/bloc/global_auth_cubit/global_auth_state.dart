import 'package:equatable/equatable.dart';
import '../../../../features/auth/data/models/user_model.dart'; 

abstract class GlobalAuthState extends Equatable {
  const GlobalAuthState();

  @override
  List<Object?> get props => [];
}

class Authenticated extends GlobalAuthState {
  // 2. Changed String userName to UserModel user
  final UserModel user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends GlobalAuthState {
  const Unauthenticated();

  @override
  List<Object?> get props => [];
}