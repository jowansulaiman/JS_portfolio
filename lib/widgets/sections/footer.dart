// lib/widgets/sections/footer.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:js_portfolio/app/app_data.dart';
import 'package:js_portfolio/utils/responsive_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding:
      EdgeInsets.symmetric(vertical: context.isPhone ? 60 : 72),
      child: Column(children: [
        const Divider(indent: 80, endIndent: 80),
        const SizedBox(height: 18),
        Text('© ${DateTime.now().year} ${AppData.name}',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        Row(
            mainAxisSize: MainAxisSize.min,
            children: AppData.socialLinks.entries.map((entry) => IconButton(
              icon: FaIcon(entry.key, size: 18),
              onPressed: () => launchUrl(Uri.parse(entry.value)),
            )).toList()),
      ]),
    );
  }
}