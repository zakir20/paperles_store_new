import 'package:flutter/material.dart';
import 'package:get/get.dart'; 

class RegisterUtils {
  static void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static bool validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static Map<String, String> validateRegistration({
    required String fullName,
    required String shopName,
    required String proprietorName,
    required String phone,
    required String email,
    required String? shopType,
    required String storeAddress,
    required String location,
    required String password,
    required String confirmPassword,
    required String selectedLanguage,
  }) {
    if (fullName.isEmpty ||
        shopName.isEmpty ||
        proprietorName.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        shopType == null ||
        storeAddress.isEmpty ||
        location.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return {
        'valid': 'false',
        'message': 'fillAllRequiredFields'.tr 
      };
    }

    if (password != confirmPassword) {
      return {
        'valid': 'false',
        'message': 'passwordsNotMatch'.tr 
      };
    }

    if (password.length < 6) {
      return {
        'valid': 'false',
        'message': 'passwordTooShort'.tr 
      };
    }

    if (!validateEmail(email)) {
      return {
        'valid': 'false',
        'message': 'invalidEmail'.tr 
      };
    }

    return {'valid': 'true', 'message': ''};
  }
}