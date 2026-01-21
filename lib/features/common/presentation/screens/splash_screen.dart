import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_cubit/global_auth_cubit.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_cubit/global_auth_state.dart';
import 'package:paperless_store_upd/core/navigation/app_router.dart';
import 'package:paperless_store_upd/core/theme/app_colors.dart';
import 'package:paperless_store_upd/features/auth/presentation/screens/login_screen.dart';
import 'package:paperless_store_upd/features/common/presentation/widgets/center_circular_progress_indicator.dart';
import 'package:paperless_store_upd/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:paperless_store_upd/injection/injection_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String route = '/splash-screen';

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
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      await sl<GlobalAuthCubit>().checkAuthStatus();
      final authState = sl<GlobalAuthCubit>().state;
      if (authState is Authenticated && mounted) {
        AppRouter.go(context, DashboardScreen.route);
      } else if (mounted) {
        AppRouter.go(context, LoginScreen.route);
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
            const Spacer(),
            Center(
              child: Container(
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
            ),
            const Gap(20),
            Text(
              'app_title'.tr(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const Spacer(),
            const CenterCircularProgressIndicator(),
            const Gap(24),
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
