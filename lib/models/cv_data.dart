// lib/models/cv_data.dart

// Modell für personal_info.json
class PersonalInfo {
  final String name;
  final String title;
  final String email;
  final String phone;
  final String location;

  PersonalInfo({
    required this.name,
    required this.title,
    required this.email,
    required this.phone,
    required this.location,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'],
      title: json['title'],
      email: json['email'],
      phone: json['phone'],
      location: json['location'],
    );
  }
}

// Modell für work_experience.json
class ExperienceItem {
  final String title;
  final String company;
  final String period;
  final String location;
  final String description;

  ExperienceItem({
    required this.title,
    required this.company,
    required this.period,
    required this.location,
    required this.description,
  });

  factory ExperienceItem.fromJson(Map<String, dynamic> json) {
    return ExperienceItem(
      title: json['title'],
      company: json['company'],
      period: json['period'],
      location: json['location'],
      description: json['description'],
    );
  }
}

// Modell für education.json
class EducationItem {
  final String degree;
  final String institution;
  final String period;

  EducationItem({
    required this.degree,
    required this.institution,
    required this.period,
  });

  factory EducationItem.fromJson(Map<String, dynamic> json) {
    return EducationItem(
      degree: json['degree'],
      institution: json['institution'],
      period: json['period'],
    );
  }
}

// Modell für skills.json
class SkillCategory {
  final String categoryName;
  final List<String> skills;

  SkillCategory({required this.categoryName, required this.skills});

  factory SkillCategory.fromJson(String categoryName, List<dynamic> json) {
    return SkillCategory(
      categoryName: categoryName,
      skills: List<String>.from(json),
    );
  }
}

// Modell für languages.json
class LanguageItem {
  final String language;
  final String level;

  LanguageItem({required this.language, required this.level});

  factory LanguageItem.fromJson(Map<String, dynamic> json) {
    return LanguageItem(
      language: json['language'],
      level: json['level'],
    );
  }
}