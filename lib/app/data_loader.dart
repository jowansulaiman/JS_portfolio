// lib/app/data_loader.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:js_portfolio/models/models.dart';

// Klasse erweitert, um Projekte und Zertifikate zu halten
class PortfolioData {
  final PersonalInfo personalInfo;
  final String summary;
  final List<ExperienceItem> workExperience;
  final List<EducationItem> education;
  final List<SkillCategory> skills;
  final List<LanguageItem> languages;
  final List<String> interests;
  final List<ProjectItem> projects;       // NEU
  final List<CertificateItem> certificates; // NEU

  PortfolioData({
    required this.personalInfo,
    required this.summary,
    required this.workExperience,
    required this.education,
    required this.skills,
    required this.languages,
    required this.interests,
    required this.projects,      // NEU
    required this.certificates,  // NEU
  });
}

Future<PortfolioData> loadPortfolioData() async {
  // Lade-Liste erweitert
  final results = await Future.wait([
    rootBundle.loadString('assets/data/personal_info.json'),
    rootBundle.loadString('assets/data/summary.json'),
    rootBundle.loadString('assets/data/work_experience.json'),
    rootBundle.loadString('assets/data/education.json'),
    rootBundle.loadString('assets/data/skills.json'),
    rootBundle.loadString('assets/data/languages.json'),
    rootBundle.loadString('assets/data/interests.json'),
    rootBundle.loadString('assets/data/projects.json'),
    rootBundle.loadString('assets/data/certificates.json'),
  ]);

  // JSON-Strings in Maps umwandeln
  final personalInfoJson = json.decode(results[0]) as Map<String, dynamic>;
  final summaryJson = json.decode(results[1]) as Map<String, dynamic>;
  final workExperienceJson = json.decode(results[2]) as List<dynamic>;
  final educationJson = json.decode(results[3]) as List<dynamic>;
  final skillsJson = json.decode(results[4]) as Map<String, dynamic>;
  final languagesJson = json.decode(results[5]) as List<dynamic>;
  final interestsJson = json.decode(results[6]) as Map<String, dynamic>;
  final projectsJson = json.decode(results[7]) as List<dynamic>;
  final certificatesJson = json.decode(results[8]) as List<dynamic>;

  return PortfolioData(
    personalInfo: PersonalInfo.fromJson(personalInfoJson),
    summary: summaryJson['text'],
    workExperience: workExperienceJson
        .map((item) => ExperienceItem.fromJson(item))
        .toList(),
    education:
    educationJson.map((item) => EducationItem.fromJson(item)).toList(),
    skills: skillsJson.entries
        .map((entry) => SkillCategory.fromJson(entry.key, entry.value))
        .toList(),
    languages:
    languagesJson.map((item) => LanguageItem.fromJson(item)).toList(),
    interests: List<String>.from(interestsJson['hobbies']),
    // Maps in unsere Dart-Modelle umwandeln
    projects: projectsJson.map((item) => ProjectItem.fromJson(item)).toList(),
    certificates: certificatesJson
        .map((item) => CertificateItem.fromJson(item))
        .toList(), // NEU
  );
}