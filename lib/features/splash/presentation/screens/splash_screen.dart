import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:paperless_store_upd/core/theme/app_colors.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_cubit.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startAppFlow();
  }

  Future<void> _startAppFlow() async {
    await context.read<GlobalAuthCubit>().checkAuthStatus();
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final authState = context.read<GlobalAuthCubit>().state;

      if (authState is Authenticated) {
        // User logged in before -> Go to Dashboard
        context.go('/dashboard');
      } else {
        // New user or logged out -> Go to Login
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.store,
                color: Colors.white,
                size: 60,
              ),
            ),
            const Gap(20),
            
            Text(
              'app_title'.tr(), 
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: 'Kalpurush', 
              ),
            ),
            const Gap(30),
            
            // Loading Indicator
            const CircularProgressIndicator(
              color: AppColors.primary,
            ),
            
            const Gap(100),
            
            // Version Info
            const Text(
              'version 1.0.0+1',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}