import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/player_management/enrollment_steps.dart';

class EnrollmentFormScreen extends StatefulWidget {
  final Map<String, dynamic>? existingPlayer;
  final String mode; // 'create' or 'edit'

  const EnrollmentFormScreen({
    super.key,
    this.existingPlayer,
    this.mode = 'create',
  });

  @override
  State<EnrollmentFormScreen> createState() => _EnrollmentFormScreenState();
}

class _EnrollmentFormScreenState extends State<EnrollmentFormScreen> {
  int _currentStep = 0;
  bool _loading = false;
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  
  DateTime _dateOfBirth = DateTime.now().subtract(const Duration(days: 365 * 16));
  String? _selectedPosition;
  String? _selectedTeam;
  
  // Simulated file states
  String? _birthCertificateName;
  String? _releaseLetterName;
  String? _profilePicturePath;

  final List<StepItem> _steps = [
    StepItem(id: '01', name: 'Personal Details'),
    StepItem(id: '02', name: 'Documents'),
    StepItem(id: '03', name: 'Profile Picture'),
    StepItem(id: '04', name: 'Review'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingPlayer != null) {
      _nameController.text = widget.existingPlayer!['name'] ?? '';
      _phoneController.text = widget.existingPlayer!['phoneNumber'] ?? '';
      _emailController.text = widget.existingPlayer!['email'] ?? '';
      _selectedPosition = widget.existingPlayer!['position'];
      _selectedTeam = widget.existingPlayer!['team'];
      // ... handle other fields
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  bool _validateStep() {
    if (_currentStep == 0) {
      if (_nameController.text.isEmpty) {
        _showSnackBar('Full name is required');
        return false;
      }
      if (_selectedPosition == null) {
        _showSnackBar('Position is required');
        return false;
      }
      if (_selectedTeam == null) {
        _showSnackBar('Team is required');
        return false;
      }
      int age = _calculateAge(_dateOfBirth);
      if (age < 5 || age > 30) {
        _showSnackBar('Player must be between 5 and 30 years old');
        return false;
      }
    } else if (_currentStep == 1) {
      if (_birthCertificateName == null && widget.mode == 'create') {
        _showSnackBar('Birth certificate is required');
        return false;
      }
    }
    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleSubmit() async {
    setState(() => _loading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _loading = false);
    
    if (mounted) {
      _showSnackBar(widget.mode == 'edit' ? 'Player Updated' : 'Player Enrolled');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == 'edit' ? 'Edit Player' : 'Enroll New Player'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: EnrollmentSteps(currentStep: _currentStep, steps: _steps),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _buildStepContent(),
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0: return _buildPersonalDetails();
      case 1: return _buildUploadDocuments();
      case 2: return _buildProfilePicture();
      case 3: return _buildReview();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildPersonalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Personal Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildTextField('Full Name *', _nameController, 'e.g. John Doe'),
        const SizedBox(height: 20),
        _buildDatePicker(),
        const SizedBox(height: 20),
        _buildDropdown('Position *', ['Goalkeeper', 'Defender', 'Midfielder', 'Forward', 'Utility'], _selectedPosition, (val) => setState(() => _selectedPosition = val)),
        const SizedBox(height: 20),
        _buildDropdown('Team *', ['U-15', 'U-17', 'U-19', 'U-21', 'Senior', 'Development'], _selectedTeam, (val) => setState(() => _selectedTeam = val)),
        const SizedBox(height: 20),
        _buildTextField('Phone Number (Guardian)', _phoneController, 'e.g. 254712345678', keyboardType: TextInputType.phone),
        const SizedBox(height: 20),
        _buildTextField('Email (Guardian)', _emailController, 'e.g. guardian@example.com', keyboardType: TextInputType.emailAddress),
      ],
    );
  }

  Widget _buildUploadDocuments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Please upload required documents for player registration', style: TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 24),
        _buildFilePicker('Birth Certificate *', _birthCertificateName, () {
          setState(() => _birthCertificateName = 'birth_cert_scan.pdf');
        }),
        const SizedBox(height: 24),
        _buildFilePicker('Release Letter (Optional)', _releaseLetterName, () {
          setState(() => _releaseLetterName = 'release_letter.png');
        }),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profile Picture', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() => _profilePicturePath = 'dummy_path');
            },
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade800, width: 2, style: BorderStyle.solid),
              ),
              child: _profilePicturePath != null 
                  ? const Icon(Icons.person, size: 80, color: Colors.blue) 
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Upload', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Review & Submit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildReviewRow('Name', _nameController.text),
              _buildReviewRow('DOB', DateFormat('PPP').format(_dateOfBirth)),
              _buildReviewRow('Position', _selectedPosition ?? 'None'),
              _buildReviewRow('Team', _selectedTeam ?? 'None'),
              _buildReviewRow('Birth Cert', _birthCertificateName != null ? 'Uploaded' : 'Missing'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date of Birth *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dateOfBirth,
              firstDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
              lastDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
            );
            if (date != null) setState(() => _dateOfBirth = date);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade800),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 12),
                Text(DateFormat('PPP').format(_dateOfBirth)),
                const Spacer(),
                Text('${_calculateAge(_dateOfBirth)} yrs', style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker(String label, String? fileName, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade800, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(fileName != null ? Icons.file_present : Icons.cloud_upload, size: 32, color: fileName != null ? Colors.blue : Colors.grey),
                const SizedBox(height: 8),
                Text(fileName ?? 'Click to upload', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.grey.shade900)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
            child: const Text('Previous'),
          ),
          ElevatedButton(
            onPressed: _loading ? null : () {
              if (_validateStep()) {
                if (_currentStep < _steps.length - 1) {
                  setState(() => _currentStep++);
                } else {
                  _handleSubmit();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 48),
            ),
            child: _loading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(_currentStep == _steps.length - 1 ? 'Submit' : 'Next'),
          ),
        ],
      ),
    );
  }
}
