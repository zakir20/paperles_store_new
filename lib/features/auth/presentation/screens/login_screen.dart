import 'package:flutter/material.dart';
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
              LoginButton(
                selectedLanguage: _selectedLanguage,
                isLoading: _isLoading,
                onPressed: _loginUser,
              ),
              const SizedBox(height: 24),
              RegisterLink(
                selectedLanguage: _selectedLanguage,
                onPressed: () => Navigator.pushNamed(context, '/register'),
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
      LoginUtils.showSnackBar(
        context,
        _selectedLanguage == 'বাংলা' ? 'ইমেইল এবং পাসওয়ার্ড লিখুন' : 'Please enter email and password',
        true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.loginUser(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (result['success'] == true) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        LoginUtils.showSnackBar(
          context,
          result['message'] ?? (_selectedLanguage == 'বাংলা' ? 'লগইন ব্যর্থ হয়েছে' : 'Login failed'),
          true,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      LoginUtils.showSnackBar(
        context,
        _selectedLanguage == 'বাংলা' ? 'ত্রুটি হয়েছে: $e' : 'Error occurred: $e',
        true,
      );
    }
  }

  void _showForgotPasswordMessage() {
    LoginUtils.showSnackBar(
      context,
      _selectedLanguage == 'বাংলা' 
        ? 'পাসওয়ার্ড রিসেট বৈশিষ্ট্য শীঘ্রই আসছে' 
        : 'Password reset feature coming soon',
      false,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}