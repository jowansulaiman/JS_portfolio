// lib/widgets/sections/skills_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:js_portfolio/app/app_data.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/widgets/common/section_headline.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding:
      EdgeInsets.symmetric(vertical: context.isPhone ? 70 : 96),
      child: Column(children: [
        const SectionHeadline('Kompetenzen'),
        const SizedBox(height: 40),
        Wrap(
          spacing: 18,
          runSpacing: 18,
          alignment: WrapAlignment.center,
          children: AppData.skills
              .map((skill) => Chip(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            avatar: FaIcon(skill.icon,
                size: 16,
                color: Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer),
            label: Text(skill.name),
            labelStyle: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer),
            backgroundColor:
            Theme.of(context).colorScheme.secondaryContainer,
          ))
              .toList(),
        ),
      ]),
    ).animate().fadeIn(duration: 600.ms);
  }
}