// lib/utils/file_helper.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openOrShareFile(String assetPath, String webPath, BuildContext context) async {
  if (kIsWeb) {
    // Im Web einfach die URL öffnen
    await launchUrl(Uri.parse(webPath));
  } else {
    // Auf Mobilgeräten: Datei aus Assets in ein temporäres Verzeichnis kopieren und dann teilen.
    try {
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final fileName = assetPath.split('/').last;
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: 'Dokument von Jowan Sulaiman');
    } catch (e) {
      debugPrint('Fehler beim Teilen der Datei: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datei konnte nicht geteilt werden.')),
        );
      }
    }
  }
}