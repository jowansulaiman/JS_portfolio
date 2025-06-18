// lib/widgets/sections/hero_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:js_portfolio/models/cv_data.dart';
import 'package:js_portfolio/screens/portfolio_page.dart'; // Import für den DataProvider
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/widgets/common/image_preview_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  final void Function(int) onJump;
  final bool isUnlocked;
  final VoidCallback onUnlock;
  final VoidCallback onAccessRequest;

  const HeroSection({
    super.key,
    required this.onJump,
    required this.isUnlocked,
    required this.onUnlock,
    required this.onAccessRequest,
  });

  @override
  Widget build(BuildContext context) {
    // Daten aus dem Kontext holen, anstatt von AppData
    final portfolioData = DataProvider.of(context)!.data;

    Widget profileCard = _ProfileCard(personalInfo: portfolioData.personalInfo);
    Widget introContent = _IntroContent(
      summary: portfolioData.summary,
      onJump: onJump,
      isUnlocked: isUnlocked,
      onUnlock: onUnlock,
      onAccessRequest: onAccessRequest,
    );

    final height = MediaQuery.of(context).size.height;

    if (context.isPhone) {
      return Column(children: [profileCard, introContent]);
    }

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 3, child: profileCard),
          Expanded(flex: 4, child: introContent),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final PersonalInfo personalInfo;
  const _ProfileCard({required this.personalInfo});

  @override
  Widget build(BuildContext context) {
    // Daten, die nicht aus JSON kommen, sind hier lokal definiert.
    const profileImagePath = 'assets/profile.jpg';
    final socialLinks = {
      FontAwesomeIcons.github: 'https://github.com',
      FontAwesomeIcons.linkedinIn: 'https://linkedin.com',
      FontAwesomeIcons.xing: 'https://www.xing.com',
    };

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!context.isPhone) const Spacer(flex: 2),
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (_) =>
              const ImagePreviewDialog(imagePath: profileImagePath),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(profileImagePath),
                ),
                IgnorePointer(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.zoom_in_map_rounded,
                        color: Colors.white, size: 28),
                  )
                      .animate(delay: 1200.ms)
                      .scale(
                      duration: 500.ms,
                      begin: const Offset(0.5, 0.5),
                      curve: Curves.easeOutBack)
                      .then(delay: 2500.ms)
                      .fadeOut(duration: 800.ms),
                ),
              ],
            ).animate().scale(duration: 500.ms, curve: Curves.easeOut),
          ),
          const SizedBox(height: 24),
          // Daten aus dem Model verwenden
          Text(personalInfo.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
              height: 2,
              width: 40,
              color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          // Daten aus dem Model verwenden
          Text(personalInfo.title.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(letterSpacing: 3)),
          context.isPhone ? const SizedBox(height: 32) : const Spacer(flex: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: socialLinks.entries.map((entry) {
              return IconButton(
                icon: FaIcon(entry.key, size: 20),
                onPressed: () => launchUrl(Uri.parse(entry.value)),
              );
            }).toList(),
          ),
          if (!context.isPhone) const Spacer(flex: 1),
        ],
      ),
    );
  }
}

class _IntroContent extends StatelessWidget {
  final String summary;
  final void Function(int) onJump;
  final bool isUnlocked;
  final VoidCallback onUnlock;
  final VoidCallback onAccessRequest;

  const _IntroContent({
    required this.summary,
    required this.onJump,
    required this.isUnlocked,
    required this.onUnlock,
    required this.onAccessRequest,
  });

  void _handlePress(BuildContext context, int index) {
    if (isUnlocked) {
      onJump(index);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bitte schalten Sie die Seite zuerst frei.'),
            duration: Duration(seconds: 2)),
      );
      Future.delayed(const Duration(milliseconds: 500), onUnlock);
    }
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 16, height: 1.7);
    final buttonPadding = EdgeInsets.symmetric(
      horizontal: context.isPhone ? 24 : 32,
      vertical: 18,
    );
    final buttonStyle = ElevatedButton.styleFrom(
      padding: buttonPadding,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    return Container(
      color: Theme.of(context).colorScheme.background,
      padding:
      EdgeInsets.symmetric(horizontal: context.isPhone ? 24 : 60, vertical: 80),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hallo',
                style: GoogleFonts.playfairDisplay(
                    fontSize: context.isPhone ? 60 : 82,
                    fontWeight: FontWeight.bold,
                    height: 1.2)),
            const SizedBox(height: 16),
            Text('Wer ich bin & was ich mache',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 32),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _handlePress(context, 1),
                    style: buttonStyle,
                    child: const Text('LEBENSLAUF'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () => _handlePress(context, 2),
                    style: buttonStyle,
                    child: const Text('PROJEKTE'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Text wird jetzt aus der JSON-Datei geladen
            Text(
              summary,
              style: textStyle,
            ),
            if (!isUnlocked) ...[
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: onAccessRequest,
                  child: const Text('Noch keinen Code? Jetzt Zugang anfragen'),
                ),
              ),
            ]
          ],
        ).animate().fade(delay: 200.ms, duration: 500.ms).slideX(begin: 0.1),
      ),
    );
  }
}