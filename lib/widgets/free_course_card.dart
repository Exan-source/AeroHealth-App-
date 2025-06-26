import 'package:flutter/material.dart';
import '../models/free_course.dart';

class FreeCourseCard extends StatelessWidget {
  final FreeCourse course;
  final VoidCallback onTap;

  const FreeCourseCard({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(course.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('${course.instructor} • ${course.institution}', style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: course.tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
              if (course.isLive)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('LIVE NOW', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
