// lib/utils/extensions.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:js_portfolio/models/models.dart';

extension HoverEffect on Widget {
  Widget addHoverEffect({Offset scale = const Offset(1.02, 1.02)}) =>
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Animate(
            target: 1,
            effects: [
              ScaleEffect(
                  begin: const Offset(1, 1), end: scale, duration: 200.ms)
            ],
            child: this),
      );
}

// Stellt sicher, dass diese Erweiterungen vorhanden sind.
extension ExperienceItemParsing on ExperienceItem {
  int? get startYear {
    final match = RegExp(r'\b\d{4}\b').firstMatch(period);
    return match != null ? int.tryParse(match.group(0)!) : null;
  }
}

extension EducationItemParsing on EducationItem {
  int? get startYear {
    final match = RegExp(r'\b\d{4}\b').firstMatch(period);
    return match != null ? int.tryParse(match.group(0)!) : null;
  }
}