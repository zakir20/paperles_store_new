import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/get.dart';
import 'package:go_router/go_router.dart'; // 1. Added GoRouter import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
=======
import '../../../../core/services/api_service.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/login'); 
=======
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Check if user is already logged in
    final isLoggedIn = await ApiService.isLoggedIn();
    
    Future.delayed(const Duration(seconds: 3), () {
      if (isLoggedIn) {
        // If logged in, go to dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // If not logged in, go to login
        Navigator.pushReplacementNamed(context, '/login');
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.white, 
=======
      backgroundColor: Colors.white,
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
<<<<<<< HEAD
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF2EB14B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.store,
=======
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF2E5BFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.inventory_2,
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
                color: Colors.white,
                size: 60,
              ),
            ),
<<<<<<< HEAD
            const SizedBox(height: 20),
            Text(
              'app_title'.tr, 
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Kalpurush', 
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Color(0xFF2EB14B),
=======
            const SizedBox(height: 30),
            
            // App Name
            const Text(
              'Paperless Store',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Loading indicator
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
            
            const SizedBox(height: 100),
            
            // JSON Storage Info
            // Container(
            //   padding: const EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //     color: Colors.green[50],
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: const Column(
            //     children: [
            //       Text(
            //         '✅ JSON Storage Active',
            //         style: TextStyle(
            //           color: Colors.green,
            //           fontSize: 12,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       SizedBox(height: 5),
            //       Text(
            //         'Works 100% offline • No server needed',
            //         style: TextStyle(
            //           color: Colors.grey,
            //           fontSize: 10,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            
            const SizedBox(height: 20),
            
            // Version
            const Text(
              'version 1.0.0+1',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
            ),
          ],
        ),
      ),
    );
  }
}