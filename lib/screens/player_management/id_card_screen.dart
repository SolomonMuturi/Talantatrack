import 'package:flutter/material.dart';

class IdCardScreen extends StatefulWidget {
  const IdCardScreen({super.key});

  @override
  State<IdCardScreen> createState() => _IdCardScreenState();
}

class _IdCardScreenState extends State<IdCardScreen> {
  String _academyName = 'TalentTrack Academy';
  String _address = '123 Football Lane, Nairobi, Kenya';
  String _phone = '+254 700 000 000';
  String _email = 'info@talenttrack.co.ke';
  
  final List<Map<String, String>> _players = [
    {'id': '0001', 'name': 'Alex Johnson', 'role': 'Midfielder', 'team': 'U-17'},
    {'id': '0002', 'name': 'Sarah Williams', 'role': 'Forward', 'team': 'Girls Team'},
    {'id': '0003', 'name': 'Michael Chen', 'role': 'Goalkeeper', 'team': 'U-19'},
  ];

  late Map<String, String> _selectedPerson;

  @override
  void initState() {
    super.initState();
    _selectedPerson = _players[0];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Digital ID Card Generator', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Select a person to generate their digital ID card.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            
            if (isLargeScreen)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildPreviewSection(theme)),
                  const SizedBox(width: 24),
                  Expanded(flex: 1, child: _buildCustomizationSection(theme)),
                ],
              )
            else
              Column(
                children: [
                  _buildPreviewSection(theme),
                  const SizedBox(height: 24),
                  _buildCustomizationSection(theme),
                ],
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildDropdown(),
            const SizedBox(height: 32),
            _buildIdCard(theme),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.print),
              label: const Text('Print / Download ID'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 48)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<Map<String, String>>(
      value: _selectedPerson,
      decoration: const InputDecoration(labelText: 'Player or Staff Member', border: OutlineInputBorder()),
      items: _players.map((p) => DropdownMenuItem(value: p, child: Text('${p['name']} (${p['role']})'))).toList(),
      onChanged: (val) => setState(() => _selectedPerson = val!),
    );
  }

  Widget _buildIdCard(ThemeData theme) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.5), width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_academyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(_address, style: const TextStyle(fontSize: 8, color: Colors.grey)),
                  Text(_phone, style: const TextStyle(fontSize: 8, color: Colors.grey)),
                ],
              ),
              Icon(Icons.track_changes, color: theme.colorScheme.primary, size: 32),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(radius: 40, backgroundColor: theme.colorScheme.surfaceVariant),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_selectedPerson['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(_selectedPerson['role']!, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text('UPID: TT-${_selectedPerson['id']}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfo('Team', _selectedPerson['team']!),
              _buildInfo('Issued', 'Jan 2024'),
              _buildInfo('Expires', 'Jan 2025'),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.qr_code, size: 80, color: Colors.black),
          ),
          const SizedBox(height: 8),
          const Text('Scan for verification', style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCustomizationSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Branding', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildField('Academy Name', _academyName, (v) => setState(() => _academyName = v)),
            const SizedBox(height: 16),
            _buildField('Address', _address, (v) => setState(() => _address = v)),
            const SizedBox(height: 16),
            _buildField('Phone', _phone, (v) => setState(() => _phone = v)),
            const SizedBox(height: 16),
            _buildField('Email', _email, (v) => setState(() => _email = v)),
            const SizedBox(height: 24),
            const Text('Logo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Academy Logo'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value, Function(String) onChanged) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      onChanged: onChanged,
    );
  }
}
