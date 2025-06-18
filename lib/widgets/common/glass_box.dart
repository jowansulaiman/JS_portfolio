// lib/widgets/common/glass_box.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBox extends StatelessWidget {
  final Widget child;
  final double r;
  final EdgeInsetsGeometry? padding;

  const GlassBox({
    super.key,
    required this.child,
    this.r = 32,
    this.padding
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(r),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
        ),
        child: child,
      ),
    ),
  );
}