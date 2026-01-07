import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'core/controllers/language_controller.dart'; 
import 'features/auth/presentation/controllers/register_controller.dart'; // ADD THIS IMPORT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  Get.put(AuthController());
  Get.put(LanguageController()); 
  Get.lazyPut(() => RegisterController()); 
  
  runApp(const MyApp());
}