import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/api_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF2E5BFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.inventory_2,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 30),
            
            const Text(
              'Paperless Store',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            
            const SizedBox(height: 10),
            
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E5BFF)),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Version
            const Text(
              'version 1.0.0+1',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final isLoggedIn = await ApiService.isLoggedIn();
        if (isLoggedIn) {
      Get.offAllNamed('/dashboard');
    } else {
      Get.offAllNamed('/login');
    }
  }
}