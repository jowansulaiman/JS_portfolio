// lib/widgets/common/quick_contact_fab.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Ein moderner FloatingActionButton, der ein Kontaktmenü in einem BottomSheet anzeigt.
class QuickContactFAB extends StatelessWidget {
  const QuickContactFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showContactMenu(context),
      icon: const Icon(Icons.contact_phone_outlined),
      label: const Text('Kontakt'),
    );
  }

  /// Zeigt das neugestaltete Kontaktmenü als Grid an.
  void _showContactMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // NEU: Diese beiden Eigenschaften machen das Menü scrollbar und verhindern den Overflow.
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        // NEU: Mit SingleChildScrollView umschlossen.
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Visueller "Drag Handle"
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Kontakt aufnehmen',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                // Das 2x2 Grid für die Aktionen
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _ContactMenuButton(
                      label: 'Anrufen',
                      icon: Icons.call_outlined,
                      onTap: () {
                        Navigator.pop(ctx);
                        launchUrl(Uri.parse('tel:+4917632429115'));
                      },
                    ),
                    _ContactMenuButton(
                      label: 'E-Mail',
                      icon: Icons.email_outlined,
                      onTap: () {
                        Navigator.pop(ctx);
                        launchUrl(Uri.parse('mailto:jowansulaiman@gmail.com'));
                      },
                    ),
                    _ContactMenuButton(
                      label: 'QR-Code',
                      icon: Icons.qr_code_2_outlined,
                      onTap: () {
                        Navigator.pop(ctx);
                        _showQrCodeDialog(context);
                      },
                    ),
                    _ContactMenuButton(
                      label: 'Formular',
                      icon: Icons.edit_note_outlined,
                      onTap: () {
                        Navigator.pop(ctx);
                        _showContactForm(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Zeigt den QR-Code mit den Kontaktdaten als vCard an.
  void _showQrCodeDialog(BuildContext context) {
    const contactData = 'MECARD:N:Jowan Sulaiman;TEL:+4917632429115;EMAIL:jowansulaiman@gmail.com;;';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Kontaktdaten scannen', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              height: 200,
              child: QrImageView(
                data: contactData,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Schließen'),
            )
          ],
        ),
      ),
    );
  }

  /// Zeigt das Kontaktformular in einem zweiten BottomSheet.
  void _showContactForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final companyController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final messageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Kontaktanfrage', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 24),
                  TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Ihr Name', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Bitte Namen eingeben' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: companyController, decoration: const InputDecoration(labelText: 'Firma (Optional)', border: OutlineInputBorder())),
                  const SizedBox(height: 16),
                  TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'Ihre E-Mail', border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Bitte E-Mail eingeben' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: phoneController, decoration: const InputDecoration(labelText: 'Telefon (Optional)', border: OutlineInputBorder()), keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  TextFormField(controller: messageController, decoration: const InputDecoration(labelText: 'Ihre Nachricht', border: OutlineInputBorder()), maxLines: 4, validator: (v) => v!.isEmpty ? 'Bitte Nachricht eingeben' : null),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final subject = 'Kontaktanfrage von ${nameController.text}';
                        final body = '''
Name: ${nameController.text}
Firma: ${companyController.text}
E-Mail: ${emailController.text}
Telefon: ${phoneController.text}
--------------------
Nachricht:
${messageController.text}
                        ''';
                        final mailtoUri = Uri.encodeFull('mailto:jowansulaiman@gmail.com?subject=$subject&body=$body');
                        launchUrl(Uri.parse(mailtoUri));
                        Navigator.pop(ctx);
                      }
                    },
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Anfrage Senden'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Ein wiederverwendbares Widget für die Buttons im Kontakt-Menü.
class _ContactMenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ContactMenuButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}