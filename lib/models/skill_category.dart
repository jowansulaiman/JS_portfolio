// lib/models/skill_category.dart

class SkillCategory {
  final String categoryName;
  final List<String> skills;

  const SkillCategory({required this.categoryName, required this.skills});

  factory SkillCategory.fromJson(String categoryName, List<dynamic> json) {
    return SkillCategory(
      categoryName: categoryName,
      skills: List<String>.from(json),
    );
  }
}