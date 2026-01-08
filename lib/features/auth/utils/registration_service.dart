import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    required Map<String, dynamic> registrationData,
    required VoidCallback onSuccess,
    required VoidCallback clearForm,
  }) async {
    try {
      final response = await ApiService.registerUser(registrationData);

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'registrationSuccessful'.tr, 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        clearForm();
        Future.delayed(const Duration(seconds: 2), onSuccess);
      } else {
        String errorMessage = response['message'] ?? 'Registration failed';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'registrationError'.tr, 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  static RegistrationController get controller => Get.find<RegistrationController>();
}

class RegistrationController extends GetxController {
  final isLoading = false.obs;
  final registrationResult = Rx<Map<String, dynamic>?>(null);
  final errorMessage = ''.obs;

  Future<void> register(Map<String, dynamic> registrationData) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await ApiService.registerUser(registrationData);
      registrationResult.value = response;
      
      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'registrationSuccessful'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      } else {
        errorMessage.value = response['message'] ?? 'Registration failed';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'registrationError'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}