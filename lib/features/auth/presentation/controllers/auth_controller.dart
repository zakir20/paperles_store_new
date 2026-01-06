import 'package:get/get.dart';

// SUPER SIMPLE CONTROLLER - Just copy this
class AuthController extends GetxController {
  // Just 4 variables to manage login
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var selectedLanguage = 'English (EN)'.obs;
  var selectedFlag = '🇺🇸'.obs;
  
  // Simple login function
  void login(String email, String password) {
    isLoading(true); // Show loading
    
    // Wait 2 seconds (simulating API)
    Future.delayed(const Duration(seconds: 2), () {
      isLoading(false); // Hide loading
      
      // Show success message
      Get.snackbar(
        'Success',
        'Login Successful!',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // Go to dashboard
      Get.toNamed('/dashboard');
    });
  }
}