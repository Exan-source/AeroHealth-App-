import '../models/free_course.dart';

class FreeCourseService {
  static Future<List<FreeCourse>> fetchFreeLiveCourses({
    String? category,
    String? level,
    String? searchQuery,
    bool liveOnly = false,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final all = [
      FreeCourse(
        title: 'Air Quality & Urban Health',
        instructor: 'Dr. Clean Air',
        institution: 'EnviroHealth Uni',
        category: 'Environmental Health',
        level: 'Beginner',
        tags: ['AQI', 'PM2.5', 'Pollution'],
        learningOutcomes: ['Understand AQI', 'Protect respiratory health'],
        isLive: false,
      ),
      FreeCourse(
        title: 'Intro to Health Tech',
        instructor: 'Techy Nurse',
        institution: 'Digital Health Academy',
        category: 'Health Tech',
        level: 'Intermediate',
        tags: ['IoT', 'Wearables', 'Remote Monitoring'],
        learningOutcomes: ['Basics of IoT in healthcare'],
        isLive: false,
      ),
    ];

    return all.where((course) {
      final matchCat = category == null || course.category == category;
      final matchLvl = level == null || course.level == level;
      final matchLive = !liveOnly || course.isLive;
      final matchSearch = searchQuery == null || course.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchCat && matchLvl && matchLive && matchSearch;
    }).toList();
  }

  static List<String> getCategories() => [
    'All',
    'Environmental Health',
    'Health Tech',
  ];
}
