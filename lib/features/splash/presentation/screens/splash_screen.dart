import 'package:flutter/material.dart';
import '../../../../core/services/api_service.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                color: Colors.white,
                size: 60,
              ),
            ),
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
            ),
          ],
        ),
      ),
    );
  }
}