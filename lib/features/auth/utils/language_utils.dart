import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Add this import

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
        title: Text('selectLanguage'.tr), // CHANGED
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 20)),
              title: Text('english'.tr), // CHANGED: Need to add key
              onTap: () {
                onLanguageChanged('English (EN)');
                onFlagChanged('🇺🇸');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇧🇩', style: TextStyle(fontSize: 20)),
              title: Text('bangla'.tr), // CHANGED: Need to add key
              onTap: () {
                onLanguageChanged('বাংলা');
                onFlagChanged('🇧🇩');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}