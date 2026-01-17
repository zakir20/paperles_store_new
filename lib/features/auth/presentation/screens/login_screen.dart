import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_store_upd/injection/injection_container.dart';
import '../bloc/auth_cubit.dart'; 
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
=======
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
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
<<<<<<< HEAD
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final Color greenColor = const Color(0xFF2EB14B);
  final Color bgColor = const Color(0xFFF1F8F1);
  final Color lightGreenButton = const Color(0xFFE8F5E9);

  String _selectedLanguage = Get.locale?.languageCode == 'bn' ? 'bn_BD' : 'en_US';

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
=======
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
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
<<<<<<< HEAD

  void _showMsg(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  OutlineInputBorder _buildBorder({Color? color, double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color ?? Colors.grey[300]!, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>(),
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _buildLanguageDropdown(),
                  ),
                  const SizedBox(height: 50),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.send, size: 70, color: Color(0xFF2EB14B)),
                        const SizedBox(height: 10),
                        Text(
                          'paperless_store'.tr, 
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),

                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'email'.tr,
                            hintText: 'enter_email'.tr,
                            prefixIcon: const Icon(Icons.email_outlined, size: 20),
                            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                            floatingLabelStyle: TextStyle(color: greenColor),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            border: _buildBorder(),
                            enabledBorder: _buildBorder(),
                            focusedBorder: _buildBorder(color: greenColor, width: 1.5),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  return TextFormField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocusNode,
                                    obscureText: !state.isPasswordVisible,
                                    style: const TextStyle(fontSize: 14, color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'password'.tr,
                                      hintText: 'enter_password'.tr,
                                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                                      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                                      floatingLabelStyle: TextStyle(color: greenColor),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                      border: _buildBorder(),
                                      enabledBorder: _buildBorder(),
                                      focusedBorder: _buildBorder(color: greenColor, width: 1.5),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return InkWell(
                                  onTap: () => context.read<AuthCubit>().togglePassword(),
                                  child: Container(
                                    height: 45, 
                                    width: 65,
                                    decoration: BoxDecoration(
                                      color: lightGreenButton,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      state.isPasswordVisible ? 'hide'.tr : 'show'.tr,
                                      style: TextStyle(color: greenColor, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'forgot_password'.tr, 
                              style: TextStyle(color: greenColor, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthSuccess) {
                              _showMsg('Login Successful', isError: false);
                              context.go('/dashboard'); 
                            }
                            if (state is AuthError) {
                               _showMsg(state.message);
                            }
                          },
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: state is AuthLoading ? null : () {
                                  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                    _showMsg('Please fill all fields');
                                    return;
                                  }
                                  context.read<AuthCubit>().login(
                                    _emailController.text.trim(),
                                    _passwordController.text,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: greenColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                                child: state is AuthLoading 
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : Text(
                                      'sign_in'.tr, 
                                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("no_account".tr, style: const TextStyle(color: Colors.black54)),
                            TextButton(
                              onPressed: () {
                                context.push('/register'); 
                              },
                              child: Text(
                                'register'.tr,
                                style: TextStyle(color: greenColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_selectedLanguage == 'en_US' ? "🇺🇸" : "🇧🇩", style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              _selectedLanguage == 'en_US' ? "EN" : "BN",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      offset: const Offset(0, 50),
      elevation: 4,
      onSelected: (String newValue) {
        setState(() => _selectedLanguage = newValue);
        Get.updateLocale(newValue == 'bn_BD' ? const Locale('bn', 'BD') : const Locale('en', 'US'));
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'en_US',
          child: Row(
            children: [
              const Text("🇺🇸", style: TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(child: Text("English (EN)", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.w600))),
              if (_selectedLanguage == 'en_US') Icon(Icons.check, color: greenColor, size: 20),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'bn_BD',
          child: Row(
            children: [
              const Text("🇧🇩", style: TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(child: Text("বাংলা (BN)", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.w600))),
              if (_selectedLanguage == 'bn_BD') Icon(Icons.check, color: greenColor, size: 20),
            ],
          ),
        ),
      ],
    );
  }
=======
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
}