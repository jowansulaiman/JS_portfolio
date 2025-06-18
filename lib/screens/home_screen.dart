// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:js_portfolio/app/data_loader.dart';
import 'package:js_portfolio/screens/portfolio_page.dart'; // NEU: Die eigentliche Seite

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    // FutureBuilder lädt die Daten und zeigt je nach Status (laden, fertig, fehler) eine andere UI an.
    return FutureBuilder<PortfolioData>(
      future: loadPortfolioData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Fehler beim Laden der Daten: ${snapshot.error}')));
        }
        if (snapshot.hasData) {
          // Wenn die Daten da sind, bauen wir die Hauptseite und übergeben die Daten.
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