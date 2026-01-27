import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_store_upd/core/theme/app_colors.dart';

class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.greyText,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: 'home'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.inventory_2), label: 'products'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.shopping_cart), label: 'sales'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: 'profile'.tr()),
        ],
      ),
    );
  }
}