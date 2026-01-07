import 'package:flutter/material.dart';  
import 'package:get/get.dart';

class RouteNames {
  // Route paths
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String products = '/products';
  static const String customers = '/customers';
  static const String addProduct = '/addProduct';
  static const String addCustomer = '/addCustomer';
  static const String manageProducts = '/manageProducts';
  
  // Helper methods for GetX navigation
  static void goToSplash() => Get.toNamed(splash);
  static void goToLogin() => Get.toNamed(login);
  static void goToRegister() => Get.toNamed(register);
  static void goToDashboard() => Get.offAllNamed(dashboard);
  static void goToProducts() => Get.toNamed(products);
  static void goToCustomers() => Get.toNamed(customers);
  static void goToAddProduct() => Get.toNamed(addProduct);
  static void goToAddCustomer() => Get.toNamed(addCustomer);
  static void goToManageProducts() => Get.toNamed(manageProducts);
  static void goBack() => Get.back();
  static void goBackWithResult(dynamic result) => Get.back(result: result);
  
  // Dialogs and snackbars
  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
  
  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
  
  static void showLoading([String message = 'Loading...']) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}