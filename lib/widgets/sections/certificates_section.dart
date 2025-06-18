// lib/widgets/sections/certificates_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:js_portfolio/app/app_data.dart';
import 'package:js_portfolio/models/certificate.dart';
import 'package:js_portfolio/utils/extensions.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/widgets/common/section_headline.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificatesSection extends StatefulWidget {
  const CertificatesSection({super.key});

  @override
  State<CertificatesSection> createState() => _CertificatesSectionState();
}

class _CertificatesSectionState extends State<CertificatesSection> {
  CertificateCategory? _selectedCategory;

  String _getCategoryName(CertificateCategory category) {
    switch (category) {
      case CertificateCategory.berufserfahrung:
        return 'Berufserfahrung';
      case CertificateCategory.ausbildung:
        return 'Ausbildung';
      case CertificateCategory.weiterbildung:
        return 'Weiterbildung';
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableCategories = AppData.certificates.map((c) => c.category).toSet().toList();
    final filteredCerts = _selectedCategory == null
        ? AppData.certificates
        : AppData.certificates.where((cert) => cert.category == _selectedCategory).toList();

    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.symmetric(vertical: context.isPhone ? 70 : 96, horizontal: 24),
      child: Column(children: [
        const SectionHeadline('Zertifikate'),
        const SizedBox(height: 40),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: DropdownButtonFormField<CertificateCategory?>(
              value: _selectedCategory,
              hint: const Text('Kategorie auswählen...'),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: [
                const DropdownMenuItem<CertificateCategory?>(
                  value: null,
                  child: Text('Alle anzeigen'),
                ),
                ...availableCategories.map((category) {
                  return DropdownMenuItem<CertificateCategory?>(
                    value: category,
                    child: Text(_getCategoryName(category)),
                  );
                }),
              ],
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 40),

        Wrap(
          spacing: 16, runSpacing: 16,
          alignment: WrapAlignment.center,
          children: filteredCerts
              .map((cert) => CertificateCard(certificate: cert))
              .toList(),
        ),
      ]),
    ).animate().fadeIn(duration: 600.ms);
  }
}

class CertificateCard extends StatelessWidget {
  final Certificate certificate;
  const CertificateCard({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.isPhone ? double.infinity : 320,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => launchUrl(Uri.parse(certificate.url), mode: LaunchMode.externalApplication),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: FaIcon(certificate.icon, size: 20, color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            title: Text(certificate.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            subtitle: Text(certificate.year),
            trailing: const Icon(Icons.open_in_new_rounded, size: 20),
          ),
        ),
      ),
    ).addHoverEffect();
  }
}