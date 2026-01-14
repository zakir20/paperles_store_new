import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState()) {
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  void _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<LanguageState> emit,
  ) {
    if (event.localeCode == 'bn_BD') {
      emit(state.copyWith(
        localeCode: 'bn_BD',
        languageName: 'বাংলা',
        flag: '🇧🇩',
      ));
    } else {
      emit(state.copyWith(
        localeCode: 'en_US',
        languageName: 'English',
        flag: '🇺🇸',
      ));
    }
  }
}