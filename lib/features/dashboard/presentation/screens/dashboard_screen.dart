import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paperless_store_upd/core/theme/app_colors.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_cubit.dart'; 

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _userName = "User";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? "Store Manager";
    });
  }

  //   Logout Logic
  Future<void> _handleLogout() async {
    // Call the Global Cubit to clear memory and update state
    await context.read<GlobalAuthCubit>().logout();
    
    if (mounted) {
      //  Use GoRouter to return to Login
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0.5,
        title: Text(
          "dashboard".tr(),
          style: const TextStyle(
            color: AppColors.black, 
            fontWeight: FontWeight.bold, 
            fontSize: 18,
            fontFamily: 'Kalpurush',
          ),
        ),
        actions: [
          IconButton(
            // Logout icon set to Red to be clear
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Welcome Section
            Text(
              "${"welcome".tr()}, $_userName",
              style: const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: AppColors.black,
                fontFamily: 'Kalpurush',
              ),
            ),
            const Gap(20),

            // 2. Stats Rows
            Row(
              children: [
                _buildStatCard("Total Sales", "TK 123,123", Icons.trending_up, Colors.blue),
                const Gap(12),
                _buildStatCard("Outstanding", "TK 3,423", Icons.account_balance_wallet, Colors.orange),
              ],
            ),
            const Gap(12),
            Row(
              children: [
                _buildStatCard("Low Stock", "112 Items", Icons.warning_amber_rounded, Colors.red),
                const Gap(12),
                _buildStatCard("Purchases", "TK 4,202", Icons.shopping_bag, AppColors.primary),
              ],
            ),
            const Gap(24),

            // 3. Sales Overview Chart
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Sales Overview", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                      return Column(
                        children: [
                          Container(
                            height: 60, width: 12,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2), 
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const Gap(8),
                          Text(day, style: const TextStyle(fontSize: 10, color: AppColors.greyText)),
                        ],
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
            const Gap(80), 
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.greyText,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Sales'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const Gap(12),
            Text(title, style: const TextStyle(color: AppColors.greyText, fontSize: 12)),
            const Gap(4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.black)),
          ],
        ),
      ),
    );
  }
}