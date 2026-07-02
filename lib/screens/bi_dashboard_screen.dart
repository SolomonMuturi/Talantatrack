import 'package:flutter/material.dart';
import '../widgets/kpi_card.dart';
import '../widgets/player_distribution_chart.dart';
import '../widgets/revenue_vs_expense_chart.dart';

class BiDashboardScreen extends StatefulWidget {
  const BiDashboardScreen({super.key});

  @override
  State<BiDashboardScreen> createState() => _BiDashboardScreenState();
}

class _BiDashboardScreenState extends State<BiDashboardScreen> {
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
            'totalPlayers': 142,
            'netProfit': 116000,
            'avgAttendance': 92.5,
            'injuryDaysLost': 45,
            'disciplineInfractions': 12,
            'avgSkillScore': 84.2,
            'avgPlayerRank': 15.4,
          };
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load BI data';
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
    
    final netProfit = _stats!['netProfit'] as int;
    final totalPlayers = _stats!['totalPlayers'] as int;
    final profitPerPlayer = totalPlayers > 0 ? netProfit / totalPlayers : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Intelligence Dashboard',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Deep dive into your academy\'s performance and financial metrics.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Top KPI Grid
          _buildKpiGrid(screenWidth, [
            KpiCard(
              title: 'Net Profit',
              value: 'KES ${netProfit.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
              icon: Icons.attach_money,
              description: 'YTD Profit',
            ),
            KpiCard(
              title: 'Profit Per Player',
              value: 'KES ${profitPerPlayer.toInt().toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
              icon: Icons.people,
              description: 'YTD Average',
            ),
            KpiCard(
              title: 'Attendance Rate',
              value: '${(_stats!['avgAttendance'] as double).toStringAsFixed(1)}%',
              icon: Icons.how_to_reg,
              description: 'Across all players',
            ),
            KpiCard(
              title: 'Injury Days Lost',
              value: _stats!['injuryDaysLost'].toString(),
              icon: Icons.medical_services,
              description: 'Total estimated days',
            ),
          ]),

          const SizedBox(height: 24),

          // Charts Row
          if (isLargeScreen)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 3, child: RevenueVsExpenseChart()),
                const SizedBox(width: 24),
                const Expanded(flex: 2, child: PlayerDistributionChart()),
              ],
            )
          else
            Column(
              children: [
                const RevenueVsExpenseChart(),
                const SizedBox(height: 24),
                const PlayerDistributionChart(),
              ],
            ),

          const SizedBox(height: 24),

          // Bottom KPI Grid
          _buildKpiGrid(screenWidth, [
            KpiCard(
              title: 'Discipline Infractions',
              value: _stats!['disciplineInfractions'].toString(),
              icon: Icons.warning_amber_rounded,
              description: 'Total logged infractions',
            ),
            KpiCard(
              title: 'Average Skill Score',
              value: (_stats!['avgSkillScore'] as double).toStringAsFixed(1),
              icon: Icons.psychology,
              description: 'Across all skills',
            ),
            KpiCard(
              title: 'Average Player Rank',
              value: '#${(_stats!['avgPlayerRank'] as double).toStringAsFixed(1)}',
              icon: Icons.trending_up,
              description: 'Across all players',
            ),
            const SizedBox.shrink(), // Empty slot to maintain grid alignment
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
