import 'package:flutter/material.dart';
import '../widgets/kpi_card.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/revenue_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() {
          _stats = {
            'totalRevenue': 328000,
            'totalExpenses': 212000,
            'netProfit': 116000,
            'totalPlayers': 142,
            'totalEquipment': 450,
            'lowStockItems': 12,
            'upcomingEvents': 8,
          };
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load dashboard data';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetchStats, child: const Text('Retry')),
          ],
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 1024;
    final avgRevenuePerPlayer = _stats!['totalPlayers'] > 0 
        ? _stats!['totalRevenue'] / _stats!['totalPlayers'] 
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKpiGrid(screenWidth, [
            KpiCard(
              title: 'Total Revenue',
              value: 'KES ${(_stats!['totalRevenue'] as int).toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
              change: '+11.5%',
              icon: Icons.account_balance_wallet,
              description: 'from last month',
            ),
            KpiCard(
              title: 'Total Expenses',
              value: 'KES ${(_stats!['totalExpenses'] as int).toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
              change: '+5.2%',
              icon: Icons.trending_down,
              description: 'from last month',
            ),
            KpiCard(
              title: 'Net Profit',
              value: 'KES ${(_stats!['netProfit'] as int).toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
              change: '+18.3%',
              icon: Icons.attach_money,
              description: 'revenue minus expenses',
            ),
            KpiCard(
              title: 'Players Enrolled',
              value: _stats!['totalPlayers'].toString(),
              change: '+2',
              icon: Icons.people,
              description: 'since last week',
            ),
          ]),
          
          const SizedBox(height: 24),
          
          if (isLargeScreen)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 3, child: RevenueChart()),
                const SizedBox(width: 24),
                const Expanded(flex: 2, child: RecentTransactions()),
              ],
            )
          else
            Column(
              children: [
                const RevenueChart(),
                const SizedBox(height: 24),
                const RecentTransactions(),
              ],
            ),
          
          const SizedBox(height: 24),
          
          _buildKpiGrid(screenWidth, [
            KpiCard(
              title: 'Total Equipment',
              value: _stats!['totalEquipment'].toString(),
              change: '${_stats!['lowStockItems']} low',
              icon: Icons.inventory_2,
              description: 'items in inventory',
            ),
            KpiCard(
              title: 'Low Stock Items',
              value: _stats!['lowStockItems'].toString(),
              change: 'Action needed',
              icon: Icons.warning_amber_rounded,
              description: 'below threshold',
            ),
            KpiCard(
              title: 'Revenue Per Player',
              value: 'KES ${avgRevenuePerPlayer.toInt().toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
              change: '+3%',
              icon: Icons.monetization_on,
              description: 'average per player',
            ),
            KpiCard(
              title: 'Upcoming Events',
              value: _stats!['upcomingEvents'].toString(),
              change: '+3',
              icon: Icons.calendar_month,
              description: 'scheduled',
            ),
          ]),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildKpiGrid(double screenWidth, List<Widget> children) {
    int crossAxisCount = 2;
    if (screenWidth > 1200) {
      crossAxisCount = 4;
    } else if (screenWidth > 800) {
      crossAxisCount = 3;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: children,
    );
  }
}
