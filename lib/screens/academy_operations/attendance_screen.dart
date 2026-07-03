import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<Map<String, dynamic>> _attendanceData = [
    {'name': 'Alex Johnson', 'status': 'Present', 'time': '08:15 AM'},
    {'name': 'Sarah Williams', 'status': 'Late', 'time': '08:45 AM'},
    {'name': 'Michael Chen', 'status': 'Present', 'time': '08:10 AM'},
    {'name': 'John Doe', 'status': 'Absent', 'time': '-'},
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
                    Text('Attendance Tracking', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Daily roll call for academy scholars.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Mark Roll Call')),
              ],
            ),
            const SizedBox(height: 24),
            _buildSummaryCards(),
            const SizedBox(height: 24),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _attendanceData.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final person = _attendanceData[index];
                  return ListTile(
                    title: Text(person['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Arrival: ${person['time']}'),
                    trailing: _buildStatusBadge(person['status']),
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        _summaryItem('Present', '42', Colors.greenAccent),
        const SizedBox(width: 12),
        _summaryItem('Late', '5', Colors.orangeAccent),
        const SizedBox(width: 12),
        _summaryItem('Absent', '3', Colors.redAccent),
      ],
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Present': color = Colors.greenAccent; break;
      case 'Late': color = Colors.orangeAccent; break;
      case 'Absent': color = Colors.redAccent; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
