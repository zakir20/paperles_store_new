import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/controllers/language_controller.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/forgot_password.dart';
import '../widgets/login_button.dart';
import '../widgets/register_link.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find();
  final LanguageController languageController = Get.find<LanguageController>();
  
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildLanguageSelector(),
                  ],
                ),
                const SizedBox(height: 60),
                
                
                EmailField(controller: _emailController),
                const SizedBox(height: 20),
                
                PasswordField(
                  controller: _passwordController,
                  isPasswordVisible: _isPasswordVisible,
                  onVisibilityChanged: (visible) => setState(() => _isPasswordVisible = visible),
                ),
                const SizedBox(height: 16),
                
                ForgotPassword(onPressed: _showForgotPasswordMessage),
                const SizedBox(height: 24),
                
                LoginButton(
                  isLoading: authController.isLoading.value,
                  onPressed: _loginUser,
                ),
                const SizedBox(height: 24),
                
                RegisterLink(onPressed: () => Get.toNamed('/register')),
                
              
              ],
            ),
          ),
        ),
      ),
    );
  }



Widget _buildLanguageSelector() {
  return PopupMenuButton<String>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 'en',
        child: Row(
          children: [
            const Text('🇺🇸'),
            const SizedBox(width: 8),
            const Text('English'), // Keep English hardcoded
          ],
        ),
      ),
      PopupMenuItem(
        value: 'bn',
        child: Row(
          children: [
            const Text('🇧🇩'),
            const SizedBox(width: 8),
            const Text('বাংলা'), // Keep Bangla hardcoded
          ],
        ),
      ),
    ],
    onSelected: (value) {
      if (value == 'Bangla' || value == 'বাংলা') {
  languageController.changeLanguage('Bangla', '🇧🇩', 'bn_BD');
} else {
  languageController.changeLanguage('English', '🇺🇸', 'en_US');
}
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Obx(() => Text(languageController.isBangla ? '🇧🇩' : '🇺🇸')),
          const SizedBox(width: 8),
          Obx(() => Text(languageController.isBangla ? 'বাংলা' : 'English')), // Keep hardcoded
          const Icon(Icons.arrow_drop_down, size: 20),
        ],
      ),
    ),
  );
}


  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'emailRequired'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    authController.login(email, password);
  }

 void _showForgotPasswordMessage() {
  print('=== CURRENT LOCALE: ${Get.locale} ===');
  print('"show" in Bangla: ${'show'.tr}');
  print('"hide" in Bangla: ${'hide'.tr}');
  print('"notice" in Bangla: ${'notice'.tr}');
  
  Get.snackbar(
    'notice'.tr,
    'featureComingSoon'.tr,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.blue[100],
    colorText: Colors.blue[900],
  );
}

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}