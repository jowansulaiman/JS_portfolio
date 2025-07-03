// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:js_portfolio/app/data_loader.dart';
import 'package:js_portfolio/screens/loading_screen.dart'; // NEU
import 'package:js_portfolio/screens/portfolio_page.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PortfolioData>(
      future: loadPortfolioData(),
      builder: (context, snapshot) {
        // GEÄNDERT: Zeigt jetzt den neuen Lade-Bildschirm an
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Fehler beim Laden der Daten: ${snapshot.error}')));
        }
        if (snapshot.hasData) {
          return PortfolioPage(
            data: snapshot.data!,
            toggleTheme: toggleTheme,
          );
        }
        return const Scaffold(body: Center(child: Text('Etwas ist schief gelaufen.')));
      },
    );
  }
}