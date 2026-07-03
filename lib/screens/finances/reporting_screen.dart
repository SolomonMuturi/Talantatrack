import 'package:flutter/material.dart';

class ReportingScreen extends StatelessWidget {
  const ReportingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reporting & AI Analysis', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Financial audits and fraud detection powered by AI.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _buildFraudDetectionCard(context),
            const SizedBox(height: 24),
            const Text('Available Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildReportsGrid(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildFraudDetectionCard(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.blue.withOpacity(0.1), Colors.purple.withOpacity(0.1)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology_outlined, color: Colors.blueAccent),
                const SizedBox(width: 8),
                const Text('AI Fraud Guard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Text('SCANNING', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('System is currently monitoring all MPESA and bank transactions for anomalies.', style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: () {}, child: const Text('View Anomaly Log')),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsGrid() {
    final reports = [
      {'title': 'Monthly P&L', 'icon': Icons.description_outlined},
      {'title': 'Player ROI', 'icon': Icons.insights_outlined},
      {'title': 'Inventory Audit', 'icon': Icons.inventory_outlined},
      {'title': 'Tax Compliance', 'icon': Icons.gavel_outlined},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(reports[index]['icon'] as IconData, size: 20, color: Colors.grey),
                  const SizedBox(width: 12),
                  Text(reports[index]['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
