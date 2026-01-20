import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_cubit/global_auth_cubit.dart';
import 'package:paperless_store_upd/core/constants/route_names.dart';
import 'package:paperless_store_upd/core/navigation/app_router.dart';
import 'package:paperless_store_upd/core/theme/app_colors.dart';
import 'package:paperless_store_upd/core/utils/show_toast_helper.dart';
import 'package:paperless_store_upd/features/common/presentation/widgets/center_circular_progress_indicator.dart';
import 'package:paperless_store_upd/features/common/presentation/widgets/language_selector_widget.dart';
import 'package:paperless_store_upd/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:paperless_store_upd/injection/injection_container.dart';

import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String route = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'musfique112@gmail.com');
  final _passwordController = TextEditingController(text: '12345678');
  late LoginCubit _loginCubit;

  @override
  void initState() {
    super.initState();
    _loginCubit = LoginCubit(sl());
  }

  OutlineInputBorder _border({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color ?? AppColors.greyBorder),
    );
  }

  void _onLoginPressed(BuildContext context) {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showToast(context, message: "fill_all_fields".tr());
      return;
    }

    _loginCubit.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: BlocConsumer<LoginCubit, LoginState>(
        bloc: _loginCubit,
        listener: _listener,
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const Gap(10),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: LanguageSelectorWidget(),
                    ),
                    const Gap(50),
                    _buildCard(context, state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, LoginState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.send, size: 70, color: AppColors.primary),
          const Gap(10),
          Text(
            "paperless_store".tr(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const Gap(30),
          _buildEmailField(),
          const Gap(15),
          _buildPasswordField(context, state), // Pass state here
          const Gap(20),
          _buildLoginButton(context, state),
          const Gap(20),
          _buildRegisterRow(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      style: const TextStyle(color: AppColors.black),
      decoration: InputDecoration(
        labelText: "email".tr(),
        hintText: "enter_email".tr(),
        prefixIcon: const Icon(Icons.email_outlined, size: 20),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(color: AppColors.primary),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context, LoginState state) {
    return TextFormField(
      controller: _passwordController,
      style: const TextStyle(color: AppColors.black),
      decoration: InputDecoration(
        labelText: "password".tr(),
        hintText: "enter_password".tr(),
        prefixIcon: const Icon(Icons.lock_outline, size: 20),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(color: AppColors.primary),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginState state) {
    final isLoading = state is LoginInLoadingState;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _onLoginPressed(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const CenterCircularProgressIndicator()
            : Text(
                "sign_in".tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "no_account".tr(),
          style: const TextStyle(color: AppColors.greyText),
        ),
        TextButton(
          onPressed: () => context.push(RouteNames.register),
          child: Text(
            "register".tr(),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _listener(BuildContext context, LoginState state) {
    if (state is LoginSuccessState) {
      sl<GlobalAuthCubit>().setAuthenticated(state.user.name);
      AppRouter.go(context, DashboardScreen.route);
      showToast(
        context,
        message: "login_success".tr(),
        isError: false,
      );
    }

    if (state is LoginErrorState) {
      showToast(context, message: state.message);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loginCubit.close();
    super.dispose();
  }
}
