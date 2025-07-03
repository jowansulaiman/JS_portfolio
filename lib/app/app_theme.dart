// lib/app/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// GEÄNDERT: Die Erweiterung enthält jetzt zwei verschiedene Hintergrundfarben.
@immutable
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  const CustomThemeExtension({
    required this.mainSectionBackground,
    required this.accentSectionBackground,
  });

  final Color? mainSectionBackground;
  final Color? accentSectionBackground;

  @override
  CustomThemeExtension copyWith({Color? mainSectionBackground, Color? accentSectionBackground}) {
    return CustomThemeExtension(
      mainSectionBackground: mainSectionBackground ?? this.mainSectionBackground,
      accentSectionBackground: accentSectionBackground ?? this.accentSectionBackground,
    );
  }

  @override
  CustomThemeExtension lerp(CustomThemeExtension? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      mainSectionBackground: Color.lerp(mainSectionBackground, other.mainSectionBackground, t),
      accentSectionBackground: Color.lerp(accentSectionBackground, other.accentSectionBackground, t),
    );
  }
}


class AppTheme {
  static final _lightSeedColor = const Color(0xFF9A7B4F);
  static final _darkSeedColor = const Color(0xFFD7B36B);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _lightSeedColor,
      brightness: Brightness.light,
      background: const Color(0xFFFCFBF8), // Der hellste Hintergrund
    ),
    scaffoldBackgroundColor: const Color(0xFFFCFBF8),
    textTheme: GoogleFonts.poppinsTextTheme(),
    extensions: const <ThemeExtension<dynamic>>[
      CustomThemeExtension(
        mainSectionBackground: Color(0xFFFCFBF8), // Selbe Farbe wie Haupt-Hintergrund
        accentSectionBackground: Color(0xFFF3EFEA), // Der etwas dunklere Akzent-Hintergrund
      ),
    ],
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _darkSeedColor,
      brightness: Brightness.dark,
      background: const Color(0xFF1A1A1A), // Der dunkelste Hintergrund
      surface: const Color(0xFF2C2C2C),      // Farbe für Karten
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
    extensions: const <ThemeExtension<dynamic>>[
      CustomThemeExtension(
        mainSectionBackground: Color(0xFF1A1A1A), // Selbe Farbe wie Haupt-Hintergrund
        accentSectionBackground: Color(0xFF232323), // Der etwas hellere Akzent-Hintergrund
      ),
    ],
  );
}