// lib/widgets/sections/skills_section.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:js_portfolio/models/skill_category.dart';
import 'package:js_portfolio/utils/extensions.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/widgets/common/section_headline.dart';


// GEÄNDERT: Zu einem StatefulWidget umgewandelt, um den TabController zu verwalten.
class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> with SingleTickerProviderStateMixin {
  late Future<List<SkillCategory>> _skillsFuture;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _skillsFuture = _loadSkills();
  }

  Future<List<SkillCategory>> _loadSkills() async {
    final jsonString = await rootBundle.loadString('assets/data/skills.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final categories = jsonMap.entries
        .map((entry) => SkillCategory.fromJson(entry.key, entry.value))
        .toList();

    // Initialisiere den TabController, nachdem die Daten geladen wurden
    setState(() {
      _tabController = TabController(length: categories.length, vsync: this);
    });

    return categories;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  IconData _getIconForSkill(String skillName) {
    switch (skillName.toLowerCase()) {
      case 'java':
        return FontAwesomeIcons.java;
      case 'python':
        return FontAwesomeIcons.python;
      case 'c++':
        return FontAwesomeIcons.c;
      case 'haskell':
        return Icons.functions;
      case 'sql':
        return FontAwesomeIcons.database;
      case 'git':
        return FontAwesomeIcons.gitAlt;
      case 'linux':
        return FontAwesomeIcons.linux;
      case 'windows':
        return FontAwesomeIcons.windows;
      case 'visual studio':
        return FontAwesomeIcons.microsoft;
      case 'jetbrains ides':
        return Icons.developer_mode;
      case 'opencv':
        return Icons.camera;
      default:
        return Icons.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Theme.of(context).colorScheme.primaryContainer,
      Theme.of(context).colorScheme.secondaryContainer,
      Theme.of(context).colorScheme.tertiaryContainer,
    ];

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.background,

      padding: EdgeInsets.symmetric(vertical: context.isPhone ? 70 : 96, horizontal: 24),
      child: Column(children: [
        const SectionHeadline('Kompetenzen'),
        const SizedBox(height: 50),
        FutureBuilder<List<SkillCategory>>(
          future: _skillsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || _tabController == null) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Text('Kompetenzen konnten nicht geladen werden.');
            }
            final skillCategories = snapshot.data!;

            // NEU: Die gesamte Sektion ist jetzt in einem DefaultTabController verpackt.
            return DefaultTabController(
              length: skillCategories.length,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      isScrollable: context.isPhone,
                      tabs: skillCategories
                          .map((c) => Tab(text: c.categoryName))
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                    // Der TabBarView benötigt eine feste Höhe
                    SizedBox(
                      height: 150, // Höhe nach Bedarf anpassen
                      child: TabBarView(
                        controller: _tabController,
                        children: skillCategories.map((category) {
                          // Der Inhalt jedes Tabs ist eine scrollbare Liste von Chips
                          return SingleChildScrollView(
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: category.skills.asMap().entries.map((entry) {
                                final index = entry.key;
                                final skill = entry.value;

                                return Chip(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  backgroundColor: colors[index % colors.length],
                                  avatar: FaIcon(
                                    _getIconForSkill(skill),
                                    size: 18,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  label: Text(skill),
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontWeight: FontWeight.w600
                                  ),
                                  side: BorderSide.none,
                                )
                                    .addHoverEffect()
                                    .animate(delay: (100 * index).ms)
                                    .fadeIn(duration: 400.ms)
                                    .slideY(begin: 0.5, curve: Curves.easeOut);
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}