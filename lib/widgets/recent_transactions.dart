import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Transaction {
  final String id;
  final String playerName;
  final String status;
  final String type;
  final String paymentMethod;
  final DateTime date;
  final double amount;

  Transaction({
    required this.id,
    required this.playerName,
    required this.status,
    required this.type,
    required this.paymentMethod,
    required this.date,
    required this.amount,
  });
}

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  List<Transaction> transactions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        transactions = [
          Transaction(
            id: '1',
            playerName: 'Alex Johnson',
            status: 'Completed',
            type: 'Payment',
            paymentMethod: 'MPESA',
            date: DateTime.now().subtract(const Duration(days: 1)),
            amount: 5000,
          ),
          Transaction(
            id: '2',
            playerName: 'Sarah Williams',
            status: 'Pending',
            type: 'Payment',
            paymentMethod: 'Bank Transfer',
            date: DateTime.now().subtract(const Duration(days: 2)),
            amount: 7500,
          ),
          Transaction(
            id: '3',
            playerName: 'Equipment Store',
            status: 'Success',
            type: 'Expense',
            paymentMethod: 'Credit Card',
            date: DateTime.now().subtract(const Duration(days: 3)),
            amount: -12000,
          ),
          Transaction(
            id: '4',
            playerName: 'Michael Chen',
            status: 'Completed',
            type: 'Payment',
            paymentMethod: 'Cash',
            date: DateTime.now().subtract(const Duration(days: 5)),
            amount: 3000,
          ),
        ];
        loading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        return Colors.greenAccent;
      case 'pending':
      case 'processing':
        return Colors.orangeAccent;
      case 'failed':
      case 'error':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        loading
                            ? 'Loading...'
                            : 'Showing ${transactions.length} recent',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(color: theme.colorScheme.outline),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('All', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 2),
                      Icon(Icons.arrow_outward, size: 12, color: theme.colorScheme.primary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (loading)
              const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator()))
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (context, index) => Divider(height: 16, color: theme.colorScheme.outlineVariant),
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  final isIncome = tx.amount > 0;
                  
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        child: Text(
                          tx.playerName[0].toUpperCase(),
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    tx.playerName,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(tx.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    tx.status,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(tx.status),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Icon(
                                    isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                                    size: 10,
                                    color: isIncome ? Colors.greenAccent : Colors.redAccent,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    tx.type,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(' • ', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 10)),
                                  Text(
                                    tx.paymentMethod,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(' • ', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 10)),
                                  Text(
                                    DateFormat('MMM d').format(tx.date),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${isIncome ? '+' : ''}${tx.amount.abs().toInt().toString()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isIncome ? Colors.greenAccent : Colors.redAccent,
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
