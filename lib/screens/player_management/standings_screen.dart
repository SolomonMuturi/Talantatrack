import 'package:flutter/material.dart';

class StandingsScreen extends StatelessWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Standings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('League tables and individual player rankings.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _buildTeamStandings(context),
            const SizedBox(height: 32),
            _buildPlayerRankings(context),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamStandings(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Team Standings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('Pos')),
              DataColumn(label: Text('Team')),
              DataColumn(label: Text('P')),
              DataColumn(label: Text('W')),
              DataColumn(label: Text('Pts')),
            ],
            rows: const [
              DataRow(cells: [DataCell(Text('1')), DataCell(Text('U-17 Elite')), DataCell(Text('12')), DataCell(Text('10')), DataCell(Text('30'))]),
              DataRow(cells: [DataCell(Text('2')), DataCell(Text('Junior Stars')), DataCell(Text('12')), DataCell(Text('8')), DataCell(Text('26'))]),
              DataRow(cells: [DataCell(Text('3')), DataCell(Text('City Academy')), DataCell(Text('11')), DataCell(Text('7')), DataCell(Text('22'))]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerRankings(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Top Performers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const CircleAvatar(child: Text('1')),
            title: const Text('Alex Johnson'),
            subtitle: const Text('Midfielder • 12 Goals'),
            trailing: Text('9.2 Rating', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          ListTile(
            leading: const CircleAvatar(child: Text('2')),
            title: const Text('Sarah Williams'),
            subtitle: const Text('Forward • 10 Goals'),
            trailing: Text('8.8 Rating', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
