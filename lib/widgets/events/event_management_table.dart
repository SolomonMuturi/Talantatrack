import 'package:flutter/material.dart';
import '../../models/event.dart';
import 'package:intl/intl.dart';

class EventManagementTable extends StatelessWidget {
  final List<AcademyEvent> events;

  const EventManagementTable({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('A list of all events you have created.', style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Event')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Organizer')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Actions')),
              ],
              rows: events.map((event) => DataRow(cells: [
                DataCell(
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(4)),
                        child: event.logoUrl != null ? Image.network(event.logoUrl!) : const Icon(Icons.image_outlined, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          if (event.subtitle != null) Text(event.subtitle!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                DataCell(Text(event.eventDate != null ? DateFormat('MMM dd, yyyy').format(event.eventDate!) : 'TBD', style: const TextStyle(fontSize: 12))),
                DataCell(Text(event.organizer, style: const TextStyle(fontSize: 12))),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)), borderRadius: BorderRadius.circular(12)),
                    child: Text(event.category, style: const TextStyle(fontSize: 10)),
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.more_horiz, size: 18),
                    onPressed: () {},
                  ),
                ),
              ])).toList(),
            ),
          ),
          if (events.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text('No events found.'))),
        ],
      ),
    );
  }
}
