import 'package:flutter/material.dart';

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
        'message': selectedLanguage == 'বাংলা' 
            ? 'সব প্রয়োজনীয় তথ্য পূরণ করুন' 
            : 'Please fill all required fields'
      };
    }

    if (password != confirmPassword) {
      return {
        'valid': 'false',
        'message': selectedLanguage == 'বাংলা' 
            ? 'পাসওয়ার্ড মিলছে না' 
            : 'Passwords do not match'
      };
    }

    if (password.length < 6) {
      return {
        'valid': 'false',
        'message': selectedLanguage == 'বাংলা' 
            ? 'পাসওয়ার্ড অন্তত ৬ অক্ষরের হতে হবে' 
            : 'Password must be at least 6 characters'
      };
    }

    if (!validateEmail(email)) {
      return {
        'valid': 'false',
        'message': selectedLanguage == 'বাংলা' 
            ? 'সঠিক ইমেইল ঠিকানা লিখুন' 
            : 'Please enter a valid email address'
      };
    }

    return {'valid': 'true', 'message': ''};
  }
}