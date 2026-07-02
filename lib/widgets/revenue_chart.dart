import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RevenueData {
  final String month;
  final double revenue;
  final double expenses;

  RevenueData(this.month, this.revenue, this.expenses);
}

class RevenueChart extends StatefulWidget {
  const RevenueChart({super.key});

  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart> {
  List<RevenueData> chartData = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        chartData = [
          RevenueData('Jan', 45000, 32000),
          RevenueData('Feb', 52000, 35000),
          RevenueData('Mar', 48000, 38000),
          RevenueData('Apr', 61000, 42000),
          RevenueData('May', 55000, 40000),
          RevenueData('Jun', 67000, 45000),
        ];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (loading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    final totalRevenue = chartData.fold(0.0, (sum, item) => sum + item.revenue);
    final totalExpenses = chartData.fold(0.0, (sum, item) => sum + item.expenses);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Revenue Overview',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Monthly breakdown',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildLegendItem('Rev', theme.colorScheme.primary, totalRevenue, theme),
                    const SizedBox(height: 2),
                    _buildLegendItem('Exp', Colors.pinkAccent, totalExpenses, theme),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 80000,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: theme.colorScheme.surfaceVariant,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rodIndex == 0 ? 'Rev' : 'Exp'}\n${(rod.toY / 1000).toInt()}k',
                          TextStyle(color: theme.colorScheme.onSurface, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < chartData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                chartData[value.toInt()].month,
                                style: theme.textTheme.bodySmall?.copyWith(fontSize: 9),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value / 1000).toInt()}k',
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 9),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.colorScheme.outlineVariant,
                      strokeWidth: 0.5,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: chartData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data.revenue,
                          color: theme.colorScheme.primary,
                          width: 6,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        BarChartRodData(
                          toY: data.expenses,
                          color: Colors.pinkAccent,
                          width: 6,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, double amount, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: ${(amount / 1000).toInt()}k',
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 9),
        ),
      ],
    );
  }
}
