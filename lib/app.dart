import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'navigation/app_router.dart'; 
import 'core/translations/app_translations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Paperless Store',
    
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      backButtonDispatcher: AppRouter.router.backButtonDispatcher,
      
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF2EB14B),
        fontFamily: 'Kalpurush',
      ),
    );
  }
}