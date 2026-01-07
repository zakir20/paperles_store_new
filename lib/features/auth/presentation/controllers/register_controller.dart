import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  // ========== REACTIVE VARIABLES ==========
  
  // UI State
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  
  // Language
  final selectedLanguage = 'English (EN)'.obs;
  final selectedFlag = '🇺🇸'.obs;
  
  // Form Data
  final selectedShopType = Rx<String?>(null);
  final tradeLicenseDocument = Rx<String?>(null);
  final profileImage = Rx<File?>(null);
  
  // ========== REGISTER METHOD ==========
  Future<void> register({
    required String fullName,
    required String shopName,
    required String proprietorName,
    required String phone,
    required String email,
    required String storeAddress,
    required String location,
    required String tradeLicense,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      isLoading(true);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Success - USE .tr
      Get.snackbar(
        'success'.tr, // CHANGED
        'registrationSuccessful'.tr, // CHANGED
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to login
      Get.offAllNamed('/login');
      
      // Clear form
      clearForm();
      
    } catch (e) {
      Get.snackbar(
        'error'.tr, // CHANGED
        '${'errorOccurred'.tr}: $e', // CHANGED: Need to add key
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
  
  // ========== HELPER METHODS ==========
  
  void clearForm() {
    selectedShopType.value = null;
    tradeLicenseDocument.value = null;
    profileImage.value = null;
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
  }
  
  // ========== INITIALIZATION ==========
  
  @override
  void onInit() {
    super.onInit();
    // Initialize anything here
  }
  
  @override
  void onClose() {
    clearForm();
    super.onClose();
  }
}