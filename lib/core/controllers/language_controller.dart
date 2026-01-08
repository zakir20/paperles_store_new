import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  final selectedLanguage = 'English'.obs;
  final selectedFlag = '🇺🇸'.obs;
  
  @override
  void onInit() {
    super.onInit();

  }
  
  void changeLanguage(String language, String flag, String localeCode) {
    print('=== Changing language to: $language ===');
    
    selectedLanguage.value = language;
    selectedFlag.value = flag;
    
    if (localeCode == 'bn_BD') {
      Get.updateLocale(const Locale('bn', 'BD'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
    

    
    print('Locale updated to: ${Get.locale}');
  }
}