import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../widgets/events/event_list.dart';
import '../../widgets/events/event_details.dart';
import '../../widgets/events/event_management_table.dart';
import 'event_creation_form_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AcademyEvent> _events = [];
  AcademyEvent? _selectedEvent;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() => _loading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _events = [
          AcademyEvent(
            id: '1',
            title: 'U-17 Regional Finals',
            subtitle: 'Season Opener',
            organizer: 'TalantaTrack Academy',
            eventDate: DateTime.now().add(const Duration(days: 10)),
            category: 'Tournament',
            venue: 'Kasarani Stadium',
            location: 'Nairobi',
            gameType: 'Football',
            tournamentType: 'Knockout',
            teamCount: 8,
            lineupFormation: '4-4-2',
            lineupSquad: [
              LineupPlayer(name: 'John Doe', number: 1, position: 'Goalkeeper'),
              LineupPlayer(name: 'Alex Smith', number: 2, position: 'Defender'),
              LineupPlayer(name: 'Ben White', number: 3, position: 'Defender'),
              LineupPlayer(name: 'Chris Green', number: 4, position: 'Midfielder'),
              LineupPlayer(name: 'David Blue', number: 5, position: 'Forward'),
            ],
            description: 'The final showdown of the regional championship.',
          ),
          AcademyEvent(
            id: '2',
            title: 'Academy Open Trials',
            subtitle: 'New Talent Search',
            organizer: 'TalantaTrack Academy',
            eventDate: DateTime.now().add(const Duration(days: 15)),
            category: 'Trial',
            venue: 'Academy Grounds',
            location: 'Nairobi',
            gameType: 'Football',
            tournamentType: 'N/A',
            teamCount: 0,
            description: 'Opportunity for young players to join our academy.',
          ),
        ];
        if (_events.isNotEmpty) _selectedEvent = _events[0];
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
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Marketplace'),
                Tab(text: 'Manage Events'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 1200, // Large fixed height or adjust based on content
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMarketplaceTab(),
                  EventManagementTable(events: _events),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Events & Ticketing', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Browse the marketplace or manage your events.', style: TextStyle(color: Colors.grey)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EventCreationFormScreen())),
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Create Event'),
        ),
      ],
    );
  }

  Widget _buildMarketplaceTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 900;

    if (isLargeScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: EventList(
              events: _events,
              selectedEvent: _selectedEvent,
              onSelectEvent: (ev) => setState(() => _selectedEvent = ev),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: _selectedEvent != null
                ? EventDetails(event: _selectedEvent!)
                : const Center(child: Text('Select an event to see details')),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          EventList(
            events: _events,
            selectedEvent: _selectedEvent,
            onSelectEvent: (ev) => setState(() => _selectedEvent = ev),
          ),
          const SizedBox(height: 24),
          if (_selectedEvent != null) EventDetails(event: _selectedEvent!),
        ],
      );
    }
  }
}
