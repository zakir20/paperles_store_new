import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';

class RegistrationService {
  static Map<String, dynamic> prepareRegistrationData({
    required String fullName,
    required String shopName,
    required String proprietorName,
    required String phone,
    required String email,
    required String? shopType,
    required String storeAddress,
    required String location,
    required String tradeLicense,
    required String? tradeLicenseDocument,
    required String password,
    required String? profileImagePath,
  }) {
    return {
      'full_name': fullName.trim(),
      'shop_name': shopName.trim(),
      'proprietor_name': proprietorName.trim(),
      'phone': phone.trim(),
      'email': email.trim(),
      'shop_type': shopType,
      'store_address': storeAddress.trim(),
      'location': location.trim(),
      'trade_license': tradeLicense.trim().isEmpty ? '' : tradeLicense.trim(),
      'trade_license_document': tradeLicenseDocument ?? '',
      'password': password,
      'profile_image_path': profileImagePath ?? '',
    };
  }

  static Future<void> registerUser({
    required BuildContext context,
    required Map<String, dynamic> registrationData,
    required String language,
    required VoidCallback onSuccess,
    required VoidCallback clearForm,
  }) async {
    try {
      final response = await ApiService.registerUser(registrationData);

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(language == 'বাংলা' ? '✅ নিবন্ধন সফল!' : '✅ Registration successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        
        clearForm();
        Future.delayed(Duration(seconds: 2), onSuccess);
      } else {
        String errorMessage = response['message'] ?? 'Registration failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ \$errorMessage'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(language == 'বাংলা' ? 'ত্রুটি হয়েছে। আবার চেষ্টা করুন' : 'Error occurred. Please try again'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}