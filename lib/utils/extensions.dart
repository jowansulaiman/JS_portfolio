// lib/utils/extensions.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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