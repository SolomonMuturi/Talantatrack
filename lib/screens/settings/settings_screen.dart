import 'package:flutter/material.dart';
import '../../main.dart'; // Import themeNotifier

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    // Determine the current theme string based on themeNotifier
    String currentTheme;
    switch (themeNotifier.value) {
      case ThemeMode.light:
        currentTheme = 'Light';
        break;
      case ThemeMode.dark:
        currentTheme = 'Dark';
        break;
      case ThemeMode.system:
        currentTheme = 'System';
        break;
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('Configure your preferences and account settings.', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                
                _buildSection('Profile', [
                  _buildTextField('Display Name', 'TalentTrack Admin'),
                ]),
                
                _buildSection('Notifications', [
                  SwitchListTile(
                    title: const Text('Email Notifications'),
                    value: _emailNotifications,
                    onChanged: (val) => setState(() => _emailNotifications = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: const Text('SMS Notifications'),
                    value: _smsNotifications,
                    onChanged: (val) => setState(() => _smsNotifications = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                ]),
                
                _buildSection('Appearance', [
                  _buildDropdown('Theme', ['Dark', 'Light', 'System'], currentTheme, (v) {
                    setState(() {
                      if (v == 'Light') {
                        themeNotifier.value = ThemeMode.light;
                      } else if (v == 'Dark') {
                        themeNotifier.value = ThemeMode.dark;
                      } else {
                        themeNotifier.value = ThemeMode.system;
                      }
                    });
                  }),
                  const SizedBox(height: 16),
                  _buildDropdown('Language', ['English', 'Swahili', 'French'], _language, (v) => setState(() => _language = v!)),
                ]),
                
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings saved successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 54)),
                  child: const Text('Save Changes'),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(height: 24),
        ...children,
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTextField(String label, String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
