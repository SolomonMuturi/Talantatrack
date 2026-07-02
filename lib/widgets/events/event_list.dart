import 'package:flutter/material.dart';
import '../../models/event.dart';
import 'package:intl/intl.dart';

class EventList extends StatelessWidget {
  final List<AcademyEvent> events;
  final AcademyEvent? selectedEvent;
  final Function(AcademyEvent) onSelectEvent;

  const EventList({
    super.key,
    required this.events,
    this.selectedEvent,
    required this.onSelectEvent,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(child: Text('No events found.', style: TextStyle(color: Colors.grey)));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final event = events[index];
        final isSelected = selectedEvent?.id == event.id;

        return InkWell(
          onTap: () => onSelectEvent(event),
          child: Card(
            elevation: isSelected ? 4 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(event.category, style: const TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                  if (event.subtitle != null && event.subtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        event.subtitle!,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (event.logoUrl != null && event.logoUrl!.isNotEmpty)
                    Container(
                      height: 100,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          event.logoUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 100,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.sports_soccer, size: 40, color: Colors.grey),
                    ),
                  _buildIconText(Icons.calendar_today, _formatDate(event.eventDate)),
                  const SizedBox(height: 4),
                  _buildIconText(Icons.location_on_outlined, event.venue ?? event.location ?? 'TBD'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Date not set';
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
