import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyFinancials {
  final String month;
  final double revenue;
  final double expenses;

  MonthlyFinancials(this.month, this.revenue, this.expenses);
}

class RevenueVsExpenseChart extends StatefulWidget {
  const RevenueVsExpenseChart({super.key});

  @override
  State<RevenueVsExpenseChart> createState() => _RevenueVsExpenseChartState();
}

class _RevenueVsExpenseChartState extends State<RevenueVsExpenseChart> {
  List<MonthlyFinancials> chartData = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          chartData = [
            MonthlyFinancials('Jan', 45000, 32000),
            MonthlyFinancials('Feb', 52000, 35000),
            MonthlyFinancials('Mar', 48000, 38000),
            MonthlyFinancials('Apr', 61000, 42000),
            MonthlyFinancials('May', 55000, 40000),
            MonthlyFinancials('Jun', 67000, 45000),
          ];
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (loading) {
      return Card(
        child: const SizedBox(height: 350, child: Center(child: CircularProgressIndicator())),
      );
    }

    if (error != null) {
      return Card(
        child: SizedBox(
          height: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading data', style: TextStyle(color: theme.colorScheme.error)),
              TextButton(onPressed: _fetchChartData, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue vs. Expenses',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Monthly breakdown',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(color: theme.colorScheme.outline),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('View breakdown'),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_outward, size: 14, color: theme.colorScheme.primary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 280,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 80000,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: theme.colorScheme.surfaceVariant,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rodIndex == 0 ? 'Revenue' : 'Expenses'}\nKES ${rod.toY.toInt()}',
                          TextStyle(color: theme.colorScheme.onSurfaceVariant),
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
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                chartData[value.toInt()].month,
                                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
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
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'KES ${(value / 1000).toInt()}k',
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
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
                      strokeWidth: 1,
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
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: data.expenses,
                          color: Colors.orangeAccent,
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Revenue', theme.colorScheme.primary, theme),
                const SizedBox(width: 24),
                _buildLegendItem('Expenses', Colors.orangeAccent, theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
