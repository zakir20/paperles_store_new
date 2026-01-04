import 'package:flutter/material.dart';

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
        title: Text(currentLanguage == 'বাংলা' ? 'ভাষা নির্বাচন করুন' : 'Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 20)),
              title: const Text('English (EN)'),
              onTap: () {
                onLanguageChanged('English (EN)');
                onFlagChanged('🇺🇸');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇧🇩', style: TextStyle(fontSize: 20)),
              title: const Text('বাংলা'),
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