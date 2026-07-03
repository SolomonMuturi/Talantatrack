import 'package:flutter/material.dart';

class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  final List<Map<String, dynamic>> _teamMembers = [
    {'id': 1, 'name': 'Mike Okoth', 'role': 'Head Coach', 'dept': 'Coaching', 'rate': 1200, 'hours': 160, 'status': 'Active'},
    {'id': 2, 'name': 'Sarah Wanjiku', 'role': 'Administrator', 'dept': 'Admin', 'rate': 800, 'hours': 140, 'status': 'Active'},
    {'id': 3, 'name': 'John Kamau', 'role': 'Trainer', 'dept': 'Medical', 'rate': 1000, 'hours': 120, 'status': 'On Leave'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Team Members', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Manage roles and payroll for academy staff.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Employee'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTeamTable(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamTable() {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          columns: const [
            DataColumn(label: Text('Staff Member')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Hours')),
            DataColumn(label: Text('Wage (KES)')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _teamMembers.map((m) {
            final wage = m['hours'] * m['rate'];
            return DataRow(cells: [
              DataCell(
                Row(
                  children: [
                    CircleAvatar(radius: 16, backgroundColor: Colors.grey.shade900, child: Text(m['name'][0])),
                    const SizedBox(width: 12),
                    Text(m['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              DataCell(Text(m['role'])),
              DataCell(_buildStatusBadge(m['status'])),
              DataCell(Text('${m['hours']}h')),
              DataCell(Text(wage.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},"), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent))),
              DataCell(IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status == 'Active' ? Colors.greenAccent.withOpacity(0.1) : Colors.orangeAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: status == 'Active' ? Colors.greenAccent : Colors.orangeAccent, width: 0.5),
      ),
      child: Text(status, style: TextStyle(color: status == 'Active' ? Colors.greenAccent : Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
