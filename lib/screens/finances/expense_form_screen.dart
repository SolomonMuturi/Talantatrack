import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _expenseType;
  final _amountController = TextEditingController();
  final _payeeController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _date = DateTime.now();
  bool _isSubmitting = false;

  final List<String> _types = ['Field Fees', 'Consumables', 'Fuel', 'Coach Payroll', 'Equipment', 'Other'];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Expense Logged successfully'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log an Expense')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Expense Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                value: _expenseType,
                decoration: const InputDecoration(labelText: 'Expense Type', border: OutlineInputBorder()),
                items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (val) => setState(() => _expenseType = val),
                validator: (val) => val == null ? 'Please select type' : null,
              ),
              const SizedBox(height: 20),

              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date of Expense', border: OutlineInputBorder()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('MMM dd, yyyy').format(_date)),
                      const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount (KES)', border: OutlineInputBorder()),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter amount' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _payeeController,
                decoration: const InputDecoration(labelText: 'Payee', border: OutlineInputBorder(), hintText: 'e.g. Nairobi City Council'),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter payee' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description (Optional)', border: OutlineInputBorder()),
              ),
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Log Expense'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
