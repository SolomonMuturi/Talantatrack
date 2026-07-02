import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TeamData {
  final String name;
  final double value;
  final Color color;

  TeamData(this.name, this.value, this.color);
}

class PlayerDistributionChart extends StatefulWidget {
  const PlayerDistributionChart({super.key});

  @override
  State<PlayerDistributionChart> createState() => _PlayerDistributionChartState();
}

class _PlayerDistributionChartState extends State<PlayerDistributionChart> {
  List<TeamData> data = [];
  bool loading = true;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        final colors = [
          Colors.blueAccent,
          Colors.redAccent,
          Colors.greenAccent,
          Colors.orangeAccent,
          Colors.purpleAccent,
          Colors.tealAccent,
        ];
        
        data = [
          TeamData('U-15 Team', 25, colors[0]),
          TeamData('U-18 Team', 18, colors[1]),
          TeamData('Senior Team', 22, colors[2]),
          TeamData('Girls Team', 15, colors[3]),
          TeamData('Unassigned', 10, colors[4]),
        ];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      'Player Distribution',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Number of players per team',
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
            const SizedBox(height: 24),
            if (loading)
              const SizedBox(height: 280, child: Center(child: CircularProgressIndicator()))
            else
              Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: data.asMap().entries.map((entry) {
                          final index = entry.key;
                          final team = entry.value;
                          final isTouched = index == touchedIndex;
                          final fontSize = isTouched ? 16.0 : 12.0;
                          final radius = isTouched ? 110.0 : 100.0;

                          return PieChartSectionData(
                            color: team.color,
                            value: team.value,
                            title: '${(team.value / data.fold(0.0, (sum, item) => sum + item.value) * 100).toInt()}%',
                            radius: radius,
                            titleStyle: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: data.map((team) => _buildLegendItem(team, theme)).toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(TeamData team, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: team.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          '${team.name}: ${team.value.toInt()}',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
