class Message {
  final int id;
  final String content;
  final String channel;
  final String recipientGroup;
  final String status;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    required this.channel,
    required this.recipientGroup,
    required this.status,
    required this.timestamp,
  });
}
