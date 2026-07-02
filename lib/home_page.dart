import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/bi_dashboard_screen.dart';
import 'screens/player_management/player_list_screen.dart';
import 'screens/finances/finances_screen.dart';
import 'screens/events/events_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    const BiDashboardScreen(),
    const PlayerListScreen(),
    const FinancesScreen(),
    const EventsScreen(),
    const Center(child: Text('Store Management Module')),
    const Center(child: Text('Academy Operations Module')),
    const Center(child: Text('Training Hub Module')),
    const Center(child: Text('Blog Module')),
    const Center(child: Text('Messages Module')),
    const Center(child: Text('Platform Management Module')),
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
        title: const Text(
          'TalantaTrack',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('TalantaTrack Admin'),
              accountEmail: const Text('admin@talantatrack.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.deepPurple),
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
              ),
            ),
            _buildDrawerItem(0, Icons.dashboard, 'Dashboard'),
            _buildDrawerItem(1, Icons.pie_chart, 'BI Dashboard'),
            
            _buildExpansionTile(
              index: 2,
              icon: Icons.people,
              label: 'Player Management',
              children: [
                _buildSubItem('Player Roster'),
                _buildSubItem('Standings'),
                _buildSubItem('Achievements'),
                _buildSubItem('ID & Access'),
                _buildSubItem('Scouting'),
              ],
            ),
            
            _buildExpansionTile(
              index: 3,
              icon: Icons.account_balance_wallet,
              label: 'Financial Tools',
              children: [
                _buildSubItem('Transactions'),
                _buildSubItem('Fraud Detection'),
                _buildSubItem('Reporting'),
              ],
            ),
            
            _buildExpansionTile(
              index: 4,
              icon: Icons.calendar_month,
              label: 'Events & Ticketing',
              children: [
                _buildSubItem('Marketplace'),
                _buildSubItem('Ticket Management'),
                _buildSubItem('Book a Ticket'),
              ],
            ),
            
            _buildDrawerItem(5, Icons.store, 'Store Management'),
            
            _buildExpansionTile(
              index: 6,
              icon: Icons.settings,
              label: 'Academy Operations',
              children: [
                _buildSubItem('Team Management'),
                _buildSubItem('Inventory'),
                _buildSubItem('Communications'),
                _buildSubItem('Compliance'),
              ],
            ),
            
            _buildDrawerItem(7, Icons.school, 'Training Hub'),
            _buildDrawerItem(8, Icons.newspaper, 'Blog'),
            _buildDrawerItem(9, Icons.message, 'Messages'),
            _buildDrawerItem(10, Icons.admin_panel_settings, 'Platform Management'),
            
            const Divider(),
            _buildDrawerItem(-1, Icons.settings, 'Settings'),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'BI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Players',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Finances',
          ),
        ],
        currentIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _onItemTapped(index);
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
        if (index != -1) {
          _onItemTapped(index);
        }
        Navigator.pop(context);
      },
    );
  }

  Widget _buildExpansionTile({
    required int index,
    required IconData icon,
    required String label,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(label),
      initiallyExpanded: _selectedIndex == index,
      children: children,
      onExpansionChanged: (expanded) {
        if (expanded) {
          _onItemTapped(index);
        }
      },
    );
  }

  Widget _buildSubItem(String label) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 72),
      title: Text(
        label,
        style: const TextStyle(fontSize: 14),
      ),
      onTap: () {
        // Navigate or perform action
        Navigator.pop(context);
      },
    );
  }
}
