import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import '../controllers/auth_controller.dart'; 
import '../../../../core/services/api_service.dart';
import '../widgets/language_selector.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/forgot_password.dart';
import '../widgets/login_button.dart';
import '../widgets/register_link.dart';
import '../../utils/login_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //  GetX Controller
  final AuthController authController = Get.put(AuthController());
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedLanguage = 'English (EN)';
  String _selectedFlag = '🇺🇸';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // CHANGE THIS WIDGET ONLY
                  LanguageSelector(
                    selectedLanguage: _selectedLanguage,
                    selectedFlag: _selectedFlag,
                    onLanguageChanged: (language) => setState(() => _selectedLanguage = language),
                    onFlagChanged: (flag) => setState(() => _selectedFlag = flag),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              _buildAppTitle(),
              const SizedBox(height: 60),
              EmailField(controller: _emailController, selectedLanguage: _selectedLanguage),
              const SizedBox(height: 20),
              PasswordField(
                controller: _passwordController,
                selectedLanguage: _selectedLanguage,
                isPasswordVisible: _isPasswordVisible,
                onVisibilityChanged: (visible) => setState(() => _isPasswordVisible = visible),
              ),
              const SizedBox(height: 16),
              ForgotPassword(
                selectedLanguage: _selectedLanguage,
                onPressed: _showForgotPasswordMessage,
              ),
              const SizedBox(height: 24),
              // CHANGE THIS BUTTON ONLY - Use GetX loading
              LoginButton(
                selectedLanguage: _selectedLanguage,
                isLoading: authController.isLoading.value, // Use GetX
                onPressed: _loginUser,
              ),
              const SizedBox(height: 24),
              RegisterLink(
                selectedLanguage: _selectedLanguage,
                onPressed: () => Get.toNamed('/register'), // CHANGE: Use GetX navigation
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppTitle() {
    return Text(
      _selectedLanguage == 'বাংলা' ? 'পেপারলেস স্টোর' : 'Paperless Store',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF101828),
        fontFamily: _selectedLanguage == 'বাংলা' ? 'Kalpurush' : null,
      ),
    );
  }

  Future<void> _loginUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // CHANGE: Use GetX snackbar
      Get.snackbar(
        'Error',
        'Please enter email and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // CHANGE: Use GetX controller
    authController.login(_emailController.text.trim(), _passwordController.text);
    
    // Remove all old API code below
  }

  void _showForgotPasswordMessage() {
    // CHANGE: Use GetX snackbar
    Get.snackbar(
      'Notice',
      'Password reset feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}