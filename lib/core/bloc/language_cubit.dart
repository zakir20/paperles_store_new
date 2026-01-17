import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState());

  void changeLanguage(BuildContext context, String localeCode) {
  if (localeCode == 'bn_BD') {
    context.setLocale(const Locale('bn', 'BD')); 
    emit(state.copyWith(localeCode: 'bn_BD', flag: '🇧🇩'));
  } else {
    context.setLocale(const Locale('en', 'US'));
    emit(state.copyWith(localeCode: 'en_US', flag: '🇺🇸'));
  }
}
}