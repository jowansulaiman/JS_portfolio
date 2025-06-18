// lib/app/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final _lightSeedColor = const Color(0xFF9A7B4F);
  static final _darkSeedColor = const Color(0xFFD7B36B);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _lightSeedColor,
      brightness: Brightness.light,
      surfaceContainer: const Color(0xFFF3EFEA),
      background: const Color(0xFFFCFBF8),
    ),
    scaffoldBackgroundColor: const Color(0xFFFCFBF8),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _darkSeedColor,
      brightness: Brightness.dark,
      background: const Color(0xFF1A1A1A),
      surface: const Color(0xFF242424),
      surfaceContainer: const Color(0xFF282828),
      onSurface: const Color(0xFFE0E0E0),
      onBackground: const Color(0xFFE0E0E0),
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
  );
}