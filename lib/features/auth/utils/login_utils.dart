import 'package:flutter/material.dart';

class LoginUtils {
  static void showSnackBar(BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.blue,
      ),
    );
  }

  static String getTranslatedText(String language, Map<String, String> translations) {
    return translations[language] ?? translations['English (EN)']!;
  }
}