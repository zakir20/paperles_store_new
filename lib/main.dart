import 'package:flutter/material.dart';
import 'app.dart';
import 'package:get/get.dart';
import 'core/controllers/language_controller.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    Get.put(LanguageController(), permanent: true);
  
  runApp(const MyApp());
}