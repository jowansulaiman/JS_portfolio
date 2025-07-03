// lib/widgets/sections/certificates_section.dart
//
// Animierte Zertifikate-Section MIT Maus-Hover-Effekt:
// – Karten erscheinen gestaffelt (Fade + Slide).
// – Beim Hover (nur Desktop/Web) leichtes Hochskalieren + stärkere Schatten.
// – Beim Klick-Cursor, wenn das Zertifikat geöffnet werden kann.
//

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:js_portfolio/models/models.dart';
import 'package:js_portfolio/screens/portfolio_page.dart';
import 'package:js_portfolio/utils/file_helper.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/widgets/common/section_headline.dart';


class CertificatesSection extends StatefulWidget {
  const CertificatesSection({super.key});

  @override
  State<CertificatesSection> createState() => _CertificatesSectionState();
}

class _CertificatesSectionState extends State<CertificatesSection> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final allCerts   = DataProvider.of(context)!.data.certificates;
    final categories = allCerts.map((c) => c.category).toSet().toList();

    final filteredCerts = _selectedCategory == null
        ? allCerts
        : allCerts.where((c) => c.category == _selectedCategory).toList();

    return Container(

      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.symmetric(
          vertical: context.isPhone ? 70 : 96, horizontal: 24),
      child: Column(
        children: [
          const SectionHeadline('Zertifikate'),
          const SizedBox(height: 40),

          // Kategorie-Filter ---------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: DropdownButtonFormField<String?>(
                value: _selectedCategory,
                hint: const Text('Kategorie auswählen…'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Alle anzeigen'),
                  ),
                  ...categories.map(
                        (c) => DropdownMenuItem<String?>(
                      value: c,
                      child: Text(c),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _selectedCategory = v),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Karten-Grid mit gestaffelter Animation ----------------------------
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: filteredCerts
                .asMap()
                .entries
                .map((entry) => CertificateCard(certificate: entry.value)
                .animate(onPlay: (c) => c.forward(from: 0))
                .fadeIn(duration: 400.ms, delay: (entry.key * 80).ms)
                .slideY(duration: 400.ms,
                begin: 0.12, curve: Curves.easeOut))
                .toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}

/// ---------------------------------------------------------------------------
/// Karte mit Hover-Animation
/// ---------------------------------------------------------------------------
class CertificateCard extends StatefulWidget {
  const CertificateCard({super.key, required this.certificate});

  final CertificateItem certificate;

  @override
  State<CertificateCard> createState() => _CertificateCardState();
}

class _CertificateCardState extends State<CertificateCard> {
  bool _hovering = false;

  IconData _iconFor(String category) {
    switch (category.toLowerCase()) {
      case 'ausbildung':
        return Icons.school_outlined;
      case 'weiterbildung':
        return FontAwesomeIcons.certificate;
      case 'berufserfahrung':
        return Icons.workspace_premium_outlined;
      default:
        return Icons.verified_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cert      = widget.certificate;
    final clickable = cert.status == CertificateStatus.available &&
        (cert.documentUrl?.isNotEmpty ?? false);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit:  (_) => setState(() => _hovering = false),
      cursor: clickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedScale(                         // Hover-Vergrößerung
        duration: 150.ms,
        curve: Curves.easeOut,
        scale: _hovering ? 1.04 : 1.0,
        child: AnimatedContainer(                   // Hover-Schatten
          duration: 150.ms,
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            boxShadow: [
              if (_hovering)
                BoxShadow(
                  color: Colors.black.withOpacity(.20),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: SizedBox(
            width: 360,
            height: 290,
            child: Card(
              elevation: 4,
              shadowColor: Colors.black.withOpacity(.1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kopfzeile -----------------------------------------------
                    Row(
                      children: [
                        FaIcon(_iconFor(cert.category),
                            size: 16,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          cert.category.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                            color:
                            Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Titel --------------------------------------------------
                    Text(
                      cert.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                          fontWeight: FontWeight.bold, height: 1.3),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${cert.issuer} • ${cert.year}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant),
                    ),
                    const Spacer(),

                    const Divider(height: 1, thickness: 1),
                    const SizedBox(height: 16),

                    // Footer -------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatusPill(status: cert.status),
                        if (clickable)
                          ElevatedButton(
                            onPressed: () => openOrShareFile(
                              cert.documentUrl!,
                              cert.documentUrl!,
                              context,
                            ),
                            child: const Text('Ansehen'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Status-Pill
/// ---------------------------------------------------------------------------
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final CertificateStatus status;

  @override
  Widget build(BuildContext context) {
    late String text;
    late Color bg;
    late Color fg;

    switch (status) {
      case CertificateStatus.available:
        text = 'Verfügbar';
        bg = Colors.green.withOpacity(.15);
        fg = Theme.of(context).brightness == Brightness.dark
            ? Colors.green.shade200
            : Colors.green.shade800;
        break;
      case CertificateStatus.in_progress:
        text = 'In Bearbeitung';
        bg = Colors.blue.withOpacity(.15);
        fg = Theme.of(context).brightness == Brightness.dark
            ? Colors.blue.shade200
            : Colors.blue.shade800;
        break;
      case CertificateStatus.not_available:
        text = 'Nicht verfügbar';
        bg = Colors.grey.withOpacity(.15);
        fg = Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade400
            : Colors.grey.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: fg, fontWeight: FontWeight.bold),
      ),
    );
  }
}
