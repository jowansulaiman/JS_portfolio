// lib/app/app_data.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:js_portfolio/models/certificate.dart';
import 'package:js_portfolio/models/language.dart';
import 'package:js_portfolio/models/nav_item.dart';
import 'package:js_portfolio/models/project.dart';
import 'package:js_portfolio/models/skill.dart';
import 'package:js_portfolio/models/timeline_event.dart';

class AppData {
  // KORREKTUR: Die beiden Variablen für die Zugangscodes werden hier deklariert.
  static const String permanentAccessCode = "1234";
  static const String temporaryAccessCode = "GUEST24";

  static const String profileImage = 'assets/profile.png';
  static const String name = 'Jowan Sulaiman';
  static const String jobTitle = 'Software Developer';

  static final Map<IconData, String> socialLinks = {
    FontAwesomeIcons.github: 'https://github.com',
    FontAwesomeIcons.linkedinIn: 'https://linkedin.com',
    FontAwesomeIcons.xing: 'https://www.xing.com',
  };

  static final List<NavItem> navItems = [
    const NavItem(label: 'Home', icon: Icons.home_outlined),
    const NavItem(label: 'Lebenslauf', icon: Icons.article_outlined),
    const NavItem(label: 'Projekte', icon: Icons.work_outline_rounded),
    const NavItem(label: 'Kompetenzen', icon: Icons.code_rounded),
    const NavItem(label: 'Sprachen', icon: Icons.language_outlined),
    const NavItem(label: 'Zertifikate', icon: Icons.verified_outlined),
  ];

  static const List<TimelineEvent> timeline = [
    TimelineEvent('03/2023 – 04/2023', 'Praktikum IT-Sicherheit bei CAU zu Kiel', 2023, details: 'Bekannte Sicherheitslücken erklären. Abwehrmechanismen gegen einzelne bekannte Bedrohungen implementieren.'),
    TimelineEvent('12/2022 – 01/2023', 'Praktikum Bildverarbeitung bei CAU zu Kiel', 2022, details: 'Project01: ShapeChaser, Project02: BarCodeScanner'),
    TimelineEvent('02/2022 – 03/2022', 'Praktikum Haskell bei CAU zu Kiel', 2022, details: 'Compiler für Prolog in Haskell programmiert.'),
    TimelineEvent('10/2021 – 11/2021', 'Praktikum Gaming (Pacman) bei CAU zu Kiel', 2021, details: 'Ein Spiel mit GUI und Interaktionen programmiert.'),
    TimelineEvent('seit 2021', 'Bachelorstudium Informatik an der CAU-Universität zu Kiel', 2021, details: 'Vertiefung der Leidenschaft für Technologie und Informatik an der Christian-Albrechts-Universität.'),
    TimelineEvent('04/2020 – 06/2020', 'Digitales Türschild bei Worlée GmbH, Hamburg', 2020, details: 'Digitales Türschild aufgebaut (Arduino, E-Paper) und Software in C++ programmiert.'),
    TimelineEvent('08/2017 – 05/2020', 'Ausbildung zum Fachinformatiker Anwendungsentwicklung bei Worlée GmbH, Hamburg', 2017, details: 'Abschluss der Ausbildung mit Note 2,0. Entwicklung und Weiterentwicklung von Anwendungen, z.B. des Reportcenters in Visual Basic.'),
  ];

  static const List<Project> projects = [
    Project(
      title: 'Projekt Reportcenter',
      category: 'Anwendungsentwicklung',
      shortDescription: 'Während der Ausbildung das Reportcenter in Visual Basic unter Verwendung des .Net-Frameworks weiterentwickelt.',
      longDescription: 'Hier könntest du detaillierter beschreiben, was die Herausforderungen und deine Aufgaben waren und welche Ergebnisse erzielt wurden.',
      technologies: ['Visual Basic', '.NET'],
      imagePaths: ['assets/projects/placeholder.jpg'],
      githubRepoUrl: null,
    ),
    Project(
      title: 'Digitales Türschild',
      category: 'Embedded Systems',
      shortDescription: 'Digitales Türschild aufgebaut (Arduino, E-Paper) und Software in C++ programmiert.',
      longDescription: 'Beschreibe hier die Hardware- und Software-Aspekte des Projekts. Welche Bibliotheken hast du genutzt? Wie funktionierte die Ansteuerung des E-Papers?',
      technologies: ['C++', 'Arduino', 'E-Paper'],
      imagePaths: ['assets/projects/placeholder.jpg'],
    ),
    Project(
      title: 'Spieleentwicklung (Pacman Klon)',
      category: 'Spieleentwicklung',
      shortDescription: 'Ein Spiel mit GUI und Interaktionen im Rahmen eines Praktikums programmiert.',
      longDescription: 'Welche Programmiersprache/Engine wurde verwendet? Was waren die Kernfeatures des Spiels? Gab es besondere Algorithmen (z.B. für die Gegner-KI)?',
      technologies: ['Java', 'GUI'],
      imagePaths: ['assets/projects/placeholder.jpg'],
    ),
  ];

  static const List<Skill> skills = [
    Skill(FontAwesomeIcons.windows, 'Windows'),
    Skill(FontAwesomeIcons.linux, 'Linux'),
    Skill(FontAwesomeIcons.java, 'Java'),
    Skill(Icons.code, 'C++'),
    Skill(FontAwesomeIcons.python, 'Python'),
    Skill(Icons.code, 'Haskell'),
    Skill(FontAwesomeIcons.database, 'SQL'),
    Skill(FontAwesomeIcons.gitAlt, 'Git'),
    Skill(FontAwesomeIcons.microsoft, 'Visual Studio'),
    Skill(Icons.developer_mode, 'JetBrains'),
    Skill(Icons.code, 'Visual Basic'),
    Skill(Icons.code, '.NET'),
    Skill(Icons.camera, 'OpenCV'),
    Skill(Icons.code, 'OOP'),
  ];

  static const List<Language> languages = [
    Language('🇦🇪', 'Arabisch', 'Muttersprache', 1.0),
    Language('🇹🇯', 'Kurdisch', 'Muttersprache', 1.0),
    Language('🇩🇪', 'Deutsch', 'Sehr gute Kenntnisse', 0.9),
    Language('🇬🇧', 'Englisch', 'Gute Kenntnisse', 0.7),
    Language('🇫🇷', 'Französisch', 'Grundkenntnisse', 0.4),
  ];

  static const List<Certificate> certificates = [
    Certificate('Berufsschulabschlusszeugnis', '2020', Icons.school, 'URL_ZUM_ZEUGNIS_EINFUEGEN', CertificateCategory.ausbildung),
    Certificate('Berufsausbildungszeugnis', '2020', Icons.work_history, 'URL_ZUM_ZEUGNIS_EINFUEGEN', CertificateCategory.berufserfahrung),
    Certificate('Kurs-Zertifikat Java', '2017', FontAwesomeIcons.java, 'URL_ZUM_ZERTIFIKAT_EINFUEGEN', CertificateCategory.weiterbildung),
  ];
}