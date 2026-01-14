import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();
}

class ChangeLanguageEvent extends LanguageEvent {
  final String localeCode;

  const ChangeLanguageEvent({required this.localeCode});

  @override
  List<Object> get props => [localeCode];
}