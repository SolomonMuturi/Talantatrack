import 'package:flutter/material.dart';
import '../../models/event.dart';
import 'package:intl/intl.dart';
import 'team_formation.dart';

class EventDetails extends StatelessWidget {
  final AcademyEvent event;

  const EventDetails({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  if (event.logoUrl != null && event.logoUrl!.isNotEmpty)
                    Image.network(event.logoUrl!, height: 80, fit: BoxFit.contain)
                  else
                    const CircleAvatar(radius: 40, child: Icon(Icons.sports, size: 40)),
                  const SizedBox(height: 16),
                  Text(event.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  if (event.subtitle != null)
                    Text(event.subtitle!, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(event.eventDate != null ? DateFormat('MMMM dd, yyyy').format(event.eventDate!) : 'Date TBD'),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(event.category, style: const TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'Starting Lineup'),
              ],
            ),
            SizedBox(
              height: 600, // Fixed height for content or use Expanded in a specific layout
              child: TabBarView(
                children: [
                  _buildDetailsTab(context),
                  _buildLineupTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    final details = [
      {'icon': Icons.person_outline, 'label': 'Organizer', 'value': event.organizer},
      {'icon': Icons.sports_soccer, 'label': 'Game Type', 'value': event.gameType ?? 'N/A'},
      {'icon': Icons.location_on_outlined, 'label': 'Location', 'value': event.location ?? 'N/A'},
      {'icon': Icons.emoji_events_outlined, 'label': 'Tournament', 'value': event.tournamentType ?? 'N/A'},
      {'icon': Icons.stadium_outlined, 'label': 'Venue', 'value': event.venue ?? 'N/A'},
      {'icon': Icons.groups_outlined, 'label': 'No. of Teams', 'value': event.teamCount?.toString() ?? '0'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: details.length,
            itemBuilder: (context, index) {
              final item = details[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(item['icon'] as IconData, size: 20, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item['label'] as String, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          Text(item['value'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (event.description != null && event.description!.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text('Event Description', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(event.description!),
            ),
          ],
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.confirmation_number_outlined),
              label: const Text('Purchase Ticket'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineupTab() {
    if (event.lineupSquad == null || event.lineupSquad!.isEmpty) {
      return const Center(child: Text('Lineup information is not available.'));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: TeamFormation(
        formation: event.lineupFormation ?? '4-4-2',
        squad: event.lineupSquad!,
      ),
    );
  }
}
