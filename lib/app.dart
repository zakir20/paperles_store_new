import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';
import 'core/translations/app_translations.dart';
import 'core/bindings/app_bindings.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Paperless Store',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.routes,
      initialRoute: '/splash',
      
      initialBinding: AppBindings(),
      translations: AppTranslations(),
      
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}