import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:paperless_store_upd/injection/injection_container.dart'; 
import 'package:paperless_store_upd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:paperless_store_upd/features/auth/presentation/bloc/auth_event.dart';
import 'package:paperless_store_upd/features/auth/presentation/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  
  String _selectedLanguage = Get.locale?.languageCode == 'bn' ? 'bn_BD' : 'en_US';
  final Color greenColor = const Color(0xFF2EB14B);

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language Selector
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildLanguageDropdown(),
                ),

                const SizedBox(height: 40),

                // Title
                Text(
                  'login'.tr,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 40),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'email'.tr,
                    hintText: 'enter_email'.tr,
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.black87, size: 22),
                    labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                    floatingLabelStyle: TextStyle(color: greenColor, fontWeight: FontWeight.w600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: greenColor, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Password Field
                    Expanded(
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: !state.isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'password'.tr,
                              hintText: 'enter_password'.tr,
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.black87, size: 22),
                              labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                              floatingLabelStyle: TextStyle(color: greenColor, fontWeight: FontWeight.w600),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: greenColor, width: 1.5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12), 

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return SizedBox(
                          height: 58, 
                          child: OutlinedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(TogglePasswordVisibilityEvent());
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: greenColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: Text(
                              state.isPasswordVisible ? 'hide'.tr : 'show'.tr,
                              style: TextStyle(
                                color: greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.snackbar('Info', 'Feature coming soon'.tr),
                    child: Text(
                      'forgot_password'.tr,
                      style: TextStyle(color: greenColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Login Button
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) Get.offAllNamed('/dashboard');
                    if (state is AuthError) {
                      Get.snackbar('Error'.tr, state.message, snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(LoginEvent(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                    ));
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'login'.tr,
                                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('no_account'.tr, style: TextStyle(color: Colors.grey[600])),
                    TextButton(
                      onPressed: () {},
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
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: greenColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() => _selectedLanguage = newValue);
              Get.updateLocale(newValue == 'bn_BD' ? const Locale('bn', 'BD') : const Locale('en', 'US'));
            }
          },
          items: const [
            DropdownMenuItem(value: 'en_US', child: Text("🇺🇸 EN")),
            DropdownMenuItem(value: 'bn_BD', child: Text("🇧🇩 BN")),
          ],
        ),
      ),
    );
  }
}