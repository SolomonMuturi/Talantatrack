import 'package:flutter/material.dart';

class PlatformManagementScreen extends StatefulWidget {
  const PlatformManagementScreen({super.key});

  @override
  State<PlatformManagementScreen> createState() => _PlatformManagementScreenState();
}

class _PlatformManagementScreenState extends State<PlatformManagementScreen> {
  final List<Map<String, dynamic>> _clubs = [
    {'id': 'c1', 'name': 'Kisumu All-Stars', 'plan': 'Pro', 'mrr': 15000, 'players': 142, 'status': 'Active'},
    {'id': 'c2', 'name': 'Coast Stima Academy', 'plan': 'Growth', 'mrr': 5000, 'players': 85, 'status': 'Trialing'},
    {'id': 'c3', 'name': 'Nairobi City Stars', 'plan': 'Enterprise', 'mrr': 50000, 'players': 320, 'status': 'Active'},
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
                    Text('Platform Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Superadmin overview of all onboarded clubs.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_business_outlined),
                  label: const Text('Onboard New Club'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildClubsTable(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildClubsTable() {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          columns: const [
            DataColumn(label: Text('Club Name')),
            DataColumn(label: Text('Plan')),
            DataColumn(label: Text('MRR (KES)')),
            DataColumn(label: Text('Players')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _clubs.map((c) => DataRow(cells: [
            DataCell(Text(c['name'], style: const TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Chip(label: Text(c['plan'], style: const TextStyle(fontSize: 10)))),
            DataCell(Text(c['mrr'].toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},"))),
            DataCell(Text(c['players'].toString())),
            DataCell(_buildStatusBadge(c['status'])),
            DataCell(
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (val) {},
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'manage', child: Text('Manage Subscription')),
                  const PopupMenuItem(value: 'invoice', child: Text('View Invoices')),
                  const PopupMenuItem(value: 'impersonate', child: Text('Impersonate Admin')),
                ],
              ),
            ),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = status == 'Active' ? Colors.greenAccent : Colors.orangeAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
