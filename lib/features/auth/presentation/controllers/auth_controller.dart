import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var selectedLanguage = 'English (EN)'.obs;
  var selectedFlag = '🇺🇸'.obs;
  
  void login(String email, String password) {
    isLoading(true); 
    
    Future.delayed(const Duration(seconds: 2), () {
      isLoading(false); 
      
      Get.snackbar(
        'Success',
        'Login Successful!',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      Get.toNamed('/dashboard');
    });
  }
}