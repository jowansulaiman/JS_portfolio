// lib/models/education_item.dart

class EducationItem {
  final String degree;
  final String institution;
  final String period;

  const EducationItem({
    required this.degree,
    required this.institution,
    required this.period,
  });

  factory EducationItem.fromJson(Map<String, dynamic> json) {
    return EducationItem(
      degree: json['degree'] as String,
      institution: json['institution'] as String,
      period: json['period'] as String,
    );
  }
}