// lib/models/language_item.dart

class LanguageItem {
  final String language;
  final String level;
  final double proficiency;

  const LanguageItem({
    required this.language,
    required this.level,
    required this.proficiency
  });

  factory LanguageItem.fromJson(Map<String, dynamic> json) {
    return LanguageItem(
      language: json['language'] as String,
      level: json['level'] as String,
      proficiency: (json['proficiency'] as num).toDouble(),
    );
  }
}