// lib/widgets/sections/hero_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:js_portfolio/app/app_theme.dart';
import 'package:js_portfolio/models/models.dart';
import 'package:js_portfolio/screens/portfolio_page.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/widgets/common/image_preview_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // NEU: Import für die Animation

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
  Widget _buildBackgroundBubbles(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        // Blase 1
        Positioned(
          top: 100,
          left: 50,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.08),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true), delay: 300.ms)
              .move(duration: 8000.ms, begin: Offset.zero, end: const Offset(20, -80), curve: Curves.easeInOut),
        ),
        // Blase 2
        Positioned(
          top: 250,
          right: 80,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.05),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
              .move(duration: 12000.ms, begin: Offset.zero, end: const Offset(-50, 100), curve: Curves.easeInOut),
        ),
        // Blase 3
        Positioned(
          bottom: 60,
          left: -40,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.03),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true), delay: 1000.ms)
              .move(duration: 15000.ms, begin: Offset.zero, end: const Offset(80, -120), curve: Curves.easeInOut),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const profileImagePath = 'assets/profile.jpg';
    final socialLinks = {
      FontAwesomeIcons.github: 'https://github.com/jowansulaiman',
      FontAwesomeIcons.linkedinIn: 'https://linkedin.com/in/jowan-sulaiman',
      FontAwesomeIcons.xing: 'https://www.xing.com/profile/Jowan_Sulaiman',
    };

    // NEU: Liste der Texte, die animiert werden sollen
    const animatedTexts = [
      'Software Developer',
      'Cybersecurity',
      'Programmierung',
      'Automatisierung',
      'Java & Python',
      'Flutter & Dart',
    ];

    // Style für den animierten Text, damit er zum Design passt
    final textStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(letterSpacing: 3);


    return Container(
      color: Theme.of(context).extension<CustomThemeExtension>()!.accentSectionBackground,

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

          // GEÄNDERT: Statischer Text wurde durch die Animation ersetzt
          SizedBox(
            height: 20, // Feste Höhe, um Springen zu verhindern
            child: AnimatedTextKit(
              animatedTexts: animatedTexts.map((text) => TypewriterAnimatedText(
                text.toUpperCase(),
                textStyle: textStyle,
                speed: const Duration(milliseconds: 100),
              )).toList(),
              pause: const Duration(milliseconds: 500),
              repeatForever: true,
            ),
          ),

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
            const SizedBox(height: 30),
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
            Text(
              summary,
              style: textStyle,
              // maxLines: 7, <-- ENTFERNT
              // overflow: TextOverflow.ellipsis, <-- ENTFERNT
            ),
            const SizedBox(height: 24),
            if (!isUnlocked)
              TextButton(
                onPressed: onAccessRequest,
                child: const Text('Noch keinen Code? Jetzt Zugang anfragen'),
              ),
          ],
        ).animate().fade(delay: 200.ms, duration: 500.ms).slideX(begin: 0.1),
      ),
    );
  }
}