// lib/models/certificate_item.dart
import 'package:flutter/foundation.dart';

// NEU: Ein Enum, um die möglichen Zustände klar zu definieren.
enum CertificateStatus { available, in_progress, not_available }

class CertificateItem {
  final String title;
  final String issuer;
  final String year;
  final String category;
  final String? documentUrl;
  final CertificateStatus status; // NEU: Das Status-Feld

  const CertificateItem({
    required this.title,
    required this.issuer,
    required this.year,
    required this.category,
    this.documentUrl,
    required this.status, // NEU
  });

  factory CertificateItem.fromJson(Map<String, dynamic> json) {
    // Hilfsfunktion, um den String aus JSON in unseren Enum-Wert umzuwandeln
    final status = CertificateStatus.values.firstWhere(
          (e) => describeEnum(e) == json['status'],
      orElse: () => CertificateStatus.not_available,
    );

    return CertificateItem(
      title: json['title'] as String,
      issuer: json['issuer'] as String,
      year: json['year'] as String,
      category: json['category'] as String,
      documentUrl: json['document_url'] as String?,
      status: status, // NEU
    );
  }
}