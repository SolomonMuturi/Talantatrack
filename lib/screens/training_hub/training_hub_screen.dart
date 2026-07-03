import 'package:flutter/material.dart';

class TrainingHubScreen extends StatefulWidget {
  const TrainingHubScreen({super.key});

  @override
  State<TrainingHubScreen> createState() => _TrainingHubScreenState();
}

class _TrainingHubScreenState extends State<TrainingHubScreen> {
  final List<Map<String, dynamic>> _courses = [
    {
      'id': 'c1',
      'title': 'Advanced Tactical Positioning',
      'desc': 'Master the art of space management and transition play.',
      'type': 'Self-paced',
      'price': 1500,
      'progress': 65.0,
      'modules': 12,
    },
    {
      'id': 'c2',
      'title': 'Mental Strength & Leadership',
      'desc': 'Developing the psychology required for high-performance sports.',
      'type': 'Instructor-led',
      'price': 2500,
      'progress': 0.0,
      'modules': 8,
    },
    {
      'id': 'c3',
      'title': 'Nutrition for Young Athletes',
      'desc': 'Essential dietary guidelines for growth and recovery.',
      'type': 'Self-paced',
      'price': 0,
      'progress': 100.0,
      'modules': 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Training Hub', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('LMS for player and coach development.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_box_outlined),
                  label: const Text('Add Course'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _courses.length,
              itemBuilder: (context, index) => _buildCourseCard(_courses[index]),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    final theme = Theme.of(context);
    final isPaid = course['price'] > 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.grey.shade900,
            child: const Icon(Icons.video_library_outlined, size: 40, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(course['type'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    if (isPaid)
                      Text('KES ${course['price']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.primary))
                    else
                      const Text('FREE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(course['desc'], style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${course['modules']} modules', style: const TextStyle(fontSize: 11)),
                    Text('${course['progress'].toInt()}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: course['progress'] / 100),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(course['progress'] > 0 ? 'Continue' : 'Enroll Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
