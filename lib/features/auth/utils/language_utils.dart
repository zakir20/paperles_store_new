import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/language_controller.dart'; 

class LanguageUtils {
  static void showLanguageDialog({
    required BuildContext context,
    required String currentLanguage,
    required ValueChanged<String> onLanguageChanged,
    required ValueChanged<String> onFlagChanged,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('selectLanguage'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 20)),
              title: Text('english'.tr),
              onTap: () {
                onLanguageChanged('English');
                onFlagChanged('🇺🇸');
                
                final languageController = Get.find<LanguageController>();
                languageController.changeLanguage('English', '🇺🇸', 'en_US');
                
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇧🇩', style: TextStyle(fontSize: 20)),
              title: Text('bangla'.tr),
              onTap: () {
                onLanguageChanged('বাংলা');
                onFlagChanged('🇧🇩');
                
                final languageController = Get.find<LanguageController>();
                languageController.changeLanguage('বাংলা', '🇧🇩', 'bn_BD');
                
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}