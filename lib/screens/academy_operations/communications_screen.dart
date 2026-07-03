import 'package:flutter/material.dart';

class CommunicationsScreen extends StatelessWidget {
  const CommunicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Communications Hub', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Manage mass alerts and group notifications.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _buildBroadcastCard(context),
            const SizedBox(height: 24),
            const Text('Recent Broadcasts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildHistoryList(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildBroadcastCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New Broadcast', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Target Group',
                border: OutlineInputBorder(),
                hintText: 'e.g. All Parents, U-15 Team',
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
                hintText: 'Type your announcement here...',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.sms_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                const Text('Send as SMS', style: TextStyle(fontSize: 12)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Send Broadcast'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return const Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.campaign_outlined)),
            title: Text('Tournament Reminder', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Sent to All Players • 2 days ago'),
            trailing: Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
          ),
        );
      },
    );
  }
}
