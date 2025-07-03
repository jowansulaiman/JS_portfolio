// lib/widgets/sections/languages_section.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:js_portfolio/models/language_item.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/widgets/common/section_headline.dart';

import '../../app/app_theme.dart';

// GEÄNDERT: Lädt seine Daten jetzt selbst aus der JSON-Datei
class LanguagesSection extends StatefulWidget {
  const LanguagesSection({super.key});

  @override
  State<LanguagesSection> createState() => _LanguagesSectionState();
}

class _LanguagesSectionState extends State<LanguagesSection> {
  late Future<List<LanguageItem>> _languagesFuture;

  @override
  void initState() {
    super.initState();
    _languagesFuture = _loadLanguages();
  }

  Future<List<LanguageItem>> _loadLanguages() async {
    final jsonString = await rootBundle.loadString('assets/data/languages.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => LanguageItem.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).extension<CustomThemeExtension>()!.accentSectionBackground,

      padding: EdgeInsets.symmetric(vertical: context.isPhone ? 70 : 96, horizontal: 24),
      child: Column(
        children: [
          const SectionHeadline('Sprachen'),
          const SizedBox(height: 50),
          FutureBuilder<List<LanguageItem>>(
            future: _languagesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Center(child: Text('Sprachen konnten nicht geladen werden.'));
              }
              final languages = snapshot.data!;
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: languages
                      .map((lang) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: LanguageCard(language: lang),
                  ))
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}

class LanguageCard extends StatelessWidget {
  final LanguageItem language;
  const LanguageCard({super.key, required this.language});

  Widget _buildProficiencyDots(BuildContext context, double proficiency) {
    final filledDots = (proficiency * 5).round();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Icon(
            index < filledDots ? Icons.circle : Icons.circle_outlined,
            size: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      }),
    );
  }

  String _getFlagForLanguage(String langName) {
    switch (langName.toLowerCase()) {
      case 'arabisch': return '🇦🇪';
      case 'kurdisch': return '🇹🇯';
      case 'deutsch': return '🇩🇪';
      case 'englisch': return '🇬🇧';
      case 'französisch': return '🇫🇷';
      default: return '🏳️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Text(_getFlagForLanguage(language.language), style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(language.language, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                      language.level,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _buildProficiencyDots(context, language.proficiency),
          ],
        ),
      ),
    );
  }
}