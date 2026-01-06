
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  // CHANGED: MaterialApp → GetMaterialApp
      title: 'Paperless Store',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.routes,  // GetX routes
      initialRoute: '/',
      // onGenerateRoute: AppRouter.generateRoute,
    );
  }
}