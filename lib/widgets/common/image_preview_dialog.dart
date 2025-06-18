// lib/widgets/common/image_preview_dialog.dart
import 'package:flutter/material.dart';

class ImagePreviewDialog extends StatelessWidget {
  final String imagePath;
  const ImagePreviewDialog({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: InteractiveViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}