import 'package:flutter/material.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/finances/transactions_table.dart';
import '../../models/transaction.dart';
import 'payment_form_screen.dart';
import 'expense_form_screen.dart';

class FinancesScreen extends StatefulWidget {
  const FinancesScreen({super.key});

  @override
  State<FinancesScreen> createState() => _FinancesScreenState();
}

class _FinancesScreenState extends State<FinancesScreen> {
  bool _loading = true;
  List<Transaction> _transactions = [];
  Map<String, double> _totals = {'revenue': 328000, 'expenses': 212000, 'profit': 116000};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _transactions = [
          Transaction(id: '1', playerName: 'Alex Johnson', date: DateTime.now().subtract(const Duration(days: 1)), amount: 5000, type: 'PAYMENT', description: 'Monthly fee', status: 'Completed', paymentMethod: 'MPESA'),
          Transaction(id: '2', playerName: 'Sarah Williams', date: DateTime.now().subtract(const Duration(days: 2)), amount: 7500, type: 'PAYMENT', description: 'Registration', status: 'Pending', paymentMethod: 'Cash'),
          Transaction(id: '3', playerName: 'Nairobi City Council', date: DateTime.now().subtract(const Duration(days: 3)), amount: -15000, type: 'EXPENSE', description: 'Field rental', status: 'Paid', paymentMethod: 'Bank Transfer'),
          Transaction(id: '4', playerName: 'Sports World', date: DateTime.now().subtract(const Duration(days: 5)), amount: -4200, type: 'EXPENSE', description: 'Training cones', status: 'Paid', paymentMethod: 'Credit Card'),
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
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildKPIs(),
            const SizedBox(height: 24),
            TransactionsTable(data: _transactions),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Financial Automation', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text('View and manage all academy financial transactions.', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentFormScreen())),
              icon: const Icon(Icons.add),
              label: const Text('Make Payment'),
            ),
            OutlinedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpenseFormScreen())),
              icon: const Icon(Icons.description_outlined),
              label: const Text('Log Expense'),
            ),
            PopupMenuButton<String>(
              child: OutlinedButton.icon(
                onPressed: null, // PopupMenuButton handles tap
                icon: const Icon(Icons.download),
                label: const Text('Export Report'),
              ),
              onSelected: (val) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exporting as $val...'))),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'CSV', child: Text('Export as CSV')),
                const PopupMenuItem(value: 'Excel', child: Text('Export as Excel')),
                const PopupMenuItem(value: 'PDF', child: Text('Export as PDF')),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPIs() {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        KpiCard(title: 'Total Revenue', value: 'KES ${_formatNum(_totals['revenue']!)}', icon: Icons.trending_up, description: 'All incoming funds'),
        KpiCard(title: 'Total Expenses', value: 'KES ${_formatNum(_totals['expenses']!)}', icon: Icons.trending_down, description: 'All outgoing funds'),
        KpiCard(title: 'Net Profit', value: 'KES ${_formatNum(_totals['profit']!)}', icon: Icons.account_balance_wallet, description: 'Revenue minus expenses'),
      ],
    );
  }

  String _formatNum(double num) => num.toInt().toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},");
}
