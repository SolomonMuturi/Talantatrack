class Transaction {
  final String id;
  final String playerName;
  final DateTime date;
  final double amount;
  final String type; // PAYMENT or EXPENSE
  final String description;
  final String status;
  final String paymentMethod;

  Transaction({
    required this.id,
    required this.playerName,
    required this.date,
    required this.amount,
    required this.type,
    required this.description,
    required this.status,
    required this.paymentMethod,
  });
}
