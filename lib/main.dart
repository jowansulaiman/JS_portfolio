// lib/main.dart
import 'package:flutter/material.dart';
import 'package:js_portfolio/app/app_theme.dart';
import 'package:js_portfolio/screens/home_screen.dart';

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});
  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  final _themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: _themeModeNotifier,
    builder: (context, currentMode, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jowan Sulaiman',
      themeMode: currentMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: HomeScreen(
        toggleTheme: () {
          _themeModeNotifier.value =
          currentMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
        },
      ),
    ),
  );
}