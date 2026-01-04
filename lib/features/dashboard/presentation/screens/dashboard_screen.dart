import 'package:flutter/material.dart';
import '../../../../core/services/api_service.dart'; 
import '../../../../navigation/right_side_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _userData;
  int _selectedIndex = 0;
  String _selectedPeriod = 'Day'; // Day, Week, Month
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample data for charts
  final Map<String, List<Map<String, dynamic>>> _chartData = {
    'Day': [
      {'label': 'Mon', 'value': 3200, 'color': const Color(0xFF4F46E5)},
      {'label': 'Tue', 'value': 2800, 'color': const Color(0xFF4F46E5)},
      {'label': 'Wed', 'value': 1800, 'color': const Color(0xFF4F46E5)},
      {'label': 'Thu', 'value': 1500, 'color': const Color(0xFF4F46E5)},
      {'label': 'Fri', 'value': 1200, 'color': const Color(0xFF4F46E5)},
      {'label': 'Sat', 'value': 2500, 'color': const Color(0xFF4F46E5)},
      {'label': 'Sun', 'value': 3000, 'color': const Color(0xFF4F46E5)},
    ],
    'Week': [
      {'label': 'W1', 'value': 3200, 'color': const Color(0xFF4F46E5)},
      {'label': 'W2', 'value': 2800, 'color': const Color(0xFF4F46E5)},
      {'label': 'W3', 'value': 1800, 'color': const Color(0xFF4F46E5)},
      {'label': 'W4', 'value': 1500, 'color': const Color(0xFF4F46E5)},
    ],
    'Month': [
      {'label': 'Jan', 'value': 3200, 'color': const Color(0xFF4F46E5)},
      {'label': 'Feb', 'value': 2800, 'color': const Color(0xFF4F46E5)},
      {'label': 'Mar', 'value': 1800, 'color': const Color(0xFF4F46E5)},
      {'label': 'Apr', 'value': 1500, 'color': const Color(0xFF4F46E5)},
      {'label': 'May', 'value': 1200, 'color': const Color(0xFF4F46E5)},
      {'label': 'Jun', 'value': 2500, 'color': const Color(0xFF4F46E5)},
    ],
  };

  // Bottom Navigation Bar Items
  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.inventory),
      label: 'Inventory',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      label: 'Sales',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'History',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.more_horiz),
      label: 'More',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await ApiService.getCurrentUser();
    setState(() {
      _userData = user;
    });
  }

  void _openRightDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final currentChartData = _chartData[_selectedPeriod] ?? [];
    final maxValue = currentChartData.isNotEmpty 
        ? currentChartData.map((e) => e['value'] as int).reduce((a, b) => a > b ? a : b)
        : 1;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA),
      endDrawer:  RightSideDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Left drawer or menu
          },
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                _userData?['shop_name'] != null 
                    ? 'Welcome to ${_userData!['shop_name']}'
                    : 'Welcome to Paperless Store',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
            ),

            // First Row: Total Sales and Outstanding Due
            Row(
              children: [
                // Total Sales Card
                Expanded(
                  child: _buildTotalSalesCard(),
                ),
                const SizedBox(width: 12),
                // Outstanding Due Card
                Expanded(
                  child: _buildOutstandingDueCard(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Second Row: Low Stock Alerts and Purchases
            Row(
              children: [
                // Low Stock Alerts
                Expanded(
                  child: _buildLowStockAlertCard(),
                ),
                const SizedBox(width: 12),
                // Purchases
                Expanded(
                  child: _buildPurchasesCard(),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Sales Overview Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sales Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Period selector tabs
                  Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _buildPeriodTab('Day', 0),
                        _buildPeriodTab('Week', 1),
                        _buildPeriodTab('Month', 2),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Chart with proper X and Y axis
                  SizedBox(
                    height: 220,
                    child: Column(
                      children: [
                        // Y-axis labels
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 30,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${(maxValue / 1000).toInt()}k',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    Text(
                                      '${(maxValue * 0.75 / 1000).toInt()}k',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    Text(
                                      '${(maxValue * 0.5 / 1000).toInt()}k',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    Text(
                                      '${(maxValue * 0.25 / 1000).toInt()}k',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    const Text(
                                      '0k',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              
                              // Chart bars and X-axis
                              Expanded(
                                child: Column(
                                  children: [
                                    // Chart bars area
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: currentChartData.map((data) {
                                            final height = (data['value'] as int) / maxValue;
                                            return Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    // Bar
                                                    Container(
                                                      height: height * 140, // Max bar height 140px
                                                      decoration: BoxDecoration(
                                                        color: data['color'] as Color,
                                                        borderRadius: const BorderRadius.only(
                                                          topLeft: Radius.circular(4),
                                                          topRight: Radius.circular(4),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    // X-axis label
                                                    Text(
                                                      data['label'] as String,
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Color(0xFF6B7280),
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    
                                    // X-axis line
                                    Container(
                                      height: 1,
                                      color: const Color(0xFFE5E7EB),
                                    ),
                                    
                                    // X-axis period labels
                                    Container(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _selectedPeriod == 'Day' ? 'Mon' : 
                                            _selectedPeriod == 'Week' ? 'Week 1' : 'Jan',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                          Text(
                                            _selectedPeriod,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                          Text(
                                            _selectedPeriod == 'Day' ? 'Sun' : 
                                            _selectedPeriod == 'Week' ? 'Week 4' : 'Jun',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Low Stock Section
            _buildLowStockSection(),

            const SizedBox(height: 80), // Space for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF4F46E5), // Indigo color
        unselectedItemColor: const Color(0xFF9CA3AF), // Gray color
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _handleNavigation(index);
          });
        },
      ),
    );
  }

  Widget _buildPeriodTab(String title, int index) {
    bool isSelected = _selectedPeriod == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = title;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected ? [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF6B7280),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalSalesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Sales',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'TK 123,123',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: Color(0xFF10B981),
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '+12%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'vs yesterday',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOutstandingDueCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Outstanding Due',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'TK 3,423.333',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '34 Customers',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockAlertCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7), // Amber background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Low Stock Alerts',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF92400E), // Dark amber text
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '112',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF92400E),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              _showComingSoon('Review Products');
            },
            child: Row(
              children: [
                Text(
                  'Review products',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF92400E).withOpacity(0.8),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  color: const Color(0xFF92400E).withOpacity(0.8),
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE), // Light blue background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Purchases',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF075985), // Dark blue text
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'TK 4,202',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF075985),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Today',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF075985),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Low Stock',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    '17',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Products are running low on stock and need attention',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {
                  _showComingSoon('View All Low Stock');
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0: // Dashboard
        // Already on dashboard
        break;
      case 1: // Inventory
        _showComingSoon('Inventory');
        break;
      case 2: // Sales
        _showComingSoon('Sales');
        break;
      case 3: // History
        _showComingSoon('History');
        break;
      case 4: // More
        _openRightDrawer();
        // Reset bottom nav index to stay on dashboard
        Future.delayed(Duration.zero, () {
          if (mounted) {
            setState(() {
              _selectedIndex = 0;
            });
          }
        });
        break;
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: const Color(0xFF4F46E5),
      ),
    );
  }
}