import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart'; 
import 'package:paperless_store_upd/core/bloc/app_bloc_observer.dart';
import 'package:paperless_store_upd/injection/injection_container.dart' as di;
import 'package:paperless_store_upd/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  await di.init();

  Bloc.observer = AppBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('bn', 'BD'),
      ],
      path: 'assets/translations', 
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}