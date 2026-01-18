import 'package:equatable/equatable.dart';

abstract class GlobalAuthState extends Equatable {
  const GlobalAuthState();
  @override
  List<Object?> get props => [];
}

class AuthUnknown extends GlobalAuthState {} // App just started
class Authenticated extends GlobalAuthState {} // User is logged in
class Unauthenticated extends GlobalAuthState {} // User needs to login