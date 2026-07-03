import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.support_agent, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 24),
              const Text('Support & Help Center', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                'Need help? Our team is available to assist you with any questions or platform issues.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              _buildSupportOption(Icons.email_outlined, 'Email Support', 'support@talenttrack.com'),
              const SizedBox(height: 16),
              _buildSupportOption(Icons.help_outline, 'Knowledge Base', 'View common questions & guides'),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Contact Support'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 54)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportOption(IconData icon, String title, String value) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {},
      ),
    );
  }
}
