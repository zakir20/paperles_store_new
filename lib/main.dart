import 'package:flutter/material.dart';
import 'app.dart';
import 'package:get/get.dart';
import 'core/controllers/language_controller.dart'; 
import 'core/services/json_registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  Get.put(LanguageController(), permanent: true);

  try {
    print(' App starting...');
    
    final jsonReg = JsonRegistration();
    await jsonReg.initMode();
    
    print('Mode initialized');
    
  } catch (e) {
    print(' Initialization error: $e');
  }
  
  runApp(const MyApp());
}