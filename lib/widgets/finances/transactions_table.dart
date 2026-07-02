import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaction.dart';

class TransactionsTable extends StatelessWidget {
  final List<Transaction> data;

  const TransactionsTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter by player/payee...',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 24,
              columns: const [
                DataColumn(label: Text('Player/Payee')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Amount (KES)')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Method')),
              ],
              rows: data.map((tx) {
                final isExpense = tx.type.toUpperCase() == 'EXPENSE';
                return DataRow(cells: [
                  DataCell(Text(tx.playerName, style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(DateFormat('MMM dd, yyyy').format(tx.date))),
                  DataCell(Text(
                    '${isExpense ? '-' : '+'}KES ${tx.amount.abs().toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
                    style: TextStyle(
                      color: isExpense ? Colors.redAccent : Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  DataCell(_buildTypeBadge(tx.type)),
                  DataCell(_buildStatusBadge(tx.status)),
                  DataCell(Text(tx.paymentMethod)),
                ]);
              }).toList(),
            ),
          ),
          if (data.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No transactions found.', style: TextStyle(color: Colors.grey)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    final isExpense = type.toUpperCase() == 'EXPENSE';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isExpense ? Colors.redAccent.withOpacity(0.1) : Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isExpense ? Colors.redAccent : Colors.blueAccent, width: 0.5),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: isExpense ? Colors.redAccent : Colors.blueAccent,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
      case 'paid':
        color = Colors.greenAccent;
        break;
      case 'pending':
      case 'in progress':
        color = Colors.orangeAccent;
        break;
      case 'failed':
        color = Colors.redAccent;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
