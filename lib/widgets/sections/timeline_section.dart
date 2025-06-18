// lib/widgets/sections/timeline_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:js_portfolio/app/app_data.dart';
import 'package:js_portfolio/models/timeline_event.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/widgets/common/section_headline.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart'; // NEU: Import für den Link

class TimelineSection extends StatefulWidget {
  const TimelineSection({super.key});

  @override
  State<TimelineSection> createState() => _TimelineSectionState();
}

class _TimelineSectionState extends State<TimelineSection> {
  int? _selectedYear;
  late final List<int> _uniqueYears;

  @override
  void initState() {
    super.initState();
    _uniqueYears = AppData.timeline.map((e) => e.startYear).toSet().toList()..sort((a,b) => b.compareTo(a));
  }

  // NEU: Funktion zum Öffnen der PDF
  void _downloadCV() {
    launchUrl(Uri.parse('assets/PDFS/cv.pdf'));
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final filteredTimeline = _selectedYear == null
        ? AppData.timeline
        : AppData.timeline.where((event) => event.startYear == _selectedYear).toList();

    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.symmetric(
          horizontal: 24, vertical: context.isPhone ? 60 : 96),
      child: Column(children: [
        const SectionHeadline('Lebenslauf'),
        const SizedBox(height: 24),

        // NEU: Der Download-Button an seiner neuen Position
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonalIcon(
              onPressed: _downloadCV,
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('CV Herunterladen'),
            ),
          ),
        ),
        const SizedBox(height: 24),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            FilterChip(
              label: const Text('Alle'),
              selected: _selectedYear == null,
              onSelected: (selected) {
                setState(() => _selectedYear = null);
              },
            ),
            ..._uniqueYears.map((year) => FilterChip(
              label: Text(year.toString()),
              selected: _selectedYear == year,
              onSelected: (selected) {
                setState(() {
                  _selectedYear = selected ? year : null;
                });
              },
            ))
          ],
        ),
        const SizedBox(height: 56),

        if (filteredTimeline.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('Keine Einträge für das ausgewählte Jahr gefunden.'),
          )
        else
          ...filteredTimeline.asMap().entries.map((entry) {
            final index = entry.key;
            final event = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TimelineTile(
                alignment: TimelineAlign.manual,
                lineXY: 0.1,
                isFirst: index == 0,
                isLast: index == filteredTimeline.length - 1,
                indicatorStyle: IndicatorStyle(
                  width: 30,
                  height: 30,
                  indicator: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 2),
                          shape: BoxShape.circle),
                      child: Center(
                          child: Container(
                            width: 15, height: 15,
                            decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                          )
                      )),
                ),
                beforeLineStyle: LineStyle(color: primaryColor.withOpacity(0.5), thickness: 2),
                afterLineStyle: LineStyle(color: primaryColor.withOpacity(0.5), thickness: 2),
                endChild: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: _ExpandableTimelineTile(event: event)
                      .animate(onPlay: (c) => c.forward(from: 0))
                      .slideX(begin: -.25, duration: 400.ms, delay: 100.ms)
                      .fadeIn(),
                ),
              ),
            );
          })
      ]),
    ).animate().fadeIn(duration: 600.ms);
  }
}

class _ExpandableTimelineTile extends StatefulWidget {
  final TimelineEvent event;
  const _ExpandableTimelineTile({required this.event});

  @override
  State<_ExpandableTimelineTile> createState() => _ExpandableTimelineTileState();
}

class _ExpandableTimelineTileState extends State<_ExpandableTimelineTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool isExpandable = widget.event.details?.isNotEmpty ?? false;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isExpandable ? () => setState(() => _isExpanded = !_isExpanded) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.event.date,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isExpandable)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: 200.ms,
                          child: const Icon(Icons.expand_more),
                        ),
                      ),
                  ],
                ),
                if (isExpandable)
                  AnimatedCrossFade(
                    firstChild: const SizedBox(width: double.infinity, height: 0),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 12.0, right: 8.0),
                      child: Text(
                        widget.event.details!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: 300.ms,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}