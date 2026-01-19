import 'package:equatable/equatable.dart';

abstract class GlobalAuthState extends Equatable {
  const GlobalAuthState();
  @override
  List<Object?> get props => [];
}

class Authenticated extends GlobalAuthState {} 
class Unauthenticated extends GlobalAuthState {}