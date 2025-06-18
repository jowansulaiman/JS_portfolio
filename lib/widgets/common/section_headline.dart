// lib/widgets/common/section_headline.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';

class SectionHeadline extends StatelessWidget {
  final String text;
  const SectionHeadline(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.playfairDisplay(
        fontSize: context.isPhone ? 34.0 : 42.0, fontWeight: FontWeight.bold);

    return Text(text, textAlign: TextAlign.center, style: style);
  }
}