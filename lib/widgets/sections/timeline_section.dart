// lib/widgets/sections/timeline_section.dart
//
//  Timeline-Section  •  Accordion-Version  •  Overflow-Fix
// ─────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:js_portfolio/models/models.dart';
import 'package:js_portfolio/utils/file_helper.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/utils/extensions.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../screens/portfolio_page.dart';

/*─────────────────────────── SECTION ───────────────────────────*/
class TimelineSection extends StatefulWidget {
  const TimelineSection({super.key});
  @override
  State<TimelineSection> createState() => _TimelineSectionState();
}

class _TimelineSectionState extends State<TimelineSection> {
  int? _selectedYear;
  final List<int> _uniqueYears = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _collectUniqueYears();
  }

  void _collectUniqueYears() {
    final data = DataProvider.of(context)?.data;
    if (data == null) return;

    final years = <int>{
      ...data.workExperience.map((e) => e.startYear).whereType<int>(),
      ...data.education.map((e) => e.startYear).whereType<int>(),
    }.toList()
      ..sort((a, b) => b.compareTo(a));

    if (!listEquals(years, _uniqueYears)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _uniqueYears
              ..clear()
              ..addAll(years);
          });
        }
      });
    }
  }

  List<T> _filterByYear<T>(Iterable<T> src, int? Function(T) y) =>
      _selectedYear == null ? src.toList() : src.where((e) => y(e) == _selectedYear).toList();

  @override
  Widget build(BuildContext context) {
    final data = DataProvider.of(context)!.data;

    final work = _filterByYear<ExperienceItem>(data.workExperience, (e) => e.startYear)
      ..sort((a, b) => (b.startYear ?? 0).compareTo(a.startYear ?? 0));
    final edu = _filterByYear<EducationItem>(data.education, (e) => e.startYear)
      ..sort((a, b) => (b.startYear ?? 0).compareTo(a.startYear ?? 0));

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: context.isPhone ? 60 : 96),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SectionHeadline('Lebenslauf'),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('CV herunterladen'),
                onPressed: () => openOrShareFile(
                  'assets/documents/Lebenslauf.pdf',
                  'assets/documents/Lebenslauf.pdf?v=${DateTime.now().millisecondsSinceEpoch}',
                  context,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _YearFilterChips(
              years: _uniqueYears,
              selected: _selectedYear,
              onChange: (y) => setState(() => _selectedYear = y),
            ),
            const SizedBox(height: 56),
            _CategorySection(title: 'Berufserfahrung', events: work),
            const SizedBox(height: 56),
            _CategorySection(title: 'Bildungsweg', events: edu),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}

/*─────────────────────────── YEAR CHIPS ───────────────────────────*/
class _YearFilterChips extends StatelessWidget {
  const _YearFilterChips({
    required this.years,
    required this.selected,
    required this.onChange,
  });
  final List<int> years;
  final int? selected;
  final ValueChanged<int?> onChange;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 12,
    alignment: WrapAlignment.center,
    children: [
      FilterChip(
        label: const Text('Alle'),
        selected: selected == null,
        onSelected: (_) => onChange(null),
      ),
      ...years.map((y) => FilterChip(
        label: Text('$y'),
        selected: selected == y,
        onSelected: (v) => onChange(v ? y : null),
      )),
    ],
  );
}

/*─────────────────────────── CATEGORY ───────────────────────────*/
/*─────────────────────────── CATEGORY ───────────────────────────*/
class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.title, required this.events});
  final String title;
  final List<dynamic> events;

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 24),
          child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        ),
        if (events.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text('Für das ausgewählte Jahr gibt es hier keine Einträge.'),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemBuilder: (_, i) {
              final e = events[i];
              return TimelineTile(
                alignment: TimelineAlign.manual,
                lineXY: 0.065,
                isFirst: i == 0,
                isLast: i == events.length - 1,
                indicatorStyle: IndicatorStyle(
                  width: 14,
                  height: 14,
                  indicator: Container(
                    decoration: BoxDecoration(
                      color: p,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
                beforeLineStyle: LineStyle(color: p.withOpacity(.35), thickness: 2),
                afterLineStyle: LineStyle(color: p.withOpacity(.35), thickness: 2),
                endChild: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  // --- HIER IST DIE NEUE KREATIVE ANIMATION ---
                  child: _TimelineEntryCard.from(e)
                      .animate(
                    // Die Verzögerung wird auf die gesamte Animationskette angewendet
                    delay: (200 * i).ms,
                  )
                      .fadeIn(duration: 600.ms, curve: Curves.easeOutCubic)
                      .scaleXY(
                    begin: 0.9, // Startet bei 90% der Größe
                    duration: 600.ms,
                    curve: Curves.easeOutCubic,
                  )
                      .blur(
                    begin: const Offset(8, 8), // Startet weichgezeichnet
                    end: Offset.zero,
                    duration: 700.ms,
                    curve: Curves.easeOut,
                  )
                      .slideX(
                    begin: -0.5, // Gleitet von links herein
                    duration: 700.ms,
                    curve: Curves.easeOutCubic,
                  )
                      .then(delay: 500.ms) // Kurze Pause nach der Hauptanimation
                      .shimmer(
                    // Einmaliger Glanz-Effekt am Ende
                    duration: 1200.ms,
                    angle: 45,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                  ),
                  // --- ENDE DER ANIMATION ---
                ),
              );
            },
          ),
      ],
    );
  }
}
/*─────────────────────────── CARD (Accordion) ───────────────────────────*/
class _TimelineEntryCard extends StatefulWidget {
  final String title, subtitle, period;
  final String? description;
  const _TimelineEntryCard({
    required this.title,
    required this.subtitle,
    required this.period,
    this.description,
  });

  factory _TimelineEntryCard.from(dynamic e) {
    if (e is ExperienceItem) {
      return _TimelineEntryCard(
        title: e.title,
        subtitle: '${e.company} • ${e.location}',
        period: e.period,
        description: e.description,
      );
    } else {
      final ed = e as EducationItem;
      return _TimelineEntryCard(
        title: ed.degree,
        subtitle: ed.institution,
        period: ed.period,
        description: null,
      );
    }
  }

  @override
  State<_TimelineEntryCard> createState() => _TimelineEntryCardState();
}

/*─────────────────────────── CARD (Accordion) ───────────────────────────*/

// ... (die _TimelineEntryCard Klasse bleibt gleich) ...

// in lib/widgets/sections/timeline_section.dart

class _TimelineEntryCardState extends State<_TimelineEntryCard> with SingleTickerProviderStateMixin {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Prüfen, ob die Karte Details zum Ausklappen hat.
    final bool isExpandable = widget.description != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.period,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            // --- HIER IST DIE 1. KORREKTUR ---
            // onTap wird auf null gesetzt, wenn die Karte nicht ausklappbar ist.
            // Dadurch wird sie nicht mehr klickbar.
            onTap: isExpandable
                ? () {
              setState(() => _open = !_open);
              if (!_open == false) { // Logik korrigiert, um nur beim Öffnen zu scrollen
                Future.delayed(const Duration(milliseconds: 350), () {
                  if (mounted) {
                    Scrollable.ensureVisible(
                      context,
                      alignment: 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
                    );
                  }
                });
              }
            }
                : null,
            child: ClipRect(
              child: AnimatedSize(
                duration: 300.ms,
                curve: Curves.easeInOut,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.title,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.subtitle,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: cs.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Accent-Bar
                          Container(
                            width: 40,
                            color: cs.primary,
                            child: Center(
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: FittedBox(
                                  // --- HIER IST DIE 2. KORREKTUR ---
                                  // Der Text wird nur angezeigt, wenn die Karte ausklappbar ist.
                                  child: isExpandable
                                      ? Text(
                                    _open ? '–  Weniger' : '+  Details',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                      : const SizedBox.shrink(), // Zeigt nichts an, wenn nicht ausklappbar
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Content
                    if (_open && isExpandable) ...[
                      const Divider(height: 1, thickness: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        child: Text(
                          widget.description!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/*─────────────────────────── HEADLINE UTIL ───────────────────────────*/
class SectionHeadline extends StatelessWidget {
  final String text;
  const SectionHeadline(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
  );
}