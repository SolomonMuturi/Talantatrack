import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/message.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool _loading = true;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _messages = [
          Message(
            id: 1,
            content: 'The U-17 regional finals have been rescheduled to next Saturday at 14:00.',
            channel: 'System Notification',
            recipientGroup: 'U-17 Team',
            status: 'Delivered',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          Message(
            id: 2,
            content: 'Monthly academy fees for July are now due. Please process your payments.',
            channel: 'Finance Alert',
            recipientGroup: 'All Parents',
            status: 'Read',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
          ),
          Message(
            id: 3,
            content: 'New training equipment has arrived and is ready for pickup in Storage A.',
            channel: 'Inventory Update',
            recipientGroup: 'Coaches',
            status: 'Delivered',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: SingleChildScrollView(
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
                    const Text('Messages', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('${_messages.length} messages in your inbox', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Clear All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    foregroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_messages.isEmpty)
              _buildEmptyState()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _messages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageCard(msg);
                },
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(Message msg) {
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
                    Text(msg.channel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${msg.recipientGroup} • ${msg.status}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                Text(
                  DateFormat('MMM dd, HH:mm').format(msg.timestamp),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              msg.content,
              style: const TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(Icons.message_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No messages yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
