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
      
      await Future.delayed(const Duration(seconds: 2));
      
      Get.snackbar(
        'success'.tr, 
        'registrationSuccessful'.tr, 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      Get.offAllNamed('/login');
      
      clearForm();
      
    } catch (e) {
      Get.snackbar(
        'error'.tr, 
        '${'errorOccurred'.tr}: $e', 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
  
  
  void clearForm() {
    selectedShopType.value = null;
    tradeLicenseDocument.value = null;
    profileImage.value = null;
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
  }
  
  
  @override
  void onInit() {
    super.onInit();
  }
  
  @override
  void onClose() {
    clearForm();
    super.onClose();
  }
}