import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_store_upd/injection/injection_container.dart';
import '../bloc/auth_cubit.dart'; 
import '../bloc/auth_state.dart';

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

  final Color greenColor = const Color(0xFF2EB14B);
  final Color bgColor = const Color(0xFFF1F8F1);
  final Color lightGreenButton = const Color(0xFFE8F5E9);

  String _selectedLanguage = Get.locale?.languageCode == 'bn' ? 'bn_BD' : 'en_US';

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
}