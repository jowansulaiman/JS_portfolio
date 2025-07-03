// lib/models/experience_item.dart

class ExperienceItem {
  final String title;
  final String company;
  final String period;
  final String location;
  final String description;

  const ExperienceItem({
    required this.title,
    required this.company,
    required this.period,
    required this.location,
    required this.description,
  });

  factory ExperienceItem.fromJson(Map<String, dynamic> json) {
    return ExperienceItem(
      title: json['title'] as String,
      company: json['company'] as String,
      period: json['period'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
    );
  }
}