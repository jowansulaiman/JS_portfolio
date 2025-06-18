// lib/widgets/sections/languages_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:js_portfolio/app/app_data.dart';
import 'package:js_portfolio/models/language.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/widgets/common/section_headline.dart';

class LanguagesSection extends StatelessWidget {
  const LanguagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.symmetric(vertical: context.isPhone ? 70 : 96, horizontal: 24),
      child: Column(
        children: [
          const SectionHeadline('Sprachen'),
          const SizedBox(height: 50),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: AppData.languages
                  .map((lang) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: LanguageCard(language: lang),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}

class LanguageCard extends StatelessWidget {
  final Language language;
  const LanguageCard({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(language.flag, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text(language.levelDescription, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: language.proficiency,
                minHeight: 8,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}