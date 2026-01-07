import 'package:get/get.dart';
import 'package:flutter/material.dart'; 

class LanguageController extends GetxController {
  final selectedLanguage = 'English (EN)'.obs;
  final selectedFlag = '🇺🇸'.obs;
  
  bool get isBangla => selectedLanguage.value.contains('Bangla') || 
                       selectedLanguage.value.contains('বাংলা');
  
  void changeLanguage(String language, String flag, String localeCode) {
    selectedLanguage.value = language;
    selectedFlag.value = flag;
    
    final parts = localeCode.split('_');
    if (parts.length == 2) {
      Get.updateLocale(Locale(parts[0], parts[1])); 
    } else {
      Get.updateLocale(Locale(localeCode)); 
    }
  }
}