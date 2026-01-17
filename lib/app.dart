import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/get.dart';
import 'navigation/app_router.dart'; 
import 'core/translations/app_translations.dart';
=======
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
=======
    return MaterialApp(
      title: 'Paperless Store',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
    );
  }
}