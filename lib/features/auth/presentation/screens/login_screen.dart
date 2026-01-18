import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart'; 
import 'package:easy_localization/easy_localization.dart'; 
import 'package:paperless_store_upd/injection/injection_container.dart';
import 'package:paperless_store_upd/core/bloc/language_cubit.dart';
import 'package:paperless_store_upd/core/bloc/language_state.dart';
import 'package:paperless_store_upd/core/theme/app_colors.dart'; 
import '../bloc/login_cubit.dart'; 
import '../bloc/login_state.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_cubit.dart';

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
        backgroundColor: isError ? Colors.red : AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  OutlineInputBorder _buildBorder({Color? color, double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color ?? AppColors.greyBorder, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 2. Updated BlocProvider to use LoginCubit
    return BlocProvider<LoginCubit>(
      create: (context) => sl<LoginCubit>(),
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, langState) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      const Gap(10), 
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildLanguageDropdown(langState),
                      ),
                      const Gap(50), 

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.send, size: 70, color: AppColors.primary),
                            const Gap(10), 
                            Text(
                              "paperless_store".tr(), 
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.black),
                            ),
                            const Gap(30), 

                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              style: const TextStyle(fontSize: 14, color: AppColors.black),
                              decoration: InputDecoration(
                                labelText: "email".tr(),
                                hintText: "enter_email".tr(),
                                prefixIcon: const Icon(Icons.email_outlined, size: 20),
                                labelStyle: const TextStyle(color: AppColors.greyText, fontSize: 13),
                                floatingLabelStyle: const TextStyle(color: AppColors.primary),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                border: _buildBorder(),
                                enabledBorder: _buildBorder(),
                                focusedBorder: _buildBorder(color: AppColors.primary, width: 1.5),
                              ),
                            ),

                            const Gap(15), 

                            // Password Field
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  // 3. Updated Builder for LoginCubit
                                  child: BlocBuilder<LoginCubit, LoginState>(
                                    builder: (context, loginState) {
                                      return TextFormField(
                                        controller: _passwordController,
                                        focusNode: _passwordFocusNode,
                                        obscureText: !loginState.isPasswordVisible,
                                        style: const TextStyle(fontSize: 14, color: Colors.black),
                                        decoration: InputDecoration(
                                          labelText: "password".tr(),
                                          hintText: "enter_password".tr(),
                                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                                          labelStyle: const TextStyle(color: AppColors.greyText, fontSize: 13),
                                          floatingLabelStyle: const TextStyle(color: AppColors.primary),
                                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                          border: _buildBorder(),
                                          enabledBorder: _buildBorder(),
                                          focusedBorder: _buildBorder(color: AppColors.primary, width: 1.5),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const Gap(8), 
                                BlocBuilder<LoginCubit, LoginState>(
                                  builder: (context, loginState) {
                                    return InkWell(
                                      // 4. Using LoginCubit function
                                      onTap: () => context.read<LoginCubit>().togglePassword(),
                                      child: Container(
                                        height: 45, 
                                        width: 65,
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGreenButton,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          loginState.isPasswordVisible ? "hide".tr() : "show".tr(),
                                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),

                            const Gap(10), 
                            
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "forgot_password".tr(), 
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),

                            const Gap(10), 

                            // SIGN IN BUTTON
                            BlocConsumer<LoginCubit, LoginState>(
                              listener: (context, loginState) {
                                if (loginState is LoginSuccess) {
                                   context.read<GlobalAuthCubit>().setAuthenticated(); 
                                  _showMsg('Login Successful', isError: false);
                                  context.go('/dashboard'); 
                                }
                                if (loginState is LoginError) {
                                   _showMsg(loginState.message);
                                }
                              },
                              builder: (context, loginState) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: loginState is LoginLoading ? null : () {
                                      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                        _showMsg("error".tr());
                                        return;
                                      }
                                      // 6. Call LoginCubit method
                                      context.read<LoginCubit>().login(
                                        _emailController.text.trim(),
                                        _passwordController.text,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      elevation: 0,
                                    ),
                                    child: loginState is LoginLoading 
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : Text(
                                          "sign_in".tr(), 
                                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                  ),
                                );
                              },
                            ),

                            const Gap(20), 
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("no_account".tr(), style: const TextStyle(color: AppColors.greyText)),
                                TextButton(
                                  onPressed: () => context.push('/register'),
                                  child: Text(
                                    "register".tr(),
                                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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
          );
        },
      ),
    );
  }

  Widget _buildLanguageDropdown(LanguageState langState) {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardWhite.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.greyBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(langState.flag, style: const TextStyle(fontSize: 18)),
            const Gap(8),
            Text(
              langState.localeCode == 'en_US' ? "EN" : "BN",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.black),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.greyText),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      offset: const Offset(0, 50),
      elevation: 4,
      onSelected: (String newValue) {
        context.read<LanguageCubit>().changeLanguage(context, newValue);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'en_US',
          child: Row(
            children: [
              const Text("🇺🇸", style: TextStyle(fontSize: 20)),
              const Gap(12),
              const Expanded(child: Text("English (EN)", style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600))),
              if (langState.localeCode == 'en_US') const Icon(Icons.check, color: AppColors.primary, size: 20),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'bn_BD',
          child: Row(
            children: [
              const Text("🇧🇩", style: TextStyle(fontSize: 20)),
              const Gap(12),
              const Expanded(child: Text("বাংলা (BN)", style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600))),
              if (langState.localeCode == 'bn_BD') const Icon(Icons.check, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}