// lib/widgets/sections/footer.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:js_portfolio/app/app_theme.dart';
import 'package:js_portfolio/screens/portfolio_page.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:js_portfolio/widgets/common/legal_dialog.dart'; // NEU
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final personalInfo = DataProvider.of(context)!.data.personalInfo;

    final socialLinks = {
      FontAwesomeIcons.github: 'https://github.com',
      FontAwesomeIcons.linkedinIn: 'https://linkedin.com/in/jowan-sulaiman',
      FontAwesomeIcons.xing: 'https://www.xing.com/profile/Jowan_Sulaiman',
    };

    // NEU: Die Texte für die Dialoge werden hier definiert
    final impressumText = '''
Angaben gemäß § 5 TMG

${personalInfo.name}
${personalInfo.location} 

Kontakt:
Telefon: ${personalInfo.phone}
E-Mail: ${personalInfo.email}

Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV:
${personalInfo.name}
Anschrift wie oben.
''';

    const datenschutzText = '''
1. Datenschutz auf einen Blick
Verantwortliche Stelle für die Datenverarbeitung auf dieser Website ist:
${'Jowan Sulaiman'}
${'Am Bahnhof 15, 24232 Schönkirchen'}
Telefon: ${'0176/32429115'}
E-Mail: ${'jowansulaiman@gmail.com'}

2. Hosting & Server-Log-Dateien
Diese Website wird bei einem externen Dienstleister gehostet. Der Hoster erhebt und speichert automatisch Informationen in so genannten Server-Log-Dateien, die Ihr Browser automatisch übermittelt. Dies sind: Browsertyp und Browserversion, verwendetes Betriebssystem, Referrer URL, Hostname des zugreifenden Rechners, Uhrzeit der Serveranfrage und IP-Adresse. Eine Zusammenführung dieser Daten mit anderen Datenquellen wird nicht vorgenommen.

3. Cookies & Lokaler Speicher
Diese Webseite verwendet den lokalen Speicher (Local Storage) Ihres Browsers, um den Freischalt-Status der Seite zu speichern. Dies dient der reinen Funktionalität und es werden dabei keine Daten an uns oder Dritte übertragen.

4. Kontaktanfragen
Wenn Sie uns per Kontaktformular oder E-Mail kontaktieren, werden Ihre Angaben zwecks Bearbeitung der Anfrage und für den Fall von Anschlussfragen bei uns gespeichert. Diese Daten geben wir nicht ohne Ihre Einwilligung weiter.

5. Google Fonts (Lokal)
Diese Seite nutzt zur einheitlichen Darstellung von Schriftarten Google Fonts, die lokal eingebunden sind. Es wird keine Verbindung zu Servern von Google hergestellt.
''';

    void showLegalDialog(String title, String content) {
      showDialog(
        context: context,
        builder: (_) => LegalDialog(title: title, content: content),
      );
    }

    return Container(
      color: Theme.of(context).extension<CustomThemeExtension>()!.accentSectionBackground,
      padding:
      EdgeInsets.symmetric(vertical: context.isPhone ? 40 : 50),
      child: Column(children: [
        Row(
            mainAxisSize: MainAxisSize.min,
            children: socialLinks.entries.map((entry) => IconButton(
              icon: FaIcon(entry.key, size: 18),
              onPressed: () => launchUrl(Uri.parse(entry.value)),
            )).toList()),
        const SizedBox(height: 24),

        // NEU: Links für Impressum und Datenschutz
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => showLegalDialog('Impressum', impressumText),
                child: const Text('Impressum')
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('•'),
            ),
            TextButton(
                onPressed: () => showLegalDialog('Datenschutzerklärung', datenschutzText),
                child: const Text('Datenschutz')
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('© ${DateTime.now().year} ${personalInfo.name}',
            style: Theme.of(context).textTheme.bodySmall),
      ]),
    );
  }
}