import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/json_registration.dart';

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
    // Reset loading first
    isLoading.value = true;
    
    print('🎯 REGISTER CONTROLLER: Starting...');
    
    try {
      // ========== VALIDATION ==========
      if (password != confirmPassword) {
        throw 'Passwords do not match';
      }
      
      if (selectedShopType.value == null || selectedShopType.value!.isEmpty) {
        throw 'Please select shop type';
      }
      
      if (fullName.isEmpty || email.isEmpty || phone.isEmpty) {
        throw 'Required fields are missing';
      }
      
      // ========== CALL JSON REGISTRATION ==========
      print('🔧 Preparing data for registration...');
      
      final jsonReg = JsonRegistration();
      
      final userData = {
        'full_name': fullName,
        'shop_name': shopName,
        'proprietor_name': proprietorName,
        'phone': phone,
        'email': email,
        'shop_type': selectedShopType.value!,
        'store_address': storeAddress,
        'location': location,
        'trade_license': tradeLicense,
        'password': password,
      };
      
      print('📤 Sending: $userData');
      
      final result = await jsonReg.registerUser(userData);
      
      print('📥 Result received: ${result["success"]} - ${result["message"]}');
      
      if (result["success"] == true) {
        // SUCCESS - Show dialog instead of snackbar
        print('✅ Registration successful!');
        
        // Clear form
        clearForm();
        
        // Show success DIALOG (user must click OK)
        Get.dialog(
          AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text('Registration Successful'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Your account has been created successfully!'),
                SizedBox(height: 10),
                Text('Please login to continue.', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                if (result["mode"] == 'online')
                  Text('✓ Saved to MySQL Database', style: TextStyle(color: Colors.green)),
                if (result["mode"] == 'offline')
                  Text('⚠ Saved locally (offline mode)', style: TextStyle(color: Colors.orange)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  // Then navigate to login
                  Get.offAllNamed('/login');
                },
                child: Text('LOGIN NOW', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          barrierDismissible: false, // User must click OK
        );
        
      } else {
        // FAILED
        throw result["message"] ?? 'Registration failed';
      }
      
    } catch (e) {
      print('❌ Registration error: $e');
      
      // Show error dialog
      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text('Registration Failed'),
            ],
          ),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('OK'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
      
    } finally {
      // ALWAYS set loading to false
      isLoading.value = false;
      print('🔄 Loading state set to false');
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