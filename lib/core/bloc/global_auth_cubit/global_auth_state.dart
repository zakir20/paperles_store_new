import 'package:equatable/equatable.dart';

abstract class GlobalAuthState extends Equatable {
  const GlobalAuthState();

  @override
  List<Object?> get props => [];
}

class Authenticated extends GlobalAuthState {
  final String userName;

  const Authenticated({required this.userName});

  @override
  List<Object?> get props => [userName];
}

class Unauthenticated extends GlobalAuthState {
  const Unauthenticated();

  @override
  List<Object?> get props => [];
}
