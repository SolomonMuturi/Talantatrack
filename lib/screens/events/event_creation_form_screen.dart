import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCreationFormScreen extends StatefulWidget {
  const EventCreationFormScreen({super.key});

  @override
  State<EventCreationFormScreen> createState() => _EventCreationFormScreenState();
}

class _EventCreationFormScreenState extends State<EventCreationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _organizerController = TextEditingController();
  final _venueController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _teamCountController = TextEditingController(text: '0');

  DateTime? _selectedDate;
  String? _selectedCategory;
  String? _selectedGameType;
  String? _selectedTournamentType;
  String? _selectedFormation;

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Event')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Event Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('Provide the details for your event below.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              
              _buildTextField('Organizer Name *', _organizerController, 'e.g. TalentTrack Academy'),
              const SizedBox(height: 20),
              _buildTextField('Event Name *', _titleController, 'e.g. U-17 Regional Finals'),
              const SizedBox(height: 20),
              _buildTextField('Event Subtitle (Optional)', _subtitleController, 'e.g. Season Opener'),
              const SizedBox(height: 20),
              
              _buildDatePicker(),
              const SizedBox(height: 20),
              
              _buildDropdown('Event Category *', ['Tournament', 'Match', 'Trial', 'Concert', 'Conference', 'Social'], _selectedCategory, (val) => setState(() => _selectedCategory = val)),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(child: _buildTextField('Venue *', _venueController, 'e.g. Kasarani Stadium')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Location *', _locationController, 'e.g. Nairobi')),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _buildDropdown('Game Type', ['Football', 'Basketball', 'Rugby', 'Tennis', 'Athletics', 'Other'], _selectedGameType, (val) => setState(() => _selectedGameType = val))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdown('Tournament Type', ['N/A', 'Knockout', 'League', 'Group Stage', 'Friendly'], _selectedTournamentType, (val) => setState(() => _selectedTournamentType = val))),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _buildTextField('No. of Teams', _teamCountController, '0', keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdown('Formation', ['4-4-2', '4-3-3', '4-2-3-1', '3-5-2', '4-5-1', '3-4-3'], _selectedFormation, (val) => setState(() => _selectedFormation = val))),
                ],
              ),
              const SizedBox(height: 20),

              _buildTextField('Description', _descriptionController, 'A brief description...', maxLines: 4),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Create Event'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (val) => (label.contains('*') && (val == null || val.isEmpty)) ? 'Required field' : null,
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date of Event *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) setState(() => _selectedDate = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade800), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedDate != null ? DateFormat('PPP').format(_selectedDate!) : 'Pick a date'),
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (val) => (label.contains('*') && val == null) ? 'Required field' : null,
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      if (_selectedDate == null) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a date')));
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event Created Successfully'), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }
}
