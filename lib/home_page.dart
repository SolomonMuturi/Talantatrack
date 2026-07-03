import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/bi_dashboard_screen.dart';
import 'screens/player_management/player_list_screen.dart';
import 'screens/player_management/standings_screen.dart';
import 'screens/player_management/scouting_screen.dart';
import 'screens/player_management/id_card_screen.dart';
import 'screens/finances/finances_screen.dart';
import 'screens/finances/reporting_screen.dart';
import 'screens/events/events_screen.dart';
import 'screens/merchandise/merchandise_screen.dart';
import 'screens/academy_operations/team_management_screen.dart';
import 'screens/academy_operations/attendance_screen.dart';
import 'screens/academy_operations/communications_screen.dart';
import 'screens/inventory/inventory_screen.dart';
import 'screens/training_hub/training_hub_screen.dart';
import 'screens/blog/blog_screen.dart';
import 'screens/messages/messages_screen.dart';
import 'screens/platform_management/platform_management_screen.dart';
import 'screens/settings/settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(), // 0
    const BiDashboardScreen(), // 1
    const PlayerListScreen(), // 2
    const StandingsScreen(), // 3
    const ScoutingScreen(), // 4
    const IdCardScreen(), // 5
    const FinancesScreen(), // 6
    const ReportingScreen(), // 7
    const EventsScreen(), // 8
    const MerchandiseScreen(), // 9
    const TeamManagementScreen(), // 10
    const AttendanceScreen(), // 11
    const InventoryScreen(), // 12
    const CommunicationsScreen(), // 13
    const TrainingHubScreen(), // 14
    const BlogScreen(), // 15
    const MessagesScreen(), // 16
    const PlatformManagementScreen(), // 17
    const SettingsScreen(), // 18
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TalentTrack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => _onItemTapped(16),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('TalentTrack Admin'),
              accountEmail: const Text('admin@talenttrack.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Color(0xFF33CC33)),
                  ),
                ),
              ),
              decoration: BoxDecoration(color: theme.colorScheme.primary),
            ),
            _buildDrawerItem(0, Icons.dashboard, 'Dashboard'),
            _buildDrawerItem(1, Icons.analytics, 'BI Dashboard'),
            
            _buildExpansionTile(
              icon: Icons.people,
              label: 'Player Management',
              children: [
                _buildSubItem(2, 'Player Roster'),
                _buildSubItem(3, 'Standings'),
                _buildSubItem(4, 'Scouting'),
                _buildSubItem(5, 'ID & Access'),
              ],
            ),
            
            _buildExpansionTile(
              icon: Icons.account_balance_wallet,
              label: 'Financial Tools',
              children: [
                _buildSubItem(6, 'Transactions'),
                _buildSubItem(7, 'Reporting & AI'),
              ],
            ),
            
            _buildDrawerItem(8, Icons.calendar_month, 'Events & Ticketing'),
            _buildDrawerItem(9, Icons.store, 'Store Management'),
            
            _buildExpansionTile(
              icon: Icons.settings,
              label: 'Academy Operations',
              children: [
                _buildSubItem(10, 'Team Management'),
                _buildSubItem(11, 'Attendance'),
                _buildSubItem(12, 'Inventory'),
                _buildSubItem(13, 'Communications'),
              ],
            ),
            
            _buildDrawerItem(14, Icons.school, 'Training Hub'),
            _buildDrawerItem(15, Icons.newspaper, 'Blog'),
            _buildDrawerItem(16, Icons.message, 'Messages'),
            _buildDrawerItem(17, Icons.admin_panel_settings, 'Platform Management'),
            
            const Divider(),
            _buildDrawerItem(18, Icons.settings, 'Settings'),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Players'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Finances'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
        currentIndex: _selectedIndex == 0 ? 0 : (_selectedIndex == 2 ? 1 : (_selectedIndex == 6 ? 2 : (_selectedIndex == 18 ? 3 : 0))),
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) _onItemTapped(0);
          if (index == 1) _onItemTapped(2);
          if (index == 2) _onItemTapped(6);
          if (index == 3) _onItemTapped(18);
        },
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String label) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: _selectedIndex == index,
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildExpansionTile({required IconData icon, required String label, required List<Widget> children}) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(label),
      children: children,
    );
  }

  Widget _buildSubItem(int index, String label) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 72),
      title: Text(label, style: const TextStyle(fontSize: 13)),
      selected: _selectedIndex == index,
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context);
      },
    );
  }
}
