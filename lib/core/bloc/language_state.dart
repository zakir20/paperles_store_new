import 'package:equatable/equatable.dart';

class LanguageState extends Equatable {
  final String localeCode;
  final String languageName;
  final String flag;

  const LanguageState({
    this.localeCode = 'en_US',
    this.languageName = 'English',
    this.flag = '🇺🇸',
  });

  LanguageState copyWith({
    String? localeCode,
    String? languageName,
    String? flag,
  }) {
    return LanguageState(
      localeCode: localeCode ?? this.localeCode,
      languageName: languageName ?? this.languageName,
      flag: flag ?? this.flag,
    );
  }

  @override
  List<Object> get props => [localeCode, languageName, flag];
}