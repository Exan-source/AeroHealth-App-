class FreeCourse {
  final String title;
  final String instructor;
  final String institution;
  final String category;
  final String level;
  final List<String> tags;
  final List<String> learningOutcomes;
  final bool isLive;

  FreeCourse({
    required this.title,
    required this.instructor,
    required this.institution,
    required this.category,
    required this.level,
    required this.tags,
    required this.learningOutcomes,
    required this.isLive,
  });
}
