import 'package:flutter/material.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

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
                    Text('Academy Blog', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Latest news and updates from the academy.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit_note), label: const Text('Write Post')),
              ],
            ),
            const SizedBox(height: 24),
            _buildBlogList(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 150, color: Colors.grey.shade900, child: const Center(child: Icon(Icons.image_outlined, size: 40, color: Colors.grey))),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('OFFICIAL ANNOUNCEMENT', style: TextStyle(color: Color(0xFF33CC33), fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('TalentTrack Wins Regional Youth Cup', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Our U-17 team has emerged victorious in the annual youth championships held this past weekend...', style: TextStyle(color: Colors.grey, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const CircleAvatar(radius: 12, backgroundColor: Colors.grey),
                        const SizedBox(width: 8),
                        const Text('By Admin • 4 hours ago', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        const Spacer(),
                        TextButton(onPressed: () {}, child: const Text('Read More')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
