import 'package:flutter/material.dart';

class PaymentFormScreen extends StatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPlayer;
  final _amountController = TextEditingController(text: '5000');
  final _phoneController = TextEditingController(text: '254');
  final _descriptionController = TextEditingController();
  String _paymentMethod = 'cash';
  bool _isSubmitting = false;

  final List<Map<String, String>> _players = [
    {'id': '1', 'name': 'Alex Johnson'},
    {'id': '2', 'name': 'Sarah Williams'},
    {'id': '3', 'name': 'Michael Chen'},
  ];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_paymentMethod == 'mpesa' 
            ? '📱 M-Pesa Prompt Sent!' 
            : '✅ Cash Payment Recorded!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Make a Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Payment Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Select payment method and enter information below.', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 24),
              
              // Payment Method
              const Text('Payment Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Cash', style: TextStyle(fontSize: 14)),
                      value: 'cash',
                      groupValue: _paymentMethod,
                      onChanged: (val) => setState(() => _paymentMethod = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('M-Pesa', style: TextStyle(fontSize: 14)),
                      value: 'mpesa',
                      groupValue: _paymentMethod,
                      onChanged: (val) => setState(() => _paymentMethod = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Player Selection
              DropdownButtonFormField<String>(
                value: _selectedPlayer,
                decoration: const InputDecoration(labelText: 'Player', border: OutlineInputBorder()),
                items: _players.map((p) => DropdownMenuItem(value: p['id'], child: Text(p['name']!))).toList(),
                onChanged: (val) => setState(() => _selectedPlayer = val),
                validator: (val) => val == null ? 'Please select a player' : null,
              ),
              const SizedBox(height: 20),

              // Amount
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount (KES)', border: OutlineInputBorder()),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter amount' : null,
              ),
              const SizedBox(height: 20),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description (Optional)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),

              // Phone Number (M-Pesa only)
              if (_paymentMethod == 'mpesa')
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'M-Pesa Phone Number', border: OutlineInputBorder(), hintText: '254XXXXXXXXX'),
                  validator: (val) {
                    if (_paymentMethod == 'mpesa') {
                      if (val == null || !RegExp(r'^254\d{9}$').hasMatch(val)) return 'Enter valid number (254XXXXXXXXX)';
                    }
                    return null;
                  },
                ),
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : Text(_paymentMethod == 'mpesa' ? 'Send M-Pesa Prompt' : 'Record Cash Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
