import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'core/translations/app_translations.dart';
import 'core/controllers/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  Get.put(AuthController());
  Get.put(LanguageController());
  
  runApp(const MyApp());
}

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
      
      // TRANSLATIONS
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}