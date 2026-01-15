abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent({required this.email, required this.password});
}

class TogglePasswordVisibilityEvent extends AuthEvent {}

class RegisterSubmitted extends AuthEvent {
  final String registrantName;
  final String shopName;
  final String proprietorName;
  final String phoneNumber;
  final String email;
  final String shopType;
  final String address;
  final String tradeLicense;
  final String password;

  RegisterSubmitted({
    required this.registrantName,
    required this.shopName,
    required this.proprietorName,
    required this.phoneNumber,
    required this.email,
    required this.shopType,
    required this.address,
    required this.tradeLicense,
    required this.password,
  });
}