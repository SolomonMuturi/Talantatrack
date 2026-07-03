import 'package:flutter/material.dart';

class ScoutingScreen extends StatelessWidget {
  const ScoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scouting Portal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Identify and track promising talent outside the academy.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _buildScoutingList(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildScoutingList() {
    final scouts = [
      {'name': 'David Maina', 'age': '14', 'pos': 'Striker', 'club': 'Mathare Youth', 'rating': '⭐⭐⭐⭐'},
      {'name': 'Joy Achieng', 'age': '15', 'pos': 'Winger', 'club': 'Coastal Queens', 'rating': '⭐⭐⭐⭐⭐'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: scouts.length,
      itemBuilder: (context, index) {
        final p = scouts[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${p['pos']} • ${p['age']} years', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const Spacer(),
                Text(p['club']!, style: const TextStyle(fontSize: 11)),
                Text(p['rating']!, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }
}
