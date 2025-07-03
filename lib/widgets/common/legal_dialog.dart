// lib/widgets/common/legal_dialog.dart
import 'package:flutter/material.dart';

class LegalDialog extends StatelessWidget {
  final String title;
  final String content;

  const LegalDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title),
      content: SingleChildScrollView(
        child: Text(content),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Schließen'),
        ),
      ],
    );
  }
}